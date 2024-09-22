// SPDX-License-Identifier: MIT
// Vulnerable Contract
pragma solidity ^0.8.0;

contract VulnerableContract {
    mapping(address => uint256) private balances;
    bool private locked;

    // Modifier to prevent reentrancy (for demonstration purposes, but won't work fully here)
    modifier noReentrant() {
        require(!locked, "ReentrancyGuard: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    // Deposit function to add funds
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // A read-only function (view function) that checks if an address is eligible for some bonus
    // The issue is that this can be attacked via reentrancy.
    function isEligibleForBonus(address _user) public view returns (bool) {
        // Check if the user has more than 1 ether balance for bonus eligibility
        return balances[_user] > 1 ether;
    }

    // Function to withdraw funds with a reentrancy guard
    function withdraw() external noReentrant {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");

        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
    }
}
