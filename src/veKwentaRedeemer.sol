// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@kwenta/interfaces/IRewardEscrow.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

/// @title $veKWENTA redeemer for $KWENTA (Optimism)
/// @author JaredBorders (jaredborders@proton.me)
/// @notice exchanges $veKWENTA for equal amount of $KWENTA
/// and creates reward escrow entry for address specified by the caller
contract veKwentaRedeemer {
    /*///////////////////////////////////////////////////////////////
                                Constants
    ///////////////////////////////////////////////////////////////*/

    /// @notice token to be burned
    address public immutable veKwenta;

    /// @notice token to be redeemed
    /// @dev token will be sent to escrow
    address public immutable kwenta;

    /// @notice reward escrow address
    address public immutable rewardEscrow;

    /*///////////////////////////////////////////////////////////////
                                Events
    ///////////////////////////////////////////////////////////////*/

    /// @notice emitted when $veKWENTA is exchanged for $KWENTA
    /// @param redeemer: caller who exchanged $veKWENTA for $KWENTA
    /// @param beneficiary: account address used when creating escrow entry
    /// @param redeemedAmount: amount of $KWENTA redeemed and then escrowed
    event Redeemed(
        address indexed redeemer,
        address indexed beneficiary,
        uint256 redeemedAmount
    );

    /*///////////////////////////////////////////////////////////////
                                Errors
    ///////////////////////////////////////////////////////////////*/

    /// @notice caller has no $veKWENTA to exchange
    /// @param caller: caller of the redeem() function
    /// @param callerBalance: caller's balance of $veKWENTA
    error InvalidCallerBalance(address caller, uint256 callerBalance);

    /// @notice contract does not have enough $KWENTA to exchange
    /// @param contractBalance: veKwentaRedeemer's $KWENTA balance
    error InvalidContractBalance(uint256 contractBalance);

    /// @notice $veKWENTA transfer to this address failed
    /// @param caller: caller of the redeem() function
    error TransferFailed(address caller);

    /*///////////////////////////////////////////////////////////////
                                Constructor
    ///////////////////////////////////////////////////////////////*/

    /// @notice establish necessary addresses
    /// @param _veKwenta: L2 token address of $veKWENTA
    /// @param _kwenta: L2 token address $KWENTA
    /// @param _rewardEscrow: address of reward escrow for $KWENTA
    constructor(
        address _veKwenta,
        address _kwenta,
        address _rewardEscrow
    ) {
        veKwenta = _veKwenta;
        kwenta = _kwenta;
        rewardEscrow = _rewardEscrow;
    }

    /*///////////////////////////////////////////////////////////////
                        Redemption and Escrow Creation
    ///////////////////////////////////////////////////////////////*/

    /// @notice exchange caller's $veKWENTA for $KWENTA
    /// @dev $KWENTA will be sent to reward escrow
    /// @dev caller must approve this contract to spend $veKWENTA
    /// @param _beneficiary: account address used when creating escrow entry
    function redeem(address _beneficiary) external {
        // establish $veKWENTA and $KWENTA balances
        uint256 callerveKwentaBalance = IERC20(veKwenta).balanceOf(msg.sender);
        uint256 contractKwentaBalance = IERC20(kwenta).balanceOf(address(this));

        /// ensure valid $veKWENTA balance
        if (callerveKwentaBalance == 0) {
            revert InvalidCallerBalance({
                caller: msg.sender,
                callerBalance: callerveKwentaBalance
            });
        }

        /// ensure valid $KWENTA balance
        if (callerveKwentaBalance > contractKwentaBalance) {
            revert InvalidContractBalance({
                contractBalance: contractKwentaBalance
            });
        }

        /// lock $veKWENTA in this contract
        bool success = IERC20(veKwenta).transferFrom(
            msg.sender,
            address(this),
            callerveKwentaBalance
        );

        // ensure transfer suceeded
        if (!success) {
            revert TransferFailed({caller: msg.sender});
        }

        // create escrow entry
        IERC20(kwenta).approve(rewardEscrow, callerveKwentaBalance);
        IRewardEscrow(rewardEscrow).createEscrowEntry(
            _beneficiary,
            callerveKwentaBalance,
            52 weeks
        );

        emit Redeemed({
            redeemer: msg.sender,
            beneficiary: _beneficiary,
            redeemedAmount: callerveKwentaBalance
        });
    }
}
