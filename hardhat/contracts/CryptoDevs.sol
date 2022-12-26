// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";


contract CryptoDevs is ERC721Enumerable, Ownable{
  string _baseTokenURI;
  
  uint256 public _price = 0.01 ether;
  
  bool public _paused;
  
  uint256 public maxTokensIds = 20;

  uint256 public tokensIds;
  
  IWhitelist whitelist;
  
  bool public presaleStarted;
  
  uint256 public presaledEnded;

  modifier onlyWhenNotPaused{
    require(!_pause, "Contract currently paused");
    _;
  }

  constructor (string memory baseUri, address whitelistContract) ERC721("Crypto Devs, CD"){
    _baseTokenURI = baseUri;
    whitelist = IWhitelist(whitelistContract);
  }

  function startPresale() public onlyOwner {
    presaleStarted = true;
    presaledEnded = block.timestamp + 5 minutes;
  }

  function presaleMint() public payable onlyWhenNotPaused{
    require(presaleStarted && block.timestamp < presaledEnded, "Presale is not running");
    require(tokensIds < maxTokensIds, "Exceed maximum Crypto Devs supply");
    require(msg.value >= _price, "Ether sent is not correct");
    tokensIds +=1;
    _safeMint(msg.sender, tokensIds);
  }

  function mint() public payable onlyWhenNotPaused{
    require(presaleStarted && block.timestamp >= presaledEnded, "Presale has not ended);
    require(tokensIds < maxTokensIds, "Exceed maximum Crypto Devs supply);
    require(msg.value >= _price, "Ether sent is not correct");
    tokensIds += 1;
    _safeMint(msg.sender, tokensIds);
  }

  function _baseURI() internal view virtual override returns (string memory){
    return _baseTokenURI;
  }

  function setPaused(bool val) public onlyOwner{
    _paused = val;
  }

  function withdraw() public onlyOwner{
    address _owner = owner();
    uint256 amount = address(this).balance;
    (bool sent, ) = _owner.call{value: amount}("");
    require(sent, "Failed to send Ether");
  }

  receive() external payable{}

  fallback() external payable{}
}