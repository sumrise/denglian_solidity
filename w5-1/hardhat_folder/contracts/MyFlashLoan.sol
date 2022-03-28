
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

contract MyFlashLoan is IUniswapV2Callee,Ownable{
    using SafeMath for uint;
    
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
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }
    function getAmountsIn(address pair, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut,uint times) = 
            IUniswapV2Pair(pair).getReserves();
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }

    function execute(address _tokenA,address _tokenB,uint amount) external {
        console.log("start execute:");
        address pair = IUniswapV2Factory(v2Router.factory()).getPair(_tokenA, _tokenB);
        IUniswapV2Pair(pair).swap(0,amount,address(this),bytes('do'));//*10**18
    }

    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external override{
        //v2 乐观转账，相当于借币,直接到账tokenA amount0
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        address tokenB = token0 == tokenA ? token1 : token0;

        address pairAddress = IUniswapV2Factory(v2Router.factory()).getPair(token0, token1);
        require(msg.sender == pairAddress, "msg.sender != pairAddress");
        require(sender == address(this), "sender != address(this)");
        
        ERC20(tokenA).approve(address(v3Router),MAX_INT);

        IV3SwapRouter.ExactInputSingleParams memory params =
            IV3SwapRouter.ExactInputSingleParams({
                tokenIn: tokenA,
                tokenOut: tokenB,
                fee: 3000,
                recipient: address(this),
                amountIn: amount1,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        //v3卖 ，v3收币
        uint amountReceived = v3Router.exactInputSingle(params);
        console.log("success v3AmountOut:",amountReceived);

        address[] memory path = new address[](2);
        path[0] = tokenB;
        path[1] = tokenA;

        uint amountRequired = getAmountsIn(msg.sender, amount1, path)[0];
        console.log("success amountRequired:",amountRequired);

        assert(amountReceived > amountRequired); // fail if we didn't get enough ETH back to repay our flash loan
        ERC20(tokenB).transfer(msg.sender, amountRequired);
        console.log("done");
    }
}
