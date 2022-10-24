// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IL2StandardERC20.sol";
import {Lib_PredeployAddresses} from "./libraries/Lib_PredeployAddresses.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title L2 veKwenta (Optimism)
/// @author JaredBorders (jaredborders@proton.me)
/// @notice see https://github.com/ethereum-optimism
/// @dev simply deploy L2 veKwenta pair which supports
/// L2 standard ERC20 interface (thus facilitating bridging)
contract L2veKwenta is IL2StandardERC20, ERC20 {
    address public immutable l1Token;
    address public immutable l2Bridge;

    modifier onlyL2Bridge() {
        require(msg.sender == l2Bridge, "Only L2 Bridge can mint and burn");
        _;
    }

    /// @param _l1Token address of the corresponding L1 token
    /// @param _name ERC20 name
    /// @param _symbol ERC20 symbol
    constructor(
        address _l1Token,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        l1Token = _l1Token;
        l2Bridge = Lib_PredeployAddresses.L2_STANDARD_BRIDGE;
    }

    // slither-disable-next-line external-function
    function supportsInterface(bytes4 _interfaceId) public pure returns (bool) {
        bytes4 firstSupportedInterface = bytes4(
            keccak256("supportsInterface(bytes4)")
        ); // ERC165
        bytes4 secondSupportedInterface = IL2StandardERC20.l1Token.selector ^
            IL2StandardERC20.mint.selector ^
            IL2StandardERC20.burn.selector;
        return
            _interfaceId == firstSupportedInterface ||
            _interfaceId == secondSupportedInterface;
    }

    // slither-disable-next-line external-function
    function mint(address _to, uint256 _amount) public virtual onlyL2Bridge {
        _mint(_to, _amount);

        emit Mint(_to, _amount);
    }

    // slither-disable-next-line external-function
    function burn(address _from, uint256 _amount) public virtual onlyL2Bridge {
        _burn(_from, _amount);

        emit Burn(_from, _amount);
    }
}
