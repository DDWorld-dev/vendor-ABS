// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./Core.sol";
import "./letterOfCredit.sol";
contract OtherContract{
    Core public coreInstance;
    LettersOfCredit public letterInsctance;
    ClientInfo public clientInfo;
    constructor(address _coreAddress, address _LetterOfCredit, address clientInfo_) {
        coreInstance = Core(_coreAddress);
        letterInsctance = LettersOfCredit(_LetterOfCredit);
        clientInfo = ClientInfo(clientInfo_);
    }
    function checkClient(address client) public view returns(string memory,address, address, uint, uint, uint){
        return clientInfo.getClientInfo(client);
    }
    
    function setOwnerBank() public{
        clientInfo.createBank();
    }
    function setOwnerClient(address owner_)  public{    
        clientInfo.setOwner(owner_);
    }
    function addNeworacle_(address token, address oracle) public{
        clientInfo.addNeworacle(token, oracle);
    }
    function investing_(address token, uint amount) public{
        coreInstance.investing(msg.sender, token, amount);
    }
    function _checkLetter(address sender) public view returns(address, address, uint, address, string memory, uint){
        return letterInsctance.checkLetter(sender);
    }
    function _makeLetterOfCerdit(address to, uint amount, address token, string calldata contitions) public {
        letterInsctance.makeLettersOfCredit(msg.sender, to, amount, token, contitions);
    }
    function _confirmLetterOfCredit(address _client) public{
        letterInsctance.confirmLetterOfCredit(msg.sender, _client);
    }
    function _sendLettersOfCredit(address _client) public{
        letterInsctance.sendLettersOfCredit(msg.sender, _client);
    }
    function _checkLetterOfCredit(address _client) public{
        letterInsctance.checkLetterOfCredit(msg.sender, _client);
    }
    function _sendMoney(address _client) public{
        letterInsctance.sendMoney(msg.sender, _client);
    }
    function _compliteLetterOfCredit(address _client) public{
        letterInsctance.compliteLetterOfCredit(msg.sender, _client);
    }
    function openAccount(address _client, uint typeAccount) public{
        coreInstance.complitesubscribersAccount(_client, typeAccount, msg.sender);
    }
    function deletAccount(address _client, uint typeAccount) public{
        coreInstance.comliteDeletAccount(_client, typeAccount, msg.sender);
        
    }
    function deletAccountDebet_() public{
       
        coreInstance.deletAccountDebet(msg.sender);
    }
    function deletAccountCredit_() public{
       
        coreInstance.deletAccountCredit(msg.sender);
    }
    function addAccountDebet_() public{
       
        coreInstance.addAccountDebet(msg.sender);
    }
    function addAccountCredit_() public{
       
        coreInstance.addAccountCredit(msg.sender);
    }
    function newClient(string calldata _name) public{
        clientInfo.initializeClient(_name, msg.sender);
    }
    function balance(address token) public view returns(uint){
        return IERC20(token).balanceOf(msg.sender);
    }

    function depositeToBank(uint amount, address token) public{
        //approve frontend
        coreInstance.deposit(amount, token, msg.sender);
    }
    function transferBalanceInBank(uint amount, address token, address to) public{
        coreInstance.transferBalance(amount, token, to, msg.sender);
    }
    function checkAllowance(address token) public view returns(uint){
        return IERC20(token).allowance(msg.sender, address(this));
    }
}
