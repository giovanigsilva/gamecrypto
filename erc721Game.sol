// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
 
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";

contract newNFT is NFTokenMetadata{
    uint public decimals = 2;
    uint public totalSupply;
  
  constructor() {
    nftName = "ENERGY NFT";
    nftSymbol = "ENEFT";
    nextTokenId = 0;
    }
 
  uint private nextTokenId;

  function mint(string calldata uri) external {
    _mintage(msg.sender, uri);  
  }

  function _mintage(address _to, string calldata _uri) internal returns(uint){
    nextTokenId++;
    super._mint(_to, nextTokenId);
    super._setTokenUri(nextTokenId, _uri);
    totalSupply += 1;
    return nextTokenId;
  }  
  
}
