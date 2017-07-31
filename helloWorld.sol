pragma solidity ^0.4.0;

contract HelloWorld {
    
    uint public balance;
    
    // constructor
    // runs once upon contract creation
    
    function HelloWorld() {
        balance = 1000;
    }
}