pragma solidity ^0.4.11;

contract EternalTokenStorage {
    struct TokenStorage {
        mapping (address => uint) balances;
        mapping (address => mapping (address => uint)) allowed;
        uint totalSupply;
    }
}
