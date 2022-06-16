pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/gates.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

template MultiOR(n){
    signal input in[n];
    signal output out;
    component and;
    and = MultiAND(n);
    var i;
    for(i=0; i<n; i++){
        0 === (1 - in[i]) * in[i]; // Make sure that in[i] is 0 or 1
        and.in[i] <== 1 - in[i];   // Negate in[i]
    }

    out <== and.out;
}

template RangeProof(n) {
    assert(n <= 252);
    signal input in; // this is the number to be proved inside the range
    signal input range[2]; // the two elements should be the range, i.e. [lower bound, upper bound]
    signal output out;
    signal out1;
    signal out2;

    component low = LessEqThan(n);
    component high = GreaterEqThan(n);

    low.in[0] <== in;
    low.in[1] <== range[1];
    low.out ==> out1;
    
    high.in[0] <== in;
    high.in[1] <== range[0];
    high.out ==> out2;

    out1*out2 ==> out;
}

template IsNotZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    
    in*out === 1;
}
