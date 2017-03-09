pragma solidity ^0.4.8;

import "./StandardToken.sol";

contract WrappedToken is StandardToken {
  function WrappedToken(address _token) {
    token = StandardToken(_token);
  }

  // previous to wrap msg.sender must create an allowance for wrapper
  function wrap() {
    uint256 wrappingAmount = token.allowance(msg.sender, this);
    if (wrappingAmount < 1) throw;
    if (!token.transferFrom(msg.sender, address(this), wrappingAmount)) throw;
    totalSupply = safeAdd(totalSupply, wrappingAmount);
    balances[msg.sender] = safeAdd(balances[msg.sender], wrappingAmount);
  }

  function unwrap(uint amount) {
    // if (amount > balances[msg.sender]) throw; // Implicitely checked by safeSub(balance[msg.sender], amount)
    totalSupply = safeSub(totalSupply, amount);
    balances[msg.sender] = safeSub(balances[msg.sender], amount);
    if (!token.transfer(msg.sender, amount)) throw;
  }

  StandardToken token;
}
