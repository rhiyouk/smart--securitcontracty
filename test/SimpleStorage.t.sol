// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public simpleStorage;

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

}