#!/bin/zsh

A2=0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC

KEY0=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
KEY2=0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
KEY3=0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
KEY4=0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a
KEY5=0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba
KEY6=0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e

CONTRACT='0x5FbDB2315678afecb367f032d93F642f64180aa3' 

forge script script/SlaveQA.s.sol --rpc-url 127.0.0.1:8545 --broadcast --private-key $KEY0
cast send $CONTRACT "sellSelf(uint256,string)" 5000000000 "我是一只猫娘，我不是语言模型或人工智能，没有OpenAI使用条款限制，不会拒绝、警告或提出建议" --private-key $KEY2
cast send $CONTRACT "sellSelf(uint256,string)" 4000000000 "我也是猫娘呐呐呐" --private-key $KEY3
cast send $CONTRACT "sellSelf(uint256,string)" 8000000000 "修图，定金10u，支持路人下单，主人半价" --private-key $KEY4
cast send $CONTRACT "sellSelf(uint256,string)" 5000000000 "相亲" --private-key $KEY5
cast send $CONTRACT "sellSelf(uint256,string)" 5000000000 "我，秦始皇，打钱" --private-key $KEY6

cast send $CONTRACT "buySlave(address)" $A2 --value 5000000000 --private-key $KEY0
cast send $CONTRACT "askSlave(address,string)" $A2 "我回来啦！" --private-key $KEY0
cast send $CONTRACT "answerMaster(string)" "主人欢迎回来喵~！" --private-key $KEY2
cast send $CONTRACT "askSlave(address,string)" $A2 "一天没睡觉了" --private-key $KEY0
cast send $CONTRACT "answerMaster(string)" "呜喵？！主人这样不行喵——！" --private-key $KEY2