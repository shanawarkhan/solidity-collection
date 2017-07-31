pragma solidity ^0.4.11;

contract WhatTheFunc {
    string word = "Khan";
    uint public number = 13;
    
    string word2;
    uint public number2;
    address owner;
    
    
    
    function WhatTheFunc() {
        word2 = "Nazli";
        number2 = 31;
        owner = msg.sender;
    }
    
    // Modifier method:1 -- used in setWord()
    // modifier onlyOwner {
    //     if (msg.sender != owner){
    //         revert();
    //     }
    //     _;
    // }

    
    // Modifier method:2 -- used in setWord()
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
     // Log events -- used in setWord()
    event Changed(address a);
    
    function getWord() constant returns (string) {
        return word;
    }
    
    // Setting word and USING MODIFIER
    function setWord(string _word) onlyOwner {
        word = _word;
        Changed(msg.sender);
    }
    
}