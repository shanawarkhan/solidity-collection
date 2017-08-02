pragma solidity ^0.4.8;

import "ds-base/base.sol";
import "ds-token/base.sol";
import "ds-feeds/feeds.sol";

import "./simple_role_auth.sol";

contract SimplecoinEvents {
    event LogIssue(address indexed from, uint48 collateral_type, uint stablecoin_quantity);
    event LogCover(address indexed to, uint48 collateral_type, uint stablecoin_quantity);
}

contract Simplecoin is DSTokenBase(0), DSAuth, DSBase, SimplecoinEvents {
    // precision of the price feed
    uint public constant PRICE_UNIT = 10**18;

    DSFeeds     public  feeds;
    string      public  name;
    string      public  symbol;
    uint8       public  constant  decimals = 18;  // 18 decimal places, the same as ETH.

    CollateralType[] types;

    struct CollateralType {
        ERC20         token;
        bytes12       feed;
        address       vault;
        uint          spread;
        uint          debt;
        uint          ceiling;
    }

    function Simplecoin(
        DSFeeds     _feeds,
        string      _name,
        string      _symbol
    ) {
        feeds     = _feeds;
        name      = _name;
        symbol    = _symbol;
    }

    //------------------------------------------------------

    function nextType() constant returns (uint48) {
        return uint48(types.length);
    }

    function register(ERC20 token)
        auth returns (uint48 id)
    {
        return uint48(types.push(CollateralType({
            token:    token,
            vault:    0,
            feed:     0,
            spread:   0,
            debt:     0,
            ceiling:  0,
        })) - 1);
    }

    function setVault(uint48 type_id, address vault) auth {
        types[type_id].vault = vault;
    }

    function setFeed(uint48 type_id, bytes12 feed) auth {
        types[type_id].feed = feed;
    }

    function setSpread(uint48 type_id, uint spread) auth {
        types[type_id].spread = spread;
    }

    function setCeiling(uint48 type_id, uint ceiling) auth {
        types[type_id].ceiling = ceiling;
    }

    function unregister(uint48 collateral_type) auth {
        delete types[collateral_type];
    }

    //------------------------------------------------------

    function token(uint48 type_id) constant returns (ERC20) {
       return types[type_id].token;
    }

    function vault(uint48 type_id) constant returns (address) {
       return types[type_id].vault;
    }

    function feed(uint48 type_id) constant returns (bytes12) {
       return types[type_id].feed;
    }

    function spread(uint48 type_id) constant returns (uint) {
       return types[type_id].spread;
    }

    function ceiling(uint48 type_id) constant returns (uint) {
       return types[type_id].ceiling;
    }

    function debt(uint48 type_id) constant returns (uint) {
       return types[type_id].debt;
    }

    //------------------------------------------------------

    bytes4 transfer_sig = bytes4(sha3("transfer(address,uint256)"));

    modifier transfer_auth(address to, uint amount) {
        // transfer recipients must also be able to call transfer
        assert(DSAuthority(authority).canCall(to, this, transfer_sig));
        _;
    }

    function transfer(address to, uint amount)
        auth
        transfer_auth(to, amount)
        returns (bool)
    {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint amount)
        auth
        transfer_auth(to, amount)
        returns (bool)
    {
        return super.transferFrom(from, to, amount);
    }

    //------------------------------------------------------

    modifier zeroguard(uint48 collateral_type) {
        var t = types[collateral_type];
        assert(t.token != address(0));
        assert(t.vault != address(0));
        assert(t.feed  != 0);
        _;
    }

    function issue(uint48 collateral_type, uint pay_how_much)
        auth
        zeroguard(collateral_type)
        mutex
        returns (uint issued_quantity)
    {
        var t = types[collateral_type];

        assert(t.token.transferFrom(msg.sender, t.vault, pay_how_much));

        var price = getPrice(t.feed);
        var mark_price = price + price / t.spread;
        assert(safeToMul(PRICE_UNIT, pay_how_much));
        issued_quantity = (PRICE_UNIT * pay_how_much) / mark_price;

        assert(safeToAdd(_balances[msg.sender], issued_quantity));
        _balances[msg.sender] += issued_quantity;

        assert(safeToAdd(_supply, issued_quantity));
        _supply += issued_quantity;

        assert(safeToAdd(t.debt, issued_quantity));
        t.debt += issued_quantity;

        assert(t.debt <= t.ceiling);
        assert(_balances[msg.sender] <= _supply);

        LogIssue(msg.sender, collateral_type, issued_quantity);
    }

    function cover(uint48 collateral_type, uint stablecoin_quantity)
        auth
        zeroguard(collateral_type)
        mutex
        returns (uint returned_amount)
    {
        var t = types[collateral_type];

        assert(safeToSub(_balances[msg.sender], stablecoin_quantity));
        _balances[msg.sender] -= stablecoin_quantity;

        assert(safeToSub(_supply, stablecoin_quantity));
        _supply -= stablecoin_quantity;

        assert(safeToSub(t.debt, stablecoin_quantity));
        t.debt -= stablecoin_quantity;

        var price = getPrice(t.feed);
        var mark_price = price - price / t.spread;
        assert(safeToMul(stablecoin_quantity, mark_price));
        returned_amount = (stablecoin_quantity * mark_price) / PRICE_UNIT;

        assert(t.token.transferFrom(t.vault, msg.sender, returned_amount));

        assert(t.debt <= t.ceiling);
        assert(_balances[msg.sender] <= _supply);

        LogCover(msg.sender, collateral_type, returned_amount);
    }

    function getPrice(bytes12 feed) internal returns (uint) {
        var (price, ok) = feeds.tryGet(feed);
        assert(ok);
        return uint(price);
    }
}