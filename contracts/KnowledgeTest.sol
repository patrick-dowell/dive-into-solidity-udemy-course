//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
    string[] public tokens = ["BTC", "ETH"];
    address[] public players;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeTokens() public {
        string[] storage t = tokens;
        t[0] = "VET";
    }

    receive() external payable {

    }

    fallback() external payable {

    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function transferAll(address payable destination) public returns (bool, bytes memory) {
        require(msg.sender == owner, "ONLY_OWNER");

        (bool success, bytes memory returnBytes) = destination.call{value: getBalance()}("");
        return (success, returnBytes);
    }

    function start() public {
        players.push(msg.sender);
    }

    function concatenate(string calldata s1, string calldata s2) public pure returns (string memory) {
        return string(abi.encodePacked(s1, s2));
    }
}
