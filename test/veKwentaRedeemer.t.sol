// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/veKwentaRedeemer.sol";
import "../src/L2veKwenta.sol";
import "./mock/MockERC20.sol";
import "@kwenta/interfaces/IRewardEscrow.sol";

contract veKwentaRedeemerTest is Test {
    uint256 private constant KWENTA_SUPPLY = 313373 ether;
    address private constant L2_STANDARD_BRIDGE =
        0x4200000000000000000000000000000000000010;

    L2veKwenta private veKwenta;
    veKwentaRedeemer private redeemer;
    MockERC20 kwenta;

    address private constant EOA = 0xc625F59d51ecDff57FEFE535C80d318CA42A0Ec4;

    // constructor params
    address private constant L1Token =
        0x6e1768574dC439aE6ffCd2b0A0f218105f2612c6;
    address private constant ESCROW =
        0x999999cf1046e68e36E1aA2E0E07105eDDD1f08E;
    string private constant name = "veKwenta";
    string private constant symbol = "veKWENTA";

    // events
    event Redeemed(
        address indexed redeemer,
        address indexed beneficiary,
        uint256 redeemedAmount
    );

    // errors

    // @mock rewardEscrow.createEscrowEntry()
    function mockRewardEscrow() internal {
        vm.etch(ESCROW, new bytes(0x19));
        vm.mockCall(
            ESCROW,
            abi.encodeWithSelector(
                IRewardEscrow.createEscrowEntry.selector,
                EOA,
                1 ether,
                52 weeks
            ),
            ""
        );
    }

    function setUp() public {
        kwenta = new MockERC20();

        veKwenta = new L2veKwenta({
            _l1Token: L1Token,
            _name: name,
            _symbol: symbol
        });

        redeemer = new veKwentaRedeemer({
            _veKwenta: address(veKwenta),
            _kwenta: address(kwenta),
            _rewardEscrow: ESCROW
        });

        mockRewardEscrow();
    }

    function testveKwentaSet() public {
        assertEq(redeemer.veKwenta(), address(veKwenta));
    }

    function testKwentaSet() public {
        assertEq(redeemer.kwenta(), address(kwenta));
    }

    function testEscrowSet() public {
        assertEq(redeemer.rewardEscrow(), ESCROW);
    }

    function testRedeem() public {
        kwenta.mint(address(redeemer), 1 ether);
        vm.prank(L2_STANDARD_BRIDGE);
        veKwenta.mint(EOA, 1 ether);
        vm.prank(EOA);
        veKwenta.approve(address(redeemer), 1 ether);
        vm.prank(EOA);
        redeemer.redeem(EOA);
        assertEq(veKwenta.balanceOf(address(redeemer)), 1 ether);
    }

    function testRedeemEmitsEvent() public {
        kwenta.mint(address(redeemer), 1 ether);
        vm.prank(L2_STANDARD_BRIDGE);
        veKwenta.mint(EOA, 1 ether);
        vm.prank(EOA);
        veKwenta.approve(address(redeemer), 1 ether);
        vm.expectEmit(true, true, false, true);
        emit Redeemed(EOA, EOA, 1 ether);
        vm.prank(EOA);
        redeemer.redeem(EOA);
    }

    function testRevertInvalidCallerBalance() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                veKwentaRedeemer.InvalidCallerBalance.selector,
                EOA,
                0
            )
        );
        vm.prank(EOA);
        redeemer.redeem(EOA);
    }

    function testRevertInvalidContractBalance() public {
        kwenta.mint(address(redeemer), 1 ether);
        vm.prank(L2_STANDARD_BRIDGE);
        veKwenta.mint(EOA, 2 ether);
        vm.prank(EOA);
        veKwenta.approve(address(redeemer), 2 ether);
        vm.expectRevert(
            abi.encodeWithSelector(
                veKwentaRedeemer.InvalidContractBalance.selector,
                1 ether
            )
        );
        vm.prank(EOA);
        redeemer.redeem(EOA);
    }
}
