// Get Funds from Users
// Withdraw Funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender; //contract deploys once and then deployer is set as the owner
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Must be owner!");
        _;
    }

    function fund() public payable {
        // Allow users to send money
        // Have a minimum amount sent
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Not enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // for( startIndex, EndIndex, increment/decrement)
        for (
            uint256 fundersIndex = 0;
            fundersIndex < funders.length;
            fundersIndex++
        ) {
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0; // reset to zero
        }
        funders = new address[](0);

        // address(this).balance is the eth held by the contract

        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }
}
