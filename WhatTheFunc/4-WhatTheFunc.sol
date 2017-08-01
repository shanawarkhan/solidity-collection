pragma solidity ^0.4.13;

// How two contracts can communicate with each other
// 1) Using Calculator contract by instantiating a new instance of the contract
// 2) By referencing a contract that's allready published by it's address


// Contract Calculator
contract Calculator {
    function add(int a, int b) returns (int) {
        return a + b;
    }
    
    function multiply(int a, int b) returns (int) {
        return a * b;
    }
}



// 1) Using Calculator contract by instantiating a new instance of the contract
contract Foo {
    Calculator calc = new Calculator();
    
    function twoTimesThree() constant returns(int) {
        return calc.multiply(3, 3);
    }
    
    function onePlusThirteen() constant returns(int) {
        return calc.add(1, 13);
    }
}

// 2) By referencing a contract that's allready published by it's address
contract Alpha {
    Calculator calc = Calculator(0xd25ed029c093e56bc8911a07c46545000cbf37c6);
    
    function twoTimesThree() constant returns(int) {
        return calc.multiply(3, 3);
    }
    
    function onePlusThirteen() constant returns(int) {
        return calc.add(1, 13);
    }
    
}