# veKwenta

[![Github Actions][gha-badge]][gha] 
[![Foundry][foundry-badge]][foundry] 
[![License: MIT][license-badge]][license]

[gha]: https://github.com/Kwenta/veKWENTA/actions
[gha-badge]: https://github.com/Kwenta/veKWENTA/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg


Used for the $KWENTA token distribution as described in https://kips.kwenta.io/kips/kip-34/. Should not be confused as 'vote escrowed' $KWENTA.

## Contracts

```
script/GoerliDeploy.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0
│   ├── lib/forge-std/src/console.sol >=0.4.22 <0.9.0
│   ├── lib/forge-std/src/console2.sol >=0.4.22 <0.9.0
│   └── lib/forge-std/src/StdJson.sol >=0.6.0 <0.9.0
│       └── lib/forge-std/src/Vm.sol >=0.6.0 <0.9.0
└── src/L1veKwenta.sol ^0.8.13
    └── lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol ^0.8.0
        ├── lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol ^0.8.0
        ├── lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol ^0.8.0
        │   └── lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol ^0.8.0
        └── lib/openzeppelin-contracts/contracts/utils/Context.sol ^0.8.0
script/MainnetDeploy.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
└── src/L1veKwenta.sol ^0.8.13 (*)
script/OptimismDeploy.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
├── src/L2veKwenta.sol ^0.8.13
│   ├── src/interfaces/IL2StandardERC20.sol ^0.8.13
│   │   ├── lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol ^0.8.0
│   │   └── lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol ^0.8.0
│   ├── src/libraries/Lib_PredeployAddresses.sol ^0.8.13
│   └── lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol ^0.8.0 (*)
└── src/veKwentaRedeemer.sol ^0.8.13
    ├── lib/token/contracts/interfaces/IRewardEscrow.sol ^0.8.0
    └── lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol ^0.8.0
        └── lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol ^0.8.0
script/OptimismGoerliDeploy.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
├── src/L2veKwenta.sol ^0.8.13 (*)
└── src/veKwentaRedeemer.sol ^0.8.13 (*)
src/L1veKwenta.sol ^0.8.13 (*)
src/L2veKwenta.sol ^0.8.13 (*)
src/interfaces/IL2StandardERC20.sol ^0.8.13 (*)
src/libraries/Lib_PredeployAddresses.sol ^0.8.13
src/veKwentaRedeemer.sol ^0.8.13 (*)
test/L1veKwenta.t.sol ^0.8.13
├── lib/forge-std/src/Test.sol >=0.6.0 <0.9.0
│   ├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
│   └── lib/forge-std/lib/ds-test/src/test.sol >=0.5.0
└── src/L1veKwenta.sol ^0.8.13 (*)
test/L2veKwenta.t.sol ^0.8.13
├── lib/forge-std/src/Test.sol >=0.6.0 <0.9.0 (*)
└── src/L2veKwenta.sol ^0.8.13 (*)
test/mock/MockERC20.sol ^0.8.13
└── lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol ^0.8.0 (*)
test/veKwentaRedeemer.t.sol ^0.8.13
├── lib/forge-std/src/Test.sol >=0.6.0 <0.9.0 (*)
├── src/veKwentaRedeemer.sol ^0.8.13 (*)
├── src/L2veKwenta.sol ^0.8.13 (*)
├── test/mock/MockERC20.sol ^0.8.13 (*)
└── lib/token/contracts/interfaces/IRewardEscrow.sol ^0.8.0
```

## Specs

### Introduction

-  The Kwenta DAO will host two Aelin pools with a combined 35% of the initial supply which will enable eligible addresses to purchase $veKWENTA (for a discounted price relative to $KWENTA)
-  $veKWENTA can then be exchanged for $KWENTA with a 1-year vesting period _on L2_ via the `veKwentaRedeemer.sol`
-  Eligible addresses include both EOA's and contract addresses
-  L1 _EOA addresses_ persist on L2 and thus, purchasing $veKWENTA is straight-forward
-  L1 _contract addresses_ eligible to purchase $veKWENTA require a seperate cross-chain purchasing mechanism
-  There will be _two_ Aelin pools for users to purchase $veKWENTA; a pool on L1 for L1 _contract addresses_ and a pool on L2 for L1/L2 _EOA addresses_

