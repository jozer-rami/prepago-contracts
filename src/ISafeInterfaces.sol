// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.15;

import {Enum} from "@safe-contracts/common/Enum.sol";

interface ISafeInterfaces {
    function execTransactionFromModule(address to, uint256 value, bytes calldata data, Enum.Operation operation)
        external
        returns (bool success);

    function removeOwner(address prevOwner, address owner, uint256 _threshold) external;

    function swapOwner(address prevOwner, address oldOwner, address newOwner) external;

    function getOwners() external view returns (address[] memory);
}

interface ISafeProxy {
    /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
    /// @param singleton Address of singleton contract.
    /// @param data Payload for message call sent to new proxy contract.
    function createProxy(address singleton, bytes memory data) external returns (address proxy);

    /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
    /// @param _singleton Address of singleton contract.
    /// @param initializer Payload for message call sent to new proxy contract.
    /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
    function createProxyWithNonce(address _singleton, bytes memory initializer, uint256 saltNonce)
        external
        returns (address proxy);
}
