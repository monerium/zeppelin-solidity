pragma solidity ^0.4.4;

import "./EternalTokenStorage.sol";
import "../SafeMathLib.sol";

library ERC20Lib {
    using SafeMathLib for uint;

    // struct TokenStorage {
        // mapping (address => uint) balances;
        // mapping (address => mapping (address => uint)) allowed;
        // uint totalSupply;
    // }

    // external
    function init(EternalTokenStorage.TokenStorage storage self, address _caller, uint _initial_supply) {
        self.totalSupply = _initial_supply;
        self.balances[_caller] = _initial_supply;
    }

    function transfer(EternalTokenStorage.TokenStorage storage self, address _caller, address _to, uint _value) 
        returns (bool success) 
    {
        self.balances[_caller] = self.balances[_caller].minus(_value);
        self.balances[_to] = self.balances[_to].plus(_value);
        Transfer(_caller, _to, _value);
        return true;
    }

    function transferFrom(
        EternalTokenStorage.TokenStorage storage self, 
        address _caller, 
        address _from, 
        address _to, 
        uint _value
    ) returns (bool success) {
        var _allowance = self.allowed[_from][_caller];

        self.balances[_to] = self.balances[_to].plus(_value);
        self.balances[_from] = self.balances[_from].minus(_value);
        self.allowed[_from][_caller] = _allowance.minus(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(EternalTokenStorage.TokenStorage storage self, address _owner) 
        constant 
        returns (uint balance) 
    {
        return self.balances[_owner];
    }

    function approve(EternalTokenStorage.TokenStorage storage self, address _caller, address _spender, uint _value) 
        constant
        returns (bool success) 
    {
        self.allowed[_caller][_spender] = _value;
        Approval(_caller, _spender, _value);
        return true;
    }

    function allowance(EternalTokenStorage.TokenStorage storage self, address _owner, address _spender) 
        constant 
        returns (uint remaining) 
    {
        return self.allowed[_owner][_spender];
    }

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}
