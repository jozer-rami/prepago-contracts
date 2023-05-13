// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.0;

import "./ISafeInterfaces.sol";
import "@openzeppelin/access/AccessControl.sol";

contract PrepaidModule is AccessControl {
    address safeProxyFactory;
    address safeMasterCopy;
    address merchand;
    address cardHodler;
    // Define a new role identifier for the merchand
    bytes32 public constant MERCHAND_ROLE = keccak256("MERCHAND_ROLE");
    // Define a new role identifier for the card hodler
    bytes32 public constant CARD_HODLER_ROLE = keccak256("CARD_HODLER_ROLE");
    // Safe FALLBACK_HANDLER
    address internal constant FALLBACK_HANDLER = 0xf48f2B2d2a534e402487b3ee7C18c33Aec0Fe5e4;

    event ModuleEnabled(address indexed safe, address indexed module);

    error TxExecutionModuleFailed();
    error CreateSafeWithProxyFailed();

    constructor(address _safeProxyFactory, address _safeMasterCopy, address _merchand, address _cardHodler) {
        safeProxyFactory = _safeProxyFactory;
        safeMasterCopy = _safeMasterCopy;
        merchand = _merchand;
        cardHodler = _cardHodler;

        // Grant the merchand role to a specified address
        _setupRole(MERCHAND_ROLE, _merchand);
        _setupRole(CARD_HODLER_ROLE, _cardHodler);
    }

    function activateCard(address safe) public onlyRole(MERCHAND_ROLE) {
        ISafeInterfaces safeDestination = ISafeInterfaces(safe);
        // Get previous owner, for now the first owner will always be the card owner
        address[] memory owners = safeDestination.getOwners();
        address prevOwner = owners[0];

        bytes memory data = abi.encodeWithSelector(ISafeInterfaces.removeOwner.selector, prevOwner, msg.sender, 1);
        require(
            safeDestination.execTransactionFromModule(safe, 0, data, Enum.Operation.Call),
            "Could not execute remove merchand to activate card"
        );
    }

    function createSafeProxy(address[] memory owners, uint256 threshold) external returns (address safe) {
        bytes memory internalEnableModuleData = abi.encodeWithSignature("internalEnableModule(address)", address(this));

        bytes memory data = abi.encodeWithSignature(
            "setup(address[],uint256,address,bytes,address,address,uint256,address)",
            owners,
            threshold,
            this,
            internalEnableModuleData,
            FALLBACK_HANDLER,
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

    function internalEnableModule(address module) internal {
        this.enableModule(module);
    }

    /// @dev Non-executed code, function called by the new safe
    function enableModule(address module) external {
        emit ModuleEnabled(address(this), module);
    }
}
