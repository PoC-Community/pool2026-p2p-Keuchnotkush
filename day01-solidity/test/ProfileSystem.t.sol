import "forge-std/Test.sol";
import "../src/ProfileSystem.sol";

contract ProfileTest is Test {
    ProfileSystem profileSystem;
    address user = address(0x1);

    function setUp() public {
        profileSystem = new ProfileSystem();
    }

    function testCreateProfile() public {
        vm.prank(user);
        profileSystem.createProfile("Alice");

        (string memory username, uint256 level, ProfileSystem.Role role, uint256 lastUpdated) = profileSystem.profiles(user);

        assertEq(username, "Alice");
        assertEq(level, 1);
        assertEq(uint256(role), uint256(ProfileSystem.Role.USER));
        assertGt(lastUpdated, 0);
    }

    function testCannotCreateEmptyProfile() public {
        vm.prank(user);
        vm.expectRevert(ProfileSystem.EmptyUsername.selector);
        profileSystem.createProfile("");
    }

    function testCannotCreateDuplicateProfile() public {
        vm.prank(user);
        profileSystem.createProfile("Alice");

        vm.prank(user);
        vm.expectRevert(ProfileSystem.UserAlreadyExists.selector);
        profileSystem.createProfile("Bob");
    }

    function testLevelUp() public {
        vm.prank(user);
        profileSystem.createProfile("Alice");

        vm.prank(user);
        profileSystem.levelUp();

        (, uint256 level, , ) = profileSystem.profiles(user);
        assertEq(level, 2);
    }

    function testCannotLevelUpIfNotRegistered() public {
        vm.prank(user);
        vm.expectRevert(ProfileSystem.UserNotRegistered.selector);
        profileSystem.levelUp();
    }
}