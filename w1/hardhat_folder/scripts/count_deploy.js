const hhat = require("hardhat")

const {writeAbiAddr} = require('./artifact_saver.js');
const { artifacts } = require("hardhat");

async function main(){
    console.log(`count deploy start`)
    await hhat.run("compile")
    const Counter = await hhat.ethers.getContractFactory("Counter");
    const counter = await Counter.deploy(10);

    await counter.deployed();

    console.log(`Counter deployed to: ${counter.address}`)
    console.log(`Counter counter to: ${await counter.counter()}`)

    let Artifact = await artifacts.readArtifact("Counter");
    await writeAbiAddr(Artifact, counter.address, "Counter",network.name);
}

main()