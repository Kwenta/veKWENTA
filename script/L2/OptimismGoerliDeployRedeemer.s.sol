// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/veKwentaRedeemer.sol";

/************************** 
TESTNET DEPLOYMENT: L2
**************************/

contract OptimismGoerliDeployRedeemer is Script {
    // contract(s) being deployed
    veKwentaRedeemer redeemer;

    // veKwentaRedeemer constructor arguments
    address private constant veKWENTA_ADDRESS = 0x3e52b5f840eafD79394c6359E93Bf3FfdAE89ee4;
    address private constant KWENTA_ADDRESS = address(0); // @TODO
    address private constant REWARD_ESCROW_ADDRESS = address(0); // @TODO

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
 * > forge script script/L2/OptimismGoerliDeployRedeemer.s.sol:OptimismGoerliDeployRedeemer --rpc-url $OPTIMISM_GOERLI_RPC_URL --broadcast --verify -vvvv
 */
