// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./clientsInfo.sol";
contract LettersOfCredit{
    ClientInfo clientInfo;
     struct letterofcredit{
        address from;
        address to;
        uint amount;
        address token;
        string conditions;
        uint stage;
    }
    mapping(address=>letterofcredit) public LettersOfCredits;
    constructor(address clientInfo_){
        clientInfo = ClientInfo(clientInfo_);
    }
    event newLetterOfCreditrequest(address to, string message);
 
    function makeLettersOfCredit(address sender, address recipient, uint amount, address token, string calldata contitions) public {

        letterofcredit storage newLetterOfCredit = LettersOfCredits[sender];
        newLetterOfCredit.from = sender;
        newLetterOfCredit.to = recipient;
        newLetterOfCredit.amount = amount;
        newLetterOfCredit.token = token;
        newLetterOfCredit.conditions = contitions;
        newLetterOfCredit.stage = 1;
    }
    function confirmLetterOfCredit(address sender, address _client) public {
        require(LettersOfCredits[_client].stage == 1, "Error");
        require(clientInfo.ownersBank(sender) == true, "only owner bank can confirm");
        LettersOfCredits[_client].stage = 2;
    }
    function sendLettersOfCredit(address sender, address _client) public{
        require(LettersOfCredits[_client].stage == 2, "Error");
        require(clientInfo.ownersBank(sender) == true, "only owner bank can send");
        emit newLetterOfCreditrequest(LettersOfCredits[_client].to, LettersOfCredits[_client].conditions);
        LettersOfCredits[_client].stage = 3;
    }
    function checkLetterOfCredit(address sender, address _client) public{
        require(LettersOfCredits[_client].stage == 3, "Error");
        require(clientInfo.ownersBank(sender) == true, "only bank can confirm check");
        LettersOfCredits[_client].stage = 4;
    }
    function transferBalance_(uint amount, address token, address to, address sender) private{
        clientInfo.updateBalanceInUSD(sender);
        clientInfo.transferBalanceInBank(sender, to, token, amount, "new transfer balance letter of credit");
    }
   
    function checkLetter(address sender) public view returns(address, address, uint, address, string memory, uint){
        return (LettersOfCredits[sender].from, LettersOfCredits[sender].to, LettersOfCredits[sender].amount, LettersOfCredits[sender].token, LettersOfCredits[sender].conditions, LettersOfCredits[sender].stage);
    }
    function sendMoney(address sender, address _client) public{
        require(LettersOfCredits[_client].stage == 4, "error");
        require(clientInfo.ownersBank(sender) == true, "only bank can send money");
        transferBalance_(LettersOfCredits[_client].amount, LettersOfCredits[_client].token, LettersOfCredits[_client].to, clientInfo.BANK());
        LettersOfCredits[_client].stage = 5;
    }
    function compliteLetterOfCredit(address sender, address _client) public {
        require(LettersOfCredits[_client].stage == 5, "error");
        require(clientInfo.ownersBank(sender) == true, "only bank can send money");
        delete LettersOfCredits[_client];
    }
}