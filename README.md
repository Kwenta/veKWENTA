# veKwenta

[![Github Actions][gha-badge]][gha] 
[![Foundry][foundry-badge]][foundry] 
[![License: MIT][license-badge]][license]

[gha]: https://github.com/Kwenta/veKWENTA/actions
[gha-badge]: https://github.com/Kwenta/veKWENTA/actions/workflows/Tests.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg


Used for the $KWENTA token distribution as described in https://kips.kwenta.io/kips/kip-34/. Should not be confused as 'vote escrowed' $KWENTA.

## Contracts

```
script/L1/GoerliDeployL1veKwenta.s.sol ^0.8.13
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
script/L1/MainnetDeployL1veKwenta.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
└── src/L1veKwenta.sol ^0.8.13 (*)
script/L2/OptimismDeployL2veKwenta.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
└── src/L2veKwenta.sol ^0.8.13
    ├── src/interfaces/IL2StandardERC20.sol ^0.8.13
    │   ├── lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol ^0.8.0
    │   └── lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol ^0.8.0
    ├── src/libraries/Lib_PredeployAddresses.sol ^0.8.13
    └── lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol ^0.8.0 (*)
script/L2/OptimismDeployRedeemer.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
└── src/veKwentaRedeemer.sol ^0.8.13
    ├── lib/token/contracts/interfaces/IRewardEscrow.sol ^0.8.0
    └── lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol ^0.8.0
        └── lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol ^0.8.0
script/L2/OptimismGoerliDeployL2veKwenta.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
└── src/L2veKwenta.sol ^0.8.13 (*)
script/L2/OptimismGoerliDeployRedeemer.s.sol ^0.8.13
├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
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

-  The Kwenta DAO will host one Aelin pool with 35% of the initial supply which will enable eligible addresses to purchase $veKWENTA (for a discounted price relative to $KWENTA) on Optimism (L2)
-  $veKWENTA can then be exchanged for $KWENTA with a 1-year vesting period _on L2_ via the `veKwentaRedeemer.sol`
-  Eligible addresses include both EOA's and contract addresses
-  After purchasing $veKWENTA, the user can bridge $veKWENTA to Optimism via the [Optimism Gateway Portal](https://gateway.optimism.io/)

### $veKWENTA

-  Initial supply will be deployed and minted on L1
-  Supply can be purchased by eligible addresses from the Aelin pool on both L1 ONLY
-  Used to later claim $KWENTA
-  Token implements [IL2StandardERC20](https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts/contracts/standards/IL2StandardERC20.sol) to allow for bridging to Optimism via the [Optimism Gateway Portal](https://gateway.optimism.io/)
-  L2 compatibility achieved following guide described [here](https://github.com/ethereum-optimism/optimism-tutorial/tree/main/standard-bridge-standard-token#deploying-a-standard-token)

### L1 Pool

-  Merkle tree (and derived root) for Aelin pool on L1 will contain all eligible addresses which can purchase $veKWENTA and how much they are allowed to buy
-  Pool will exchange $sUSD for $veKWENTA
-  Pool details defined by Aelin

### Claiming Mechanism 

-  Whitelisted addresss will purchase $veKWENTA
-  $veKWENTA must then be bridged to Optimism where it can be exchanged for $KWENTA
-  $veKWENTA can be used to redeem $KWENTA which will then be sent to escrow

## Code Coverage

```
+------------------------------------------------+----------------+----------------+---------------+---------------+
| File                                           | % Lines        | % Statements   | % Branches    | % Funcs       |
+==================================================================================================================+
| script/L1/GoerliDeployL1veKwenta.s.sol         | 0.00% (0/4)    | 0.00% (0/5)    | 100.00% (0/0) | 0.00% (0/1)   |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| script/L1/MainnetDeployL1veKwenta.s.sol        | 0.00% (0/4)    | 0.00% (0/5)    | 100.00% (0/0) | 0.00% (0/1)   |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| script/L2/OptimismDeployL2veKwenta.s.sol       | 0.00% (0/4)    | 0.00% (0/5)    | 100.00% (0/0) | 0.00% (0/1)   |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| script/L2/OptimismDeployRedeemer.s.sol         | 0.00% (0/4)    | 0.00% (0/5)    | 100.00% (0/0) | 0.00% (0/1)   |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| script/L2/OptimismGoerliDeployL2veKwenta.s.sol | 0.00% (0/4)    | 0.00% (0/5)    | 100.00% (0/0) | 0.00% (0/1)   |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| script/L2/OptimismGoerliDeployRedeemer.s.sol   | 0.00% (0/4)    | 0.00% (0/5)    | 100.00% (0/0) | 0.00% (0/1)   |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| src/L2veKwenta.sol                             | 100.00% (7/7)  | 100.00% (9/9)  | 100.00% (0/0) | 100.00% (3/3) |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| src/veKwentaRedeemer.sol                       | 91.67% (11/12) | 93.33% (14/15) | 83.33% (5/6)  | 100.00% (1/1) |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| test/mock/MockERC20.sol                        | 25.00% (1/4)   | 25.00% (1/4)   | 0.00% (0/4)   | 33.33% (1/3)  |
|------------------------------------------------+----------------+----------------+---------------+---------------|
| Total                                          | 40.43% (19/47) | 41.38% (24/58) | 50.00% (5/10) | 38.46% (5/13) |
+------------------------------------------------+----------------+----------------+---------------+---------------+
```

## Diagram

<p align="center">
  <img src="/veKwentaDiagram.png" width="800" height="500" alt="veKwenta"/>
</p>

## Deployment Addresses

### L1

#### Mainnet
L1veKwenta.sol: `https://etherscan.io/address/0x6789d8a7a7871923fc6430432a602879ecb6520a`
#### Goerli
L1veKwenta.sol: `https://goerli.etherscan.io/address/0xf36c9a9E8333663F8CA3608C5582916628E79e3f`

### L2

#### Optimism
L2veKwenta.sol: `https://optimistic.etherscan.io/address/0x678d8f4ba8dfe6bad51796351824dcceceaeff2b`
veKwentaRedeemer: tbd
#### Optimism Goerli
L2veKwenta.sol: `https://goerli-optimism.etherscan.io/address/0x3e52b5f840eafd79394c6359e93bf3ffdae89ee4`
veKwentaRedeemer: tbd
