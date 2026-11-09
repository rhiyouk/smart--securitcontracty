// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    
    SimpleStorage[] public listOfSimpleStorageContract; 

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        listOfSimpleStorageContract.push(simpleStorage);
    }

    function sfStore(uint256 _favoriteNumber, uint256 _simpleStorageIndex) public {
        // Address
        // ABI
        SimpleStorage simpleStorage = SimpleStorage(address(listOfSimpleStorageContract[_simpleStorageIndex]));
        simpleStorage.store(_favoriteNumber);
    }

}