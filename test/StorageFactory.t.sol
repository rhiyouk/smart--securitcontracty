// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, stdError} from "forge-std/Test.sol";
import {StorageFactory} from "../src/StorageFactory.sol";

contract StorageFactoryTest is Test {

    StorageFactory public storageFactory;
    address public riuk = makeAddr("riuk");

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

    function testSfstoreOutOfBoundsEmptyArray() public {
        vm.expectRevert(stdError.indexOOBError);
        storageFactory.sfStore(42, 0); // This should revert because there is no contract at index 1
    }

    function testSfstoreOutOfBoundshighIndex() public {
        storageFactory.createSimpleStorageContract();
        vm.expectRevert(stdError.indexOOBError);
        storageFactory.sfStore(42, 1); // This should revert because there is no contract at index 1
    }

    function test_AnyoneCanStoreViaFactory() public {
        //Arrange: préparer
        vm.deal(riuk, 1 ether);
        storageFactory.createSimpleStorageContract();
        //Act: agir
        vm.prank(riuk);
        storageFactory.sfStore(666, 0);
        //Assert: vérifier
        assertEq(storageFactory.listOfSimpleStorageContract(0).retrieve(), 666);
        //Conclusion : n'importe qui peut stocker un nombre dans le contrat SimpleStorage via le StorageFactory. Il faudrait ajouter une vérification pour s'assurer que seul le propriétaire du contrat SimpleStorage peut stocker un nombre.
    }
    
}