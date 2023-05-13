// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.0;

import "./ISafeInterfaces.sol";

contract GHOcardsModule {

    address merchand;
    address card;

    constructor(address _merchand, address _card) {
        merchand = _merchand;
        card = _card;
    }

}