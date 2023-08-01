// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Core {
    address owner;
    mapping(address=>bool) public ownersBank;
    address public BANK;
    constructor(){
        owner = msg.sender;
    }
    struct client{
        string name;
        address clientOwner;
        address bank;
        uint clientType;
        bool accountDebet;
        bool accountCredit;
        bytes32[] paymentInfo;
        document[] documents;
        uint balanceUsdt;
        mapping(address=>uint) tokenBalance;
        uint balanceCredit;
    }
    struct document{
        uint typeDocument;
        string documentInfo;
        address document;
    }
    mapping(address=>mapping(uint=>bool)) initSubscribe;
    mapping(address=>client) private clients;
    mapping(address=>address) oracles;

    modifier onlyOwner() {
        require(owner == msg.sender, "faild");
        _;
    }
    modifier onlyOwnerBank(address sender){
        require(ownersBank[sender] == true);
        _;
    }
    function checkOwnerBank() public view returns(bool){
        return ownersBank[msg.sender];
    }
    modifier checkTransfer(address sender, address to) {
        require(clients[sender].clientOwner == sender, "not client");
        require(clients[to].clientOwner == to, "not client");
        require(msg.sender == BANK, "not bank");
        require(clients[sender].accountDebet == true, "not open account");
        require(clients[to].accountDebet == true, "not open account");
        require(clients[to].bank == clients[sender].bank, "different bank");
        _;
    }
    function transferBalance(uint amount, address token, address to, address sender) public checkTransfer(sender, to){
        (, int256 price, , , ) = AggregatorV3Interface(oracles[token]).latestRoundData();
        require(price > 0, "Invalid price");
        unchecked {
            // need decimals 
            clients[sender].balanceUsdt -= (amount / 1000000) * (uint(price) / 100); 
            clients[sender].tokenBalance[token] -= amount;
            clients[to].balanceUsdt += (amount / 1000000) * (uint(price) / 100);
            clients[to].tokenBalance[token] += amount;
            
        }
    }
    function addNeworacle(address token, address _oracle) public onlyOwner(){
        oracles[token] = _oracle;
    }
    
    //updateBalanceInUSD()???...
    //function transferFromBank()???...
    
    function deposit(uint amount, address token, address sender) public {
        require(BANK == msg.sender, "not bank");
        require(clients[sender].clientOwner == sender, "not client");
        require(clients[sender].accountDebet == true, "not open account");
        require(IERC20(token).allowance(sender, address(this)) >= amount, "chek allowance");
        IERC20(token).transferFrom(sender, BANK, amount);
        (, int256 price, , , ) = AggregatorV3Interface(oracles[token]).latestRoundData();
        require(price > 0, "Invalid price");
        clients[sender].balanceUsdt += (amount / 1000000) * (uint(price) / 100);
        clients[sender].tokenBalance[token] += amount;

    }
    function withdrawal(uint amount, address token, address oracle, address sender) public{
        require(BANK == msg.sender, "not bank");
        require(clients[sender].clientOwner == sender, "not client");
        require(clients[sender].accountDebet == true, "not open account");
        require(IERC20(token).allowance(msg.sender, address(this)) >= amount, "chek allowance");
        IERC20(token).transferFrom(msg.sender, sender, amount);
        (, int256 price, , , ) = AggregatorV3Interface(oracle).latestRoundData();
        require(price > 0, "Invalid price");
        clients[sender].balanceUsdt -= (amount / 1000000) * (uint(price) / 100);
        clients[sender].tokenBalance[token] -= amount;
    }  
    function balanceTokenAccount(address tokenAddress, address oracle, address sender) public view returns(uint, uint){
        require(clients[sender].clientOwner == sender, "not client");
        uint balance = IERC20(tokenAddress).balanceOf(sender);
        (, int256 price, , , ) = AggregatorV3Interface(oracle).latestRoundData();
        require(price > 0, "Invalid price");   
        return (balance, balance*(uint(price)/100));
    }
    function createBank() public{
        BANK = msg.sender;
    }
    function setOwner(address _owner) public{
        require(msg.sender == BANK);
        ownersBank[_owner] = true;
    }

    function initializeClient(string calldata _name, address sender) public{
        require(BANK == msg.sender, "not bank");
        require(clients[sender].bank != msg.sender || clients[sender].clientOwner != sender, "already exist");
        client storage newClientInfo = clients[sender];
        newClientInfo.name = _name;
        newClientInfo.clientOwner = sender;
        newClientInfo.bank = msg.sender;
        newClientInfo.accountDebet = false;
        newClientInfo.accountCredit = false;

        uint size;
        
        assembly {
            size := extcodesize(sender)
        }
        if (size > 0) {
            bytes4 expectedFunctionSignature = bytes4(keccak256("check(uint256,address)"));
            (bool success, ) = sender.call(abi.encodeWithSelector(expectedFunctionSignature, 1, sender));
            require(success, "faild");
            if(success == true){
                newClientInfo.clientType = 1;
                newClientInfo.documents.push(document(0, "entity person", sender));
            } 
        } else{
            newClientInfo.clientType = 0;
            newClientInfo.documents.push(document(0, "natural person", sender));
        }
        newClientInfo.paymentInfo.push(bytes32(keccak256(bytes("Create client"))));    
    }
    function getClientInfo(address _client) public view returns(string memory, address, address, bytes32[] memory, uint, uint, uint) {
        return (clients[_client].name, clients[_client].clientOwner, clients[_client].bank, clients[_client].paymentInfo, clients[_client].balanceUsdt, clients[_client].tokenBalance[0xdAC17F958D2ee523a2206206994597C13D831ec7], clients[_client].tokenBalance[0x514910771AF9Ca656af840dff83E8264EcF986CA]);
    }
    function addAccountDebet(address sender) public{  
        require(sender == clients[sender].clientOwner, "Not client4");
        initSubscribe[sender][0] = true;
    }
    function addAccountCredit(address sender) public{  
        require(sender == clients[sender].clientOwner);
        initSubscribe[sender][1] = true;
    }
    function complitesubscribersAccount(address _client, uint typeAccount, address sender) public onlyOwnerBank(sender){
        require(initSubscribe[_client][typeAccount] == true, "not complite");
        require(typeAccount == 0 || typeAccount == 1, "error");
        if(typeAccount == 0){
            clients[_client].accountDebet = true;
            initSubscribe[_client][typeAccount] = false;
        }
        if(typeAccount == 1){
            clients[_client].accountCredit = true;
            initSubscribe[_client][typeAccount] = false;
        }
    }
    function deletAccountDebet(address sender) public{
        require(sender == clients[sender].clientOwner);
        require(clients[sender].accountDebet == true, "not open");
        initSubscribe[sender][0] = true;
    }
    function deletAccountCredit(address sender) public{
        require(sender == clients[sender].clientOwner);
        require(clients[sender].accountCredit == true, "not open");
        initSubscribe[sender][1] = true;
    }
    function comliteDeletAccount(address _client, uint typeAccount, address sender) public onlyOwnerBank(sender){
        require(initSubscribe[_client][typeAccount] == true, "not complite");
        require(typeAccount == 0 || typeAccount == 1, "error");
        if(typeAccount == 0){
            clients[_client].accountDebet = false;
            initSubscribe[_client][typeAccount] = false;
        }
        if(typeAccount == 1){          
            clients[_client].accountCredit = false;
            initSubscribe[_client][typeAccount] = false;
        }
    }
   
    
}

