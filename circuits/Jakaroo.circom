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
    signal input new_player_cards[5];
    signal input players_cards_commit;
    signal input player_card;
    signal input played_ball;
    signal input new_playground[16];
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
            hashPoseidon1.inputs[i] <== new_playground[i];
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
        // add to first stage MUX the card from 1 to 12. 
        var j=1;
          for(var i = 0; i < 12; i++){
            mux4.c[i] <== playground[i] + j;
            j = j+1;
        }

// Second stage of MUX
        component mux1_0 = Mux1();
        component mux1_1 = Mux1();
        component mux1_2 = Mux1();
        component mux1_3 = Mux1();
        component mux1_4 = Mux1();
        component mux1_5 = Mux1();
        component mux1_6 = Mux1();
        component mux1_7 = Mux1();
        component mux1_8 = Mux1();
        component mux1_9 = Mux1();
        component mux1_10 = Mux1();
        component mux1_11 = Mux1();
        component mux1_12 = Mux1();
        component mux1_13 = Mux1();
        component mux1_14 = Mux1();
        component mux1_15 = Mux1();

        mux1_0.c[0] <== playground[0];
        mux1_1.c[0] <== playground[1];
        mux1_2.c[0] <== playground[2];
        mux1_3.c[0] <== playground[3];
        mux1_4.c[0] <== playground[4];
        mux1_5.c[0] <== playground[5];
        mux1_6.c[0] <== playground[6];
        mux1_7.c[0] <== playground[7];
        mux1_8.c[0] <== playground[8];
        mux1_9.c[0] <== playground[9];
        mux1_10.c[0] <== playground[10];
        mux1_11.c[0] <== playground[11];
        mux1_12.c[0] <== playground[12];
        mux1_13.c[0] <== playground[13];
        mux1_14.c[0] <== playground[14];
        mux1_15.c[0] <== playground[15];
        
        mux1_0.c[1] <== playground[0];
        mux1_1.c[1] <== playground[1];
        mux1_2.c[1] <== playground[2];
        mux1_3.c[1] <== playground[3];
        mux1_4.c[1] <== playground[4];
        mux1_5.c[1] <== playground[5];
        mux1_6.c[1] <== playground[6];
        mux1_7.c[1] <== playground[7];
        mux1_8.c[1] <== playground[8];
        mux1_9.c[1] <== playground[9];
        mux1_10.c[1] <== playground[10];
        mux1_11.c[1] <== playground[11];
        mux1_12.c[1] <== playground[12];
        mux1_13.c[1] <== playground[13];
        mux1_14.c[1] <== playground[14];
        mux1_15.c[1] <== playground[15];
        
        mux1_0.out ==> new_playground[0];
        mux1_1.out ==> new_playground[1];
        mux1_2.out ==> new_playground[2];
        mux1_3.out ==> new_playground[3];
        mux1_4.out ==> new_playground[4];
        mux1_5.out ==> new_playground[5];
        mux1_6.out ==> new_playground[6];
        mux1_7.out ==> new_playground[7];
        mux1_8.out ==> new_playground[8];
        mux1_9.out ==> new_playground[9];
        mux1_10.out ==> new_playground[10];
        mux1_11.out ==> new_playground[11];
        mux1_12.out ==> new_playground[12];
        mux1_13.out ==> new_playground[13];
        mux1_14.out ==> new_playground[14];
        mux1_15.out ==> new_playground[15];
        

        // No ball of his balls block the play

        // No two balls of others balls block the play

        // No ball in its base that block the play 

    // cards 1-n, 13-n 

    // cards 11

    // cards 5

}


component main = jakaroo();
