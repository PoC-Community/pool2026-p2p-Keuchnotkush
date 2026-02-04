// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract VaultTest is Test {
    Vault vault;
    ERC20Mock asset;

    address Alice = address(0x1);
    address owner = address(this);

    function setUp() public {
        asset = new ERC20Mock();
        asset.mint(owner, 1_000_000 ether);
        vault = new Vault(IERC20(address(asset)));
        asset.mint(Alice, 1_000 ether);
    }

    function testRewardsAdded() public {
        uint256 depositAmount = 1000 ether;
        uint256 rewardAmount = 100 ether;

        vm.startPrank(Alice);
        
        asset.approve(address(vault), type(uint256).max);
        uint256 sharesReceived = vault.deposit(depositAmount);
        vm.stopPrank();
        
        assertEq(vault.sharesOf(Alice), depositAmount, "Alice should have 1000 shares");
        assertEq(asset.balanceOf(address(vault)), depositAmount, "Vault should have 1000 tokens");

        vm.startPrank(owner);
        asset.approve(address(vault), type(uint256).max);
        vault.addReward(rewardAmount);
        vm.stopPrank();
        assertEq(asset.balanceOf(address(vault)), depositAmount + rewardAmount, "Vault should have 1100 tokens");

        uint256 aliceAssets = vault.assetsOf(Alice);
        assertEq(aliceAssets, depositAmount + rewardAmount, "Alice should be able to withdraw 1100 tokens");

        vm.startPrank(Alice);
        uint256 assetsReceived = vault.withdrawAll();
        vm.stopPrank();

        assertEq(assetsReceived, depositAmount + rewardAmount, "Alice should receive 1100 tokens");
        assertEq(vault.sharesOf(Alice), 0, "Alice should have 0 shares after withdrawal");
        assertEq(vault.totalShares(), 0, "Total shares should be 0");
    }
    
    // Vault vault;
    // ERC20Mock asset;

    // address user = address(0x1);

    // function setUp() public {
    //     asset = new ERC20Mock();
    //     asset.mint(address(this), 1_000_000 ether);
    //     vault = new Vault(IERC20(address(asset)));
    //     asset.mint(user, 1_000 ether);
    // }
    // function testDeposit() public {
    //     vm.startPrank(user);
    //     asset.approve(address(vault), type(uint256).max);
    //     uint256 shares = vault.deposit(100 ether);
    //     assertEq(shares, 100 ether);
    //     assertEq(vault.sharesOf(user), 100 ether);
    //     assertEq(vault.totalShares(), 100 ether);
    //     vm.stopPrank();
    // }

    // function testWithdraw() public {
    //     vm.startPrank(user);
    //     asset.approve(address(vault), type(uint256).max);
    //     uint256 shares = vault.deposit(200 ether);
    //     assertEq(shares, 200 ether);
    //     uint256 assets = vault.withdraw(100 ether);
    //     assertEq(assets, 100 ether);
    //     assertEq(vault.sharesOf(user), 100 ether);
    //     assertEq(vault.totalShares(), 100 ether);
    //     vm.stopPrank();
    // }

    // function testDepositZeroAmount() public {
    //     vm.startPrank(user);
    //     asset.approve(address(vault), type(uint256).max);
    //     vm.expectRevert(Vault.ZeroAmount.selector);
    //     vault.deposit(0);
    //     vm.stopPrank();
    // }

    // function testWithdrawInsufficientShares() public {
    //     vm.startPrank(user);
    //     asset.approve(address(vault), type(uint256).max);
    //     vault.deposit(50 ether);
    //     vm.expectRevert(Vault.InsufficientShares.selector);
    //     vault.withdraw(100 ether);
    //     vm.stopPrank();
    // }

    // function testWithdrawZeroShares() public {
    //     vm.startPrank(user);
    //     asset.approve(address(vault), type(uint256).max);
    //     vault.deposit(50 ether);
    //     vm.expectRevert(Vault.ZeroShares.selector);
    //     vault.withdraw(0);
    //     vm.stopPrank();
    // }

    // function testConvertToSharesAndAssets() public {
    //     vm.startPrank(user);
    //     asset.approve(address(vault), type(uint256).max);
    //     vault.deposit(100 ether);
    //     uint256 shares = vault.deposit(100 ether);
    //     assertEq(shares, 100 ether);
    //     uint256 assets = vault.withdraw(50 ether);
    //     assertEq(assets, 50 ether);
    //     vm.stopPrank();
    // }

    // function testMultipleUsers() public {
    //     address user2 = address(0x2);
    //     asset.mint(user2, 1_000 ether);

    //     vm.startPrank(user);
    //     asset.approve(address(vault), type(uint256).max);
    //     vault.deposit(200 ether);
    //     vm.stopPrank();

    //     vm.startPrank(user2);
    //     asset.approve(address(vault), type(uint256).max);
    //     vault.deposit(300 ether);
    //     vm.stopPrank();

    //     assertEq(vault.sharesOf(user), 200 ether);
    //     assertEq(vault.sharesOf(user2), 300 ether);
    //     assertEq(vault.totalShares(), 500 ether);

    //     vm.startPrank(user);
    //     uint256 assets1 = vault.withdraw(100 ether);
    //     assertEq(assets1, 100 ether);
    //     vm.stopPrank();

    //     vm.startPrank(user2);
    //     uint256 assets2 = vault.withdraw(150 ether);
    //     assertEq(assets2, 150 ether);
    //     vm.stopPrank();
    // }

    // function testReentrancyGuard() public {
    //     // This is a placeholder for reentrancy tests.
    //     // Implementing a full reentrancy attack simulation would require a malicious contract.
    //     assertTrue(true);
    // }

    // function testOwnership() public {
    //     assertEq(vault.owner(), address(this));
    // }
}
