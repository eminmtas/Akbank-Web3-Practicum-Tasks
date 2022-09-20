//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// Hands on Task (Beginner Level): Build and Deploy an Ether-Store Smart Contract with Remix IDE
// Owner: 0xbabacA9617a2cC30bC34A18E5F251F4Bd8CAbfac
// Contract Address: 0x9228ea52f29c99a669a21e5b3c753abbd65ffb60
contract FeeCollector {
    address public owner;
    uint public balance;

    constructor() {
        owner = msg.sender;
    }
    receive() external payable {
        balance += msg.value;
    }

    function withdraw(uint amount, address payable destAddr) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount <= balance, "Insufficient balance");

        destAddr.transfer(amount);
        balance -= amount;
    }
}