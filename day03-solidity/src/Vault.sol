// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is ReentrancyGuard, Ownable {
    event Deposit(address indexed user, uint256 assets, uint256 shares);
    event Withdraw(address indexed user, uint256 assets, uint256 shares);
    event RewardAdded(uint256 amount);
    
    error ZeroAmount();
    error InsufficientShares();
    error ZeroShares();
    
    IERC20 immutable asset;
    uint256 public totalShares;
    mapping(address => uint256) public sharesOf;

    constructor(IERC20 _asset) Ownable(msg.sender) {
        asset = _asset;
    }

    function _convertToShares(uint256 assets) internal view returns (uint256) {
        if (totalShares == 0) {
            return assets;
        } else {
            return (assets * totalShares) / asset.balanceOf(address(this));
        }
    }

    function _convertToAssets(uint256 shares) internal view returns (uint256) {
        if (totalShares == 0) {
            return shares;
        } else {
            return (shares * asset.balanceOf(address(this))) / totalShares;
        }
    }

    function deposit(uint256 assets) external nonReentrant returns (uint256 shares) {
        if (assets == 0) {
            revert ZeroAmount();
        }
        shares = _convertToShares(assets);
        if (shares == 0) {
            revert ZeroShares();
        }
        sharesOf[msg.sender] += shares;
        totalShares += shares;
        SafeERC20.safeTransferFrom(asset, msg.sender, address(this), assets);
        emit Deposit(msg.sender, assets, shares);
        return shares;
    }

    function withdraw(uint256 shares) public nonReentrant returns (uint256 assets) {
        if (shares == 0) {
            revert ZeroShares();
        }
        if (sharesOf[msg.sender] < shares) {
            revert InsufficientShares();
        }
        assets = _convertToAssets(shares);
        sharesOf[msg.sender] -= shares;
        totalShares -= shares;
        SafeERC20.safeTransfer(asset, msg.sender, assets);
        emit Withdraw(msg.sender, assets, shares);
        return assets;
    }

    function withdrawAll() external returns (uint256 assets) {
        uint256 shares = sharesOf[msg.sender];
        if (shares == 0) {
            revert ZeroShares();
        }
        if (sharesOf[msg.sender] < shares) {
            revert InsufficientShares();
        }
        assets = _convertToAssets(shares);
        sharesOf[msg.sender] -= shares;
        totalShares -= shares;
        SafeERC20.safeTransfer(asset, msg.sender, assets);
        emit Withdraw(msg.sender, assets, shares);
        return assets;
    }

    function previewDeposit(uint256 assets) external view returns (uint256 shares) {
        return _convertToShares(assets);
    }

    function previewWithdraw(uint256 shares) external view returns (uint256 assets) {
        return _convertToAssets(shares);
    }

    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }

    function currentRatio() external view returns (uint256) {
        if (totalShares == 0) {
            return 1e18;
        } else {
            return (totalAssets() * 1e18) / totalShares;
        }
    }

    function assetsOf(address user) external view returns (uint256) {
        return _convertToAssets(sharesOf[user]);
    }

    function addReward(uint256 amount) external onlyOwner {
        if (amount == 0) {
            revert ZeroAmount();
        }
        if (totalShares == 0) {
            revert ZeroShares();
        }
        
        SafeERC20.safeTransferFrom(asset, msg.sender, address(this), amount);
        emit RewardAdded(amount);
    }
}
