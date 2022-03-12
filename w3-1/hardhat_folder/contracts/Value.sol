//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

// * 编写⼀个Vault 合约：
//   * 编写deposite ⽅法，实现 ERC20 存⼊ Vault，并记录每个⽤户存款⾦额 ， ⽤从前端调⽤（Approve，transferFrom） 
//   * 编写 withdraw ⽅法，提取⽤户⾃⼰的存款 （前端调⽤）
//   * 前端显示⽤户存款⾦额
contract Value is Ownable {

    mapping(address => uint) public deposited;
    address public immutable token;
    constructor(address _token) {
        token = _token;
    }

    function deposit(uint amount) external {
        require(IERC20(token).transferFrom(msg.sender,address(this),amount), "Transfer from error");
        deposited[msg.sender]+=amount;
    }

    function withdraw() external {
        uint amount = deposited[msg.sender];
        require(amount>0,"user must have money in bank");
        deposited[msg.sender]=0;
        IERC20(token).transfer(msg.sender, amount);
    }

    function balanceOf(address user)  public view returns(uint){
        return deposited[user];
    }
}