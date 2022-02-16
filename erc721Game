// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
 
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";

contract newNFT is NFTokenMetadata{
  
  constructor() {
    nftName = "ENERGY NFT";
    nftSymbol = "ENECF";
    nextTokenId = 0;
    }
 
  uint public nextTokenId;
  tokensIdOfOwner[] public tokensIdsList;
  
  function mint(string calldata uri) external {
    _mintage(msg.sender, uri);  
  }

  function _mintage(address _to, string calldata _uri) internal{
    nextTokenId++;
    super._mint(_to, nextTokenId);
    super._setTokenUri(nextTokenId, _uri);
    updateTokensIdList(_to, nextTokenId);
    
  }  
  
}
