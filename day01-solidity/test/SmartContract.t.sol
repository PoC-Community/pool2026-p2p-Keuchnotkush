// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SmartContract.sol";

contract SmartContractTest is Test {
    SmartContractHelper helper;
    
    uint256 HAL; address MEC; string PIW;
    uint256 H = 21;
    function setUp() public {
        helper = new SmartContractHelper();
        HAL = helper.getHalfAnswerOfLife();
        MEC = helper.myEtherumContractAddress();
        PIW = helper.PoCIsWhat();
    }


    function testAnswer() public view {
        assertEq(HAL,H);
        assertEq(MEC,address(helper));
        assertEq(PIW,"PoC is good, PoC is life.");
    }

    function testStructComplete() public view {
        (string memory firstName, string memory lastName, uint8 age, string memory city, SmartContract.roleEnum role) = helper.myInformations();
        assertEq(firstName, "Keuch");
        assertEq(lastName, "Fall");
        assertEq(age, 20);
        assertEq(city, "Paris");
        assertEq(uint256(role), uint256(SmartContract.roleEnum.STUDENT));
    }

}