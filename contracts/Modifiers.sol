// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract PausableToken {
    address public owner;
    bool public paused;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
        paused = false;
        balances[owner] = 1000;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You aren't the owner");
        _;
    }

    // Implement the modifier to check if the contract isn't paused
    function pause() public onlyOwner {
        paused = true;
    }

    function unPause() public onlyOwner {
        paused = false;
    }

    // implement the modifier to check if the contract isn't paused
    modifier notPaused() {
        require(paused == false, "The contract is paused");
        _;
    }
    //use the notPaused modifier in this fn

    function transfer(address to , uint amt) public notPaused{
        require(balances[msg.sender] >= amt , "Insufficient balance");

        balances[msg.sender] -= amt;
        balances[to] += amt;
    }
}
