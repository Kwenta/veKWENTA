// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/L2veKwenta.sol";

/************************** 
MAINNET DEPLOYMENT: L2
**************************/

contract OptimismDeployL2veKwenta is Script {
    // contract(s) being deployed
    L2veKwenta veKwenta;

    // L2veKwenta constructor arguments
    address private constant L1_TOKEN_ADDRESS = 0x6789D8a7a7871923Fc6430432A602879eCB6520a;
    string private constant NAME = "veKwenta";
    string private constant SYMBOL = "veKWENTA";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        veKwenta = new L2veKwenta({
            _l1Token: L1_TOKEN_ADDRESS,
            _name: NAME,
            _symbol: SYMBOL
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
 * > forge script script/L2/OptimismDeployL2veKwenta.s.sol:OptimismDeployL2veKwenta --rpc-url $OPTIMISM_RPC_URL --broadcast --verify -vvvv
 */
