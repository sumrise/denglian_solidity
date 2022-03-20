//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";
contract Mytoken is ERC20,Ownable {

    constructor(uint number) ERC20("Mytoken name", "MYT"){
        _mint(msg.sender,number*10**18);
    }
}