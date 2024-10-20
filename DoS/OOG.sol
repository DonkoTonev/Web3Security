// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;


contract DoSExample {

    // a withdrawal batch created when some withdrawals were finalized
    struct WithdrawalBatch {
        // index of last withdrawal that was finalized in this batch
        uint128 indexOfLastWithdrawal;
        // the exchange rate of LSTs per underlying shares at the time of this batch
        uint128 stakePerShares;
    }

    uint128 public withdrawalBatchIdCutoff = 3;
    WithdrawalBatch[] public withdrawalBatches;

    // Populate the batches to simulate the DoS
    function populateBatches() public {
        for (uint128 i = 1; i <= 500; i++) {
            withdrawalBatches.push(WithdrawalBatch({
                indexOfLastWithdrawal: i * 2,  // Arbitrary index
                stakePerShares: 100
            }));
        }
    }

    function testLargeInput() public {
        uint256[] memory largeWithdrawalIds;
        for (uint256 i = 0; i < 1000; i++) {
            largeWithdrawalIds[i] = i + 1;
        }

        getBatchIds(largeWithdrawalIds);
    }

    function getBatchIds(uint256[] memory _withdrawalIds) public view returns (uint256[] memory) {    
        uint256[] memory batchIds = new uint256[](_withdrawalIds.length);

        for (uint256 i = 0; i < _withdrawalIds.length; ++i) {
            uint256 batchId;
            uint256 withdrawalId = _withdrawalIds[i];

            for (uint256 j = withdrawalBatchIdCutoff; j < withdrawalBatches.length; ++j) {
                uint256 indexOfLastWithdrawal = withdrawalBatches[j].indexOfLastWithdrawal;

                if (withdrawalId <= indexOfLastWithdrawal) {
                    batchId = j;
                    break;
                }
            }

            batchIds[i] = batchId;
        }

        return batchIds;
    }

}