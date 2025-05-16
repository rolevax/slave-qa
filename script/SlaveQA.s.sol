// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {SlaveQA} from "../src/SlaveQA.sol";

contract SlaveQAScript is Script {
    SlaveQA public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new SlaveQA();

        vm.stopBroadcast();
    }
}
