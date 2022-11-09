const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LibertadorProtocol", function () {
    async function deployContract() {
        const [owner, otherAccount] = await ethers.getSigners();
        const LibertadorProtocol = await ethers.getContractFactory("LibertadorProtocol");
        const libertadorProtocol = await LibertadorProtocol.deploy();
        return { libertadorProtocol, owner, otherAccount };
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { libertadorProtocol, owner } = await deployContract();
            expect(await libertadorProtocol.owner()).to.equal(owner.address);
        });
    })

    describe("Deposit", function () {
        it("Should deposit", async function () {
            const { libertadorProtocol, owner } = await deployContract();
            await libertadorProtocol.deposit({ value: 100 });
            expect(await ethers.provider.getBalance(libertadorProtocol.address)).to.equal(100);
        });
    })

    describe("Withdraw", function () {
        it("Should withdraw", async function () {
            const { libertadorProtocol, owner } = await deployContract();
            await libertadorProtocol.deposit({ value: 100 });
            await libertadorProtocol.withdraw(100);
            expect(await ethers.provider.getBalance(libertadorProtocol.address)).to.equal(0);
        });
    })

})




