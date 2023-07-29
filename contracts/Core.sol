// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Core {
    address owner;
    constructor(){
        owner = msg.sender;
    }
    struct client{
        string name;
        address clientOwner;
        uint clientType;
        bool accountDebet;
        bool accountCredit;
        bytes32[] paymentInfo;
        document[] documents;
    }
    struct document{
        uint typeDocument;
        string documentInfo;
        address document;
    }
    mapping(address=>mapping(uint=>bool)) initSubscribe;
    mapping(address=>client) clients;
    modifier onlyOwner() {
        require(owner == msg.sender, "faild");
        _;
    }
    function initializeClient(string calldata _name) public{
        client storage newClientInfo = clients[msg.sender];
        newClientInfo.name = _name;
        newClientInfo.clientOwner = msg.sender;
       
        newClientInfo.accountDebet = false;
        newClientInfo.accountCredit = false;

        uint size;
        address addr = msg.sender;
        assembly {
            size := extcodesize(addr)
        }
        if (size > 0) {
            bytes4 expectedFunctionSignature = bytes4(keccak256("check(uint256,address)"));
            (bool success, ) = addr.call(abi.encodeWithSelector(expectedFunctionSignature, 1, addr));
            require(success, "faild");
            if(success == true){
                newClientInfo.clientType = 1;
                newClientInfo.documents.push(document(0, "entity person", msg.sender));
            } 
        } else{
            newClientInfo.clientType = 0;
            newClientInfo.documents.push(document(0, "natural person", msg.sender));
        }
        newClientInfo.paymentInfo.push(bytes32(keccak256(bytes("Create client"))));    
    }
    function clientInfo(address client_) public view returns(client memory){
            client memory _client = clients[client_];
            return _client;
    }
    function addAccountDebet() public{  
        require(msg.sender == clients[msg.sender].clientOwner);
        initSubscribe[msg.sender][0] = true;
    }
    function addAccountCredit() public{  
        require(msg.sender == clients[msg.sender].clientOwner);
        initSubscribe[msg.sender][1] = true;
    }
    function comlitesubscribersAccount(address _client, uint typeAccount) public onlyOwner{
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
    function deletAccountDebet() public{
        require(msg.sender == clients[msg.sender].clientOwner);
        require(clients[msg.sender].accountDebet == true, "not open");
        initSubscribe[msg.sender][0] = true;
    }
    function deletAccountCredit() public{
        require(msg.sender == clients[msg.sender].clientOwner);
        require(clients[msg.sender].accountCredit == true, "not open");
        initSubscribe[msg.sender][1] = true;
    }
    function comliteDeletAccount(address _client, uint typeAccount) public onlyOwner{
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
    function check(uint num, address addr) public pure{

    }
    function callInitializeClient(string calldata _name) external {
        coreInstance.initializeClient(_name);
    }
}
