// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
 
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";
import "./YourToken.sol";
 
contract newNFT is NFTokenMetadata, Ownable {
  uint256 public tokensPerBNB = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);
  YourToken yourToken;
  
  constructor(address tokenAddress) {
    nftName = "ENERGY NFT";
    nftSymbol = "ENECF";
    nextTokenId = 0;
    yourToken = YourToken(tokenAddress);

  }
 
 //Scores dos jogadores
 struct PlayGame {
    address player;
    uint score;
  }
  
  //Tokens dos jogadores
  struct tokensIdOfOwner {
      address owner;
      uint tokenId;
  }
  
  
  uint public nextTokenId;
  
  //arraysdos scores
  PlayGame[] public ranking;
  //array de Tokens Id
  tokensIdOfOwner[] public tokensIdsList;
  
  //função para cunhar NFT
  function mint(address _to, string calldata _uri) public{
    nextTokenId++;
    super._mint(_to, nextTokenId);
    super._setTokenUri(nextTokenId, _uri);
    updateTokensIdList(_to, nextTokenId);
    
  }
  
  
  function deleteTokenId(address _owner, address _to, uint _tokenId) public {
     
    for (uint256 i = 0; i < tokensIdsList.length; i++) {
      if (tokensIdsList[i].owner == _owner) 
          if (tokensIdsList[i].tokenId == _tokenId){
            tokensIdsList[i] = tokensIdsList[tokensIdsList.length-1];
            tokensIdsList.pop();
          }
    }
    updateTokensIdList(_to, _tokenId);
  }
  
  
  function updateRanking(address _from, uint _score) public {
      PlayGame memory newPlayGame = PlayGame(_from, _score);
      ranking.push(newPlayGame);
  }
  
  // Getters
  function getRanking() public view returns (PlayGame[] memory) {
      
    return ranking;
  }
  
  
   function updateTokensIdList(address _from, uint _tokenId) public {
      tokensIdOfOwner memory newTokenId = tokensIdOfOwner(_from, _tokenId);
      tokensIdsList.push(newTokenId);
  }
  
 
  function getTokensIdsList() public view returns (tokensIdOfOwner[] memory) {
    return tokensIdsList;
  }

  function buyTokens() public payable returns (uint256 tokenAmount) {
    require(msg.value > 0, "Send BNB to buy some tokens");

    uint256 amountToBuy = msg.value * tokensPerBNB;

    // check if the Vendor Contract has enough amount of tokens for the transaction
    uint256 vendorBalance = yourToken.balanceOf(address(this));
    require(vendorBalance >= amountToBuy, "Vendor contract has not enough tokens in its balance");

    // Transfer token to the msg.sender
    (bool sent) = yourToken.transfer(msg.sender, amountToBuy);
    require(sent, "Failed to transfer token to user");

    // emit the event
    emit BuyTokens(msg.sender, msg.value, amountToBuy);

    return amountToBuy;
  }

  /**
  * @notice Allow users to sell tokens for ETH
  */
    function sellTokens(uint256 tokenAmountToSell) public {
    // Check that the requested amount of tokens to sell is more than 0
    require(tokenAmountToSell > 0, "Specify an amount of token greater than zero");

    // Check that the user's token balance is enough to do the swap
    uint256 userBalance = yourToken.balanceOf(msg.sender);
    require(userBalance >= tokenAmountToSell, "Your balance is lower than the amount of tokens you want to sell");

    // Check that the Vendor's balance is enough to do the swap
    uint256 amountOfETHToTransfer = tokenAmountToSell / tokensPerBNB;
    uint256 ownerETHBalance = address(this).balance;
    require(ownerETHBalance >= amountOfETHToTransfer, "Vendor has not enough funds to accept the sell request");

    (bool sent) = yourToken.transferFrom(msg.sender, address(this), tokenAmountToSell);
    require(sent, "Failed to transfer tokens from user to vendor");


    (sent,) = msg.sender.call{value: amountOfETHToTransfer}("");
    require(sent, "Failed to send BNB to the user");
  }

  function withdraw() public onlyOwner {
    uint256 ownerBalance = address(this).balance;
    require(ownerBalance > 0, "Owner has not balance to withdraw");

    (bool sent,) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to send user balance back to the owner");
  }
  
}
