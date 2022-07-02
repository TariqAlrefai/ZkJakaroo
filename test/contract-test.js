const { poseidonContract } = require("circomlibjs");
const { ethers } = require("hardhat");
const { assert, expect } = require("chai");
const { groth16 } = require("snarkjs");

function unstringifyBigInts(o) {
    if ((typeof(o) == "string") && (/^[0-9]+$/.test(o) ))  {
        return BigInt(o);
    } else if ((typeof(o) == "string") && (/^0x[0-9a-fA-F]+$/.test(o) ))  {
        return BigInt(o);
    } else if (Array.isArray(o)) {
        return o.map(unstringifyBigInts);
    } else if (typeof o == "object") {
        if (o===null) return null;
        const res = {};
        const keys = Object.keys(o);
        keys.forEach( (k) => {
            res[k] = unstringifyBigInts(o[k]);
        });
        return res;
    } else {
        return o;
    }
}

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
        expect(jakaroo).to.have.property("address");
        // console.log(Object.keys(jakaroo));
    });

    // it("Play twice", async ()=>{

    //     await jakaroo.connect(signers[0]).NewPlay();
        
    //     let fail = false;
    //     try {
    //         await jakaroo.connect(signers[0]).NewPlay();
    //         fail = true
    //     } catch (error) {
    //         assert.ok(true);
    //     }

    //     if(fail){
    //         assert.ok(false);
    //     }  
    //     // expect(true).to.be.eq(true);
    // });

    // it("Play a full round", async ()=>{

    //     await jakaroo.connect(signers[0]).NewPlay();
    //     await jakaroo.connect(signers[1]).NewPlay();
    //     await jakaroo.connect(signers[2]).NewPlay();
    //     await jakaroo.connect(signers[3]).NewPlay();
    //     await jakaroo.connect(signers[0]).NewPlay();
        
    //     const pcounter = await jakaroo.getPlayCounter();
    //     const round = await jakaroo.getRound();
    //     const turn = await jakaroo.getTurn();
    //     expect(pcounter).to.be.eq(5);
    //     expect(round).to.be.eq(1);
    //     expect(turn).to.be.eq(1);
    // });

    it("Play a full round", async ()=>{

        const Input = {
            "playerId": "0",
            "playground": [ "100", "100", "100", "100",
                            "100", "100", "100", "100",
                            "100", "100", "100", "100",
                            "100", "100", "100", "100"],
            "players_cards": ["13", "11", "9", "5", "2"],
            "player_card": "0",
            "played_ball": "2",
            "options": ["0"]
        };
        this.timeout(20000);

        const { proof, publicSignals } = await groth16.fullProve(Input, "circuits/Jakaroo/Jakaroo_js/Jakaroo.wasm", "circuits/Jakaroo/circuit_final.zkey");
        
        const editedPublicSignals = unstringifyBigInts(publicSignals);
        const editedProof = unstringifyBigInts(proof);
        const calldata = await groth16.exportSolidityCallData(editedProof, editedPublicSignals);

        const argv = calldata.replace(/["[\]\s]/g, "").split(',').map(x => BigInt(x).toString());

        const a = [argv[0], argv[1]];
        const b = [[argv[2], argv[3]], [argv[4], argv[5]]];
        const c = [argv[6], argv[7]];
        const input = argv.slice(8);
        
        console.log(input);
        
        await jakaroo.connect(signers[0]).NewPlay(a, b, c, input);

        const round = await jakaroo.getRound();
        
        expect(round).to.be.eq(0);
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