pragam circom 2.0.4

template jakaroo(){
    signal input playerId; // To identify which player (No player can jumb above its own ball)
    signal input playground[16]; // one array for the player's balls
    signal input current_playground_commit;
    signal input players_cards_commit;
    signal input players_cards[5];
    signal input player_card;
    signal input played_ball;
    signal input options; // Optional, depending on played card (1, 11)

    signal output new_cards_commit;
    signal output new_playground;

    // Make sure it is the same playground as in smart contract

    // Make sure players cards are the same as in smart contract

    // Extract the card and make sure it is not an empty card slot

    // Determine card functionality

    // cards 1-1, 1-11, 2, 3, 4-b, 6, 7, 8, 9, 10, 12
        // Make sure player plays his own ball

        // His ball is in playground (not in 0 or in winning place)

        // No ball of his balls block the play

        // No two balls of others balls block the play

        // No ball in its base that block the play 


    // cards 1-n, 13-n 
        // Make sure player plays his own ball

    // cards 11
        // Make sure player plays his own ball

    // cards 5

}


component main{private players_cards} = jakaroo();
