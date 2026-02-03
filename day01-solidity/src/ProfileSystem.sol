// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


contract ProfileSystem {

    // ========== ENUMS ==========

    // TODO: Create enum Role { GUEST, USER, ADMIN }
    enum Role {
        GUEST,
        USER,
        ADMIN
    }

    // ========== STRUCTS ==========

    // TODO: Create struct UserProfile with:

    //   - string username

    //   - uint256 level

    //   - Role role

    //   - uint256 lastUpdated
    struct UserProfile {
        string username;
        uint256 level;
        Role role;
        uint256 lastUpdated;
    }

    // ========== MAPPINGS ==========

    // TODO: mapping(address => UserProfile) public profiles
    mapping(address => UserProfile) public profiles;


    // ========== CUSTOM ERRORS ==========

    // TODO: error UserAlrnameeadyExists()
    error UserAlreadyExists();
    // TODO: error EmptyUsername()
    error EmptyUsername();
    // TODO: error UserNotRegistered()
    error UserNotRegistered();

    modifier onlyRegistered(){
        if (profiles[msg.sender].level == 0) {
            revert UserNotRegistered();
        }
        _;
    }

    // ========== FUNCTIONS ==========

    function createProfile(string calldata _name) external {
        if (bytes(_name).length == 0) {
            revert EmptyUsername();
        }
        if (profiles[msg.sender].level != 0) {
            revert UserAlreadyExists();
        }
        profiles[msg.sender] = UserProfile({
            username: _name,
            level: 1,
            role: Role.USER,
            lastUpdated: block.timestamp
        });
        emit ProfileCreated(msg.sender, _name);
    }

    function levelUp() external onlyRegistered {
        UserProfile storage profile = profiles[msg.sender];
        profile.level += 1;
        profile.lastUpdated = block.timestamp;
        emit LevelUp(msg.sender, profile.level);
    }

    event ProfileCreated(address indexed user, string username);
    event LevelUp(address indexed user, uint256 newLevel);
}