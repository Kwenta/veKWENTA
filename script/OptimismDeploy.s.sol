// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/L2veKwenta.sol";
import "../src/veKwentaRedeemer.sol";

/************************** 
MAINNET DEPLOYMENT: L2
**************************/

contract OptimismDeploy is Script {
    // contract(s) being deployed
    L2veKwenta veKwenta;
    veKwentaRedeemer redeemer;

    // L2veKwenta constructor arguments
    address private constant L1_TOKEN_ADDRESS = address(0); // @TODO
    string private constant NAME = "veKwenta";
    string private constant SYMBOL = "veKWENTA";

    // veKwentaRedeemer constructor arguments
    address private constant KWENTA_ADDRESS = address(0); // @TODO
    address private constant REWARD_ESCROW_ADDRESS = address(0); // @TODO

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        veKwenta = new L2veKwenta({
            _l1Token: L1_TOKEN_ADDRESS,
            _name: NAME,
            _symbol: SYMBOL
        });

        redeemer = new veKwentaRedeemer({
            _veKwenta: address(veKwenta),
            _kwenta: KWENTA_ADDRESS,
            _rewardEscrow: REWARD_ESCROW_ADDRESS
        });

        vm.stopBroadcast();
    }
}

/**
 * TO DEPLOY:
 *
 * @notice Kwenta.sol, RewardEscrow.sol, and L1veKwenta.sol 
 * MUST have been deployed prior to this script running
 *
 * To load the variables in the .env file
 * > source .env
 *
 * To deploy and verify our contract
 * > forge script script/OptimismDeploy.s.sol:OptimismDeploy --rpc-url $OPTIMISM_RPC_URL --broadcast --verify -vvvv
 */
