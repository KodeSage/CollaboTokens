//SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol"; //a simple way to get a counter that can only be incremented or decremented
import "@openzeppelin/contracts/access/Ownable.sol"; //Assigns Roles in SmartContract
import "@openzeppelin/contracts/utils/math/SafeMath.sol"; //Use to Prevent Overflows
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; //The ERC721Enumerable interface is an optional interface for adding more features to the ERC721 NFT.

     contract CrankySquirrel is ERC721Enumerable, Ownable {
     using SafeMath for uint256;
     using Counters for Counters.Counter;
     Counters.Counter private _tokenIds;

     uint256 public constant MAX_SUPPLY = 9;
     uint256 public constant PRICE = 0.001 ether;
     uint256 public constant MAX_PER_MINT = 1;
     string public baseTokenURI;

     constructor(string memory baseURI) ERC721("CrankySquirrel", "CRSNFT") {
          setBaseURI(baseURI);
     }
     function _mintSingleNFT() private {
      uint newTokenID = _tokenIds.current();
      _safeMint(msg.sender, newTokenID);
      _tokenIds.increment();
     }
     function reserveNFTs() public onlyOwner {
          //Reserves some amount of Tokens for the Contract Owner
          uint256 totalMinted = _tokenIds.current();
          require(totalMinted.add(4) < MAX_SUPPLY, "Not enough NFTs");
          for (uint256 i = 0; i < 4; i++) {
               _mintSingleNFT();
          }
     }

     function _baseURI() internal view virtual override returns (string memory) {
          //Returns Base URL
          return baseTokenURI;
     }

     function setBaseURI(string memory _baseTokenURI) public onlyOwner  { //Set BaseUrL
          baseTokenURI = _baseTokenURI;
     }
     function mintNFTs(uint _count) public payable { //payable functions receives ethers
          uint totalMinted = _tokenIds.current(); //checks the totalNftminted
          require(
          totalMinted.add(_count) <= MAX_SUPPLY, "Not enough NFTs!"
          );
          require(
          _count > 0 && _count <= MAX_PER_MINT, 
          "Cannot mint more than One NFT."
          );
          require(
          msg.value >= PRICE.mul(_count), 
          "Not enough ether to purchase NFTs."
          );
          for (uint i = 0; i < _count; i++) {
               _mintSingleNFT();
          }
     }
     function tokensOfOwner(address _owner) 
         external 
         view 
         returns (uint[] memory) {
     uint tokenCount = balanceOf(_owner);
     uint[] memory tokensId = new uint[](tokenCount);
     for (uint i = 0; i < tokenCount; i++) {
          tokensId[i] = tokenOfOwnerByIndex(_owner, i);
     }

     return tokensId;
}
 function withdraw() public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");
     //    address(this).balance = 0;
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
    //CaseStudy of the withdrawal function
//      function withdraw() external {
//         uint256 amount = balanceOf[msg.sender];
//         balanceOf[msg.sender] = 0;
//         (bool success, ) = msg.sender.call.value(amount)("");
//          require(success, "Transfer failed.");
//      }
}
