// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {StorageFactory} from "../src/StorageFactory.sol";

contract StorageFactoryTest is Test {

    StorageFactory public storageFactory;

    function setUp() public {
        storageFactory = new StorageFactory();
    }

    function testCreateSimpleStorageContract() public {
        storageFactory.createSimpleStorageContract();
        // Check if the contract was created and added to the list
        //assertEq(storageFactory.listOfSimpleStorageContract.length, 1);
        assertEq(storageFactory.listOfSimpleStorageContract(0).retrieve(), 0);
    }

    function testSfStore() public {
        storageFactory.createSimpleStorageContract();
        storageFactory.sfStore(42, 0);
        // Check if the value was stored correctly in the first SimpleStorage contract
        assertEq(storageFactory.listOfSimpleStorageContract(0).retrieve(), 42);
    }
    
}