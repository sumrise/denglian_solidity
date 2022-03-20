require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html

const { setGlobalDispatcher, ProxyAgent } = require('undici')
const proxyAgent = new ProxyAgent('http://127.0.0.1:7890')
setGlobalDispatcher(proxyAgent)


const fs = require("fs");
const mnemonic = fs.readFileSync(".secret").toString().trim();
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts)
   {
    console.log(account.address);
  }
});


/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks:{
    dev:{
      url: "http://127.0.0.1:8545",
      chainId:31337
    },
    goerli: {
      url: 'https://goerli.infura.io/v3/07a25b92c3cd458d8d94f92aa5877a21',
      accounts: {
        mnemonic: mnemonic,
      },
      chainId: 5,
    },
    rinkeby:{
      url:'https://rinkeby.infura.io/v3/07a25b92c3cd458d8d94f92aa5877a21',
      accounts:{
        mnemonic: mnemonic,
      },
      chainId:4
    },
    ropsten:{
      url:'https://ropsten.infura.io/v3/07a25b92c3cd458d8d94f92aa5877a21',
      accounts:{
        mnemonic: mnemonic,
      },
      chainId:3
    }
  },
  etherscan:{
    apiKey: "TQPEF3Y7WD6RA52HTY5F2E26I1ZZ4CX6YA"
  }
};
