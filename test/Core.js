const { expect } = require("chai")
const { ethers } = require("hardhat")


describe("ABS vendor", function () {
    let owner
    let buyer

    beforeEach(async function() {
      [owner, buyer] = await ethers.getSigners()

      const ABS = await ethers.getContractFactory("Core", owner)
      core = await ABS.deploy()
      await core.deployed()
      const Test = await ethers.getContractFactory("OtherContract", owner)
      contractTest = await Test.deploy(core.address)
      await contractTest.deployed()
      console.log(contractTest.address)
      console.log(core.address);
      console.log(owner.address);
    })

    it("should create new client", async function() {
      const tx = await core.initializeClient("New client")
      console.log(await core.clientInfo(owner.address));
    })
    it("should create new account", async function() {
      const tx = await core.initializeClient("New client")
      
      const tx1 = await core.addAccountDebet()
      const tx2 = await core.complitesubscribersAccount(owner.address, 0)
      const tx11 = await core.addAccountCredit()
      const tx22 = await core.complitesubscribersAccount(owner.address, 1)
      console.log(await core.clientInfo(owner.address));
    })
    it("should delet new account", async function() {
      const tx = await core.connect(buyer).initializeClient("New client")
      
      await core.connect(buyer).addAccountDebet()
      await core.complitesubscribersAccount(buyer.address, 0)
      await core.connect(buyer).addAccountCredit()
      await core.complitesubscribersAccount(buyer.address, 1)
      console.log(await core.connect(buyer).clientInfo(buyer.address));
      await core.connect(buyer).deletAccountDebet()
      await core.comliteDeletAccount(buyer.address, 0)
      await core.connect(buyer).deletAccountCredit()
      await core.comliteDeletAccount(buyer.address, 1)
      console.log(await core.connect(buyer).clientInfo(buyer.address));
    })
    it("should create new account entity", async function() {
      const tx = await contractTest.callInitializeClient("new client 1")
      console.log("entity",await core.clientInfo(contractTest.address));
    })
})