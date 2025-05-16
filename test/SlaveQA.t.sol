// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {SlaveQA} from "../src/SlaveQA.sol";

contract SlaveQATest is Test {
    SlaveQA public slaveQA;

    address USER1 = makeAddr("alice");
    address USER2 = makeAddr("bob");
    uint256 USER_BALANCE = 1 ether;

    function setUp() public {
        slaveQA = new SlaveQA();
        deal(USER1, USER_BALANCE);
        deal(USER2, USER_BALANCE);
    }

    function test_get() public {
        vm.prank(USER1);

        SlaveQA.Slave memory s = slaveQA.getOrDefault(address(0));
        assertEq(s.self, USER1);
    }

    function test_sellSelf() public {
        vm.prank(USER1);
        slaveQA.sellSelf(114514, "aaa");

        SlaveQA.Slave memory s = slaveQA.getOrDefault(USER1);
        assertEq(s.self, USER1);
        assertEq(s.price, 114514);
        assertEq(s.desc, "aaa");

        SlaveQA.Slave[] memory slaves = slaveQA.getSlaves();
        assertEq(slaves.length, 1);
        assertEq(slaves[0].self, USER1);
    }
}
