// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {SlaveQA} from "../src/SlaveQA.sol";

contract SlaveQATest is Test {
    SlaveQA public slaveQA;

    address USER1 = makeAddr("alice");
    address USER2 = makeAddr("bob");
    address USER3 = makeAddr("c");
    uint256 USER_BALANCE = 1 ether;

    function setUp() public {
        slaveQA = new SlaveQA();
        deal(USER1, USER_BALANCE);
        deal(USER2, USER_BALANCE);
        deal(USER3, USER_BALANCE);
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

    function test_buySlave() public {
        vm.prank(USER1);
        slaveQA.sellSelf(114514, "aaa");
        vm.prank(USER2);
        slaveQA.buySlave{value: 114514}(USER1);

        SlaveQA.Slave memory s1 = slaveQA.getOrDefault(USER1);
        SlaveQA.Slave memory s2 = slaveQA.getOrDefault(USER2);
        assertEq(s1.price, 0);
        assertEq(s1.master, USER2);
        assertEq(s1.slaves.length, 0);
        assertEq(s2.price, 0);
        assertEq(s2.master, address(0));
        assertEq(s2.slaves.length, 1);
        assertEq(s2.slaves[0], USER1);

        vm.prank(USER2);
        slaveQA.askSlave(USER1, "q1");
        s1 = slaveQA.getOrDefault(USER1);
        SlaveQA.Chat memory chat = s1.chats[s1.chats.length - 1];
        assertEq(chat.who, USER2);
        assertEq(chat.content, "q1");
        assertEq(chat.price, 0);

        vm.prank(USER1);
        slaveQA.answerMaster("a1");
        s1 = slaveQA.getOrDefault(USER1);
        chat = s1.chats[s1.chats.length - 1];
        assertEq(chat.who, USER1);
        assertEq(chat.content, "a1");
        assertEq(chat.price, 0);
    }

    function test_sellSlave() public {
        vm.prank(USER1);
        slaveQA.sellSelf(114514, "aaa");
        vm.prank(USER2);
        slaveQA.buySlave{value: 114514}(USER1);
        vm.prank(USER2);
        slaveQA.sellSlave(USER1, 114514);
        vm.prank(USER3);
        slaveQA.buySlave{value: 114514}(USER1);

        SlaveQA.Slave memory s1 = slaveQA.getOrDefault(USER1);
        SlaveQA.Slave memory s2 = slaveQA.getOrDefault(USER2);
        SlaveQA.Slave memory s3 = slaveQA.getOrDefault(USER3);
        assertEq(s1.price, 0);
        assertEq(s1.master, USER3);
        assertEq(s1.slaves.length, 0);
        assertEq(s2.price, 0);
        assertEq(s2.master, address(0));
        assertEq(s2.slaves.length, 0);
        assertEq(s3.price, 0);
        assertEq(s3.master, address(0));
        assertEq(s3.slaves.length, 1);
        assertEq(s3.slaves[0], USER1);
    }
}
