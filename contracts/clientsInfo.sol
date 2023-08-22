// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract ClientInfo {
    
    address public BANK;
    address owner;
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
        payment[] paymentInfo;
        document[] documents;
        address[] allTokens;
        mapping(address=>uint) balanceUsdt;
        mapping(address=>uint) tokenBalance;
    }
    struct document{
        uint typeDocument;
        string documentInfo;
        address document;
    }
    struct payment{
        address from;
        address to;
        string message;
        address token;
        uint amount;
    }
    mapping(address=>mapping(uint=>bool)) public initSubscribe;
    mapping(address=>client) public clients;
    
    mapping(address=>address) oracles;
    mapping(address=>bool) public ownersBank;

    mapping(address=>bool) module;
    modifier onlyModules(address module_) {
        require(module[module_] == true, "only module can call");
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "not owner");
        _;
    }
    function addModules(address _module) public onlyOwner{
        module[_module] = true;
    }
    function createBank() public onlyModules(msg.sender){
        BANK = msg.sender;
        client storage newClientInfo = clients[msg.sender];
        newClientInfo.name = "BANK";
        newClientInfo.clientOwner = msg.sender;
        newClientInfo.bank = msg.sender;
        newClientInfo.accountDebet = true;
        newClientInfo.accountCredit = true;
        newClientInfo.clientType = 3;
        newClientInfo.documents.push(document(0, "create bank", msg.sender));
    }

    function addNeworacle(address token, address _oracle) public onlyModules(msg.sender){
        oracles[token] = _oracle;
    }

    function initializeClient(string calldata _name, address sender) public onlyModules(msg.sender){
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
        newClientInfo.paymentInfo.push(payment(sender, address(this), "new client", address(this), 0));    
    }
   
    function setOwner(address _owner) public onlyModules(msg.sender){
        require(msg.sender == BANK);
        ownersBank[_owner] = true;
    }

    function getClientInfo(address sender) public view onlyModules(msg.sender) returns(string memory,address, address, uint, uint, uint) {
        return(clients[sender].name, clients[sender].clientOwner, clients[sender].bank, clients[sender].clientType, clients[sender].balanceUsdt[0xdAC17F958D2ee523a2206206994597C13D831ec7], clients[sender].tokenBalance[0xdAC17F958D2ee523a2206206994597C13D831ec7]);
    }

    function setSubscribe(address sender, uint typeClient) public onlyModules(msg.sender){
        initSubscribe[sender][typeClient] = true;
    }

    function addAccount(address sender, uint typeAccount) public onlyModules(msg.sender){
        if(typeAccount == 0){
            clients[sender].accountDebet = true;
        }
        if(typeAccount == 1){
            clients[sender].accountCredit = true;
        }
        
    }
    function deletAccount(address sender, uint typeAccount) public onlyModules(msg.sender){
         if(typeAccount == 0){
            clients[sender].accountDebet = false;
        }
        if(typeAccount == 1){
            clients[sender].accountCredit = false;
        }
    }
    function updateBalanceInUSD(address sender) public{
        for(uint i = 0; i < clients[sender].allTokens.length; i++){
            (, int256 price, , , ) = AggregatorV3Interface(oracles[clients[sender].allTokens[i]]).latestRoundData();
            uint balance = clients[sender].balanceUsdt[clients[sender].allTokens[i]];
            clients[sender].balanceUsdt[clients[sender].allTokens[i]] = balance * uint(price);
        }
    }
    function transferBalanceInBank(address sender, address to, address token, uint amount, string memory inf) public{
        (, int256 price, , , ) = AggregatorV3Interface(oracles[token]).latestRoundData();
        require(price > 0, "Invalid price");
        unchecked {
            clients[sender].balanceUsdt[token] -= amount * uint(price);
            clients[sender].tokenBalance[token] -= amount;
            clients[to].balanceUsdt[token] += amount * uint(price);
            clients[to].tokenBalance[token] += amount;
            
        }
        clients[sender].paymentInfo.push(payment(sender, to, inf, token, amount));
    }
    function invest(address sender, address token, uint amount) public{
        (, int256 price, , , ) = AggregatorV3Interface(oracles[token]).latestRoundData();
        require(price > 0, "Invalid price");
        clients[sender].balanceUsdt[token] -= amount * uint(price);
        clients[sender].tokenBalance[token] -= amount;
        clients[BANK].balanceUsdt[token] += amount * uint(price);
        clients[BANK].tokenBalance[token] += amount;
        clients[sender].paymentInfo.push(payment(sender, address(this), "deposit balance", token, amount));
    }
     function depositBalance(address sender, address token, uint amount) public{
        (, int256 price, , , ) = AggregatorV3Interface(oracles[token]).latestRoundData();
        require(price > 0, "Invalid price");
        clients[sender].balanceUsdt[token] += amount * uint(price);
        clients[sender].tokenBalance[token] += amount;
        clients[sender].paymentInfo.push(payment(sender, address(this), "deposit balance", token, amount));
    }
    function withdrawlBalance(address sender, address token, uint amount) public{
        IERC20(token).transfer(sender, amount);
        (, int256 price, , , ) = AggregatorV3Interface(oracles[token]).latestRoundData();
        require(price > 0, "Invalid price");
        unchecked{
            clients[sender].balanceUsdt[token] -= amount * uint(price);
            clients[sender].tokenBalance[token] -= amount;
        }
        clients[sender].paymentInfo.push(payment(address(this), sender, "withdrawal balance", token, amount));
    }
}