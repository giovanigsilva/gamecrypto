// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";

contract tokenGame{

    
    mapping(address => uint256) internal balances;
       
    string public name = "EnergyCoin";
    string public symbol = "ENEC";

    uint private numeroDeMoedas = 21000000;
    uint private casasDecimais = 8;
    
    event Transfer(address indexed from, address indexed to, uint);
    
    uint public totalSupply = numeroDeMoedas * 10 ** casasDecimais;
    uint public decimals = casasDecimais;
    
    address private contractOwner;
 
    constructor() {
        contractOwner = msg.sender;
        balances[msg.sender] = totalSupply;
    }
    
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }
    
    function burn(uint amount) external {
        _burn(msg.sender, amount);  
    }

    function _burn(address account, uint amount) private returns(bool){
        require(amount != 0);
        require(amount <= balances[account]);
        totalSupply -= amount;
        balances[account] -= amount;
        emit Transfer(account, address(0), amount);  
        return true;
    }

    function transfer(address account, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender], "Not funds");
        balances[msg.sender] -=  numTokens;
        balances[account] += numTokens;
        emit Transfer(msg.sender, account, numTokens);
        return true;
    }

    function createTokens(uint value) internal returns(bool) {
        
        if(msg.sender == contractOwner) {
            require(value != 0, "not zero permission");
            totalSupply += value;
    	    balances[msg.sender] += value;
    	    return true;
        }
        return false;
    }

    function destroyTokens(uint value) private returns(bool) {
        if(msg.sender == contractOwner) {
            require(value != 0, "not zero permission");
            require(balanceOf(msg.sender) >= value, "balance too low");
            totalSupply -= value;        
    	    balances[msg.sender] -= value;
            return true;
        }
        return false;
    }

    function mint(uint amount) external {
        _mint(msg.sender, amount);  
    }

    function _mint(address account, uint amount) private virtual returns(bool) {
        require(account != address(0), "ERC20: mint to the zero address");
        require(amount < 0, "Amount not valid");
        totalSupply += amount;
        balances[account] += amount;
        emit Transfer(address(0), account, amount);
        return true;
    }
    
}
