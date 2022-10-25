// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/L1veKwenta.sol";

contract L1veKwentaTest is Test {
    uint256 private constant KWENTA_SUPPLY = 313373;

    // constructor params
    address private constant mintToAddress =
        0x6e1768574dC439aE6ffCd2b0A0f218105f2612c6;
    string private constant name = "veKwenta";
    string private constant symbol = "veKWENTA";

    function testMinting() public {
        L1veKwenta veKwenta = new L1veKwenta({
            _mintToAddress: mintToAddress,
            _amountToMint: 1 ether,
            _name: name,
            _symbol: symbol
        });
        assertEq(veKwenta.balanceOf(mintToAddress), 1 ether);
    }

    function testFuzzMinting(uint256 amountToMint) public {
        L1veKwenta veKwenta = new L1veKwenta({
            _mintToAddress: mintToAddress,
            _amountToMint: amountToMint,
            _name: name,
            _symbol: symbol
        });
        assertEq(veKwenta.balanceOf(mintToAddress), amountToMint);
    }
}
