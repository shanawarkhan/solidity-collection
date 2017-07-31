pragma solidity ^0.4.8;

contract owned {
    bool myBool;
    uint8 myUint8;
    uint myUint256;
    bytes32 myBytes32;
    bytes myBytes;
    string myString;
    
    function owned() {
        myBool = true;
        myUint8 = 255;
        myUint256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        
        myBytes32 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        myString = "ABC";
    }
    
    function setMyString(string mystring) {
        myString = mystring;
    }   
    
    function getMyBytes32() constant returns (bytes32) {
        return myBytes32;
    }
    
    function getMyUint256() constant returns (uint256) {
        return myUint256;
    }
    
    function getMyUint8() constant returns(uint8) {
        return myUint8;
    }
    
}