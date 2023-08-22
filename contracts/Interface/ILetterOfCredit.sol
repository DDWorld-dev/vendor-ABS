// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.9;
// interface ILetterOfCredit {
//     function makeLettersOfCredit(address sender, address _bank, uint _tokenBalance, uint _tokenBalanceUsd, address oracleToken, address recipient, uint amount, address token, string calldata contitions) external;

//     function confirmLetterOfCredit(address sender, address bank) external;

//     function sendLettersOfCredit(address sender) external;
    
//     function checkLetterOfCredit(address sender) external;

//     function sendMoney(address sender) external;

//     function compliteLetterOfCredit(address sender) external;

//     function checkLetter(address sender) external view returns(address, address, uint, address, string memory, uint);

//     function getClientInfo12(address sender) external view returns(string memory,address, address, uint, uint, uint);

//     function setBank(address bank) external;
// }