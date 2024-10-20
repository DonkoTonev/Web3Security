// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PrecisionTest {

    uint256 public totalShares = 0;
    uint256 public totalStaked = 0;
    mapping(address => uint256) public shares;

    uint256 public constant DEAD_SHARES = 10 ** 3;

    function getSharesByStake(uint256 _amount) public view returns (uint256) {
        if (totalStaked == 0) {
            return _amount;
        } else {
            return (_amount * totalShares) / totalStaked;   // q Precision loss?
        }
    }

}
