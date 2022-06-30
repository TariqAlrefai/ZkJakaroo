pragma circom 2.0.4;  
include "../node_modules/circomlib/circuits/mux1.circom";
include "../node_modules/circomlib/circuits/mux4.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

// converting playing card to a binary form to use it as selector to the MUX

template Num2Bits1(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * 2**i;
    }

    lc1 === in;
}

template playingCards(){
    signal input player_card;
    signal input players_cards[5];
    signal output cardMove; // Playing Card
    component converter2Bits = Num2Bits(4);

    converter2Bits.in <-- players_cards[player_card];

    // Determine card functionality     
        // Cards 1-1, 1-11, 2, 3, 4-b, 6, 7, 8, 9, 10, 12

        // Mux4 will be responsable for choosen cards.
        
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
        14 -> J Jack 11 steps backward
        */ 
        component mux4 = Mux4();

        for (var i=0; i<16; i++){
            mux4.c[i] <== i;
        }
        for (var i=0; i<4; i++){
            mux4.s[i] <== converter2Bits.out[i];
        }
        cardMove <== mux4.out;
}

template DeletePlayedCard(){
    signal input old_cards[5];
    signal input played_card;
    signal output new_cards[5];

    component mux1[5];
    component isEqual[5];
    
    for(var i=0; i<5; i++){
        mux1[i] = Mux1();
        isEqual[i] = IsEqual();
        
        assert((played_card != i) || (played_card == i && old_cards[i] != 0));

        mux1[i].c[0] <== old_cards[i];
        mux1[i].c[1] <== 0;
        isEqual[i].in[0] <== played_card;
        isEqual[i].in[1] <== i;
        mux1[i].s <== isEqual[i].out;
        new_cards[i] <== mux1[i].out;
    }
}


// component main = playingCards();
