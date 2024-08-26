
# Perennial V2 Update #3 contest details

- Join [Sherlock Discord](https://discord.gg/MABEWyASkp)
- Submit findings using the issue page in your private contest repo (label issues as med or high)
- [Read for more details](https://docs.sherlock.xyz/audits/watsons)

# Q&A

### Q: On what chains are the smart contracts going to be deployed?
Currently deployed to Arbitrum. Other EVM L2s are eligible but only Optimism Chains and Arbitrum are currently supported for gas pricing
___

### Q: If you are integrating tokens, are you allowing only whitelisted tokens to work with the codebase or any complying with the standard? Are they assumed to have certain properties, e.g. be non-reentrant? Are there any types of [weird tokens](https://github.com/d-xo/weird-erc20) you want to integrate?
DSU and USDC (native USDC on L2s)

The new Emptyset reserve strategies can interact with Aave aTokens and Compound v3 cTokens
___

### Q: Are there any limitations on values set by admins (or other roles) in the codebase, including restrictions on array lengths?
The Protocol parameter identifies some maximum/minimum values that are able to be set for market parameters. Refer to `ProtocolParameter.sol` and where those fields are used in `MarketParameter.sol` and `RiskParameter.sol`

The `OracleParameter.sol` determines the limits of the `KeeperOracleParameter.sol`
___

### Q: Are there any limitations on values set by admins (or other roles) in protocols you integrate with, including restrictions on array lengths?
No
___

### Q: For permissioned functions, please list all checks and requirements that will be made before calling the function.
For most permissioned functions there is a modifier which checks if the calling address is a specific address set in state. For example, `onlyOwner` requires the caller to be the `owner()` of the contract
___

### Q: Is the codebase expected to comply with any EIPs? Can there be/are there any deviations from the specification?
No
___

### Q: Are there any off-chain mechanisms or off-chain procedures for the protocol (keeper bots, arbitrage bots, etc.)?
Yes - there are keepers for oracle updates + settlements, liquidations, and order types. There is also a new Intent system which matches taker orders with corresponding netting orders from Market Makers, along with intents for Collateral Accounts and Trigger Orders
___

### Q: Are there any hardcoded values that you intend to change before (some) deployments?
Yes - will update the parameters that are set for the various GasOracles based on the cost to do certain actions on the respective chains. We will also update certain keeper bonuses. There are also values in the various `__Parameter.sol` structs that may be modified before deployment
___

### Q: If the codebase is to be deployed on an L2, what should be the behavior of the protocol in case of sequencer issues (if applicable)? Should Sherlock assume that the Sequencer won't misbehave, including going offline?
Sequencer downtime should be essentially handled as if the market is closed (no new position changes can be posted to the market). If there are other adverse effects of sequencer downtime we would like to know about them.

___

### Q: Should potential issues, like broken assumptions about function behavior, be reported if they could pose risks in future integrations, even if they might not be an issue in the context of the scope? If yes, can you elaborate on properties/invariants that should hold?
Yes - function behavior is defined in the natspec comments and if they pose integration risk we would like to be aware of that.
___

### Q: Please discuss any design choices you made.
Nothing stands out - Perennial is a complex codebase so we encourage auditors to thoroughly read documentation and comments, as well as ask us any questions about design decisions that they might have.
___

### Q: Please list any known issues and explicitly state the acceptable risks for each known issue.
Coordinators are given broad control over the parameters of the markets they coordinate. The protocol parameter is designed to prevent situations where parameters are set to malicious steal funds. If the coordinator can operate within the bounds of reasonable protocol parameters to negatively affect markets we would like to know about it

Oracle providers (Pyth, Chainlink, etc) are expected to provide and verify prices correctly. If they provide incorrect prices that are still verified on-chain, we have no ability to correct for this

There is no cure period for positions after sequencer downtime
___

### Q: We will report issues where the core protocol functionality is inaccessible for at least 7 days. Would you like to override this value?
We'd like to know of any issues which leave the functionality inaccessible for at least 24 hours
___

### Q: Please provide links to previous audits (if any).
https://github.com/equilibria-xyz/perennial-v2/tree/main/audits

___

### Q: Please list any relevant protocol resources.
V2.3 Intents Doc: https://docs.google.com/document/d/12nCBzhwYRCwAvNESxV0HHYVTFsS2-yNu5BsD9BRjI9M
V2 Docs: https://docs.perennial.finance (note: this is not updated for v2.3)
V2 Mechanism 1-pager: https://docs.google.com/document/d/1f-V_byFYkJdJAHMXxN2NiiDqysYhoqKzZXteee8BuIQ
___

### Q: Additional audit information.
The base of this audit should be this commit: https://github.com/equilibria-xyz/perennial-v2/commit/f61cbe10830da3ef6c636c22d517bf4bd075991b

This update enables Intents in the Perennial system - this allows for orders to be matched by an off-chain system and submitted on-chain by the market maker for the intent. This results in numerous signature based messages which are verified on-chain by the intent system. We have also moved some the existing extensions to the signature based system, such as trigger orders

Coming from update #2, we opted to fully remove "no-op" settles which allow for settlement without any changes to the account. We have also made settlement and liquidation fees gas-aware
___



# Audit scope


[emptyset-mono @ 90b1b5e9422f7a06afadeb7d2d7bc00ca1cfd459](https://github.com/equilibria-xyz/emptyset-mono/tree/90b1b5e9422f7a06afadeb7d2d7bc00ca1cfd459)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/ReserveBase.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/ReserveBase.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/AaveV3FiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/AaveV3FiatReserve.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/CompoundV3FiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/CompoundV3FiatReserve.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/NoopFiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/NoopFiatReserve.sol)

[perennial-v2 @ 08bfd603f0bd003825e8e9b517e40e44d289d9cd](https://github.com/equilibria-xyz/perennial-v2/tree/08bfd603f0bd003825e8e9b517e40e44d289d9cd)
- [perennial-v2/packages/perennial-account/contracts/Account.sol](perennial-v2/packages/perennial-account/contracts/Account.sol)
- [perennial-v2/packages/perennial-account/contracts/AccountVerifier.sol](perennial-v2/packages/perennial-account/contracts/AccountVerifier.sol)
- [perennial-v2/packages/perennial-account/contracts/Controller.sol](perennial-v2/packages/perennial-account/contracts/Controller.sol)
- [perennial-v2/packages/perennial-account/contracts/Controller_Arbitrum.sol](perennial-v2/packages/perennial-account/contracts/Controller_Arbitrum.sol)
- [perennial-v2/packages/perennial-account/contracts/Controller_Incentivized.sol](perennial-v2/packages/perennial-account/contracts/Controller_Incentivized.sol)
- [perennial-v2/packages/perennial-account/contracts/libs/RebalanceLib.sol](perennial-v2/packages/perennial-account/contracts/libs/RebalanceLib.sol)
- [perennial-v2/packages/perennial-account/contracts/types/Action.sol](perennial-v2/packages/perennial-account/contracts/types/Action.sol)
- [perennial-v2/packages/perennial-account/contracts/types/DeployAccount.sol](perennial-v2/packages/perennial-account/contracts/types/DeployAccount.sol)
- [perennial-v2/packages/perennial-account/contracts/types/MarketTransfer.sol](perennial-v2/packages/perennial-account/contracts/types/MarketTransfer.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RebalanceConfig.sol](perennial-v2/packages/perennial-account/contracts/types/RebalanceConfig.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RebalanceConfigChange.sol](perennial-v2/packages/perennial-account/contracts/types/RebalanceConfigChange.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedAccessUpdateBatch.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedAccessUpdateBatch.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedGroupCancellation.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedGroupCancellation.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedNonceCancellation.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedNonceCancellation.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedOperatorUpdate.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedOperatorUpdate.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedSignerUpdate.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedSignerUpdate.sol)
- [perennial-v2/packages/perennial-account/contracts/types/Withdrawal.sol](perennial-v2/packages/perennial-account/contracts/types/Withdrawal.sol)
- [perennial-v2/packages/perennial-extensions/contracts/Coordinator.sol](perennial-v2/packages/perennial-extensions/contracts/Coordinator.sol)
- [perennial-v2/packages/perennial-extensions/contracts/MultiInvoker.sol](perennial-v2/packages/perennial-extensions/contracts/MultiInvoker.sol)
- [perennial-v2/packages/perennial-oracle/contracts/Oracle.sol](perennial-v2/packages/perennial-oracle/contracts/Oracle.sol)
- [perennial-v2/packages/perennial-oracle/contracts/OracleFactory.sol](perennial-v2/packages/perennial-oracle/contracts/OracleFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/chainlink/ChainlinkFactory.sol](perennial-v2/packages/perennial-oracle/contracts/chainlink/ChainlinkFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/KeeperFactory.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/KeeperFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/KeeperOracle.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/KeeperOracle.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/libs/DedupLib.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/libs/DedupLib.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/types/KeeperOracleParameter.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/types/KeeperOracleParameter.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/types/PriceResponse.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/types/PriceResponse.sol)
- [perennial-v2/packages/perennial-oracle/contracts/metaquants/MetaQuantsFactory.sol](perennial-v2/packages/perennial-oracle/contracts/metaquants/MetaQuantsFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/payoff/Inverse.sol](perennial-v2/packages/perennial-oracle/contracts/payoff/Inverse.sol)
- [perennial-v2/packages/perennial-oracle/contracts/pyth/PythFactory.sol](perennial-v2/packages/perennial-oracle/contracts/pyth/PythFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/types/OracleParameter.sol](perennial-v2/packages/perennial-oracle/contracts/types/OracleParameter.sol)
- [perennial-v2/packages/perennial-order/contracts/Manager.sol](perennial-v2/packages/perennial-order/contracts/Manager.sol)
- [perennial-v2/packages/perennial-order/contracts/Manager_Arbitrum.sol](perennial-v2/packages/perennial-order/contracts/Manager_Arbitrum.sol)
- [perennial-v2/packages/perennial-order/contracts/OrderVerifier.sol](perennial-v2/packages/perennial-order/contracts/OrderVerifier.sol)
- [perennial-v2/packages/perennial-order/contracts/types/Action.sol](perennial-v2/packages/perennial-order/contracts/types/Action.sol)
- [perennial-v2/packages/perennial-order/contracts/types/CancelOrderAction.sol](perennial-v2/packages/perennial-order/contracts/types/CancelOrderAction.sol)
- [perennial-v2/packages/perennial-order/contracts/types/InterfaceFee.sol](perennial-v2/packages/perennial-order/contracts/types/InterfaceFee.sol)
- [perennial-v2/packages/perennial-order/contracts/types/PlaceOrderAction.sol](perennial-v2/packages/perennial-order/contracts/types/PlaceOrderAction.sol)
- [perennial-v2/packages/perennial-order/contracts/types/TriggerOrder.sol](perennial-v2/packages/perennial-order/contracts/types/TriggerOrder.sol)
- [perennial-v2/packages/perennial-vault/contracts/Vault.sol](perennial-v2/packages/perennial-vault/contracts/Vault.sol)
- [perennial-v2/packages/perennial-vault/contracts/VaultFactory.sol](perennial-v2/packages/perennial-vault/contracts/VaultFactory.sol)
- [perennial-v2/packages/perennial-vault/contracts/libs/StrategyLib.sol](perennial-v2/packages/perennial-vault/contracts/libs/StrategyLib.sol)
- [perennial-v2/packages/perennial-vault/contracts/types/Checkpoint.sol](perennial-v2/packages/perennial-vault/contracts/types/Checkpoint.sol)
- [perennial-v2/packages/perennial-vault/contracts/types/VaultParameter.sol](perennial-v2/packages/perennial-vault/contracts/types/VaultParameter.sol)
- [perennial-v2/packages/perennial-verifier/contracts/Verifier.sol](perennial-v2/packages/perennial-verifier/contracts/Verifier.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/AccessUpdate.sol](perennial-v2/packages/perennial-verifier/contracts/types/AccessUpdate.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/AccessUpdateBatch.sol](perennial-v2/packages/perennial-verifier/contracts/types/AccessUpdateBatch.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/Intent.sol](perennial-v2/packages/perennial-verifier/contracts/types/Intent.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/OperatorUpdate.sol](perennial-v2/packages/perennial-verifier/contracts/types/OperatorUpdate.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/SignerUpdate.sol](perennial-v2/packages/perennial-verifier/contracts/types/SignerUpdate.sol)
- [perennial-v2/packages/perennial/contracts/Market.sol](perennial-v2/packages/perennial/contracts/Market.sol)
- [perennial-v2/packages/perennial/contracts/MarketFactory.sol](perennial-v2/packages/perennial/contracts/MarketFactory.sol)
- [perennial-v2/packages/perennial/contracts/libs/CheckpointLib.sol](perennial-v2/packages/perennial/contracts/libs/CheckpointLib.sol)
- [perennial-v2/packages/perennial/contracts/libs/InvariantLib.sol](perennial-v2/packages/perennial/contracts/libs/InvariantLib.sol)
- [perennial-v2/packages/perennial/contracts/libs/MagicValueLib.sol](perennial-v2/packages/perennial/contracts/libs/MagicValueLib.sol)
- [perennial-v2/packages/perennial/contracts/libs/VersionLib.sol](perennial-v2/packages/perennial/contracts/libs/VersionLib.sol)
- [perennial-v2/packages/perennial/contracts/types/Global.sol](perennial-v2/packages/perennial/contracts/types/Global.sol)
- [perennial-v2/packages/perennial/contracts/types/Guarantee.sol](perennial-v2/packages/perennial/contracts/types/Guarantee.sol)
- [perennial-v2/packages/perennial/contracts/types/Local.sol](perennial-v2/packages/perennial/contracts/types/Local.sol)
- [perennial-v2/packages/perennial/contracts/types/MarketParameter.sol](perennial-v2/packages/perennial/contracts/types/MarketParameter.sol)
- [perennial-v2/packages/perennial/contracts/types/OracleReceipt.sol](perennial-v2/packages/perennial/contracts/types/OracleReceipt.sol)
- [perennial-v2/packages/perennial/contracts/types/Order.sol](perennial-v2/packages/perennial/contracts/types/Order.sol)
- [perennial-v2/packages/perennial/contracts/types/Position.sol](perennial-v2/packages/perennial/contracts/types/Position.sol)
- [perennial-v2/packages/perennial/contracts/types/ProtocolParameter.sol](perennial-v2/packages/perennial/contracts/types/ProtocolParameter.sol)
- [perennial-v2/packages/perennial/contracts/types/RiskParameter.sol](perennial-v2/packages/perennial/contracts/types/RiskParameter.sol)
- [perennial-v2/packages/perennial/contracts/types/Version.sol](perennial-v2/packages/perennial/contracts/types/Version.sol)

[root @ b323676390b56cd1519a7332dbcdab85040b475f](https://github.com/equilibria-xyz/root/tree/b323676390b56cd1519a7332dbcdab85040b475f)
- [root/contracts/adiabatic/types/LinearAdiabatic6.sol](root/contracts/adiabatic/types/LinearAdiabatic6.sol)
- [root/contracts/adiabatic/types/NoopAdiabatic6.sol](root/contracts/adiabatic/types/NoopAdiabatic6.sol)
- [root/contracts/attribute/Factory.sol](root/contracts/attribute/Factory.sol)
- [root/contracts/attribute/Ownable.sol](root/contracts/attribute/Ownable.sol)
- [root/contracts/gas/GasOracle.sol](root/contracts/gas/GasOracle.sol)
- [root/contracts/gas/GasOracle_Arbitrum.sol](root/contracts/gas/GasOracle_Arbitrum.sol)
- [root/contracts/gas/GasOracle_Optimism.sol](root/contracts/gas/GasOracle_Optimism.sol)
- [root/contracts/token/types/Token18.sol](root/contracts/token/types/Token18.sol)
- [root/contracts/token/types/Token6.sol](root/contracts/token/types/Token6.sol)
- [root/contracts/token/types/TokenOrEther18.sol](root/contracts/token/types/TokenOrEther18.sol)
- [root/contracts/verifier/VerifierBase.sol](root/contracts/verifier/VerifierBase.sol)
- [root/contracts/verifier/types/Common.sol](root/contracts/verifier/types/Common.sol)
- [root/contracts/verifier/types/GroupCancellation.sol](root/contracts/verifier/types/GroupCancellation.sol)




[emptyset-mono @ 90b1b5e9422f7a06afadeb7d2d7bc00ca1cfd459](https://github.com/equilibria-xyz/emptyset-mono/tree/90b1b5e9422f7a06afadeb7d2d7bc00ca1cfd459)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/ReserveBase.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/ReserveBase.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/AaveV3FiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/AaveV3FiatReserve.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/CompoundV3FiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/CompoundV3FiatReserve.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/NoopFiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/NoopFiatReserve.sol)

[perennial-v2 @ 08bfd603f0bd003825e8e9b517e40e44d289d9cd](https://github.com/equilibria-xyz/perennial-v2/tree/08bfd603f0bd003825e8e9b517e40e44d289d9cd)
- [perennial-v2/packages/perennial-account/contracts/Account.sol](perennial-v2/packages/perennial-account/contracts/Account.sol)
- [perennial-v2/packages/perennial-account/contracts/AccountVerifier.sol](perennial-v2/packages/perennial-account/contracts/AccountVerifier.sol)
- [perennial-v2/packages/perennial-account/contracts/Controller.sol](perennial-v2/packages/perennial-account/contracts/Controller.sol)
- [perennial-v2/packages/perennial-account/contracts/Controller_Arbitrum.sol](perennial-v2/packages/perennial-account/contracts/Controller_Arbitrum.sol)
- [perennial-v2/packages/perennial-account/contracts/Controller_Incentivized.sol](perennial-v2/packages/perennial-account/contracts/Controller_Incentivized.sol)
- [perennial-v2/packages/perennial-account/contracts/libs/RebalanceLib.sol](perennial-v2/packages/perennial-account/contracts/libs/RebalanceLib.sol)
- [perennial-v2/packages/perennial-account/contracts/types/Action.sol](perennial-v2/packages/perennial-account/contracts/types/Action.sol)
- [perennial-v2/packages/perennial-account/contracts/types/DeployAccount.sol](perennial-v2/packages/perennial-account/contracts/types/DeployAccount.sol)
- [perennial-v2/packages/perennial-account/contracts/types/MarketTransfer.sol](perennial-v2/packages/perennial-account/contracts/types/MarketTransfer.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RebalanceConfig.sol](perennial-v2/packages/perennial-account/contracts/types/RebalanceConfig.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RebalanceConfigChange.sol](perennial-v2/packages/perennial-account/contracts/types/RebalanceConfigChange.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedAccessUpdateBatch.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedAccessUpdateBatch.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedGroupCancellation.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedGroupCancellation.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedNonceCancellation.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedNonceCancellation.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedOperatorUpdate.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedOperatorUpdate.sol)
- [perennial-v2/packages/perennial-account/contracts/types/RelayedSignerUpdate.sol](perennial-v2/packages/perennial-account/contracts/types/RelayedSignerUpdate.sol)
- [perennial-v2/packages/perennial-account/contracts/types/Withdrawal.sol](perennial-v2/packages/perennial-account/contracts/types/Withdrawal.sol)
- [perennial-v2/packages/perennial-extensions/contracts/Coordinator.sol](perennial-v2/packages/perennial-extensions/contracts/Coordinator.sol)
- [perennial-v2/packages/perennial-extensions/contracts/MultiInvoker.sol](perennial-v2/packages/perennial-extensions/contracts/MultiInvoker.sol)
- [perennial-v2/packages/perennial-oracle/contracts/Oracle.sol](perennial-v2/packages/perennial-oracle/contracts/Oracle.sol)
- [perennial-v2/packages/perennial-oracle/contracts/OracleFactory.sol](perennial-v2/packages/perennial-oracle/contracts/OracleFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/chainlink/ChainlinkFactory.sol](perennial-v2/packages/perennial-oracle/contracts/chainlink/ChainlinkFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/KeeperFactory.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/KeeperFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/KeeperOracle.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/KeeperOracle.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/libs/DedupLib.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/libs/DedupLib.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/types/KeeperOracleParameter.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/types/KeeperOracleParameter.sol)
- [perennial-v2/packages/perennial-oracle/contracts/keeper/types/PriceResponse.sol](perennial-v2/packages/perennial-oracle/contracts/keeper/types/PriceResponse.sol)
- [perennial-v2/packages/perennial-oracle/contracts/metaquants/MetaQuantsFactory.sol](perennial-v2/packages/perennial-oracle/contracts/metaquants/MetaQuantsFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/payoff/Inverse.sol](perennial-v2/packages/perennial-oracle/contracts/payoff/Inverse.sol)
- [perennial-v2/packages/perennial-oracle/contracts/pyth/PythFactory.sol](perennial-v2/packages/perennial-oracle/contracts/pyth/PythFactory.sol)
- [perennial-v2/packages/perennial-oracle/contracts/types/OracleParameter.sol](perennial-v2/packages/perennial-oracle/contracts/types/OracleParameter.sol)
- [perennial-v2/packages/perennial-order/contracts/Manager.sol](perennial-v2/packages/perennial-order/contracts/Manager.sol)
- [perennial-v2/packages/perennial-order/contracts/Manager_Arbitrum.sol](perennial-v2/packages/perennial-order/contracts/Manager_Arbitrum.sol)
- [perennial-v2/packages/perennial-order/contracts/OrderVerifier.sol](perennial-v2/packages/perennial-order/contracts/OrderVerifier.sol)
- [perennial-v2/packages/perennial-order/contracts/types/Action.sol](perennial-v2/packages/perennial-order/contracts/types/Action.sol)
- [perennial-v2/packages/perennial-order/contracts/types/CancelOrderAction.sol](perennial-v2/packages/perennial-order/contracts/types/CancelOrderAction.sol)
- [perennial-v2/packages/perennial-order/contracts/types/InterfaceFee.sol](perennial-v2/packages/perennial-order/contracts/types/InterfaceFee.sol)
- [perennial-v2/packages/perennial-order/contracts/types/PlaceOrderAction.sol](perennial-v2/packages/perennial-order/contracts/types/PlaceOrderAction.sol)
- [perennial-v2/packages/perennial-order/contracts/types/TriggerOrder.sol](perennial-v2/packages/perennial-order/contracts/types/TriggerOrder.sol)
- [perennial-v2/packages/perennial-vault/contracts/Vault.sol](perennial-v2/packages/perennial-vault/contracts/Vault.sol)
- [perennial-v2/packages/perennial-vault/contracts/VaultFactory.sol](perennial-v2/packages/perennial-vault/contracts/VaultFactory.sol)
- [perennial-v2/packages/perennial-vault/contracts/libs/StrategyLib.sol](perennial-v2/packages/perennial-vault/contracts/libs/StrategyLib.sol)
- [perennial-v2/packages/perennial-vault/contracts/types/Checkpoint.sol](perennial-v2/packages/perennial-vault/contracts/types/Checkpoint.sol)
- [perennial-v2/packages/perennial-vault/contracts/types/VaultParameter.sol](perennial-v2/packages/perennial-vault/contracts/types/VaultParameter.sol)
- [perennial-v2/packages/perennial-verifier/contracts/Verifier.sol](perennial-v2/packages/perennial-verifier/contracts/Verifier.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/AccessUpdate.sol](perennial-v2/packages/perennial-verifier/contracts/types/AccessUpdate.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/AccessUpdateBatch.sol](perennial-v2/packages/perennial-verifier/contracts/types/AccessUpdateBatch.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/Intent.sol](perennial-v2/packages/perennial-verifier/contracts/types/Intent.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/OperatorUpdate.sol](perennial-v2/packages/perennial-verifier/contracts/types/OperatorUpdate.sol)
- [perennial-v2/packages/perennial-verifier/contracts/types/SignerUpdate.sol](perennial-v2/packages/perennial-verifier/contracts/types/SignerUpdate.sol)
- [perennial-v2/packages/perennial/contracts/Market.sol](perennial-v2/packages/perennial/contracts/Market.sol)
- [perennial-v2/packages/perennial/contracts/MarketFactory.sol](perennial-v2/packages/perennial/contracts/MarketFactory.sol)
- [perennial-v2/packages/perennial/contracts/libs/CheckpointLib.sol](perennial-v2/packages/perennial/contracts/libs/CheckpointLib.sol)
- [perennial-v2/packages/perennial/contracts/libs/InvariantLib.sol](perennial-v2/packages/perennial/contracts/libs/InvariantLib.sol)
- [perennial-v2/packages/perennial/contracts/libs/MagicValueLib.sol](perennial-v2/packages/perennial/contracts/libs/MagicValueLib.sol)
- [perennial-v2/packages/perennial/contracts/libs/VersionLib.sol](perennial-v2/packages/perennial/contracts/libs/VersionLib.sol)
- [perennial-v2/packages/perennial/contracts/types/Global.sol](perennial-v2/packages/perennial/contracts/types/Global.sol)
- [perennial-v2/packages/perennial/contracts/types/Guarantee.sol](perennial-v2/packages/perennial/contracts/types/Guarantee.sol)
- [perennial-v2/packages/perennial/contracts/types/Local.sol](perennial-v2/packages/perennial/contracts/types/Local.sol)
- [perennial-v2/packages/perennial/contracts/types/MarketParameter.sol](perennial-v2/packages/perennial/contracts/types/MarketParameter.sol)
- [perennial-v2/packages/perennial/contracts/types/OracleReceipt.sol](perennial-v2/packages/perennial/contracts/types/OracleReceipt.sol)
- [perennial-v2/packages/perennial/contracts/types/Order.sol](perennial-v2/packages/perennial/contracts/types/Order.sol)
- [perennial-v2/packages/perennial/contracts/types/Position.sol](perennial-v2/packages/perennial/contracts/types/Position.sol)
- [perennial-v2/packages/perennial/contracts/types/ProtocolParameter.sol](perennial-v2/packages/perennial/contracts/types/ProtocolParameter.sol)
- [perennial-v2/packages/perennial/contracts/types/RiskParameter.sol](perennial-v2/packages/perennial/contracts/types/RiskParameter.sol)
- [perennial-v2/packages/perennial/contracts/types/Version.sol](perennial-v2/packages/perennial/contracts/types/Version.sol)




[emptyset-mono @ 90b1b5e9422f7a06afadeb7d2d7bc00ca1cfd459](https://github.com/equilibria-xyz/emptyset-mono/tree/90b1b5e9422f7a06afadeb7d2d7bc00ca1cfd459)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/ReserveBase.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/ReserveBase.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/AaveV3FiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/AaveV3FiatReserve.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/CompoundV3FiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/CompoundV3FiatReserve.sol)
- [emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/NoopFiatReserve.sol](emptyset-mono/packages/emptyset-reserve/contracts/reserve/strategy/NoopFiatReserve.sol)


