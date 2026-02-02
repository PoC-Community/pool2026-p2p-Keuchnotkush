// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract SmartContract {
    uint256 public halfAnswerOfLife = 21;
    address public myEtherumContractAddress = address(this);
    address public myEtherumAddress = msg.sender;
    string public PoCIsWhat = "PoC is good, PoC is life.";
    bool internal _areYouABadPerson = false;
    int256 private _youAreACheater = -42;

    bytes32 public whoIsTheBest;
    mapping(string => uint256) public myGrades;
    string[5] public myPhoneNumber;
    enum roleEnum {
        STUDENT,
        TEACHER
    }
    struct informations {
        string firstName;
        string lastName;
        uint8 age;
        string city;
        roleEnum role;
    }

    informations public myInformations =
        informations({
            firstName: "Keuch",
            lastName: "Fall",
            age: 20,
            city: "Paris",
            role: roleEnum.STUDENT
        });

    /**

    * @notice Returns halfAnswerOfLife

    * @dev TODO: Return the value of halfAnswerOfLife

    */

    function getHalfAnswerOfLife() public view returns (uint256) {
        return halfAnswerOfLife;
    }

    /**

    * @notice Returns the contract address (internal)

    * @dev TODO: Return myEthereumContractAddress

    */

    function _getMyEthereumContractAddress() internal view returns (address) {
        return myEtherumContractAddress;
    }

    /**

    * @notice Returns PoCIsWhat (external only)

    * @dev TODO: Return PoCIsWhat with memory keyword for string

    */

    function getPoCIsWhat() external view returns (string memory) {
        return PoCIsWhat;
    }

    /**

    * @notice Sets _areYouABadPerson (internal)

    * @dev TODO: Update the internal variable

    */

    function _setAreYouABadPerson(bool _value) internal {
        _areYouABadPerson = _value;
    }
}

contract SmartContractHelper is SmartContract {
    // Expose internal functions as public

    function getMyEthereumContractAddress() public view returns (address) {
        return _getMyEthereumContractAddress();
    }

    function getAreYouABadPerson() public view returns (bool) {
        return _areYouABadPerson; // Access internal variable
    }
}
