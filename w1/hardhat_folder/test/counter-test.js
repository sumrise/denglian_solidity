const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Counter", function () {
  it("Counter test changed success", async function () {
    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy(10);
    await counter.deployed();
    expect(await counter.read()).to.equal(10);
    const incrCounter = await counter.incr();
    await incrCounter.wait();

    expect(await counter.read()).to.equal(10+1);
  });
});
