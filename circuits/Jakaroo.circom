pragma circom 2.0.4;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "./logicgates.circom";
include "../node_modules/circomlib/circuits/gates.circom";
include "./playerBalls.circom";
include "./playingCards.circom";
include "../node_modules/circomlib/circuits/mux4.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

template jakaroo(){
    signal input playerId; // To identify which player (No player can jumb above its own ball)
    signal input playground[16]; // one array for the player's balls
    signal input current_playground_commit; // hash of playground
    signal input players_cards[5];
    signal input players_cards_commit;
    signal input player_card;
    signal input played_ball;
    signal input options; // Optional, depending on played card (1, 11)
    
    // Normal signal
    signal new_playground[16];
    signal new_players_cards[5];
    signal winning_playground[16];

    signal output new_cards_commit;
    signal output new_playground_out[16];
    signal output new_playground_commit; // might not be needed

    // Extract the card and make sure it is not an empty card slot
        // check its value if it is value between 0,4 - then check the array index value not 0.
        component rangeCard = RangeProof(16);
        rangeCard.in <== player_card;
        rangeCard.range[0] <== 0;
        rangeCard.range[1] <== 4;
        rangeCard.out === 1;
        
        component notZero = IsNotZero();
        
        notZero.in <-- players_cards[player_card];
        notZero.out === 0; 

        // His ball is in playground (not in 0 or in winning place)
        component rangeBall = RangeProof(16);
        rangeBall.in <== played_ball;
        rangeBall.range[0] <== 0;
        rangeBall.range[1] <== 73;
        rangeBall.out === 1;


// Determine card functionality     
    // Make sure player plays his own ball
        component only_player_balls1 = onlyPlayerBalls();
        only_player_balls1.playerId <== playerId;
        only_player_balls1.played_ball <== played_ball;
        only_player_balls1.output0 === 1; 


    // Cards 1-1, 1-11, 2, 3, 4-b, 6, 7, 8, 9, 10, 12

    // Mux4 will be responsable for choosen cards.
        component selector = playingCards();
        selector.player_card <== player_card;
        component mux4 = Mux4();
        
        for (var i=0; i<16; i++){
            mux4.c[i] <== i+1;
        }

        /* 
        1 -> 1 step forward
        2 -> 2 steps forward
        3 -> 2 steps forward
        4 -> 4 steps backward
        5 -> 5 steps forward
        6 -> 6 steps forward
        7 -> 7 steps forward
        8 -> 8 steps forward
        9 -> 9 steps forward
        10 -> 10 steps forward
        11 -> 11 steps forward
        12 -> Queen -12- steps forward
        13 -> 13 King place
        14 -> J Jack replacement
        */

        for (var i=0; i<4; i++){
            mux4.s[i] <== selector.binary_selector[i];
        }
        
    // Mux1 will be responsable for changing the ball inside playground
        component mux1[16];
        component isequal[16];
        for(var i = 0; i < 16; i++){
            mux1[i] = Mux1();
            isequal[i]= IsEqual();
        }

        for (var i = 0; i < 16; i++){
            mux1[i].c[0] <== playground[i];
            mux1[i].c[1] <== playground[i]+ mux4.out;
            isequal[i].in[0] <== played_ball;
            isequal[i].in[1] <== i;
            mux1[i].s <== isequal[i].out;
            mux1[i].out ==> new_playground[i];
        }

        

        // No ball of his balls block the play

        // No two balls of others balls block the play

        // No ball in its base that block the play 

    // cards 1-n, 13-n 

    // cards 11

    // cards 5

// Check winning
    component winRange_P1[4];
    component winRange_P2[4];
    component winRange_P3[4];
    component winRange_P4[4];

    var j = 4;
    var k = 8;
    var u = 12;
    for (var i=0; i<4; i++){
        winRange_P1[i] = RangeProof(16);
        winRange_P1[i].in <== new_playground[i];
        winRange_P1[i].range[0] <== 72;
        winRange_P1[i].range[1] <== 73;
        winRange_P1[i].out ==> winning_playground[i];

        winRange_P2[i] = RangeProof(16);
        winRange_P2[i].in <== new_playground[j];
        winRange_P2[i].range[0] <== 17;
        winRange_P2[i].range[1] <== 18;
        winRange_P2[i].out ==> winning_playground[j];
        j = j+1;

        winRange_P3[i] = RangeProof(16);
        winRange_P3[i].in <== new_playground[k];
        winRange_P3[i].range[0] <== 35;
        winRange_P3[i].range[1] <== 36;
        winRange_P3[i].out ==> winning_playground[k];
        k=k+1;

        winRange_P4[i] = RangeProof(16);
        winRange_P4[i].in <== new_playground[u];
        winRange_P4[i].range[0] <== 53;
        winRange_P4[i].range[1] <== 54;
        winRange_P4[i].out ==> winning_playground[u];
        u = u+1;
    }

    // Make sure it is the same playground as in smart contract
        // choose any hash function, then check if its correct with the current playground new_playground
        // then the hashed value store it in new_playground.
    //     component hashPoseidon0 = Poseidon(16);
    //     for(var i = 0; i < 16; i++){
    //         hashPoseidon0.inputs[i] <== playground[i];
    //     }
    //     hashPoseidon0.out === current_playground_commit;
    //     component hashPoseidon1 = Poseidon(16);
    //     for(var i = 0; i < 16; i++){
    //         hashPoseidon1.inputs[i] <== new_playground[i];
    //     }
    //     hashPoseidon1.out ==> new_playground_commit; // The new playground should goes here

    // // Make sure players cards are the same as in smart contract
    //     // choose any hash function, then check if its correct with the current new_cards_commit  
    //     component hashPoseidon2 = Poseidon(5);
    //     for(var i = 0; i < 5; i++){
    //         hashPoseidon2.inputs[i] <== players_cards[i];
    //     }
    //     hashPoseidon1.out === players_cards_commit;
    //     component hashPoseidon3 = Poseidon(4);
    //     for(var i = 0; i < 4; i++){
    //         hashPoseidon3.inputs[i] <== new_players_cards[i];
    //     }
    //     hashPoseidon3.out ==> new_cards_commit; // The new cards commit should goes here

}

component main = jakaroo();
