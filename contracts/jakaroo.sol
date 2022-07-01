// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.1;


// - In the beginning of the game:
//      - Make sure there are four players
//      - Distribute cards
// - Make sure the current player is valid
// - Run new play
// - Check winner
contract Jakaroo {
    
    // Global Variables
    uint32 roundCounter=0;
    uint32 turnOn=0; // Who is the current turn for ?

    address players[4];

    enum JakarooStages {
        Joining, 
        CardDistribution_SubmitCommit1, 
        CardDistribution_SubmitCommit2, 
        CardDistribution_Selection, 
        CardDistribution_NormalEncrypting, 
        CardDistribution_DistributorDecrypt, 
        CardDistribution_HashSubmitting,
        Player1_Turn,
        Player2_Turn,
        Player3_Turn,
        Player4_Turn,
        GameEnd
    }

    JakarooStages currentStage;
    modifier CheckStage(JakarooStages stage) {
        require(currentStage == stage, "Trying to run function you are not allowed to run");
    }

    modifier CheckPlayer {
        require(players[turnOn] == msg.sender, "It is not your turn");
    }

    // Structures
    struct PlayGround {
        uint32 balls[16];
        bytes32 current_commit;
        bytes32 players_cards_commits[4];
    }
    
    // Events
    event NewPlayEvent(uint32 indexed round, uint32 playerId, uint32 playedCard, uint32 playedBall);
    event ThereIsWinner(uint32 playerId);
    
    constructor(address players[4]) {
        
    }

    modifier validPlayerTurn {
        // The player plays in a valid turn
        // match the addresses of the sender and who is curretn turn for.
    }

    function DistributeCards()  returns () {
        
    }

    function NewPlay()  returns () {
        // Verify player play
        // Emit event
        // Update structure
        // Increase roundCounter
        // Move the turn
    }

    function CheckWinner() returns (){
        // Check for winner in playground array
    }
}