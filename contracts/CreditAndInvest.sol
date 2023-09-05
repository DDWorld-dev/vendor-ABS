// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./clientsInfo.sol";

contract CreditAndInvest{
    ClientInfo clientInfo;
    address clientInfoAddress;
    struct creditClient{
        address client;
        mapping(address=>uint) tokenBalanceCredit;
    }
    struct investClient{
        address client;
        mapping(address=>uint) tokenBalanceInvest;
        mapping(uint=>uint) tokenTypeInvest;
    }
    mapping(address=>creditClient) creditClients;
    mapping(address=>investClient) investClients;
    event newCredit(address indexed client, address token, uint amount);
    event newInvest(address indexed client, uint amount);
    constructor(address clientInfo_){
        clientInfo = ClientInfo(clientInfo_);
        clientInfoAddress = clientInfo_;
    }
    
    function Credit(address sender, address token, uint amount) public{
        creditClients[sender].client = sender;
        emit newCredit(sender, token, amount);
    }
    function getCredit(address sender, address _client, address token, uint amount) public{
        require(clientInfo.ownersBank(sender) == true, "not owner bank!");
        clientInfo.getCredit(token, amount);
        unchecked {
            creditClients[_client].tokenBalanceCredit[token] += amount;
        }
    }
    function invest(address sender, address token, uint amount, uint typeInvest) public{
        //approve frontend
        investClients[sender].client = sender;
        IERC20(token).transferFrom(sender, clientInfoAddress, amount);
        investClients[sender].tokenTypeInvest[typeInvest] += amount;
        investClients[sender].tokenBalanceInvest[token] += amount;
        emit newInvest(sender, amount);
        //invest frontend
    }
}