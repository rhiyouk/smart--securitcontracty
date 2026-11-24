// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, stdError} from "forge-std/Test.sol";
import {Cagnotte} from "../src/Cagnotte.sol";

contract CagnotteTest is Test {
    Cagnotte public cagnotte;
    address public Alice = makeAddr("Alice");
    address public Bob = makeAddr("Bob");

    function setUp() public {
        cagnotte = new Cagnotte();
    }

    function testAnyoneCanChangefraisBpsByChangingHisOwnOwner() public {
        vm.prank(Alice);
        Cagnotte newCagnotte = new Cagnotte();
        assertEq(newCagnotte.owner(), Alice);

        vm.prank(Alice);
        newCagnotte.setFrais(200);
        assertEq(newCagnotte.fraisBps(), 200);

        vm.prank(Bob);
        newCagnotte.setFrais(300);
        assertEq(newCagnotte.fraisBps(), 300);
    }

    function testDoS() public {

    }

}


