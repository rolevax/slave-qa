#!/bin/zsh

KEY0=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
KEY2=0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
KEY3=0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
KEY4=0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a
CONTRACT='0x5FbDB2315678afecb367f032d93F642f64180aa3' 
forge script script/SlaveQA.s.sol --rpc-url 127.0.0.1:8545 --broadcast --private-key $KEY0
cast send $CONTRACT "sellSelf(uint256,string)" 114514 "desc 2" --private-key $KEY2
cast send $CONTRACT "sellSelf(uint256,string)" 114514 "desc 3" --private-key $KEY3
cast send $CONTRACT "sellSelf(uint256,string)" 114514 "desc 4" --private-key $KEY4
