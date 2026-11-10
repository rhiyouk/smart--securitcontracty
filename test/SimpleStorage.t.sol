// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public simpleStorage;
    address riuk = address(0xBEEF);

    function setUp() public {
        simpleStorage = new SimpleStorage();
    }

    function testStore() public {
        simpleStorage.store(42);
        assertEq(simpleStorage.retrieve(), 42);
    }

    function testAddPerson() public {
        simpleStorage.addPerson("Alice", 25);
        (uint256 favoriteNumber, string memory name) = simpleStorage.listOfPeople(0);
        assertEq(favoriteNumber, 25);
        assertEq(name, "Alice");
        assertEq(simpleStorage.nameToFavoriteNumber("Alice"), 25);
    }

    function testUpdatePerson() public {
    }

    function testOnlyOwner() public {
        vm.prank(riuk);
        vm.expectRevert(SimpleStorage.NotOwner.selector);
        simpleStorage.store(42);
    }

    //Test de fuzzing
    function testFuzzOnlyOwner(address ad, uint256 _favoriteNumber) public {
        vm.assume(ad != address(0));
        vm.assume(ad != address(this));
        vm.prank(ad);
        vm.expectRevert(SimpleStorage.NotOwner.selector);
        simpleStorage.store(_favoriteNumber);
    }

}