contract OtherContract {
    address public coreAddress; 
    Core public coreInstance; 
    constructor(address _coreAddress) {
        coreAddress = _coreAddress;
        coreInstance = Core(coreAddress);
    }
    function checkClient(address client) public view returns(string memory,address, address, bytes32[] memory, uint, uint, uint){
        return coreInstance.getClientInfo(client);
    }
    function setOwnerBank() public{
        coreInstance.createBank();
    }
    function setOwnerClient(address owner_)  public{    
        coreInstance.setOwner(owner_);
    }
    function openAccount(address client, uint typeAccount) public{
        coreInstance.complitesubscribersAccount(client, typeAccount, msg.sender);
    }
    function addAccountDebet() public{
       
        coreInstance.addAccountDebet(msg.sender);
    }
    function newClient(string calldata _name) public{
        coreInstance.initializeClient(_name, msg.sender);
    }
    function balance(address token) public view returns(uint){
        return IERC20(token).balanceOf(msg.sender);
    }

    function depositeToBank(uint amount, address token) public{
        //approve frontend
        coreInstance.deposit(amount, token, msg.sender);
    }
    function getWETHPriceInUSD(address oracle) public view returns (uint256) {
        (, int256 price, , , ) = AggregatorV3Interface(oracle).latestRoundData();
        require(price > 0, "Invalid price");
        return uint256(price) / 100; //делим на 100 так как decimals оракла 8 а у usdt decimals 6 => 8-6=2 лишние нули
    }
     function transferBalanceInBank(uint amount, address token, address to) public{
         coreInstance.transferBalance(amount, token, to, msg.sender);
     }

     function checkAllowance(address token) public view returns(uint){
        return IERC20(token).allowance(msg.sender, address(this));
     }
}
