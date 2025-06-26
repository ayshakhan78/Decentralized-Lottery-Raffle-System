// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value >= 0.01 ether, "Minimum 0.01 ETH required");
        players.push(msg.sender);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function getBalance() public view returns (uint) {
        require(msg.sender == manager, "Only manager can view balance");
        return address(this).balance;
    }

    function pickWinner() public {
        require(msg.sender == manager, "Only manager can pick winner");
        require(players.length > 0, "No players in lottery");

        uint randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length))) % players.length;
        address winner = players[randomIndex];
        payable(winner).transfer(address(this).balance);
        delete players;
    }
}
