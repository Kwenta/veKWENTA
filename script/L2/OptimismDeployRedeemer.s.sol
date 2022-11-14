// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/veKwentaRedeemer.sol";

/************************** 
MAINNET DEPLOYMENT: L2
**************************/

contract OptimismDeployRedeemer is Script {
    // contract(s) being deployed
    veKwentaRedeemer redeemer;

    // veKwentaRedeemer constructor arguments
    address private constant veKWENTA_ADDRESS = 0x678d8f4Ba8DFE6bad51796351824DcCECeAefF2B;
    address private constant KWENTA_ADDRESS = 0x920Cf626a271321C151D027030D5d08aF699456b;
    address private constant REWARD_ESCROW_ADDRESS = 0x1066A8eB3d90Af0Ad3F89839b974658577e75BE2;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        redeemer = new veKwentaRedeemer({
            _veKwenta: veKWENTA_ADDRESS,
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
 * > forge script script/L2/OptimismDeployRedeemer.s.sol:OptimismDeployRedeemer --rpc-url $OPTIMISM_RPC_URL --broadcast --verify -vvvv
 */
