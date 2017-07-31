pragma solidity ^0.4.11;


contract SimpleStorage {
    uint public data;

    function setData(uint a) { data = a; }
    function getData() public returns(uint) { return data; }    
}