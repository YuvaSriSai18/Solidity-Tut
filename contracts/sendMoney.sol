// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DoubleMoneyContract {
    uint public balance ;

    function sendMoneytoContract() public payable {

    }

    function doubleMoney(uint _amt) public returns (uint256){
        balance = _amt * 2 ;
        return balance;
    }

    // Stores contract balance
    uint public contractBalance;

    // Event to log successful transfers
    event TransferSuccessful(address indexed from, address indexed to, uint amount);

    // Function to receive Ether and update contract balance
    receive() external payable {
        contractBalance += msg.value;
    }

    // Function to send money from sender to another wallet
    function transferMoney(address payable _recipient) public payable {
        require(msg.value > 0, "Amount must be greater than zero");
        require(_recipient != address(0), "Invalid recipient address");

        // Transfer the amount to the recipient
        _recipient.transfer(msg.value);

        // Emit an event for successful transfer
        emit TransferSuccessful(msg.sender, _recipient, msg.value);
    }

    // Get the contract's Ether balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}