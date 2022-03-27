const hhat = require("hardhat")

const { artifacts } = require("hardhat");

async function main(){
    console.log(`tokenA and tokenB deploy start`)
    await hhat.run("compile")
    const Mytoken = await hhat.ethers.getContractFactory("Mytoken");
    const tokenA = await Mytoken.deploy("TokenA","TA");
    const tokenB = await Mytoken.deploy("TokenB","TB");

    await tokenA.deployed();
    console.log(`tokenA deployed to: ${tokenA.address}`)

    await tokenB.deployed();
    console.log(`tokenB deployed to: ${tokenB.address}`)
}

main()