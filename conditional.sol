pragma solidity ^0.4.0;

contract ConditionalContract {
    uint someVar;
    
    function setSomeVar(uint myVar) {
        someVar = myVar;
    }
    
    function getMyVar() constant returns (string) {
        if(someVar > 2) {
            return "is greater two";
        } else if(someVar == 2) {
            return "is exactly two";
        } else {
            return "is smaller two";
        }
    }
    
    function getWhile() constant returns (uint) {
        uint i = 0;
        while(i < 5) {
            i++;
        }
        return i;
    }
}