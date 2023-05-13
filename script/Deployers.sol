// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {SafeProxyFactory} from
    "@safe-contracts/proxies/SafeProxyFactory.sol";
import {SafeProxy} from "@safe-contracts/proxies/SafeProxy.sol";
import {Safe} from "@safe-contracts/Safe.sol";
import {IProxyCreationCallback} from
    "@safe-contracts/proxies/IProxyCreationCallback.sol";
import {PrepaidModule} from "../src/PrepaidModule.sol";

contract DeploySafeFactory is Script {
    SafeProxyFactory public safeProxyFactory;
    Safe public safeMasterCopy;
    SafeProxy safeProxy;
    PrepaidModule prepaidModule;

    // Deploys a SafeProxyFactory & Safe contract
    function run() public {
        Solenv.config();
        address merchand = vm.envAddress("MERCHAND");
        address cardOwner= vm.envAddress("CARD_OWNER_1");

        vm.startBroadcast();
        safeProxyFactory = new SafeProxyFactory();
        safeMasterCopy = new Safe();
        
        prepaidModule = new PrepaidModule(address(safeProxyFactory), address(safeMasterCopy), card, merchand);
        vm.stopBroadcast();
    }
}


