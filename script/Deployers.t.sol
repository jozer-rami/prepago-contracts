// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {GnosisSafeProxyFactory} from "@safe-contracts/proxies/GnosisSafeProxyFactory.sol";
import {GnosisSafeProxy} from "@safe-contracts/proxies/GnosisSafeProxy.sol";
import {GnosisSafe} from "@safe-contracts/GnosisSafe.sol";
import {IProxyCreationCallback} from "@safe-contracts/proxies/IProxyCreationCallback.sol";
import {PrepaidModule} from "../src/PrepaidModule.sol";
import {PrepaidGuardCreator} from "../src/PrepaidGuardCreator.sol";
import "@solenv/Solenv.sol";

contract DeployAllTest is Script {
    GnosisSafeProxyFactory public safeProxyFactory;
    GnosisSafe public safeMasterCopy;
    GnosisSafeProxy safeProxy;
    PrepaidModule prepaidModule;

    // Deploys a SafeProxyFactory & Safe contract
    function run() public {
        Solenv.config();
        address merchand = vm.envAddress("MERCHAND");
        address cardHodler = vm.envAddress("CARD_HODLER_1");

        vm.startBroadcast();
        safeProxyFactory = new GnosisSafeProxyFactory();
        safeMasterCopy = new GnosisSafe();

        prepaidModule = new PrepaidModule(address(safeProxyFactory), address(safeMasterCopy), cardHodler, merchand);
        address newPrepaidCard = prepaidModule.createSafeProxy();
        vm.stopBroadcast();
    }
}

contract DeployPrepaidModule is Script {
    function run() public {
        Solenv.config();
        address merchand = vm.envAddress("MERCHAND");
        address cardHodler = vm.envAddress("CARD_HODLER_1");
        address safeProxyFactory = vm.envAddress("SAFE_PROXY_FACTORY_ADDRESS");
        address safeMasterCopy = vm.envAddress("SAFE_MASTER_COPY_ADDRESS");

        vm.startBroadcast();
        PrepaidModule prepaidModule =
            new PrepaidModule(address(safeProxyFactory), address(safeMasterCopy), cardHodler, merchand);
        vm.stopBroadcast();
    }
}

contract DeployPrepaidModuleWithSafe is Script {
    event safeCreated(address);

    function run() public {
        Solenv.config();
        address merchand = vm.envAddress("MERCHAND");
        address cardHodler = vm.envAddress("CARD_HODLER_1");
        address safeProxyFactory = vm.envAddress("SAFE_PROXY_FACTORY_ADDRESS");
        address safeMasterCopy = vm.envAddress("SAFE_MASTER_COPY_ADDRESS");

        vm.startBroadcast();
        PrepaidModule prepaidModule =
            new PrepaidModule(address(safeProxyFactory), address(safeMasterCopy), cardHodler, merchand);
        address newPrepaidCard = prepaidModule.createSafeProxy();
        emit safeCreated(newPrepaidCard);

        vm.stopBroadcast();
    }
}

contract DeployPrepaidGuardWithSafe is Script {
    event safeCreated(address);

    function run() public {
        Solenv.config();
        address merchand = vm.envAddress("MERCHAND");
        address cardHodler = vm.envAddress("CARD_HODLER_1");
        address safeProxyFactory = vm.envAddress("SAFE_PROXY_FACTORY_ADDRESS");
        address safeMasterCopy = vm.envAddress("SAFE_MASTER_COPY_ADDRESS");
        address[] memory owners = new address[](2);
        owners[0] = cardHodler;
        owners[1] = merchand;
        uint256 threshold = 1;
        vm.startBroadcast();
        PrepaidGuardCreator prepaidGuard = new PrepaidGuardCreator(address(safeProxyFactory), address(safeMasterCopy));
        address newPrepaidCard = prepaidGuard.createSafeProxy(owners, threshold);
        emit safeCreated(newPrepaidCard);
        vm.stopBroadcast();
    }
}
