const {ethers, network} = require("hardhat");

const contractAddress = "0xedbdA3e45F0F7471b7Bdf722348cD1d6544b7782"

async function parseTransferEvent(event){
    const TransferEvent = new ethers.utils.Interface(["event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);"])
    let decodeData = TransferEvent.parseLog(event);

    console.log(`from:${decodeData.args.from}`);
    console.log(`to:${decodeData.args.to}`);
    console.log(`tokenId:${decodeData.args.tokenId}`);
}
async function main(){
    let [owner] = await ethers.getSigners();
    let myerc721 = await ethers.getContractAt("MyERC721",
        contractAddress,
        owner);

    let filter = myerc721.filters.Transfer();

    console.log("start listen event");
    ethers.provider.on(filter,(event)=>{
        console.log(event);
        parseTransferEvent(event);
    })
}
main()