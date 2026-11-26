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

    function testRetraitAvecFraisFaitEchouerDepot() public {
        // Alice dépose 1 ether dans la cagnotte
        hoax(Alice, 2 ether);
        cagnotte.deposer{value: 1 ether}();

        // Bob dépose 1 ether dans la cagnotte
        hoax(Bob, 1 ether);
        cagnotte.deposer{value: 1 ether}();

        // Alice retire tout avec frais
        vm.prank(Alice);
        cagnotte.retirerTout();

        // Vérifie que le solde de la cagnotte est supperieur au total des dépôts après le retrait avec frais
        uint256 balance = address(cagnotte).balance; 

        assertGt(balance, cagnotte.totalDepots(), "solde");

        // Vérifie qu'une nouvelle tentative de dépôt échoue
        vm.expectRevert("Etat incoherent");   
        vm.prank(Alice);
        cagnotte.deposer{value: 1 ether}();
    }

    function testPerteDePrecisionDansCalculFrais() public {
        // Alice dépose 1 ether dans la cagnotte
        hoax(Alice, 1 ether);
        cagnotte.deposer{value: 9999 wei}();

        vm.prank(Alice);
        cagnotte.retirerTout();

        //verifier que le solde d'alice est de 1 ether et que les frais ont été perdus à cause de la division entière
        uint256 balance = Alice.balance;
        assertGt(balance, 1, "solde");
    }

}


