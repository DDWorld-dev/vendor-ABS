const { expect } = require("chai")
const { ethers } = require("hardhat")


describe("ABS vendor", function () {
    let owner
    let buyer
    let client
    beforeEach(async function() {
      [owner, buyer, client] = await ethers.getSigners()

      const ABS = await ethers.getContractFactory("Core", owner)
      core = await ABS.deploy()
      await core.deployed()
      const Test = await ethers.getContractFactory("OtherContract", owner)
      contractTest = await Test.deploy(core.address)
      await contractTest.deployed()    
      const swapToken = await ethers.getContractFactory("EthToTokenSwap", owner)
      swap = await swapToken.deploy()
      await swap.deployed()
      console.log(contractTest.address)
      console.log(core.address);
      console.log(owner.address);
    })

    it("should create new client", async function() {
      await contractTest.setOwnerBank();
      const tx = await contractTest.newClient("New client")
      //console.log(await core.getClientInfo(owner.address));
    })
    it("should create new account", async function() {
      await contractTest.setOwnerBank();
      const tx = await contractTest.newClient("New client")
      
      // const tx1 = await contractTest.addAccountDebet()
      // const tx2 = await contractTest.complitesubscribersAccount(contractTest.address, 0)
      // const tx11 = await contractTest.addAccountCredit()
      // const tx22 = await contractTest.complitesubscribersAccount(contractTest.address, 1)
      //console.log(await core.getClientInfo(owner.address));
    })
    it("should delet new account", async function() {
      await contractTest.setOwnerBank();
      const tx = await contractTest.connect(buyer).newClient("New client")
      
      // await contractTest.connect(buyer).addAccountDebet()
      // await contractTest.complitesubscribersAccount(contractTest.address, 0)
      // await contractTest.connect(buyer).addAccountCredit()
      // await contractTest.complitesubscribersAccount(contractTest.address, 1)
      // console.log(await contractTest.connect(buyer).getClientInfo(buyer.address));
      // await contractTest.connect(buyer).deletAccountDebet()
      // await contractTest.comliteDeletAccount(contractTest.address, 0)
      // await contractTest.connect(buyer).deletAccountCredit()
      // await contractTest.comliteDeletAccount(contractTest.address, 1)

      //console.log(await core.connect(buyer).getClientInfo(buyer.address));
    })
  
    it("should deposit token", async function () {
      await contractTest.setOwnerBank();
      const tx = await contractTest.connect(buyer).newClient("New client1")
      console.log(await contractTest.connect(buyer).checkClient(buyer.address));
      await contractTest.setOwnerClient(owner.address)
      await contractTest.connect(buyer).addAccountDebet()
      await contractTest.openAccount(buyer.address, 0)
      await core.addNeworacle("0xdAC17F958D2ee523a2206206994597C13D831ec7", "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D")
      await swap.connect(buyer).swapETHForTokens("0xdAC17F958D2ee523a2206206994597C13D831ec7", {value: ethers.utils.parseEther("1")})
      console.log("amount token", await swap.connect(buyer).getTokenBalance("0xdAC17F958D2ee523a2206206994597C13D831ec7"))
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
  
        const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"; 
        const usdtContract = new ethers.Contract(usdtAddress, usdtABI, buyer);
    
        const amount = ethers.utils.parseUnits("100", 6);
    
        const spenderAddress = core.address 
    
        const tx3 = await usdtContract.connect(buyer).approve(spenderAddress, amount);
        await tx3.wait();
        console.log("allowance", await contractTest.connect(buyer).checkAllowance("0xdac17f958d2ee523a2206206994597c13d831ec7"));
        await contractTest.connect(buyer).depositeToBank(amount, "0xdac17f958d2ee523a2206206994597c13d831ec7")
        console.log("AMOUNT MONEY", await contractTest.connect(buyer).checkClient(buyer.address));
      
    });
    it("should transfer token", async function () {
      
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
      await contractTest.connect(buyer).newClient("New client1")
     
      await contractTest.setOwnerClient(owner.address)
      await contractTest.connect(buyer).addAccountDebet()
      await contractTest.openAccount(buyer.address, 0)
      await core.addNeworacle("0xdAC17F958D2ee523a2206206994597C13D831ec7", "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D")
      await swap.connect(buyer).swapETHForTokens("0xdAC17F958D2ee523a2206206994597C13D831ec7", {value: ethers.utils.parseEther("1")})
      console.log("amount token", await swap.connect(buyer).getTokenBalance("0xdAC17F958D2ee523a2206206994597C13D831ec7"))
      const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"; 
      const usdtContract = new ethers.Contract(usdtAddress, usdtABI, buyer);
    
      const amount = ethers.utils.parseUnits("100", 6);
    
      const spenderAddress = core.address 
    
      const tx3 = await usdtContract.connect(buyer).approve(spenderAddress, amount);
      await tx3.wait();
      console.log("allowance", await contractTest.connect(buyer).checkAllowance("0xdac17f958d2ee523a2206206994597c13d831ec7"));
      await contractTest.connect(buyer).depositeToBank(amount, "0xdac17f958d2ee523a2206206994597c13d831ec7")
      await contractTest.connect(client).newClient("New client2")
      await contractTest.connect(client).addAccountDebet()
      await contractTest.openAccount(client.address, 0)
      console.log(await contractTest.connect(client).checkClient(client.address));
      console.log(await contractTest.connect(buyer).checkClient(buyer.address));
      await contractTest.connect(buyer).transferBalanceInBank(amount/2, usdtAddress, client.address)
      console.log(await contractTest.connect(buyer).checkClient(buyer.address), await contractTest.connect(client).checkClient(client.address));
      
    });
    
})