//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

interface MasterChefV2 {
    function deposit(uint256 pid, uint256 amount) external;
    function withdraw(uint256 pid, uint256 amount) external;
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    
}

contract MyTokenMarket is Ownable {
    uint256 MAX_INT = 2**256 - 1;

    ERC20 mytoken;
    MasterChefV2 masterChef;
    constructor(address mytokenAddress,address masterChefAddress) {
        mytoken = ERC20(mytokenAddress);
        masterChef = MasterChefV2(masterChefAddress);
    }

    function addLiquidityETH(address dexRouter,uint amount) external payable{
        ERC20(address(mytoken)).transferFrom(msg.sender,address(this),amount);
        ERC20(address(mytoken)).approve(dexRouter,MAX_INT);

        IUniswapV2Router01 router = IUniswapV2Router01(dexRouter);
        router.addLiquidityETH{value: msg.value}(
            address(mytoken),amount,0,0,address(this),block.timestamp
        );
    }

    function deposit(address dexRouter,uint pid, uint stakeAmount) external{
        IUniswapV2Router01 router = IUniswapV2Router01(dexRouter);
        address pair = IUniswapV2Factory(router.factory()).getPair(router.WETH(), address(mytoken));
        ERC20(pair).approve(address(masterChef),MAX_INT);
        //存入sushi
        masterChef.deposit(pid, stakeAmount);
    }

    function buyToken(address dexRouter) external payable {
        IUniswapV2Router01 router = IUniswapV2Router01(dexRouter);
        address[] memory path = new address[](2);
        path[0]=router.WETH();
        path[1] = address(mytoken);
        router.swapExactETHForTokens{value: msg.value}(
            1,path,address(this),block.timestamp
        );

    }

    function withdraw(uint pid) external onlyOwner{
        masterChef.withdraw(pid,100);
    }

    function withdrawToken(address _token) external onlyOwner{
        ERC20 erc20 = ERC20(_token);
        uint balance = erc20.balanceOf(msg.sender);
        erc20.transfer(owner(),balance);
    }
}