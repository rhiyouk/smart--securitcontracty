// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract SimpleStorage {

    uint256 internal favoriteNumber;
    address private immutable i_owner;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    constructor() {
        i_owner = msg.sender;
    }

    function store(uint256 _favoriteNumber) public onlyOwner {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public onlyOwner {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
    
    error NotOwner();
}
