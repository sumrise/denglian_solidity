
//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.0;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';
import '@uniswap/swap-router-contracts/contracts/interfaces/IV3SwapRouter.sol';

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

import '@openzeppelin/contracts/utils/math/SafeMath.sol';

contract MyFlashLoan is FlashLoanSimpleReceiverBase, Withdrawable {
    using SafeMath for uint;
    
    IV3SwapRouter immutable v3Router;
    IUniswapV2Router01 immutable v2Router;
    address immutable  tokenA;
    address immutable  tokenB;
    uint256 MAX_INT = 2**256 - 1;

    constructor(IPoolAddressesProvider _providerAddress,address _routerV2, address _routerV3, address _tokenA, address _tokenB)
    FlashLoanSimpleReceiverBase(_providerAddress){
        v2Router = IUniswapV2Router01(_routerV2);
        v3Router = IV3SwapRouter(_routerV3);
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    receive() external payable{

    }

    function executeOperation(address assert,uint256 amount, uint256 premium, address initiator, bytes calldata params) external override returns(bool){
        //v2 乐观转账，相当于借币,直接到账tokenA amount0
        //借A
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        address tokenB = token0 == tokenA ? token1 : token0;

        address pairAddress = IUniswapV2Factory(v2Router.factory()).getPair(token0, token1);
        require(msg.sender == pairAddress, "msg.sender != pairAddress");
        //v2 卖 A -> B
        uint resValue = IUniswapV2Pair(pair).swap(0,amount,address(this),bytes(''));//*10**18
        
        //v3 买 B -> A
        IV3SwapRouter.ExactInputSingleParams memory params =
            IV3SwapRouter.ExactInputSingleParams({
                tokenIn: tokenB,
                tokenOut: tokenA,
                fee: 3000,
                recipient: address(this),
                amountIn: resValue,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        //v3收 A
        uint amountReceived = v3Router.exactInputSingle(params);
        console.log("success v3AmountOut:",amountReceived);

        ERC20(assert).transfer(msg.sender, amountReceived-amount);
        console.log("done");
    }
}
