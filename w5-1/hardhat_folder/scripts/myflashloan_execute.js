const {ethers, network} = require("hardhat");

const contractAddress = "0x74bF3DabF01Db066362a2CBB7d9110C24A65Cc68"


async function main(){
    let [owner] = await ethers.getSigners();
    let myFlashLoan = await ethers.getContractAt("MyFlashLoan",
        contractAddress,
        owner);
    const tokenA = "0xcE9F149300932C06834F7321d7c63E414da756BB";
    const tokenB = "0x3aa354bC8596E9e4e2C70149f51874593bf42F07";
    
    console.log("myFlashLoan:",myFlashLoan.address);
    await myFlashLoan.execute(tokenA,tokenB,100);

}
main()