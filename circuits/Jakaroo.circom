pragma circom 2.0.4;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "./logicgates.circom";
include "../node_modules/circomlib/circuits/gates.circom";
include "./playerBalls.circom";
include "./playingCards.circom";
include "../node_modules/circomlib/circuits/mux1.circom";
include "../node_modules/circomlib/circuits/mux2.circom";

function getPlayerStertPos(playerid){
    if (playerid == 0){
        return 0;
    }
    else if (playerid == 1){
        return 19;
    }
    else if (playerid == 2){
        return 37;
    }
    else if (playerid == 3){
        return 55;
    }
    return 0;
}

template jakaroo(){
    signal input playerId; // To identify which player (No player can jumb above its own ball)
    signal input playground[16]; // one array for the player's balls
    signal input players_cards[5];
    signal input player_card;
    signal input played_ball;
    signal input options[1]; // Optional, depending on played card (1, 11) [burn]
    // signal input current_playground_commit; // hash of playground
    // signal input players_cards_commit;
    signal output new_playground_out[16];
    signal output new_cards_commit[5];
    signal output played_card;
    

    signal burn <== options[0];
    assert( ((1-burn) * burn) == 0); // Make sure burn is either 0 or 1

    // Assert input cards is between 0 & 13
    for(var i=0; i<5; i++){
        assert(players_cards[i] >= 0 && players_cards[i] <= 13);
    }

    // Assert burning non-burnable King
    if(burn && players_cards[player_card] == 13){
        for(var i=playerId*4; i<playerId*4+4; i++){
            assert(playground[i] != 100);
        }
    }
    



    // Normal signal
    signal new_playground[16];
    signal new_players_cards[5];
    signal hive[16];
    signal winning_playground[16];
    signal new_cards[5];

    // signal output new_playground_commit; // might not be needed

    // Extract the card and make sure it is not an empty card slot
        // check its value if it is value between 0,4 - then check the array index value not 0.
        component rangeCard = RangeProof(16);
        rangeCard.in <== player_card;
        rangeCard.range[0] <== 0;
        rangeCard.range[1] <== 4;
        rangeCard.out === 1;

        // Make sure player plays his own ball
        component only_player_balls = onlyPlayerBalls();
        only_player_balls.playerId <== playerId;
        only_player_balls.played_ball <== played_ball;
        only_player_balls.output0 === 1; 
        
        component PlayingCards = playingCards();
        PlayingCards.player_card <== player_card;
        for (var i=0; i<5; i++){
            PlayingCards.players_cards[i] <== players_cards[i];
        }

        // for printing:
        for (var i=0; i<16; i++){
            // log(playground[i]);
            // log(hive[i]);
        }

        // bring the ball status (in hive or playground or winning)
        component BallStatus = ballStatus();
        for (var i=0;i<16;i++){
            BallStatus.playground[i] <== playground[i];
        }

        component isThePlayedBall[16];
        component mux2[16];
        component cardIsKing[16];
        component isBallInHive[16];
        component And[16];
        component Isnotzero[16];
        component And2[16];
        component playedBallAndnotBurn[16];
        
        for(var i = 0; i < 16; i++){
            mux2[i] = Mux2();
            isThePlayedBall[i] = IsEqual();
            cardIsKing[i] = IsEqual();
            Isnotzero[i] = IsNotZero();
            And[i] = and();
            isBallInHive[i] = GreaterThan(18);
            And2[i] = and();
        }

        // four options for this: 
            // 1. & 2. are negalgable.
            // 3. doing the chaings in playground.
            // 4. the card is king & playble ball is in base playground.
            
        var changing_pos;
        for (var i = 0; i < 16; i++){

            // make sure this is the played ball that we are using.
            isThePlayedBall[i].in[0] <== played_ball; 
            isThePlayedBall[i].in[1] <== i;           
            // check if this a King card or not.
            cardIsKing[i].in[0] <== 13;          
            cardIsKing[i].in[1] <== PlayingCards.cardMove;

            isBallInHive[i].in[0] <== BallStatus.hive[i]; 
            isBallInHive[i].in[1] <== 0;
            //                                  
            
            assert((!isThePlayedBall[i].out) || 
                   ( isBallInHive[i].out &&  cardIsKing[i].out) || 
                   (!isBallInHive[i].out && !cardIsKing[i].out) || 
                   burn); // Don't move any non-played ball.
            /*
                isBallInHive | cardIsKing | R
                0|0 F
                0|1 F
                1|0 -> T
                1|1 F
            */
            //       index@played ball     Ball out of base        The played card is King
            // assert(!(isThePlayedBall[i].out   && (!isBallInHive[i].out && cardIsKing[i].out))      || burn); // King Dosen't move any playable ball.
            // assert((!isThePlayedBall[i].out)   || (!isBallInHive[i].out && cardIsKing[i].out)      || burn); // King Dosen't move any playable ball.
            //0 
            //1
            //-2
            //3
            //4
            
            for (var j=0;j<16;j++){
                // log(playground[j]);
                // log(isThePlayedBall[i].out);
                // assert(!(getPlayerStertPos(playerId) != playground[j] && isThePlayedBall[i].out && (isBallInHive[k].out && cardIsKing[i].out)));  // Make sure that no other balls in start position when played new ball
            }

            // And[i].a <== Isnotzero[i].out;
            And[i].a <== isBallInHive[i].out;
            And[i].b <== cardIsKing[i].out;
            
            And2[i].a <== And[i].out;
            And2[i].b <== isThePlayedBall[i].out;
            
            playedBallAndnotBurn[i] = and();
            playedBallAndnotBurn[i].a <== isThePlayedBall[i].out;
            playedBallAndnotBurn[i].b <== 1-burn; // Not burn

            mux2[i].c[0] <== playground[i];                // s[1] = 0, s[0] = 0
            mux2[i].c[1] <== playground[i];                // s[1] = 0, s[0] = 1 
            mux2[i].c[2] <-- (playground[i]+ PlayingCards.cardMove)%74; // s[1] = 1, s[0] = 0 
            mux2[i].c[3] <== BallStatus.hive[i]-1;           // s[1] = 1, s[0] = 1
            
            mux2[i].s[1] <== playedBallAndnotBurn[i].out;
            mux2[i].s[0] <== And2[i].out; 

            mux2[i].out ==> new_playground[i];

            // Cehck that when a ball is moved it is not on another ball
            if(!mux2[i].s[0] && mux2[i].s[1]){ 
                for(var j=0; j<16; j++){
                    assert(mux2[i].out != playground[j]);
                }
            }

        }

        // Assert burning non-burnable Normal
        if(burn && players_cards[player_card] != 13){
            for(var i=playerId*4; i<playerId*4+4; i++){
                assert(playground[i] == 100 || playground[i] == 200 ); // 200 is the winning area
            }
        }

    	// Check winning

    // winning balls => 200, 300, 400, 500. 
        component winRange_P1[4];
        component winRange_P2[4];
        component winRange_P3[4];
        component winRange_P4[4];

        component mux_P1[4];
        component mux_P2[4];
        component mux_P3[4];
        component mux_P4[4];

        var j = 4;
        var k = 8;
        var u = 12;
        for (var i=0; i<4; i++){
            mux_P1[i] = Mux1();
            mux_P2[i] = Mux1();
            mux_P3[i] = Mux1();
            mux_P4[i] = Mux1();

            winRange_P1[i] = RangeProof(16);
            winRange_P1[i].in <== new_playground[i];
            winRange_P1[i].range[0] <== 72;
            winRange_P1[i].range[1] <== 73;
            winRange_P1[i].out ==> winning_playground[i];

            mux_P1[i].c[0] <== new_playground[i];
            mux_P1[i].c[1] <== 200;
            mux_P1[i].s    <== winRange_P1[i].out;
            mux_P1[i].out  ==> new_playground_out[i];

            winRange_P2[i] = RangeProof(16);
            winRange_P2[i].in <== new_playground[j];
            winRange_P2[i].range[0] <== 17;
            winRange_P2[i].range[1] <== 18;
            winRange_P2[i].out ==> winning_playground[j];

            mux_P2[i].c[0] <== new_playground[j];
            mux_P2[i].c[1] <== 300;
            mux_P2[i].s    <== winRange_P2[i].out;
            mux_P2[i].out  ==> new_playground_out[j];
            j = j+1;

            winRange_P3[i] = RangeProof(16);
            winRange_P3[i].in <== new_playground[k];
            winRange_P3[i].range[0] <== 35;
            winRange_P3[i].range[1] <== 36;
            winRange_P3[i].out ==> winning_playground[k];

            mux_P3[i].c[0] <== new_playground[k];
            mux_P3[i].c[1] <== 400;
            mux_P3[i].s    <== winRange_P3[i].out;
            mux_P3[i].out  ==> new_playground_out[k];
            k=k+1;

            winRange_P4[i] = RangeProof(16);
            winRange_P4[i].in <== new_playground[u];
            winRange_P4[i].range[0] <== 53;
            winRange_P4[i].range[1] <== 54;
            winRange_P4[i].out ==> winning_playground[u];
            
            mux_P4[i].c[0] <== new_playground[u];
            mux_P4[i].c[1] <== 500;
            mux_P4[i].s    <== winRange_P4[i].out;
            mux_P4[i].out  ==> new_playground_out[u];
            u = u+1;
            
    }
    // mux for king
    component mux_2[16];

    component deletePlayedCard = DeletePlayedCard();
    deletePlayedCard.played_card <== player_card;
    for(var i=0; i<5; i++){
        deletePlayedCard.old_cards[i] <== players_cards[i];
    }

    for(var i=0; i<5; i++){
        new_cards_commit[i] <== deletePlayedCard.new_cards[i];
    }
    
    played_card <== deletePlayedCard.card;
}

