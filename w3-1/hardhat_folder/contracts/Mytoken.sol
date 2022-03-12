//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";
contract Mytoken is ERC20,Ownable {

    constructor() ERC20("Mytoken name", "MYT"){
    }
    
    function ownerMint(uint number) external onlyOwner {
        console.log("ownerMint add %s, token for owner",number);
        _mint(msg.sender,number*10**18);
    }
}