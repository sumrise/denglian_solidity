//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract Bank{
    mapping(address => uint) public deposits;
    function deposit() public payable {
        deposits[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint values = deposits[msg.sender];
        deposits[msg.sender]=0;
        (bool success, )  = msg.sender.call{value:values}("");
        require(success, "Failed to send Ether");
    }
}