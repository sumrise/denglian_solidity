const {expect} = require("chai");
const { ethers } = require("hardhat");

describe("My721 contract", function(){
    it("Deployment shoud owner", async function(){
        const [owner] = await ethers.getSigners();

        const MyERC721 = await ethers.getContractFactory("MyERC721");

        const token721 = await MyERC721.deploy();
        console.log(token721.address);

        await token721.mint(1);
        expect(await token721.totalSupply()).to.equals(1);

    })
})