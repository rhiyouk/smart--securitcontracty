// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Cagnotte — une épargne commune avec frais et bonus
contract Cagnotte {
    address public owner;
    uint256 public fraisBps = 100;          // 100 bps = 1 %
    uint256 public totalDepots;
    mapping(address => uint256) public depots;
    address[] public participants;

    event Depot(address indexed user, uint256 montant);
    event Retrait(address indexed user, uint256 montant);

    constructor() {
        owner = msg.sender;
    }

    function deposer() external payable {
        require(msg.value > 0, "Montant nul");
        require(address(this).balance - msg.value == totalDepots, "Etat incoherent");
        if (depots[msg.sender] == 0) {
            participants.push(msg.sender);
        }
        depots[msg.sender] += msg.value;
        totalDepots += msg.value;
        emit Depot(msg.sender, msg.value);
    }

    function retirerTout() external {
        uint256 montant = depots[msg.sender];
        require(montant > 0, "Rien a retirer");
        uint256 frais = montant / 10000 * fraisBps;
        (bool ok, ) = msg.sender.call{value: montant - frais}("");
        require(ok, "Echec");
        depots[msg.sender] = 0;
        totalDepots -= montant;
        emit Retrait(msg.sender, montant);
    }

    function setFrais(uint256 nouveauxFrais) external {
        require(tx.origin == owner, "Pas owner");
        fraisBps = nouveauxFrais;
    }

    function distribuerBonus() external payable {
        require(msg.sender == owner, "Pas owner");
        for (uint256 i = 0; i < participants.length; i++) {
            address p = participants[i];
            uint256 part = msg.value * depots[p] / totalDepots;
            payable(p).transfer(part);
        }
    }
}