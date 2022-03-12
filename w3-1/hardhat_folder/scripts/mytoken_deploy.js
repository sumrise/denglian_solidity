const hhat = require("hardhat")

const { artifacts } = require("hardhat");

async function main(){
    console.log(`mytoken deploy start`)
    await hhat.run("compile")
    const Mytoken = await hhat.ethers.getContractFactory("Mytoken");
    const mytoken = await Mytoken.deploy();

    await mytoken.deployed();

    console.log(`Mytoken deployed to: ${mytoken.address}`)
}

main()