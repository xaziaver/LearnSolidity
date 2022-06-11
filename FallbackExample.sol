// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FallbackExample {
    uint256 public result;

    // when a contract is called with empty call data, 'receive' function is always triggered
    receive() external payable {
        result = 1;
    }

    // when a contract is called with call data that doesn't match any function,
    // then the 'fallback' function is called
    fallback() external payable {
        result = 2;
    }
}

    // Explainer from https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //       is msg.data empty?
    //           /   \
    //          yes  no
    //         /      \
    //    recieve()?  fallback()?
    //      /    \
    //     yes   no
    //    /        \
    // recieve()    fallback()
