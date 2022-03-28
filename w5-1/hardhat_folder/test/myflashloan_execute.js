const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Loan", function () {
  it("Should return the new greeting once it's changed", async function () {

    // const library = await ethers.getContractFactory("UniswapV2Library");
    const MyFlashLoan = await ethers.getContractFactory("MyFlashLoan",{
        // libraries:{
        //     "UniswapV2Library":"0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D",
        // }
    });
    const v2Router = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
    const v3Router = "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45";
    const tokenA = "0xcE9F149300932C06834F7321d7c63E414da756BB";
    const tokenB = "0x3aa354bC8596E9e4e2C70149f51874593bf42F07";
    
    const loan = await MyFlashLoan.deploy(v2Router, v3Router, tokenA);
    await loan.deployed();

    console.log(loan.address);


    await loan.execute(tokenA,tokenB,(100*10**18).toString());
  });
});
