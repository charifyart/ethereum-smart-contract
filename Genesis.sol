// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";
import './royalties/ERC2981ContractWideRoyalties.sol';

contract CharifyNFT is ERC721, ERC721Enumerable, Ownable, ERC2981ContractWideRoyalties {
    
    constructor() ERC721("Charify NFT", "CNFT") {}

    uint256 price = 100000000000000000;
    uint256 allowedAmount = 2;

    function setPrice(uint256 price_) external onlyOwner {
        price = price_;
    }

    function safeMint(address to) public onlyOwner {
        _safeMint(to, totalSupply());
    }

    function mint(uint256 num) public payable {
        uint256 supply = totalSupply();
        require( num <= allowedAmount, "You cannot mint more then the allowed amount");
        require( supply + num < 100, "Exceeds maximum supply");
        require( msg.value >= price * num, "Not enough ETH sent, check price" );
        for(uint256 i; i < num; i++){
        _safeMint( msg.sender, supply + i );
    }
 }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    //================================== ERC2981 Royalties =======================================/

     function setRoyalty(
        address recipient,
        uint256 value
     ) public virtual onlyOwner {
        _setRoyalties(recipient, value);
    }
}