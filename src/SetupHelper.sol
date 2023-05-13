// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.0;

contract SetupHelper {
    event ModuleEnabled(address indexed safe, address indexed module);
    event GuardSet(address indexed safe, address indexed module);

    // In our `SafeTeller.createSafe()` function, we call `GnosisSafeProxyFactory.createProxyWithNonce()`
    // with a callback to this `delegateSetup()` function. The proxy factory will then call this function
    // via a delegate call.
    // In the context of this delegate call, `this` will refer to the proxy factory, which then in turn makes a
    // delegate call to GnosisSafe, and `this` will then refer to GnosisSafe
    // therefore this function will call `GnosisSafe.enableModule()`, which is inherited from `ModuleManager`.
    function internalEnableModule(address module) external {
        this.enableModule(module);
    }

    /// @dev Non-executed code, function called by the new safe
    function enableModule(address module) external {
        emit ModuleEnabled(address(this), module);
    }

    function internalSetGuard(address guard) external {
        this.setGuard(guard);
    }

    /// @dev Non-executed code, function called by the new safe
    function setGuard(address guard) external {
        emit GuardSet(address(this), guard);
    }
}
