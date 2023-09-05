const { expect } = require("chai")
const { ethers } = require("hardhat")


describe("ABS vendor", function () {
    let owner
    let buyer
    let client
    beforeEach(async function() {
      [owner, buyer, client] = await ethers.getSigners()

      const clientInfo = await ethers.getContractFactory("ClientInfo", owner)
      info = await clientInfo.deploy()
      await info.deployed() 

      const letterOfcredit = await ethers.getContractFactory("LettersOfCredit", owner)
      letter = await letterOfcredit.deploy(info.address)
      await letter.deployed() 
     
      const ABS = await ethers.getContractFactory("Core", owner)
      core = await ABS.deploy(info.address)
      await core.deployed()
     
      const Test = await ethers.getContractFactory("OtherContract", owner)
      contractTest = await Test.deploy(core.address, letter.address, info.address)
      await contractTest.deployed() 

      const swapToken = await ethers.getContractFactory("EthToTokenSwap", owner)
      swap = await swapToken.deploy()
      await swap.deployed()
      

      console.log(letter.address);
      console.log(contractTest.address)
      console.log(core.address);
      console.log(owner.address);
      info.addModules(core.address)
      info.addModules(letter.address)
      info.addModules(contractTest.address)
    })

    // it("should create new client", async function() {
    //   await contractTest.setOwnerBank();
    //   await contractTest.newClient("New client")
    //   console.log(await contractTest.checkClient(owner.address));
    // })
    // it("should create new account", async function() {
    //   await contractTest.setOwnerBank();
    //   console.log(await contractTest.checkClient(contractTest.address));
    //   await contractTest.setOwnerClient(owner.address)
    //   const tx = await contractTest.newClient("New client")
    //   const tx1 = await contractTest.addAccountDebet_()
    //   const tx2 = await contractTest.openAccount(owner.address, 0)
    //   const tx11 = await contractTest.addAccountCredit_()
    //   const tx22 = await contractTest.openAccount(owner.address, 1)
    //   console.log(await contractTest.checkClient(owner.address));
    // })
    // it("should delet new account", async function() {
    //     await contractTest.setOwnerBank();
    //     console.log(await contractTest.checkClient(contractTest.address));
    //     await contractTest.setOwnerClient(owner.address)
    //     const tx = await contractTest.newClient("New client")
    //     const tx1 = await contractTest.addAccountDebet_()
    //     const tx2 = await contractTest.openAccount(owner.address, 0)
    //     const tx11 = await contractTest.addAccountCredit_()
    //     const tx22 = await contractTest.openAccount(owner.address, 1)
    //     console.log(await contractTest.checkClient(owner.address));
    //     await contractTest.deletAccountDebet_()
    //     await contractTest.deletAccount(owner.address, 0)
    //     await contractTest.deletAccountCredit_()
    //     await contractTest.deletAccount(owner.address, 1)

    //     console.log(await contractTest.checkClient(buyer.address));
    // })
  
    // it("should deposit token", async function () {
    //   await contractTest.setOwnerBank();
    //   const tx = await contractTest.connect(buyer).newClient("New client1")
    //   console.log(await contractTest.connect(buyer).checkClient(buyer.address));
    //   await contractTest.setOwnerClient(owner.address)
    //   await contractTest.connect(buyer).addAccountDebet_()
    //   await contractTest.openAccount(buyer.address, 0)
    //   await contractTest.addNeworacle_("0xdAC17F958D2ee523a2206206994597C13D831ec7", "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D")
    //   await swap.connect(buyer).swapETHForTokens("0xdAC17F958D2ee523a2206206994597C13D831ec7", {value: ethers.utils.parseEther("1")})
    //   console.log("amount token", await swap.connect(buyer).getTokenBalance("0xdAC17F958D2ee523a2206206994597C13D831ec7"))
    //   const usdtABI = [
    //     {
    //         "constant": false,
    //         "inputs": [
    //             {
    //                 "name": "_spender",
    //                 "type": "address"
    //             },
    //             {
    //                 "name": "_value",
    //                 "type": "uint256"
    //             }
    //         ],
    //         "name": "approve",
    //         "outputs": [
    //             {
    //                 "name": "",
    //                 "type": "bool"
    //             }
    //         ],
    //         "payable": false,
    //         "stateMutability": "nonpayable",
    //         "type": "function"
    //     },
        
    //     ] 
  
    //     const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"; 
    //     const usdtContract = new ethers.Contract(usdtAddress, usdtABI, buyer);
    
    //     const amount = ethers.utils.parseUnits("100", 6);
    
    //     const spenderAddress = core.address 
    
    //     const tx3 = await usdtContract.connect(buyer).approve(spenderAddress, amount);
    //     await tx3.wait();
    //     console.log("allowance", await contractTest.connect(buyer).checkAllowance("0xdac17f958d2ee523a2206206994597c13d831ec7"));
    //     await contractTest.connect(buyer).depositeToBank(amount, "0xdac17f958d2ee523a2206206994597c13d831ec7")
    //     console.log("AMOUNT MONEY", await contractTest.connect(buyer).checkClient(buyer.address));
      
    // });
    // it("should transfer token", async function () {
      
    //   const usdtABI = [
    //   {
    //       "constant": false,
    //       "inputs": [
    //           {
    //               "name": "_spender",
    //               "type": "address"
    //           },
    //           {
    //               "name": "_value",
    //               "type": "uint256"
    //           }
    //       ],
    //       "name": "approve",
    //       "outputs": [
    //           {
    //               "name": "",
    //               "type": "bool"
    //           }
    //       ],
    //       "payable": false,
    //       "stateMutability": "nonpayable",
    //       "type": "function"
    //   },
      
    //   ] 

    //   await contractTest.setOwnerBank();
    //   await contractTest.connect(buyer).newClient("New client1")
     
    //   await contractTest.setOwnerClient(owner.address)
    //   await contractTest.connect(buyer).addAccountDebet_()
    //   await contractTest.openAccount(buyer.address, 0)
    //   await contractTest.addNeworacle_("0xdAC17F958D2ee523a2206206994597C13D831ec7", "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D")
    //   await swap.connect(buyer).swapETHForTokens("0xdAC17F958D2ee523a2206206994597C13D831ec7", {value: ethers.utils.parseEther("1")})
    //   console.log("amount token", await swap.connect(buyer).getTokenBalance("0xdAC17F958D2ee523a2206206994597C13D831ec7"))
    //   const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"; 
    //   const usdtContract = new ethers.Contract(usdtAddress, usdtABI, buyer);
    
    //   const amount = ethers.utils.parseUnits("100", 6);
    
    //   const spenderAddress = core.address 
    
    //   const tx3 = await usdtContract.connect(buyer).approve(spenderAddress, amount);
    //   await tx3.wait();
    //   console.log("allowance", await contractTest.connect(buyer).checkAllowance("0xdac17f958d2ee523a2206206994597c13d831ec7"));
    //   await contractTest.connect(buyer).depositeToBank(amount, "0xdac17f958d2ee523a2206206994597c13d831ec7")
    //   await contractTest.connect(client).newClient("New client2")
    //   await contractTest.connect(client).addAccountDebet_()
    //   await contractTest.openAccount(client.address, 0)
    //   console.log(await contractTest.connect(client).checkClient(client.address));
    //   console.log(await contractTest.connect(buyer).checkClient(buyer.address));
    //   await contractTest.connect(buyer).transferBalanceInBank(amount/2, usdtAddress, client.address)
    //   console.log(await contractTest.connect(buyer).checkClient(buyer.address), await contractTest.connect(client).checkClient(client.address));
      
    // });
    // it("should show correct balance", async function() {
    //   const usdtABI = [
    //     {
    //         "constant": false,
    //         "inputs": [
    //             {
    //                 "name": "_spender",
    //                 "type": "address"
    //             },
    //             {
    //                 "name": "_value",
    //                 "type": "uint256"
    //             }
    //         ],
    //         "name": "approve",
    //         "outputs": [
    //             {
    //                 "name": "",
    //                 "type": "bool"
    //             }
    //         ],
    //         "payable": false,
    //         "stateMutability": "nonpayable",
    //         "type": "function"
    //     },
        
    //     ] 
    //   await contractTest.setOwnerBank();
    //   await contractTest.newClient("New client")
    //   await contractTest.setOwnerBank();
    //   await contractTest.connect(buyer).newClient("New client1")
     
    //   await contractTest.setOwnerClient(owner.address)
    //   await contractTest.connect(buyer).addAccountDebet_()
    //   await contractTest.openAccount(buyer.address, 0)
    //   await contractTest.addNeworacle_("0xdAC17F958D2ee523a2206206994597C13D831ec7", "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D")
    //   await swap.connect(buyer).swapETHForTokens("0xdAC17F958D2ee523a2206206994597C13D831ec7", {value: ethers.utils.parseEther("1")})
    //   console.log("amount token", await swap.connect(buyer).getTokenBalance("0xdAC17F958D2ee523a2206206994597C13D831ec7"))
    //   const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"; 
    //   const usdtContract = new ethers.Contract(usdtAddress, usdtABI, buyer);
    
    //   const amount = ethers.utils.parseUnits("0.645", 6);
    
    //   const spenderAddress = core.address 
    
    //   const tx3 = await usdtContract.connect(buyer).approve(spenderAddress, amount);
    //   await tx3.wait();
    //   console.log("allowance", await contractTest.connect(buyer).checkAllowance("0xdac17f958d2ee523a2206206994597c13d831ec7"));
    //   await contractTest.connect(buyer).depositeToBank(amount, "0xdac17f958d2ee523a2206206994597c13d831ec7")
    //   console.log("AMOUNT MONEY", await contractTest.connect(buyer).checkClient(buyer.address));
    //   })
    //   it("should check letter of credit client", async function() {
    //        const usdtABI = [
    //     {
    //         "constant": false,
    //         "inputs": [
    //             {
    //                 "name": "_spender",
    //                 "type": "address"
    //             },
    //             {
    //                 "name": "_value",
    //                 "type": "uint256"
    //             }
    //         ],
    //         "name": "approve",
    //         "outputs": [
    //             {
    //                 "name": "",
    //                 "type": "bool"
    //             }
    //         ],
    //         "payable": false,
    //         "stateMutability": "nonpayable",
    //         "type": "function"
    //     },
        
    //     ] 
    //     await contractTest.setOwnerBank();
    //     await contractTest.connect(client).newClient("New client")
    //     await contractTest.connect(buyer).newClient("New client1")

    //     console.log(await contractTest.connect(client).checkClient(client.address));
    //     console.log(await contractTest.connect(buyer).checkClient(buyer.address));

    //     await contractTest.setOwnerClient(owner.address)

    //     await contractTest.connect(buyer).addAccountDebet_()
    //     await contractTest.openAccount(buyer.address, 0)
    //     await contractTest.connect(client).addAccountDebet_()
    //     await contractTest.openAccount(client.address, 0)

    //     await contractTest.addNeworacle_("0xdAC17F958D2ee523a2206206994597C13D831ec7", "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D")
        
    //     await swap.connect(buyer).swapETHForTokens("0xdAC17F958D2ee523a2206206994597C13D831ec7", {value: ethers.utils.parseEther("1")})
    //     const amount = ethers.utils.parseUnits("100", 6);
    //     const usdtContract = new ethers.Contract("0xdAC17F958D2ee523a2206206994597C13D831ec7", usdtABI, buyer);
    //     const tx3 = await usdtContract.connect(buyer).approve(core.address, amount);
    //     await tx3.wait();
        
    //     await contractTest.connect(buyer).depositeToBank(amount, "0xdac17f958d2ee523a2206206994597c13d831ec7")
    //     console.log("AMOUNT MONEY", await contractTest.connect(buyer).checkClient(buyer.address));

    //     await contractTest.connect(buyer).investing_("0xdAC17F958D2ee523a2206206994597C13D831ec7", ethers.utils.parseUnits("50", 6))
    //     console.log("AMOUNT MONEY", await contractTest.checkClient(contractTest.address));

    //     await contractTest.connect(buyer)._makeLetterOfCerdit(client.address, 100000, "0xdac17f958d2ee523a2206206994597c13d831ec7", "transfer new phone to China fom USA. 100 phone on day 3 month")

    //     await contractTest.connect(owner)._confirmLetterOfCredit(buyer.address);
    //     console.log(await contractTest.connect(buyer)._checkLetter(buyer.address));

    //     await contractTest.connect(owner)._sendLettersOfCredit(buyer.address);

    //     await contractTest.connect(owner)._checkLetterOfCredit(buyer.address);

    //     await contractTest.connect(owner)._sendMoney(buyer.address);
    //     console.log(await contractTest.connect(buyer)._checkLetter(buyer.address));

    //     await contractTest.connect(owner)._compliteLetterOfCredit(buyer.address);

    //     console.log("AMOUNT MONEY", await contractTest.checkClient(contractTest.address));
    //     console.log("AMOUNT MONEY", await contractTest.checkClient(client.address));
    //    })
       it("should transfer from anothre Bank", async function() {
        const usdtABI = [
          {
              "constant": false,
              "inputs": [
                  {
                      "name": "_spender",
                      "type": "address"
                  },
                  {
                      "name": "_value",
                      "type": "uint256"
                  }
              ],
              "name": "approve",
              "outputs": [
                  {
                      "name": "",
                      "type": "bool"
                  }
              ],
              "payable": false,
              "stateMutability": "nonpayable",
              "type": "function"
          },
          
          ] 
        await contractTest.setOwnerBank();
        await contractTest.newClient("New client")
        await contractTest.setOwnerBank();
        await contractTest.connect(buyer).newClient("New client1")
       
        await contractTest.setOwnerClient(owner.address)
        await contractTest.connect(buyer).addAccountDebet_()
        await contractTest.openAccount(buyer.address, 0)
        await contractTest.addNeworacle_("0xdAC17F958D2ee523a2206206994597C13D831ec7", "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D")
        await swap.connect(buyer).swapETHForTokens("0xdAC17F958D2ee523a2206206994597C13D831ec7", {value: ethers.utils.parseEther("1")})
        console.log("amount token", await swap.connect(buyer).getTokenBalance("0xdAC17F958D2ee523a2206206994597C13D831ec7"))
        const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"; 
        const usdtContract = new ethers.Contract(usdtAddress, usdtABI, buyer);
      
        const amount = ethers.utils.parseUnits("0.645", 6);
      
        const spenderAddress = core.address 
      
        const tx3 = await usdtContract.connect(buyer).approve(spenderAddress, amount);
        await tx3.wait();
        console.log("allowance", await contractTest.connect(buyer).checkAllowance("0xdac17f958d2ee523a2206206994597c13d831ec7"));
        await contractTest.connect(buyer).depositeToBank(amount, "0xdac17f958d2ee523a2206206994597c13d831ec7")
        console.log("AMOUNT MONEY", await contractTest.connect(buyer).checkClient(buyer.address));
        const clientInfo1 = await ethers.getContractFactory("ClientInfo")
        info1 = await clientInfo1.deploy()
        await info1.deployed() 

        await contractTest.connect(buyer).transferToAnotherBank(owner.address, info1.address, "0xdac17f958d2ee523a2206206994597c13d831ec7", amount/3)
        console.log("OLD CLIENTINFO", await info.balanceOf_("0xdac17f958d2ee523a2206206994597c13d831ec7"));
        console.log("NEW CLIENTINFO", await info1.balanceOf_("0xdac17f958d2ee523a2206206994597c13d831ec7"));
    })

})