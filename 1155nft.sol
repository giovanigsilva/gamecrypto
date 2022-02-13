pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract mygameNFT is ERC1155, Ownable {
    string public name;
    string public symbol;
    uint256 public tokensInCirculation;

    constructor() ERC1155("") {
    	name = "ETEST";
	symbol = "ET";
        tokensInCirculation = 1;
    }

    function mint(uint256 amount) public onlyOwner {
        for(uint i = 0; i < amount; i++) {
		_mint(msg.sender, tokensInCirculation, 1, "");
		tokensInCirculation++;
    	}
    }
}
