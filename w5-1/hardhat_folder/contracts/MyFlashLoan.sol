
//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.0;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';

import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';

// import '@uniswap/v3-periphery/contracts/SwapRouter.sol';
import '@uniswap/swap-router-contracts/contracts/interfaces/IV3SwapRouter.sol';
import '@uniswap/v3-periphery/contracts/interfaces/IPeripheryImmutableState.sol';

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract MyFlashLoan is IUniswapV2Callee,Ownable{
    IV3SwapRouter immutable v3Router;
    IUniswapV2Router01 immutable v2Router;
    address immutable  tokenA;
    uint256 MAX_INT = 2**256 - 1;

    constructor(address _routerV2, address _routerV3, address _tokenA)  {
        v2Router = IUniswapV2Router01(_routerV2);
        v3Router = IV3SwapRouter(_routerV3);
        tokenA = _tokenA;
    }

    receive() external payable{

    }

    function execute(address _tokenA,address _tokenB,uint amount) external {
        console.log("start execute:");
        IUniswapV2Pair(IUniswapV2Factory(v2Router.factory()).getPair(_tokenA, _tokenB))
            .swap(0,amount,address(this),bytes('do'));//*10**18
    }

    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external override{
        //v2 乐观转账，相当于借币,直接到账tokenA amount0
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        address tokenB = token0 == tokenA ? token1 : token0;

        address pairAddress = IUniswapV2Factory(v2Router.factory()).getPair(token0, token1);
        require(msg.sender == pairAddress, "msg.sender != pairAddress");
        require(sender == address(this), "sender != address(this)");
        
        address v3Pair = IUniswapV3Factory(
            IPeripheryImmutableState(address(v3Router)).factory()).getPool(tokenA,tokenB,3000);
        
        console.log("BalanceA:",ERC20(tokenA).balanceOf(address(this)));
        console.log("BalanceB:",ERC20(tokenB).balanceOf(address(this)));
        console.log("tokenA symbol:",ERC20(tokenA).symbol());
        console.log("tokenB symbol:",ERC20(tokenB).symbol());
        ERC20(tokenA).approve(v3Pair,MAX_INT);
        console.log("v3Pair",v3Pair);

        IV3SwapRouter.ExactInputSingleParams memory params =
            IV3SwapRouter.ExactInputSingleParams({
                tokenIn: tokenA,
                tokenOut: tokenB,
                fee: 3000,
                recipient: msg.sender,
                amountIn: amount1,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        //v3卖 ，v3收币
        uint v3AmountOut = v3Router.exactInputSingle(params);

        console.log("success v3AmountOut:",v3AmountOut);
        //v2买
        IUniswapV2Pair(msg.sender).swap(0,v3AmountOut,address(this), bytes(''));
        //还钱
        ERC20(address(tokenA)).approve(pairAddress,MAX_INT);
        ERC20(address(tokenA)).transferFrom(address(this),msg.sender, amount1);
    }
}
