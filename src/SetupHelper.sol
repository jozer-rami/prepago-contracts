// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.0;

import {Enum} from "@safe-contracts/common/Enum.sol";

contract SetupHelper {
    event ModuleEnabled(address indexed safe, address indexed module);
    event GuardSet(address indexed safe, address indexed module);

    // Trick to call enable module internally while creating safe
    function internalEnableModule(address module) external {
        this.enableModule(module);
    }

    function enableModule(address module) external {
        emit ModuleEnabled(address(this), module);
    }

    // Trick to call setGuard internally while creating safe
    function internalSetGuard(address guard) external {
        this.setGuard(guard);
    }

    function setGuard(address guard) external {
        emit GuardSet(address(this), guard);
    }
}
