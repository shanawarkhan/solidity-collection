pragma solidity ^0.4.8;

contract DSAuthority {
    function canCall(address src, address dst, bytes4 sig) constant returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority(address indexed authority);
    event LogSetOwner(address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority public authority;
    address     public owner;

    function DSAuth() {
        owner = msg.sender;
        LogSetOwner(msg.sender);
    }
    
    function setOwner(address _owner) auth {
        owner = _owner;
        LogSetOwner(owner);
    }
    
    function setAuthority(DSAuthority _authority) auth {
        authority = _authority;
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
}

contract DSKhan is DSAuth {
   string public sport;
   uint calorie;
   
   function setSport(string _sport) auth {
       sport = _sport;
   }
}

