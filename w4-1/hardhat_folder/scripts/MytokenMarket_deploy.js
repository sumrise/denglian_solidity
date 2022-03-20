const hhat = require("hardhat")

const { artifacts } = require("hardhat");
const masterChefAdd = '0xd9DFA8c6b37cfDF16668fE0465896f4A1B9b2c4F';
async function main(){
    console.log(`MytokenMarket deploy start`)
    await hhat.run("compile")
    const MyTokenMarket = await hhat.ethers.getContractFactory("MyTokenMarket");
    const mytokenMarket = await MyTokenMarket.deploy("0xF76795A7aF35365e3Eecd8A8070dc2A89F581A99",masterChefAdd);
    await mytokenMarket.deployed();
    console.log(`MytokenMarket deployed to: ${mytokenMarket.address}`)
}

main()