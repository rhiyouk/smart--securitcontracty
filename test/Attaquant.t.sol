// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Attaquant} from "../src/Attaquant.sol";
import {Cagnotte} from "../src/Cagnotte.sol";

contract AttaquantTest is Test {
    Cagnotte public cagnotte;
    Attaquant public attaquant;
    address public Alice = makeAddr("Alice");
    address public Bob = makeAddr("Bob");

    function setUp() public {
        cagnotte = new Cagnotte();
        attaquant = new Attaquant{value: 1 ether}(cagnotte);
    }

    function testAttaque() public {
        // Alice dépose 1 ether dans la cagnotte
        hoax(Alice, 1 ether);
        cagnotte.deposer{value: 1 ether}();

        // Bob dépose 1 ether dans la cagnotte
        hoax(Bob, 11 ether);
        cagnotte.deposer{value: 10 ether}();

        // L'attaquant attaque la cagnotte
        
        attaquant.attaquer();
        uint256 frais = 12 ether / 10000 * 100; // 1% de frais
        // Vérifie que la cagnotte est vide après l'attaque
        assertEq(address(cagnotte).balance, frais, "solde");
        // Vérifie que l'attaquant a récupéré les fonds
        assertEq(address(attaquant).balance, 12 ether - frais, "solde");
    }
}