component main { public [playerId, playground, options] } = jakaroo();
/*
    signal input playerId;         // public
    signal input playground[16];   // public
    signal input players_cards[5]; // private
    signal input player_card;      // private
    signal input played_ball;      // private
    signal input options[1];       // public
*/


// circom tester => read circom to feed inputs. 
// Card shuffling => smart contract
// Generate Solidity & Wasm + power of tau, proof, .... etc.. . 
// connecting of four wallets. 
// Deployment on test net. 
// writing readme + record a video. 
// checking if the ball in winning game or not. 

    // Make sure it is the same playground as in smart contract
        // choose any hash function, then check if its correct with the current playground new_playground
        // then the hashed value store it in new_playground.
        // component hashPoseidon0 = Poseidon(16);
        // for(var i = 0; i < 16; i++){
        //     hashPoseidon0.inputs[i] <== playground[i];
        // }
        // hashPoseidon0.out === current_playground_commit;
        // component hashPoseidon1 = Poseidon(16);
        // for(var i = 0; i < 16; i++){
        //     hashPoseidon1.inputs[i] <== new_playground[i];
        // }
        // hashPoseidon1.out ==> new_playground_commit; // The new playground should goes here

    // Make sure players cards are the same as in smart contract
        // choose any hash function, then check if its correct with the current new_cards_commit  
        // component hashPoseidon2 = Poseidon(5);
        // for(var i = 0; i < 5; i++){
        //     hashPoseidon2.inputs[i] <== players_cards[i];
        // }
        // hashPoseidon1.out === players_cards_commit;
        // component hashPoseidon3 = Poseidon(4);
        // for(var i = 0; i < 4; i++){
        //     hashPoseidon3.inputs[i] <== new_players_cards[i];
        // }
        // hashPoseidon3.out ==> new_cards_commit; // The new cards commit should goes here