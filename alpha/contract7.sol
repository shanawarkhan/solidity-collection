pragma solidity ^0.4.0;

contract contract7 {
    uint myUint;
    
    function setMyUint(uint newValue) {
        myUint = newValue;
    }
    
    function getMyUint() constant returns(uint) {
        return myUint;
    }
}