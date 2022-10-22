// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
// @TODO interface

// @TODO docs
contract veKwentaRedeemer {
    /// @notice token to be burned
    address public immutable veKwenta;

    /// @notice token to be redeemed
    /// @dev token will be sent to escrow
    address public immutable kwenta;

    /// @notice kwenta reward escrow address
    address public immutable rewardEscrow;

    // @TODO docs
    event Redeemed(address indexed redeemer, uint256 redeemedAmount);

    // @TODO docs
    constructor(
        address _veKwenta,
        address _kwenta,
        address _rewardEscrow
    ) {
        veKwenta = _veKwenta;
        kwenta = _kwenta;
        rewardEscrow = _rewardEscrow;
    }

    // @TODO docs
    function redeem() external {
        uint256 veKwentaBalance = IERC20(veKwenta).balanceOf(msg.sender);

        /// ensure valid balance
        require(veKwentaBalance > 0, "veKwentaRedeemer: No balance to redeem");
        require(
            veKwentaBalance <= IERC20(kwenta).balanceOf(address(this)),
            "veKwentaRedeemer: Insufficient contract balance"
        );

        /// lock veKwenta in this contract
        require(
            IERC20(veKwenta).transferFrom(
                msg.sender,
                address(this),
                veKwentaBalance
            ),
            "veKwentaRedeemer: veKwenta transfer failed"
        );

        // @TODO create escrow entry

        emit Redeemed(msg.sender, veKwentaBalance);
    }
}
