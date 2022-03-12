const {ethers, providers} = require("ethers")

const {config} = require('dotenv')
config()

const rpcurl = process.env.RPCURL||"error rpcurl"
const mnemonic = process.env.mnemonic||"error mnemonic"

console.log(rpcurl,mnemonic)
const contractAddress = "0xB817f07768ce7dedc647fc52927d8e8047058A6F"
async function main(){
    const provider = new providers.StaticJsonRpcProvider(rpcurl);
    const account = ethers.Wallet.fromMnemonic(mnemonic).connect(provider);
    const contract = new ethers.Contract(contractAddress,[
        'function balanceOf(address account) external view returns (uint256)',
        'function transfer(address to, uint256 amount) external returns (bool)',
        'function ownerMint(uint256 number) external'
    ],account)
    //增发代币
    // await contract.ownerMint(100);
    const testAddress="0x0000000000000000000000000000000000000001";
    let balance = await contract.balanceOf(testAddress);
    console.log(`before balance ${balance}`);
    //转账
    await contract.transfer(testAddress,ethers.utils.parseEther('1'));
    console.log('do transfer 1 to testAddress');
    //需要sleep 几秒钟
    balance = await contract.balanceOf(testAddress);
    console.log(`after balance ${balance}`);
}
main()