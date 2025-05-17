// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract SlaveQA {
    struct Chat {
        address who;
        string content;
        uint256 price;
    }

    struct Slave {
        address self;
        string desc;
        uint256 price;
        address master;
        address[] slaves;
        Chat[] chats;
    }

    error SlaveNotExistError();
    error SlaveStateError();
    error PriceError();
    error TransferError();

    mapping(address => Slave) addressToSlave;
    address[] addresses;

    function getOrDefault(address a) public view returns (Slave memory) {
        if (a == address(0)) {
            a = msg.sender;
        }

        Slave memory slave = addressToSlave[a];
        if (slave.self == address(0)) {
            slave.self = a;
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
        slave.chats.push(
            Chat({who: msg.sender, content: "sell", price: price})
        );
    }

    function buySlave(address a) public payable {
        Slave memory test = addressToSlave[a];
        if (test.self == address(0)) {
            revert SlaveNotExistError();
        }

        Slave storage buyer = addressToSlave[msg.sender];
        if (buyer.self == address(0)) {
            buyer.self = msg.sender;
            addresses.push(msg.sender);
        }

        Slave storage slave = addressToSlave[a];
        if (slave.master == msg.sender) {
            revert SlaveStateError();
        }

        if (msg.value == 0 || msg.value != slave.price) {
            revert PriceError();
        }

        address prevMaster = slave.master;
        if (prevMaster == address(0)) {
            prevMaster = slave.self;
        }

        (bool sent, ) = payable(prevMaster).call{value: msg.value}("");
        if (!sent) {
            revert TransferError();
        }

        if (prevMaster != slave.self) {
            address[] storage prevSlaves = addressToSlave[prevMaster].slaves;
            uint256 len = prevSlaves.length;
            for (uint256 i = 0; i < len; i++) {
                if (prevSlaves[i] == a) {
                    prevSlaves[i] = prevSlaves[len - 1];
                    prevSlaves.pop();
                    break;
                }
            }
        }

        if (buyer.self == slave.self) {
            slave.master = address(0);
        } else {
            slave.master = msg.sender;
            buyer.slaves.push(a);
        }

        slave.price = 0;
        slave.chats.push(
            Chat({who: msg.sender, content: "buy", price: msg.value})
        );
    }

    function sellSlave(address a, uint256 price) public payable {
        Slave storage master = addressToSlave[msg.sender];
        if (master.self == address(0)) {
            revert SlaveNotExistError();
        }

        Slave storage slave = addressToSlave[a];
        if (slave.self == address(0)) {
            revert SlaveNotExistError();
        }

        slave.price = price;
        slave.chats.push(
            Chat({who: msg.sender, content: "sell", price: price})
        );
    }

    function askSlave(address a, string memory content) public {
        Slave storage master = addressToSlave[msg.sender];
        if (master.self == address(0)) {
            revert SlaveNotExistError();
        }

        Slave storage slave = addressToSlave[a];
        if (slave.self == address(0)) {
            revert SlaveNotExistError();
        }

        if (slave.master != msg.sender) {
            revert SlaveStateError();
        }

        slave.chats.push(Chat({who: msg.sender, content: content, price: 0}));
    }

    function answerMaster(string memory content) public {
        Slave storage slave = addressToSlave[msg.sender];
        if (slave.self == address(0)) {
            slave.self = msg.sender;
        }

        slave.chats.push(Chat({who: msg.sender, content: content, price: 0}));
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
