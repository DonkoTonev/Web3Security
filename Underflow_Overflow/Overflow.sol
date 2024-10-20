// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;


contract IntegerOverflowExample {

    uint256 public largeNumber = 680564733841876926926749214863536422912;   // 2^129

    function overflowExample() public view returns (uint128) {
        uint128 smallNumber = uint128(largeNumber); 

        return smallNumber;
    }
}
