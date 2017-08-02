pragma solidity ^0.4.13;

// LIBRARY
// This library is going to manaage groups..
// and a group is going to contain addresses

library Groups {
    
    struct Group {
        mapping (address => bool) members;
    }
    
    function addMember(Group storage self, address addr) returns (bool) {
        if (self.members[addr]) {
            return false;   // already a member
        }
        self.members[addr] == true;
        return true;
    }
    
    function delMember(Group storage self, address addr) returns (bool) {
        if (!self.members[addr]) {
            return false;   // not a member
        }
        self.members[addr] == false;
        return true;
    }
}