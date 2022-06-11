// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    // this makes use of the imported library
    using PriceConverter for uint256;

    // we want to convert this USD value to ETH, so will
    // need an oracle to get off-chain data
    uint256 public constant MINIMUM_USD = 50 * 1e18;     // constant keyword for when variable doesn't change (gas efficient)

    // want to keep track of people that fund the contract
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;


    address public immutable i_owner;       // immutable keyword is used for variables that are
                                            // only set once, but outside of declaration (gas efficient)

    constructor() {
        i_owner = msg.sender;
    }

    // Smart contracts can hold native blockchain tokens (ETH)
    // need to use 'payable' keyword
    function fund() public payable{
        // want to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract?

        // this puts a restriction on function so that it must be called
        // with at least 1 ETH. If not, a 'revert' happens - any actions
        // are undone and sends remaining gas back
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough");  // 1e18 = 1 * 10^18 = 1ETH bc expressed in wei
        // msg.value has 18 decimals and type uint256

        funders.push(msg.sender);                       // global keyword to access address that calls function
        addressToAmountFunded[msg.sender] = msg.value;  // maps address & value funded
    }

    // withdraw all funds
    // only 'owner' can call (achieved through adding custom modifier)
    function withdraw() public onlyOwner{
        // loop to reset mapping
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset array
        funders = new address[](0);

        // withdraw funds - 3 ways
        // transfer: cap of 2300 gas... more will fail & revert
        payable(msg.sender).transfer(address(this).balance); // msg.sender type = address, payable(msg.sender) type = payable address
        // send: cap of 2300 gas... more will succeed, but sends a bool with success or fail (1 or 0)
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, /*bytes memory dataReturned*/) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender is not owner");
        if (msg.sender != i_owner) { revert NotOwner(); }           // custom error messages introduced in 0.8.4 (gas efficient)
        _;      // this is a placeholder for function code using this modifier
    }

    // What happens if someone sends this contract funds without calling fund() function?

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}

// 1. Enums
// 2. Events
// 3. Try/Catch
// 4. Function Selectors
// 5. abi.encode / decode
// 6. Hashing
// 7. Yul / Assembly
