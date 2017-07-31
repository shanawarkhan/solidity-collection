pragma solidity ^0.4.13;

contract Alpacino {
    bytes32  myString = "THis is some content";


    function setMyString(bytes32 _myString) {
        myString = _myString;
    }
    function getMyString() constant returns (bytes32) {
        return myString;
    }
}