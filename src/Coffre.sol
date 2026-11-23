// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Coffre {

    // fonction deposer() est payable : elle enregistre le solde de l'appelant, et sa date de déblocage à block.timestamp + 7 days ;
    // fonction retirer() revert avec l'erreur personnalisée TropTot() si la date n'est pas atteinte. Sinon, elle renvoie tout le solde en respectant Checks-Effects-Interactions, et émet un event Retrait(address, uint256).

    mapping(address => uint256) public balances;
    mapping(address => uint256) public unlockTime;

    event Retrait(address indexed user, uint256 amount);
    error TropTot();
    error SoldeInsuffisant();
    error EchecRetrait();
    error RienARetirer();
    error SoldeDejaBloque();

    function deposer() external payable {
        if(balances[msg.sender] > 0) {
            revert SoldeDejaBloque();
        }
        if(msg.value == 0) {
            revert SoldeInsuffisant();
        }
        balances[msg.sender] += msg.value;
        unlockTime[msg.sender] = block.timestamp + 7 days;
    }

    function retirer() external {
        if (block.timestamp < unlockTime[msg.sender]) {
            revert TropTot();
        }
        uint256 amount = balances[msg.sender];
        if (amount == 0) {
            revert RienARetirer();
        }
        balances[msg.sender] = 0;
        unlockTime[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert EchecRetrait();
        }

        emit Retrait(msg.sender, amount);
    }

}