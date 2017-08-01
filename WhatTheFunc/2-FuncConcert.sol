pragma solidity ^0.4.13;
// How to use the compiled contract
// Set value = 1 ether
// buy 1 ticket
// refresh number of tickets
// you can also copy/paste address you are using in purchasers input
// Then click on purchases to see how many tickets that address has bought




contract FuncConcert {
    address owner;
    uint public tickets;
    uint constant price = 1 ether;
    
    
    // key-value mapping
    // using ethereum addresses as "key"
    // and uint for number of tickets our purchaser bought/sold as "value"
    mapping (address => uint) public purchasers;
    
    function FuncConcert() {
        owner = msg.sender;
        tickets = 5;
    }
    
    // Payable function - to let know that we need to receive ether
    // for this function.
    function buyTickets(uint amount) payable {
        if (msg.value != (amount * price) || amount > tickets) {
            revert();
        }
        
        purchasers[msg.sender] += amount;
        tickets -= amount;
        
        
        // This function on destruct will return balance to owner
        // if (tickets == 0) {
            // selfdestruct(owner);
        // }
    }
    
}

