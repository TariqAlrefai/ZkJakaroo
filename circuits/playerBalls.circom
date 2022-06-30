pragma circom 2.0.4;      

include "../node_modules/circomlib/circuits/comparators.circom";
include "./logicgates.circom";
include "../node_modules/circomlib/circuits/gates.circom";

template onlyPlayerBalls(){
    signal input playerId;
    signal input played_ball;
    signal output output0;

    var ball0 = playerId * 4 + 0;
    var ball1 = playerId * 4 + 1;
    var ball2 = playerId * 4 + 2;
    var ball3 = playerId * 4 + 3;
    component Or = MultiOR(4); 
    component Eq0 = IsEqual();
    component Eq1 = IsEqual();
    component Eq2 = IsEqual();
    component Eq3 = IsEqual();

    Eq0.in[0] <== played_ball;
    Eq0.in[1] <== ball0;
    
    Eq1.in[0] <== played_ball;
    Eq1.in[1] <== ball1;
    
    Eq2.in[0] <== played_ball;
    Eq2.in[1] <== ball2;
    
    Eq3.in[0] <== played_ball;
    Eq3.in[1] <== ball3;

    Or.in[0] <== Eq0.out;
    Or.in[1] <== Eq1.out;
    Or.in[2] <== Eq2.out;
    Or.in[3] <== Eq3.out;

    output0 <== Or.out;
    // log(output0);
}

template ballStatus(){

    signal input playground[16];
    signal output hive[16];
    
    // Balls Placement:
        // Starting Locations: 
        // Player 1: 0
        // Player 2: 19
        // Player 3: 37
        // Player 4: 55
    component IsEqual_P1[4];
    component IsEqual_P2[4];
    component IsEqual_P3[4];
    component IsEqual_P4[4];

    
    var a = 4;
    var b = 8;
    var c = 12;

    for (var i=0; i<4; i++){
        IsEqual_P1[i] = IsEqual();
        IsEqual_P1[i].in[0] <== playground[i];
        IsEqual_P1[i].in[1] <== 100;
        (IsEqual_P1[i].out) ==> hive[i];
        
        IsEqual_P2[i] = IsEqual();
        IsEqual_P2[i].in[0] <== playground[a];
        IsEqual_P2[i].in[1] <== 100;
        (IsEqual_P2[i].out)*(19+1) ==> hive[a];
        a = a+1;

        IsEqual_P3[i] = IsEqual();
        IsEqual_P3[i].in[0] <== playground[b];
        IsEqual_P3[i].in[1] <== 100;
        (IsEqual_P3[i].out)*(37+1) ==> hive[b];
        b=b+1;

        IsEqual_P4[i] = IsEqual();
        IsEqual_P4[i].in[0] <== playground[c];
        IsEqual_P4[i].in[1] <== 100;
        (IsEqual_P4[i].out)*(55+1) ==> hive[c];
        c = c+1;
    }
}


// component main = onlyPlayerBalls();
