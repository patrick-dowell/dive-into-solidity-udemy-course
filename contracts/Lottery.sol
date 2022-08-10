//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract Lottery {
    // declaring the state variables
    address[] public players; //dynamic array of type address payable
    address[] public gameWinners;
    address public owner;

    // declaring the constructor
    constructor() {
        owner = msg.sender;
    }

    // declaring the receive() function that is necessary to receive ETH
    receive() external payable {
        require(msg.value == 0.1 ether, "NOT_ENOUGH_ETH");
        players.push(msg.sender);
    }

    // returning the contract's balance in wei
    function getBalance() public view returns (uint256) {
        require(msg.sender == owner, "ONLY_OWNER");
        return address(this).balance;
    }

    // selecting the winner
    function pickWinner() public {
        require(msg.sender == owner, "ONLY_OWNER");
        require(players.length >= 3, "NOT_ENOUGH_PLAYERS");

        uint256 r = random();

        r = r % players.length;

        address winner = players[r];
        gameWinners.push(winner);

        (bool success, ) = winner.call{value: getBalance()}("");
        require(success == true, "TRANSFER_FAILED");

        players = new address[](0);
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }
}
