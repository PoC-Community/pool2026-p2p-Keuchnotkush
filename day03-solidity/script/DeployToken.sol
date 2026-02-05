// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract TokenScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        uint256 initial = vm.envUint("INITIAL_SUPPLY");
        if (initial == 0) {
            initial = 1_000_000; // default 1,000,000 tokens
        }
        vm.startBroadcast(deployerPrivateKey);
        // initial supply multiplied by 1e18 (ERC20 decimals)
        new MyToken("My Token", "MTK", initial * 1e18);
        vm.stopBroadcast();
    }
}
