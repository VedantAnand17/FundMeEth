// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SafeMathTester {
    uint8 public num = 255;

    function addChecked() public {
        num += 1;
    }

    function addUnchecked() public {
        //less gas fee
        unchecked {
            num += 1;
        }
    }
}
