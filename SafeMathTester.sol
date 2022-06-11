// SPDX-License-Identifier: MIT
pragma solidity <0.8.0;

// SafeMath used to be a popular library for the below issue

contract SafeMathTester {
    uint8 public bigNumber = 255;   // unchecked before version 0.8.0

    function add() public {
        bigNumber = bigNumber + 1;

        // starting with version 0.8.0, these are checked
        // you can force to skip checking for gas efficiency:
        // unchecked {bigNumber = bigNumber + 1;}
    }
}
