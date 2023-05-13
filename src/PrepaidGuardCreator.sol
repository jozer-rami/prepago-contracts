// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.0;

import "./ISafeInterfaces.sol";
import "./SetupHelper.sol";
import {Guard} from "@safe-contracts/base/GuardManager.sol";

contract PrepaidGuardCreator is SetupHelper, Guard {
    address safeProxyFactory;
    address safeMasterCopy;
    address merchand;
    address cardHodler;

    // Safe FALLBACK_HANDLER
    address internal constant FALLBACK_HANDLER = 0xf48f2B2d2a534e402487b3ee7C18c33Aec0Fe5e4;
    address internal constant SENTINEL_OWNERS = address(0x1);
    bytes4 public constant ENCODED_SIG_REMOVE_OWNER = bytes4(keccak256("removeOwner(address,address,uint256)"));

    error CreateSafeWithProxyFailed();
    error CallerOfATransactionHasToBeTheMerchand();

    event callerIs(address);
    event checkTx();

    constructor(address _safeProxyFactory, address _safeMasterCopy, address _merchand, address _cardHodler) {
        safeProxyFactory = _safeProxyFactory;
        safeMasterCopy = _safeMasterCopy;
        merchand = _merchand;
        cardHodler = _cardHodler;
    }

    function createSafeProxy() external returns (address safe) {
        address[] memory owners = new address[](2);
        owners[0] = cardHodler;
        owners[1] = merchand;
        uint256 threshold = 1;

        bytes memory internalSetGuardData = abi.encodeWithSignature("internalSetGuard(address)", address(this));

        bytes memory data = abi.encodeWithSignature(
            "setup(address[],uint256,address,bytes,address,address,uint256,address)",
            owners,
            threshold,
            this,
            internalSetGuardData,
            address(0x0),
            address(0x0),
            uint256(0),
            payable(address(0x0))
        );

        ISafeProxy safeProxy = ISafeProxy(safeProxyFactory);
        try safeProxy.createProxy(safeMasterCopy, data) returns (address newSafe) {
            return newSafe;
        } catch {
            revert CreateSafeWithProxyFailed();
        }
    }

    function checkTransaction(
        address,
        uint256,
        bytes memory data,
        Enum.Operation,
        uint256,
        uint256,
        uint256,
        address,
        address payable,
        bytes memory,
        address
    ) external override {
        emit callerIs(msg.sender);
        emit checkTx();
    }

    function checkAfterExecution(bytes32, bool) external view override {}
}
