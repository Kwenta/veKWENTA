// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title L1 veKwenta (Optimism)
/// @author JaredBorders (jaredborders@proton.me)
/// @notice see https://github.com/ethereum-optimism
/// @dev simply deploy and supply aelin pool with veKwenta which
/// can be bridged to L2
contract L1veKwenta is ERC20 {
    /// @notice deploy veKwenta on L1 and mint 
    /// and transfer total supply to aelin pool
    /// @param _aelinPoolL1 address of aelin pool on L1
    /// @param _amountToMintForAelinL1 amount to mint and transfer
    /// @param _name ERC20 name
    /// @param _symbol ERC20 symbol
    constructor(
        address _aelinPoolL1,
        uint256 _amountToMintForAelinL1,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        /// @dev mint specified amount for aelin pool
        _mint(_aelinPoolL1, _amountToMintForAelinL1);
    }
}
