pragma solidity ^0.4.0;

contract SimpleContract {
    uint public alpha;
    uint public charlie;
    
    function SimpleContract() {
        charlie = 93;
    }
    function setCharlie(uint _charlie){
        charlie = _charlie;
    }
    
    function setAlpha(uint _alpha) {
        alpha = _alpha;
    }
    
    function getAlpha()  returns(uint) {
        return alpha;
    }
    
}