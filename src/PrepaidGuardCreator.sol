// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.0;

import "./ISafeInterfaces.sol";
import "./SetupHelper.sol";
import {Guard} from "@safe-contracts/base/GuardManager.sol";

contract PrepaidGuardCreator is SetupHelper, Guard {
    address public safeProxyFactory;
    address public safeMasterCopy;
    bool cardActivated;

    // Safe FALLBACK_HANDLER
    address internal constant FALLBACK_HANDLER = 0xf48f2B2d2a534e402487b3ee7C18c33Aec0Fe5e4;
    bytes4 public constant ENCODED_SIG_REMOVE_OWNER = bytes4(keccak256("removeOwner(address,address,uint256)"));

    error CreateSafeWithProxyFailed();

    constructor(address _safeProxyFactory, address _safeMasterCopy) {
        safeProxyFactory = _safeProxyFactory;
        safeMasterCopy = _safeMasterCopy;
        cardActivated = false;
    }

    // Create a safe proxy that will set this contract as a Guard
    function createSafeProxy(address[] memory owners, uint256 threshold) external payable returns (address safe) {
        bytes memory internalSetGuardData = abi.encodeWithSignature("internalSetGuard(address)", address(this));

        bytes memory data = abi.encodeWithSignature(
            "setup(address[],uint256,address,bytes,address,address,uint256,address)",
            owners,
            threshold,
            this,
            internalSetGuardData,
            FALLBACK_HANDLER,
            address(0x0),
            uint256(0),
            payable(address(0x0))
        );

        ISafeProxy safeProxy = ISafeProxy(safeProxyFactory);
        try safeProxy.createProxy(safeMasterCopy, data) returns (address newSafe) {
            // Forward Ether to the newly created safe address
            payable(newSafe).transfer(msg.value);
            return newSafe;
        } catch {
            revert CreateSafeWithProxyFailed();
        }
    }

    function checkTransaction(
        address,
        uint256,
        bytes calldata data,
        Enum.Operation,
        uint256,
        uint256,
        uint256,
        address,
        address payable,
        bytes memory,
        address
    ) external override {
        // Only Allow Remove Owner function while the prepaid card has not been activated
        if (!cardActivated) {
            require(bytes4(data) == ENCODED_SIG_REMOVE_OWNER, "Only Allow removeOwner call");
            cardActivated = true;
        }
    }

    function checkAfterExecution(bytes32, bool) external view override {}
}
