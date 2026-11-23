// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, stdError} from "forge-std/Test.sol";
import {Coffre} from "../src/Coffre.sol";

contract CoffreTest is Test {
    Coffre public coffre;
    address public Alice = makeAddr("Alice");

    function setUp() public {
        coffre = new Coffre();
    }

    function testDeposer() public {
        hoax(Alice, 2 ether);
        coffre.deposer{value: 1 ether}();
        assertEq(coffre.balances(Alice), 1 ether);
    }

    function testRetirer() public {
        hoax(Alice, 2 ether);
        coffre.deposer{value: 1 ether}();
        vm.warp(block.timestamp + 7 days);
        vm.prank(Alice);
        coffre.retirer();
        assertEq(coffre.balances(Alice), 0);
    }

    function testTropTot() public {
        hoax(Alice, 2 ether);
        coffre.deposer{value: 1 ether}();
        vm.prank(Alice);
        vm.expectRevert(Coffre.TropTot.selector);
        coffre.retirer();
    }
}