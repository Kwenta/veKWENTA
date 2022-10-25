// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/L1veKwenta.sol";

/************************** 
MAINNET DEPLOYMENT: L1
**************************/

contract MainnetDeploy is Script {
    // contract(s) being deployed 
    L1veKwenta veKwenta;

    // constructor arguments
    address private constant MINT_TO_ADDRESS = address(0); // @TODO
    uint256 private constant AMOUNT_TO_MINT = 0; // @TODO
    string private constant NAME = "veKwenta";
    string private constant SYMBOL = "veKWENTA";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        veKwenta = new L1veKwenta({
            _mintToAddress: MINT_TO_ADDRESS,
            _amountToMint: AMOUNT_TO_MINT,
            _name: NAME,
            _symbol: SYMBOL
        });

        vm.stopBroadcast();
    }
}

/**
 * TO DEPLOY:
 *
 * To load the variables in the .env file
 * > source .env
 *
 * To deploy and verify our contract
 * > forge script script/MainnetDeploy.s.sol:MainnetDeploy.s --rpc-url $MAINNET_RPC_URL --broadcast --verify -vvvv
 */
