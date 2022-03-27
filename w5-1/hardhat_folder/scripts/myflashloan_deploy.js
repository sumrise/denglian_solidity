const hhat = require("hardhat")

const { artifacts } = require("hardhat");


// tokenA deployed to: 0xcE9F149300932C06834F7321d7c63E414da756BB
// tokenB deployed to: 0x3aa354bC8596E9e4e2C70149f51874593bf42F07
async function main(){
    console.log(`MYFlashLoan deploy start`)
    await hhat.run("compile")
    const MyFlashLoan = await hhat.ethers.getContractFactory("MyFlashLoan");
    const v2Router = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
    const v3Router = "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45";
    const tokenA = "0xcE9F149300932C06834F7321d7c63E414da756BB";
    // const tokenB = "0x3aa354bC8596E9e4e2C70149f51874593bf42F07";
    const myFlashLoan = await MyFlashLoan.deploy(v2Router, v3Router, tokenA);

    await myFlashLoan.deployed();

    console.log(`myFlashLoan deployed to: ${myFlashLoan.address}`)

}

main()