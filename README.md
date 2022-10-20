# veKwenta

Used for the $KWENTA token distribution as described in https://kips.kwenta.io/kips/kip-34/. Should not be confused as 'vote escrowed' $KWENTA.

## Contracts

```ml
script/Deploy.s.sol ^0.8.13
└── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0
    ├── lib/forge-std/src/console.sol >=0.4.22 <0.9.0
    ├── lib/forge-std/src/console2.sol >=0.4.22 <0.9.0
    └── lib/forge-std/src/StdJson.sol >=0.6.0 <0.9.0
        └── lib/forge-std/src/Vm.sol >=0.6.0 <0.9.0
src/veKwenta.sol ^0.8.13
src/veKwentaRedeemer.sol ^0.8.13
test/veKwenta.t.sol ^0.8.13
├── lib/forge-std/src/Test.sol >=0.6.0 <0.9.0
│   ├── lib/forge-std/src/Script.sol >=0.6.0 <0.9.0 (*)
│   └── lib/forge-std/lib/ds-test/src/test.sol >=0.5.0
└── src/veKwenta.sol ^0.8.13
```

## Specs

### Introduction 

* The Kwenta DAO will host two Aelin pools with a combined 35% of the initial supply which will enable eligible addresses to purchase $veKWENTA (for a discounted price relative to $KWENTA)
* $veKWENTA can then be exchanged for $KWENTA with a 1-year vesting period *on L2* via the `veKwentaRedeemer.sol`
* Eligible addresses include both EOA's and contract addresses
* L1 *EOA addresses* persist on L2 and thus, purchasing $veKWENTA is straight-forward 
* L1 *contract addresses* eligible to purchase $veKWENTA require a seperate cross-chain purchasing mechanism
* There will be *two* Aelin pools for users to purchase $veKWENTA; a pool on L1 for L1 *contract addresses* and a pool on L2 for L1/L2 *EOA addresses*

### $veKWENTA

* Initial supply will be deployed and minted on L1
* Supply can be purchased by eligible addresses from the Aelin pools on both L1 and L2
* Used to later claim $KWENTA 
* Token implements [IL2StandardERC20](https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts/contracts/standards/IL2StandardERC20.sol) to allow for bridging to Optimism using the Standard Bridge
* L2 compatibility achieved following guide described [here](https://github.com/ethereum-optimism/optimism-tutorial/tree/main/standard-bridge-standard-token#deploying-a-standard-token)

### L1 Pool

* Merkle tree (and derived root) for Aelin pool on L1 will *ONLY* contain addresses which have non-zero bytecode (i.e. are contracts) and their associated amounts
* Pool will exchange $sUSD for $veKWENTA
* Pool details defined by Aelin

### L2 Pool

* Merkle tree (and derived root) for Aelin pool on L2 will contain all addresses *EXCEPT* those which have non-zero bytecode (i.e. are contracts) on L1
* Pool will exchange $sUSD for $veKWENTA
* Pool details defined by Aelin

### Claiming Mechanism for L1 *contract addresses*

* Contract addresss will purchase $veKWENTA and then bridge $veKWENTA over to L2
* Once on L2, $veKWENTA can be used to redeem $KWENTA which will then be sent to escrow

### Claiming Mechanism for *EOA addresses*

* Whitelisted addresss will purchase $veKWENTA
* $veKWENTA can be used to redeem $KWENTA which will then be sent to escrow

## Addresses

### L1
@todo
### L2
@todo