// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//Ajoute un owner à SimpleStorage, une erreur personnalisée NotOwner() et un modifier onlyOwner sur la fonction d’écriture.
contract SimpleStorage {

    uint256 favoriteNumber;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
