pragma circom 2.0.4;  
include "../node_modules/circomlib/circuits/mux1.circom";
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
    signal output binary_selector[4];
    component converter2Bits = Num2Bits(4);

    converter2Bits.in <-- players_cards[player_card];
    binary_selector[0] <== converter2Bits.out[0];
    binary_selector[1] <== converter2Bits.out[1];
    binary_selector[2] <== converter2Bits.out[2];
    binary_selector[3] <== converter2Bits.out[3];
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
