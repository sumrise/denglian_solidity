const {expect} = require("chai");
const { ethers } = require("hardhat");

describe("Mytoken contract", function(){
    it("Deployment shoud owner", async function(){
        const [owner] = await ethers.getSigners();

        const Mytoken = await ethers.getContractFactory("Mytoken");

        const hardhatToken = await Mytoken.deploy();
        console.log(hardhatToken.address);
        const ownerBalance = await hardhatToken.balanceOf(owner.address);

        expect(await hardhatToken.totalSupply()).to.equals(0);

        await hardhatToken.ownerMint(100);
        expect(await hardhatToken.totalSupply()/10**18).to.equals(100);

    })
})