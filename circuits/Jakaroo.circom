pragma circom 2.0.4;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "./logicgates.circom";
include "../node_modules/circomlib/circuits/gates.circom";
include "./playerBalls.circom";


template jakaroo(){
    signal input playerId; // To identify which player (No player can jumb above its own ball)
    signal input playground[16]; // one array for the player's balls
    signal input current_playground_commit; // hash of playground
    signal input players_cards[5];
    signal input players_cards_commit;
    signal input player_card;
    signal input played_ball;
    signal input options; // Optional, depending on played card (1, 11)

    signal output new_cards_commit;
    signal output new_playground;

    // Make sure it is the same playground as in smart contract
        // choose any hash function, then check if its correct with the current playgrond new_playground
        // then the hashed value store it in new_playground.
        component hashPoseidon0 = Poseidon(16);
        for(var i = 0; i < 16; i++){
        hashPoseidon0.inputs[i] <== playground[i];
        }
        hashPoseidon0.out === current_playground_commit;
        hashPoseidon0.out ==> new_playground; 

    // Make sure players cards are the same as in smart contract
        // choose any hash function, then check if its correct with the current new_cards_commit  
        component hashPoseidon1 = Poseidon(5);
        for(var i = 0; i < 5; i++){
        hashPoseidon1.inputs[i] <== players_cards[i];
        }
        hashPoseidon1.out === players_cards_commit;
        hashPoseidon1.out ==> new_cards_commit;

    // Extract the card and make sure it is not an empty card slot
        // check its value if it is value between 0,4 - then check the array index value not 0.
        component rangeCard = RangeProof(16);
        rangeCard.in <== player_card;
        rangeCard.range[0] <== 0;
        rangeCard.range[1] <== 4;
        rangeCard.out === 1;
        
        component notZero = IsNotZero();
        notZero.in <== players_cards[player_card];
        notZero.out === 1; 
    
        // Make sure player plays his own ball
        component only_player_balls1 = onlyPlayerBalls();
        only_player_balls1.playerId <== playerId;
        only_player_balls1.played_ball <== played_ball;
        only_player_balls1.output0 === 1; 

        // His ball is in playground (not in 0 or in winning place)
        component rangeBall = RangeProof(16);
        rangeBall.in <== played_ball;
        rangeBall.range[0] <== 0;
        rangeBall.range[1] <== 73;
        rangeBall.out === 1;

// Determine card functionality
    // Cards 1-1, 1-11, 2, 3, 4-b, 6, 7, 8, 9, 10, 12   
        // if (player_card == 2 ) { // Card 2
        //     played_ball = played_ball +2; 
        // }
        // if (player_card == 3 ) { // Card 3
        //     played_ball = played_ball +3; 
        // }
        // if (player_card == 4 ) { // Card 4
        //     played_ball = played_ball -4; 
        // }
        // if (player_card == 6 ) { // Card 6
        //     played_ball = played_ball +6; 
        // }
        // if (player_card == 7 ) { // Card 7
        //     played_ball = played_ball +7; 
        // }
        // if (player_card == 8 ) { // Card 8
        //     played_ball = played_ball +8; 
        // }
        // if (player_card == 9 ) { // Card 9
        //     played_ball = played_ball +9; 
        // }
        // if (player_card == 10 ) { // Card 10
        //     played_ball = played_ball +10; 
        // }
        // if (player_card == 12 ) { // Card 12
        //     played_ball = played_ball +12; 
        // }

        // No ball of his balls block the play

        // No two balls of others balls block the play

        // No ball in its base that block the play 

    // cards 1-n, 13-n 
        // Make sure player plays his own ball
        component only_player_balls2 = onlyPlayerBalls();
        only_player_balls2.playerId <== playerId;
        only_player_balls2.played_ball <== played_ball;
        only_player_balls2.output0 === 1;  
    // cards 11
        // Make sure player plays his own ball
        component only_player_balls3 = onlyPlayerBalls();
        only_player_balls3.playerId <== playerId;
        only_player_balls3.played_ball <== played_ball;
        only_player_balls3.output0 === 1; 
    // cards 5

}

component main = jakaroo();
