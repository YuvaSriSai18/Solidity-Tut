// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/token/ERC20/ERC20.sol";

contract MonopolyToken is ERC20 {
    mapping(uint => address) public boardBank; // Map board ID to its Bank contract
    uint public initialMoney = 1500 * (10 ** 18); // Initial money per player

    constructor() ERC20("Monopoly Money", "MNY") {}

    /// @notice Creates a new board and mints the initial money for the Bank
    function createGameBoard(uint boardId, address bankAddress) external {
        require(boardBank[boardId] == address(0), "Board already exists");
        boardBank[boardId] = bankAddress;
        _mint(bankAddress, 1000000 * (10 ** 18)); // Mint an initial supply of tokens to the bank
    }

    /// @notice Distribute starting money to each player from the bank
    function mintToPlayers(uint boardId, address[] memory players) external {
        require(boardBank[boardId] == msg.sender, "Only the board bank can distribute money");
        for (uint i = 0; i < players.length; i++) {
            _transfer(boardBank[boardId], players[i], initialMoney);
        }
    }

    /// @notice Pay the Bank (for buying properties, taxes, etc.)
    function transferToBank(uint boardId, address from, uint amount) external {
        require(boardBank[boardId] != address(0), "Invalid board");
        _transfer(from, boardBank[boardId], amount);
    }

    /// @notice Pay another player (for rent or trades)
    function transferToPlayer(uint boardId, address from, address to, uint amount) external {
        require(boardBank[boardId] != address(0), "Invalid board");
        _transfer(from, to, amount);
    }

    /// @notice Burn money when a player goes bankrupt
    function burnBankrupt(uint boardId, address player) external {
        require(boardBank[boardId] == msg.sender, "Only the bank can burn bankrupt funds");
        uint balance = balanceOf(player);
        if (balance > 0) {
            _burn(player, balance);
        }
    }
}
