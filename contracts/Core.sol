// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Clients.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Core is CreateClients{
    address owner;
    constructor(address clientInfo_) CreateClients(clientInfo_){
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(owner == msg.sender, "faild");
        _;
    }
    

    function transferBalance(uint amount, address token, address to, address sender) public{
        (, address isOwnerAccount, address bank, , bool debet,) = clientInfo.clients(sender);
        (, address isOwnerAccountTo, address bankTo, , bool debetTo,) = clientInfo.clients(to);
        require(isOwnerAccount == sender, "not client");
        require(isOwnerAccountTo == to, "not client");
        require(msg.sender == clientInfo.BANK(), "not bank");
        require(debet == true, "not open account");
        require(debetTo == true, "not open account");
        require(bank == bankTo, "different bank");
        clientInfo.updateBalanceInUSD(sender);
        clientInfo.transferBalanceInBank(sender, to, token, amount, "new transfer balance");
    }
    function investing(address sender, address token, uint amount) public{
        clientInfo.invest(sender, token, amount);
    }
    function deposit(uint amount, address token, address sender) public {
        (, address isOwnerAccount, , , bool debet,) = clientInfo.clients(sender);
        require(clientInfo.BANK() == msg.sender, "not bank");
        require(isOwnerAccount == sender, "not client");
        require(debet == true, "not open account");
        require(IERC20(token).allowance(sender, address(this)) >= amount, "chek allowance");
        clientInfo.updateBalanceInUSD(sender);
        IERC20(token).transferFrom(sender, letterOfCreditAddress, amount);
        clientInfo.depositBalance(sender, token, amount);
    }
    function withdrawal(uint amount, address token, address sender) public{
        (, address isOwnerAccount, , , bool debet,) = clientInfo.clients(sender);
        require(clientInfo.BANK() == msg.sender, "not bank");
        require(isOwnerAccount == sender, "not client");
        require(debet == true, "not open account");
        require(IERC20(token).allowance(msg.sender, address(this)) >= amount, "chek allowance");
        clientInfo.updateBalanceInUSD(sender);
        clientInfo.withdrawlBalance(sender, token, amount);
    }  
    
    // function makeLettersOfCredit_(address sender, address recipient, uint amount, address token, string calldata contitions) public {
    //     require(clients[sender].clientOwner == sender, "not client");
    //     require(clients[recipient].clientOwner == recipient, "not client");
    //     updateBalanceInUSD(sender);
    //     letterOfCredit.makeLettersOfCredit(sender, clients[sender].bank, clients[sender].tokenBalance[token], clients[sender].balanceUsdt[token], oracles[token],  recipient, amount, token, contitions);
    // }
    // function confirmLetterOfCredit_(address sender) public{
    //     letterOfCredit.confirmLetterOfCredit(sender, msg.sender);
    // }
    // function sendLettersOfCredit_(address sender) public{
    //     letterOfCredit.sendLettersOfCredit(sender);
    // }
      
    // function getClientInfo21(address sender) public view returns(string memory,address, address, uint, uint, uint){
    //     return letterOfCredit.getClientInfo12(sender);
    // }
    // function checkLetterOfCredit_(address sender) public{
    //     letterOfCredit.checkLetterOfCredit(sender);
    // }
    // function sendMoney_(address sender) public{
    //     letterOfCredit.sendMoney(sender);
    // }
    // function compliteLetterOfCredit_(address sender) public{
    //     letterOfCredit.compliteLetterOfCredit(sender);
    // }

    // function checkLetter_(address sender) public view returns(address, address, uint, address, string memory, uint){
    //     return letterOfCredit.checkLetter(sender);
    // }  

}