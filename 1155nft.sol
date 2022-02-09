pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract mygameNFT is ERC1155, Ownable {
    uint256 public tokensInCirculation;

    constructor() ERC1155("") {
        tokensInCirculation = 1;
    }

    function mint(uint256 amount) public onlyOwner {
        for(uint i = -; i < amount; i++) {
		_mint(msg.sender, tokensInCirculation, 1, "");
		tokensInCirculation++;
    	}
    }
}