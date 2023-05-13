// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.0;

import "./ISafeInterfaces.sol";
import "@openzeppelin/access/AccessControl.sol";

contract PrepaidModule is AccessControl{
    address merchand;
    address cardHodler;
    // Define a new role identifier for the merchand
    bytes32 public constant MERCHAND_ROLE = keccak256("MERCHAND_ROLE");

    // Define a new role identifier for the card hodler
    bytes32 public constant CARD_HODLER_ROLE = keccak256("CARD_HODLER_ROLE");

    error TxExecutionModuleFailed();

    constructor(address _merchand, address _cardHodler) {
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

        bytes memory data = abi.encodeWithSelector(
            ISafeInterfaces.removeOwner.selector, prevOwner, msg.sender, 1
        );
        require(safeDestination.execTransactionFromModule(safe, 0, data, Enum.Operation.Call), "Could not execute remove merchand to activate card");
    }
}