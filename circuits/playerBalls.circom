pragma circom 2.0.4;      
      
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
    Or.in[0] <== ball0;
    Or.in[1] <== ball1;
    Or.in[2] <== ball2;
    Or.in[3] <== ball3;

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
}
