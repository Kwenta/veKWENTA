// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/L2veKwenta.sol";

contract L2veKwentaTest is Test {
    uint256 private constant KWENTA_SUPPLY = 313373;
    address private constant L2_STANDARD_BRIDGE =
        0x4200000000000000000000000000000000000010;

    L2veKwenta private veKwenta;

    address private constant EOA = 0xc625F59d51ecDff57FEFE535C80d318CA42A0Ec4;

    // constructor params
    address private constant L1Token =
        0x6e1768574dC439aE6ffCd2b0A0f218105f2612c6;
    string private constant name = "veKwenta";
    string private constant symbol = "veKWENTA";

    function setUp() public {
        veKwenta = new L2veKwenta({
            _l1Token: L1Token,
            _name: name,
            _symbol: symbol
        });
    }

    function testL1TokenSet() public {
        assertEq(veKwenta.l1Token(), L1Token);
    }

    function testL2BridgeSet() public {
        assertEq(veKwenta.l2Bridge(), L2_STANDARD_BRIDGE);
    }

    function testL2veKwentaSupportsFirstInterface() public view {
        bytes4 supportedInterface = bytes4(
            keccak256("supportsInterface(bytes4)")
        );
        bool supportsInterface = veKwenta.supportsInterface(supportedInterface);
        assert(supportsInterface);
    }

    function testL2veKwentaSupportsSecondInterface() public view {
        bytes4 supportedInterface = IL2StandardERC20.l1Token.selector ^
            IL2StandardERC20.mint.selector ^
            IL2StandardERC20.burn.selector;
        bool supportsInterface = veKwenta.supportsInterface(supportedInterface);
        assert(supportsInterface);
    }

    function testOnlyL2BridgeCanMint() public {
        vm.prank(L2_STANDARD_BRIDGE);
        veKwenta.mint(EOA, 1 ether);
        assertEq(veKwenta.balanceOf(EOA), 1 ether);
    }

    function testOnlyL2BridgeCanBurn() public {
        vm.prank(L2_STANDARD_BRIDGE);
        veKwenta.mint(EOA, 1 ether);
        vm.prank(L2_STANDARD_BRIDGE);
        veKwenta.burn(EOA, 1 ether);
        assertEq(veKwenta.balanceOf(EOA), 0);
    }
}
