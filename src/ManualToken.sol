// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {
    mapping(address => uint256) private balances;

    function name() public pure returns (string memory) {
        return "ManualToken";
    }

    function symbol() public pure returns (string memory) {
        return "MTK";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public pure returns (uint256) {
        return 100 * 10 ** 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _account) public returns (bool) {
        uint256 previousBalance = balances[msg.sender] + balances[_to];
        balances[msg.sender] -= _account;
        balances[_to] += _account;
        require(balances[msg.sender] + balances[_to] == previousBalance);
        return true;
    }
}
