// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/L1veKwenta.sol";

/************************** 
TESTNET DEPLOYMENT: L1
**************************/

contract GoerliDeployL1veKwenta is Script {
    // contract(s) being deployed
    L1veKwenta veKwenta;

    // constructor arguments
    address private constant MINT_TO_ADDRESS = 0x652c46a302060B324A02d2d3e4a56e3DA07FA91b;
    uint256 private constant AMOUNT_TO_MINT = ((313373 ether * 35) / 100); // 109,680.55 ether
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
 * > forge script script/L1//GoerliDeployL1veKwenta.s.sol:GoerliDeployL1veKwenta --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
 */
