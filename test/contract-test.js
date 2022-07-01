const { poseidonContract } = require("circomlibjs");
const { ethers } = require("hardhat");
const { assert, expect } = require("chai");

describe("Test Jakaroo Contract", function () {    
    
    let Jakaroo;
    let jakaroo;
    let signers;
    let address;
    beforeEach(async function (){

        const PoseidonT3 = await ethers.getContractFactory(
            poseidonContract.generateABI(2),
            poseidonContract.createCode(2)
        )

        const poseidonT3 = await PoseidonT3.deploy();
        await poseidonT3.deployed();

        signers = await ethers.getSigners();

        Jakaroo = await ethers.getContractFactory("Jakaroo", {
            libraries: {
                PoseidonT3: poseidonT3.address
            }
        });

        jakaroo = await Jakaroo.deploy([signers[0].address, signers[1].address, signers[2].address, signers[3].address]);
        await jakaroo.deployed();
    });

    it("Test Deployment", ()=>{
        expect(jakaroo.address).to.be.not.empty();
    });

    it("Test Deployment", ()=>{
        jakaroo.connet(signers[0])
    });
});

// describe("Test Jakaroo Contract", function () {
//     beforeEach(async ()=>{
//         Jakaroo = await ethers.getContractFactory("Jakaroo");
//         jakaroo = await Jakaroo.deploy();
//         await jakaroo.deployed();
//     });
//   it("Should return the new greeting once it's changed", async function () {
//   });
// });