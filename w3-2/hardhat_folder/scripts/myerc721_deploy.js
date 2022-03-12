const hhat = require("hardhat")

const { artifacts } = require("hardhat");

async function main(){
    console.log(`my721 deploy start`)
    await hhat.run("compile")
    const MyERC721 = await hhat.ethers.getContractFactory("MyERC721");
    const myerc721 = await MyERC721.deploy();

    await myerc721.deployed();

    console.log(`MyERC721 deployed to: ${myerc721.address}`)
}

main()