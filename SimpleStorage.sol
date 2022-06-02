// SPDX-License-Identifier: MIT

//something like >=0.8.7 < 0.9.0 can be used as well
// adding ^ symbol means any version equal or greater than
pragma solidity ^0.8.7;

// Complies to bytecode that EVM: Ethereum Virtual Machine (standard for deploying contracts) can understand
// EVM compatible blockchains: Avalanche, Fantom, Polygon

contract SimpleStorage {
    // four main data types: boolean, uint, int, address, bytes
    uint256 favoriteNumber; // default value 0

    // mapping is a data structure where a key is
    // "mapped" to a single value
    mapping(string => uint256) public nameToFavoriteNumber;

    // struct is a custom type defining an object
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // uint256[] public favoriteNumberList;
    People[] public people;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    // view & pure functions do not cost gas unless being
    // called inside a function that costs gas
    // these types disallow modifications to blockchain state
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    // calldata, memory, storage are the types of storage for variables
    // calldata is temp variables that can't be modified
    // memory is temp variables that can be modified
    // storage is permanent variables that can be modified
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
