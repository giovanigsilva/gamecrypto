pragma solidity ^0.8.0;

import "./importadobomber.sol";

contract BCoinToken is BEP20Detailed, BEP20 {
  constructor() BEP20Detailed("Bomber Coin", "BCOIN", 18) {
    uint256 totalTokens = 100000000 * 10**uint256(decimals());
  function mint(uint256 amount) external {
    _mint(msg.sender, totalTokens);
  }

  function burn(uint256 amount) external {
    _burn(msg.sender, amount);
  }
}
