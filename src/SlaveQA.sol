// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract SlaveQA {
    struct Slave {
        address self;
        string desc;
        uint256 price;
        address master;
        address[] slaves;
    }

    mapping(address => Slave) addressToSlave;
    address[] addresses;

    function getOrDefault(address a) public view returns (Slave memory) {
        if (a == address(0)) {
            a = msg.sender;
        }

        Slave memory slave = addressToSlave[a];
        if (slave.self == address(0)) {
            slave.self = msg.sender;
        }

        return slave;
    }

    function sellSelf(uint256 price, string memory desc) public {
        Slave storage slave = addressToSlave[msg.sender];
        if (slave.self == address(0)) {
            slave.self = msg.sender;
            addresses.push(msg.sender);
        }

        slave.price = price;
        slave.desc = desc;
    }

    function getSlaves() public view returns (Slave[] memory) {
        uint256 len = addresses.length;
        Slave[] memory results = new Slave[](len);
        for (uint256 i = 0; i < len; i++) {
            results[i] = addressToSlave[addresses[i]];
        }
        return results;
    }
}
