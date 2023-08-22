// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./clientsInfo.sol";


contract CreateClients{
    ClientInfo public clientInfo;
    address letterOfCreditAddress;
    constructor(address clientInfo_){
        clientInfo = ClientInfo(clientInfo_);
        letterOfCreditAddress = clientInfo_;
    }
    modifier onlyOwnerBank(address sender) {
        require(clientInfo.ownersBank(sender) == true, "Not an owner bank");
        _;
    }
    function checkOwnerBank() public view returns(bool){
        return clientInfo.ownersBank(msg.sender);
    }
    
    function addAccountDebet(address sender) public {
        (, address isOwnerAccount, , , ,) = clientInfo.clients(sender);
        require(isOwnerAccount == sender, "Not client");
        clientInfo.setSubscribe(sender, 0);
    }
    function addAccountCredit(address sender) public{  
        (, address isOwnerAccount, , , ,) = clientInfo.clients(sender);
        require(isOwnerAccount == sender, "Not client");
        clientInfo.setSubscribe(sender, 1);
        
    }
    function complitesubscribersAccount(address _client, uint typeAccount, address sender) public onlyOwnerBank(sender){
        require(clientInfo.initSubscribe(_client, typeAccount) == true, "not complite");
        require(typeAccount == 0 || typeAccount == 1, "error");
        clientInfo.addAccount(_client, typeAccount);
    }
    function deletAccountDebet(address sender) public{
        (, address isOwnerAccount, , , bool debet,) = clientInfo.clients(sender);
        require(isOwnerAccount == sender, "Not client");
        require(debet == true, "not open");
         clientInfo.setSubscribe(sender, 0);
    }
    function deletAccountCredit(address sender) public{
        (, address isOwnerAccount, , , , bool credit) = clientInfo.clients(sender);
        require(isOwnerAccount == sender, "Not client");
        require(credit == true, "not open");
        clientInfo.setSubscribe(sender, 1);
    }
    function comliteDeletAccount(address _client, uint typeAccount, address sender) public onlyOwnerBank(sender){
        require(clientInfo.initSubscribe(_client, typeAccount) == true, "not complite");
        require(typeAccount == 0 || typeAccount == 1, "error");
        clientInfo.deletAccount(_client, typeAccount);
    }
}