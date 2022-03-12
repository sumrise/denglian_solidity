const hhat = require("hardhat")

const { artifacts } = require("hardhat");

async function main(){
    console.log(`value deploy start`)
    await hhat.run("compile")
    const Value = await hhat.ethers.getContractFactory("Value");
    const value = await Value.deploy("0xB817f07768ce7dedc647fc52927d8e8047058A6F");

    await value.deployed();

    console.log(`Value deployed to: ${value.address}`)
}

main()