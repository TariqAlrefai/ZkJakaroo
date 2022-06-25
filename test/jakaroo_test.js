
const wasm_tester = require("circom_tester").wasm;
// const c_tester = require("circom_tester").c;
const assert = require("assert");

// const {Float32Bytes2Number, Number2Float32Bytes, f32Mul} = require("../lib/float-circom.js");
// const Number2Float32Bytes = require("../src/floatCircom.js");
// import {Number2Float32Bytes, Float32Bytes2Number} from "../src/float-circom.mjs";

const MULTIPLY_PATH = "./circuits/Jakaroo.circom";
// const ADD_PATH = "./circuits/test_circuits/add.circom";
// const LESSTHAN_PATH = "./circuits/test_circuits/LessThan.circom";
// const GREATERTHAN_PATH = "./circuits/test_circuits/GreaterThan.circom";
// const INRANGE_PATH = "./circuits/test_circuits/InRange.circom";
// const ISEQUAL_PATH = "./circuits/test_circuits/isEqual.circom";
// const I2F_PATH = "./circuits/test_circuits/i2f.circom";


async function tester(){

    describe("Test Multiplicatoin", async ()=>{
       
        it("10.5*11.25", async ()=>{
            let p1 = 10.5;
            let p2 = 11.25;

            const circuit = await wasm_tester(MULTIPLY_PATH);
            const w = await circuit.calculateWitness({
                playerId: 1,
                playground: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                players_cards: [1,2,3,4,5],
                player_card:4,
                played_ball:4,
            });

            await circuit.checkConstraints(w);
            console.log(w);

            const output = w[1];
                        
            // const rate = f32Mul(p1,p2)/Float32Bytes2Number(output);
            // assert.ok(rate > 0.999 && rate < 1.001);
        })
    })
}


tester().
then(()=>console.log("OK")).
catch(e=>console.log(e));

