// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    bool public willBreak;

    constructor() ERC20("Mock", "MOCK") {}

    function mint(address mintTo, uint256 mintAmount) public {
        _mint(mintTo, mintAmount);
    }

    function setWillBreak(bool _willBreak) public {
        willBreak = _willBreak;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (willBreak) require(false);
        super._transfer(from, to, amount);
    }
}
