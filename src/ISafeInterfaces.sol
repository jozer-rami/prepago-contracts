// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.15;

import {Enum} from "@safe-contracts/common/Enum.sol";

interface ISafeInterfaces {
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation
    ) external returns (bool success);

    function removeOwner(address prevOwner, address owner, uint256 _threshold) external;

    function getOwners() external view returns (address[] memory);
}