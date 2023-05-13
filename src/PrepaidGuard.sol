// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.15;

import {Guard} from "@safe-contracts/base/GuardManager.sol";
import {StorageAccessible} from "@safe-contracts/common/StorageAccessible.sol";
import {Enum} from "@safe-contracts/common/Enum.sol";
import "forge-std/console.sol";

contract PrepaidGuard is Guard {
    address merchand;
    bool cardActivated;

    bytes4 public constant ENCODED_SIG_REMOVE_OWNER = bytes4(keccak256("removeOwner(address,address,uint256)"));

    error CallerOfATransactionHasToBeTheMerchand();
    error MerchandCanOnlyExecuteRemoveOwner();

    event notRemoveOnwer(bytes4);
    event callerNotMerchand(address);
    event cardActivation();

    constructor(address _merchand) {
        merchand = _merchand;
        cardActivated = false;
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
        // Merchand is the only one who can execute while the prepaid card has not been activated
        if (!cardActivated) {
            // TODO improve this: should erecover signature and check that any sig is from the merchand
            if (msg.sender != merchand) {
                emit callerNotMerchand(msg.sender);
                revert CallerOfATransactionHasToBeTheMerchand();
            } else {
                // Check merchand can only execute Remove Owner
                if (bytes4(data) != ENCODED_SIG_REMOVE_OWNER) {
                    emit notRemoveOnwer(bytes4(data));
                    revert MerchandCanOnlyExecuteRemoveOwner();
                }
                emit cardActivation();
                cardActivated = true;
            }
        }
    }

    function checkAfterExecution(bytes32, bool) external view override {}
}
