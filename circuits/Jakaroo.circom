pragma circom 2.0.4;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "./logicgates.circom";
include "../node_modules/circomlib/circuits/gates.circom";
include "./playerBalls.circom";
include "./playingCards.circom";
include "../node_modules/circomlib/circuits/mux4.circom";
include "../node_modules/circomlib/circuits/mux2.circom";


template jakaroo(){
    signal input playerId; // To identify which player (No player can jumb above its own ball)
    signal input playground[16]; // one array for the player's balls
    signal input current_playground_commit; // hash of playground
    signal input players_cards[5];
    signal input players_cards_commit;
    signal input player_card;
    signal input played_ball;
    signal input options; // Optional, depending on played card (1, 11)

    // signal output player_card;
    signal output new_cards_commit;
    signal output new_playground_commit;

    // Make sure it is the same playground as in smart contract
        // choose any hash function, then check if its correct with the current playgrond new_playground
        // then the hashed value store it in new_playground.
        component hashPoseidon0 = Poseidon(16);
        for(var i = 0; i < 16; i++){
            hashPoseidon0.inputs[i] <== playground[i];
        }
        hashPoseidon0.out === current_playground_commit;
        component hashPoseidon1 = Poseidon(16);
        for(var i = 0; i < 16; i++){
            hashPoseidon1.inputs[i] <== playground[i];
        }
        hashPoseidon1.out ==> new_playground_commit; // The new playground should goes here

    // Make sure players cards are the same as in smart contract
        // choose any hash function, then check if its correct with the current new_cards_commit  
        component hashPoseidon2 = Poseidon(5);
        for(var i = 0; i < 5; i++){
            hashPoseidon2.inputs[i] <== players_cards[i];
        }
        hashPoseidon1.out === players_cards_commit;
        component hashPoseidon3 = Poseidon(4);
        for(var i = 0; i < 4; i++){
            hashPoseidon3.inputs[i] <== players_cards[i];
        }
        hashPoseidon3.out ==> new_cards_commit; // The new cards commit should goes here

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
        component selector = playingCards();
        component mux4 = Mux4();
          for(var i = 0; i < 16; i++){
            mux4.c[i] <== playground[i];
        }

        component mux2_0 = Mux2();
        component mux2_1 = Mux2();
        component mux2_2 = Mux2();
        component mux2_3 = Mux2();
        component mux2_4 = Mux2();
        component mux2_5 = Mux2();
        component mux2_6 = Mux2();
        component mux2_7 = Mux2();
        component mux2_8 = Mux2();
        component mux2_9 = Mux2();
        component mux2_10 = Mux2();
        component mux2_11 = Mux2();
        component mux2_12 = Mux2();
        component mux2_13 = Mux2();
        component mux2_14 = Mux2();
        component mux2_15 = Mux2();
        component mux2_16 = Mux2();



        // No ball of his balls block the play

        // No two balls of others balls block the play

        // No ball in its base that block the play 

    // cards 1-n, 13-n 

    // cards 11

    // cards 5

}


component main = jakaroo();
