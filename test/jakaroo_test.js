
const wasm_tester = require("circom_tester").wasm;
// const c_tester = require("circom_tester").c;
const assert = require("assert");

// const {Float32Bytes2Number, Number2Float32Bytes, f32Mul} = require("../lib/float-circom.js");
// const Number2Float32Bytes = require("../src/floatCircom.js");
// import {Number2Float32Bytes, Float32Bytes2Number} from "../src/float-circom.mjs";

const PATH1 = "./circuits/Jakaroo.circom";
const PATH2 = "./circuits/playerBalls.circom";
// const ADD_PATH = "./circuits/test_circuits/add.circom";
// const LESSTHAN_PATH = "./circuits/test_circuits/LessThan.circom";
// const GREATERTHAN_PATH = "./circuits/test_circuits/GreaterThan.circom";
// const INRANGE_PATH = "./circuits/test_circuits/InRange.circom";
// const ISEQUAL_PATH = "./circuits/test_circuits/isEqual.circom";
// const I2F_PATH = "./circuits/test_circuits/i2f.circom";


async function tester(){
    // beforeEach(function (tester) {
    //     this.timeout(100000);
    // });

    describe("Jakaroo Test", async ()=>{
       
        it("Player 1 only move his balls", async ()=>{

            const circuit = await wasm_tester(PATH1);
            const w = await circuit.calculateWitness({
                playerId: 3,
                playground: [20,100,100,100,100,100,100,100,100,100,100,100,100,100,100,55],
                players_cards: [8,9,13,11,13],
                player_card:2, 
                played_ball:14, // 0|1|2|3
            });
            // console.log("============== Witness ==============")
            // console.log(w);

            // INPUT:
                // playground -> w[20:35]
                // players_cards -> w[]
                // player_card -> w[]
                // playebl_ball -> w[36]
            // OUTPUT: 
                // New playground -> w[37:52]
                
                // console.log(w);
                // console.log(w[2],w[37],w[38],w[52]);
                // const output = w[1];
        })
        
        // it("Player only withdraw from his 5 cards", async ()=>{

        //     const circuit = await wasm_tester(PATH1);
        //     const w = await circuit.calculateWitness({
        //         playerId: 0,
        //         playground: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],
        //         players_cards: [8,9,10,11,12],
        //         player_card:4, // 0 -> 4
        //         played_ball:2, // 0|1|2|3
        //     });
        // })
        
        // it("Player 1 winning area", async ()=>{

        //     const circuit = await wasm_tester(PATH1);
        //     const w = await circuit.calculateWitness({
        //         playerId: 0,
        //         playground: [72,73,71,73,4,5,6,7,8,9,10,11,12,13,14,15],
        //         players_cards: [1,9,10,11,12],
        //         player_card:0, // 0 -> 4
        //         played_ball:2, // 0|1|2|3
        //     });
        //     const output = w[1] && w[2] && w[3] && w[4];

        //     assert.ok(output == 1);
        // })

        // it("Player 1 moving to winning area", async ()=>{

        //     const circuit = await wasm_tester(PATH1);
        //     const w = await circuit.calculateWitness({
        //         playerId: 0,
        //         playground: [60,57,52,49,4,5,6,7,8,9,10,11,12,13,14,15],
        //         players_cards: [8,9,10,11,12],
        //         player_card:4, // 0 -> 4
        //         played_ball:0, // 0|1|2|3
        //     });
        //     const output = w[1];

        //     assert.ok(output == 1);
        // })
    
    })
}


tester().
then(()=>console.log("OK")).
catch(e=>console.log(e));

