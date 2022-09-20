// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Owner: 0xbabacA9617a2cC30bC34A18E5F251F4Bd8CAbfac
// Contract address: 0xE55238028E8079DA6e6b2cD738c2f63689F4b25b

contract EminDAO is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Emin DAO", "EDAO") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}