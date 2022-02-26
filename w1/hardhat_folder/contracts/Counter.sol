//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
contract Counter{
    uint public counter;

    constructor(uint x){
        console.log("Deploying a Counter with num:", x);
        counter = x;
        console.log("Deploying end test");
    }
    function incr() public{
        counter = counter+1;
        console.log("curr counter :",counter);
    }

    function addX(uint x) public{
        counter = counter+x;
    }

    function read() public view returns(uint){
        return counter;
    }
}