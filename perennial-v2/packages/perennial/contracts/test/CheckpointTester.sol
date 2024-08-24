// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import "../interfaces/IMarket.sol";
import "../types/Checkpoint.sol";
import "../libs/CheckpointLib.sol";

contract CheckpointTester {
    CheckpointStorage public checkpoint;

    function read() external view returns (Checkpoint memory) {
        return checkpoint.read();
    }

    function store(Checkpoint memory newCheckpoint) external {
        return checkpoint.store(newCheckpoint);
    }

    function accumulate(
        IMarket.Context memory context,
        IMarket.SettlementContext memory settlementContext,
        uint256 orderId,
        Order memory order,
        Guarantee memory guarantee,
        Version memory fromVersion,
        Version memory toVersion
    ) external returns (CheckpointAccumulationResponse memory response) {
        Checkpoint memory newCheckpoint = checkpoint.read();
        settlementContext.latestCheckpoint = newCheckpoint;

        (newCheckpoint, response) = CheckpointLib.accumulate(context, settlementContext, orderId, order, guarantee, fromVersion, toVersion);

        checkpoint.store(newCheckpoint);
    }
}
