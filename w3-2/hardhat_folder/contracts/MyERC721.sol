// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC721 is ERC721Enumerable, Ownable {

    string _baseTokenURI;

    constructor() ERC721("MyERC721", "MY721")  {
        setBaseURI("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/");
    }

    function mint(uint256 num) public {
        uint256 supply = totalSupply();
        require(num < 11, "You play a maximum of 10 ERC721Demo");
        require(supply + num < 10000, "Exceeds maximum ERC721Demos supply");
        for(uint256 i; i < num; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function withdrawAll() public payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

}