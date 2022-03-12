const {expect} = require("chai");
const { ethers } = require("hardhat");


// const tokenAddress="0x5FbDB2315678afecb367f032d93F642f64180aa3";
// const tokenAddress="0xB817f07768ce7dedc647fc52927d8e8047058A6F";
describe("Value contract", function(){
    it("Deployment Value", async function(){
        const [owner] = await ethers.getSigners();
        const Mytoken = await ethers.getContractFactory("Mytoken");
        const mytoken = await Mytoken.deploy();
        const tokenAddress = mytoken.address;

        const Value = await ethers.getContractFactory("Value");
        const value = await Value.deploy(tokenAddress);

        console.log(`token:${tokenAddress} value:${value.address}`);
        
        await mytoken.ownerMint(100_000_00_00)
        await mytoken.approve(value.address,100_000)

        await value.deposit(100);

        expect(await value.balanceOf(owner.address)).to.equals(100);

        await value.withdraw();
        expect(await value.balanceOf(owner.address)).to.equals(0);

    })
})