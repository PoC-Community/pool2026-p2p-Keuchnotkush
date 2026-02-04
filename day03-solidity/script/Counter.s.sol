// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VaultScript is Script {
    Vault public vault;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy with a mock ERC20 or real token address
        // vault = new Vault(IERC20(address(0x...)));
