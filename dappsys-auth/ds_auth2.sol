pragma solidity ^0.4.8;

contract DSAuthority {
    function canCall(address src, address dst, bytes4 sig) constant returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority  public  authority;
    address      public  owner;

    function DSAuth() {
        owner = msg.sender;
        LogSetOwner(msg.sender);
    }

    function setOwner(address owner_) auth {
        owner = owner_;
        LogSetOwner(owner);
    }

    function setAuthority(DSAuthority authority_) auth {
        authority = authority_;
        LogSetAuthority(authority);
    }

    modifier auth {
        assert(isAuthorized(msg.sender, msg.sig));
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, this, sig);
        }
    }

    function assert(bool x) internal {
        if (!x) revert();
    }
    
    uint price;
    
    function setNumber(uint _price) auth {
        price = _price;
    }
    
    function getNumber() constant returns(uint) {
        return price;
    }
}


contract DSName is DSAuthEvents {
    DSAuthority  public  authority;
    address public owner;
    
    string name;
    
    function DSAuth() {
        owner = msg.sender;
        LogSetOwner(msg.sender);
    }
    
    
    function isAuthorized(address src, bytes4 sig) internal returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, this, sig);
        }
    }
    
    modifier auth {
        assert(isAuthorized(msg.sender, msg.sig));
        _;
    }
    
    function setName(string _name) auth {
        name = _name;
    }
    
    function getName() constant returns(string) {
        return name;
    }
}