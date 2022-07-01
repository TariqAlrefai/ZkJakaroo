
// const wasm_tester = require("circom_tester").wasm;
// const assert = require("assert");
// const { expect } = require("chai");


// const PATH1 = "./circuits/Jakaroo.circom";
// const PATH2 = "./circuits/playerBalls.circom";

// async function tester(){
//     // beforeEach(function (tester) {
//     //     this.timeout(100000);
//     // });

//     describe("Jakaroo Test", async ()=>{
       
//         it("Move a ball in the playground", async ()=>{
//             const circuit = await wasm_tester(PATH1);
//             const w = await circuit.calculateWitness({
//                 playerId: 3,
//                 playground: [20,100,100,100,100,100,100,100,100,100,100,100,100,100,100,55],
//                 players_cards: [8,9,13,11,13],
//                 player_card:1, 
//                 played_ball:15, 
//                 options: [0]
//             });

//             const new_playground = w.slice(1,17);
//             const new_cards = w.slice(17,22);
//             // console.log(new_playground);
//             assert.ok(new_playground[15] == 64);
//             assert.ok(new_cards[1] == 0, "Played card didn't change to zero");
//         }); 

//         it("Place a ball for player one.", async ()=>{
//             const circuit = await wasm_tester(PATH1);
//             const w = await circuit.calculateWitness({
//                 playerId: 0,
//                 playground: [100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100],
//                 players_cards: [8,9,13,11,13],
//                 player_card:2, 
//                 played_ball:0, 
//                 options: [0]
//             });


//             const new_playground = w.slice(1,17);
//             const new_cards = w.slice(17,22);
//             // console.log(new_playground);
//             assert.ok(new_playground[0] == 0);
//             assert.ok(new_cards[2] == 0, "Played card didn't change to zero");
//         });

//         it("Try to move unplaced ball (false)", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             try {
//                 const w = await circuit.calculateWitness({
//                     playerId: 3,
//                     playground: [100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100],
//                     players_cards: [8,9,13,11,13],
//                     player_card:0, 
//                     played_ball:12, 
//                     options: [0]
//                 });
//                 assert.ok(false);
//             } catch (error) {
//                 assert.ok(true);
//             }
//         });

//         it("Try to place a placed ball (false)", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             try {
//                 const w = await circuit.calculateWitness({
//                     playerId: 1,
//                     playground: [100,100,100,100,25,26,100,100,100,100,100,100,100,100,100,100],
//                     players_cards: [8,9,13,11,13],
//                     player_card:2, 
//                     played_ball:5, 
//                     options: [0]
//                 });
//                 assert.ok(false);
//             } catch (error) {
//                 assert.ok(true);
//             }
//         });

//         it("Try to place a ball when there is another ball in the start location (false)", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             try {
//                 const w = await circuit.calculateWitness({
//                     playerId: 1,
//                     playground: [100,100,19,100,100,100,100,100,100,100,100,100,100,100,100,100],
//                     players_cards: [8,9,13,11,13],
//                     player_card:2, 
//                     played_ball:4, 
//                     options: [0]
//                 });
//                 assert.ok(false);
//             } catch (error) {
//                 assert.ok(true);
//             }
//         });

//         it("Try to play a zero card (false)", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             try {
//                 const w = await circuit.calculateWitness({
//                     playerId: 1,
//                     playground: [100,100,19,100,20,100,100,100,100,100,100,100,100,100,100,100],
//                     players_cards: [8,9,0,11,13],
//                     player_card:2, 
//                     played_ball:4, 
//                     options: [0]
//                 });
//                 assert.ok(false);
//             } catch (error) {
//                 assert.ok(true);
//             }
//         });

//         it("Try to play a card greater than 13 (false)", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             try {
//                 const w = await circuit.calculateWitness({
//                     playerId: 1,
//                     playground: [100,100,19,100,20,100,100,100,100,100,100,100,100,100,100,100],
//                     players_cards: [15,9,0,11,13],
//                     player_card:1, 
//                     played_ball:4, 
//                     options: [0]
//                 });
//                 assert.ok(false);
//             } catch (error) {
//                 assert.ok(true);
//             }
//         });

//         it("Burn a king card", async ()=>{
            
//             const circuit = await wasm_tester(PATH1);
            
//             const w = await circuit.calculateWitness({
//                 playerId: 1,
//                 playground: [100,100,19,100,20,23,25,30,100,100,100,100,100,100,100,100],
//                 players_cards: [0,0,0,13,13],
//                 player_card:3, 
//                 played_ball:4, 
//                 options: [1]
//             });
            
//             const new_cards = w.slice(17,22);
//             assert.ok(new_cards[3] == 0, "Played card didn't change to zero");
            
//         });

//         it("Burn a normal card", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             const w = await circuit.calculateWitness({
//                 playerId: 2,
//                 playground: [100,100,19,100,20,100,100,100,100,100,100,100,100,100,100,100],
//                 players_cards: [12,9,0,11,1],
//                 player_card:1, 
//                 played_ball:8, 
//                 options: [1]
//             });

//             const new_cards = w.slice(17,22);
//             assert.ok(new_cards[1] == 0, "Played card didn't change to zero");
            
//         });

//         it("Burn a non-burnable king card ", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             // try {
//                 const w = await circuit.calculateWitness({
//                     playerId: 0,
//                     playground: [10,23,19,11,20,100,100,100,100,100,100,100,100,100,100,100],
//                     players_cards: [0,0,0,13,13],
//                     player_card:3, 
//                     played_ball:1, 
//                     options: [1]
//                 });
//                 assert(false);
//             // } catch (error) {
//             //     assert(error);
//             // }
//         });

//         it("Burn a non-burnable normal card ", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             const w = await circuit.calculateWitness({
//                 playerId: 1,
//                 playground: [100,100,19,100,10,13,100,100,100,100,100,100,100,100,100,100],
//                 players_cards: [3,9,0,11,10],
//                 player_card:1, 
//                 played_ball:4, 
//                 options: [1]
//             });
//             assert.ok(false);
            
//         });

//         it("Try to move a ball on another ball ", async ()=>{
//             const circuit = await wasm_tester(PATH1);

//             const w = await circuit.calculateWitness({
//                 playerId: 1,
//                 playground: [100,100,19,100,10,13,100,100,100,100,100,100,100,100,100,100],
//                 players_cards: [3,9,0,11,10],
//                 player_card:1, 
//                 played_ball:4, 
//                 options: [0]
//             });
//             // assert.ok(false);
            
//         });
//     });
// }


// tester().
// then(()=>console.log("OK")).
// catch(e=>console.log(e));