### $veKWENTA

-  Initial supply will be deployed and minted on L1
-  Supply can be purchased by eligible addresses from the Aelin pools on both L1 and L2
-  Used to later claim $KWENTA
-  Token implements [IL2StandardERC20](https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts/contracts/standards/IL2StandardERC20.sol) to allow for bridging to Optimism using the Standard Bridge
-  L2 compatibility achieved following guide described [here](https://github.com/ethereum-optimism/optimism-tutorial/tree/main/standard-bridge-standard-token#deploying-a-standard-token)

### L1 Pool

-  Merkle tree (and derived root) for Aelin pool on L1 will _ONLY_ contain addresses which have non-zero bytecode (i.e. are contracts) and their associated amounts
-  Pool will exchange $sUSD for $veKWENTA
-  Pool details defined by Aelin

### L2 Pool

-  Merkle tree (and derived root) for Aelin pool on L2 will contain all addresses _EXCEPT_ those which have non-zero bytecode (i.e. are contracts) on L1
-  Pool will exchange $sUSD for $veKWENTA
-  Pool details defined by Aelin

### Claiming Mechanism for L1 _contract addresses_

-  Contract addresss will purchase $veKWENTA and then bridge $veKWENTA over to L2
-  Once on L2, $veKWENTA can be used to redeem $KWENTA which will then be sent to escrow

### Claiming Mechanism for _EOA addresses_

-  Whitelisted addresss will purchase $veKWENTA
-  $veKWENTA can be used to redeem $KWENTA which will then be sent to escrow

## Code Coverage

```
+-----------------------------------+----------------+----------------+---------------+---------------+
| File                              | % Lines        | % Statements   | % Branches    | % Funcs       |
+=====================================================================================================+
| script/GoerliDeploy.s.sol         | 0.00% (0/4)    | 0.00% (0/5)    | 100.00% (0/0) | 0.00% (0/1)   |
|-----------------------------------+----------------+----------------+---------------+---------------|
| script/MainnetDeploy.s.sol        | 0.00% (0/4)    | 0.00% (0/5)    | 100.00% (0/0) | 0.00% (0/1)   |
|-----------------------------------+----------------+----------------+---------------+---------------|
| script/OptimismDeploy.s.sol       | 0.00% (0/5)    | 0.00% (0/6)    | 100.00% (0/0) | 0.00% (0/1)   |
|-----------------------------------+----------------+----------------+---------------+---------------|
| script/OptimismGoerliDeploy.s.sol | 0.00% (0/5)    | 0.00% (0/6)    | 100.00% (0/0) | 0.00% (0/1)   |
|-----------------------------------+----------------+----------------+---------------+---------------|
| src/L2veKwenta.sol                | 100.00% (7/7)  | 100.00% (9/9)  | 100.00% (0/0) | 100.00% (3/3) |
|-----------------------------------+----------------+----------------+---------------+---------------|
| src/veKwentaRedeemer.sol          | 91.67% (11/12) | 93.33% (14/15) | 83.33% (5/6)  | 100.00% (1/1) |
|-----------------------------------+----------------+----------------+---------------+---------------|
| test/mock/MockERC20.sol           | 25.00% (1/4)   | 25.00% (1/4)   | 0.00% (0/4)   | 33.33% (1/3)  |
|-----------------------------------+----------------+----------------+---------------+---------------|
| Total                             | 46.34% (19/41) | 48.00% (24/50) | 50.00% (5/10) | 45.45% (5/11) |
+-----------------------------------+----------------+----------------+---------------+---------------+
```

## Diagram

<p align="center">
  <img src="/veKWENTA_1.jpg" width="800" height="800" alt="veKwenta"/>
</p>

## Addresses

### L1

@todo

### L2

@todo
