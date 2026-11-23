// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, stdError} from "forge-std/Test.sol";
import {Coffre} from "../src/Coffre.sol";

contract CoffreTest is Test {
    event Retrait(address indexed utilisateur, uint256 montant);

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
        assertEq(Alice.balance, 2 ether);
    }

    function testTropTot() public {
        hoax(Alice, 2 ether);
        coffre.deposer{value: 1 ether}();
        vm.prank(Alice);
        vm.expectRevert(Coffre.TropTot.selector);
        coffre.retirer();
    }

    function testEventRetrait() public {
        hoax(Alice, 2 ether);
        coffre.deposer{value: 1 ether}();
        vm.warp(block.timestamp + 7 days);
        vm.prank(Alice);
        vm.expectEmit();
        emit Retrait(Alice, 1 ether);
        coffre.retirer();
    }

    function testRetrait7DaysMinus1Second() public {
        hoax(Alice, 2 ether);
        coffre.deposer{value: 1 ether}();
        vm.warp(block.timestamp + 7 days - 1 seconds);
        vm.prank(Alice);
        vm.expectRevert(Coffre.TropTot.selector);
        coffre.retirer();
    }

    function testRetrait7DaysPlus1Second() public {
        hoax(Alice, 2 ether);
        coffre.deposer{value: 1 ether}();
        vm.warp(block.timestamp + 7 days + 1 seconds);
        vm.prank(Alice);
        coffre.retirer();
        assertEq(coffre.balances(Alice), 0);
        assertEq(Alice.balance, 2 ether);
    }

    function testRetraitZeroBalance() public {
        hoax(Alice, 1 ether);
        coffre.deposer{value: 1 ether}();
        vm.warp(block.timestamp + 7 days);
        vm.startPrank(Alice);
        coffre.retirer();
        vm.expectRevert(Coffre.RienARetirer.selector);
        coffre.retirer();
        vm.stopPrank();
    }

    function testUnknownUserRetrait() public {
        vm.prank(Alice);
        vm.expectRevert(Coffre.RienARetirer.selector);
        coffre.retirer();
    }

    function testFuzz_DepotPuisRetrait(uint montant) public {
        montant = bound(montant, 1, 10 ether);
        hoax(Alice, montant);
        coffre.deposer{value: montant}();
        skip(7 days);
        vm.prank(Alice);
        coffre.retirer();
        assertEq(coffre.balances(Alice), 0);
        assertEq(Alice.balance, montant);
    }

    function testFuzz_RetraitAvantEcheance(uint256 delai) public {
        delai = bound(delai, 0, 7 days - 1 seconds);
        hoax(Alice, 1 ether);
        coffre.deposer{value: 1 ether}();
        skip(delai);
        vm.prank(Alice);
        vm.expectRevert(Coffre.TropTot.selector);
        coffre.retirer();
    }

    function testFuzz_InconnuNePeutRienRetirer(address inconnu) public {
        vm.assume(inconnu != msg.sender);
        vm.prank(inconnu);
        vm.expectRevert(Coffre.RienARetirer.selector);
        coffre.retirer();
    }

}