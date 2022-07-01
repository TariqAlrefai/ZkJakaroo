// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import {Verifier} from "./JakarooVerifier.sol";

// - In the beginning of the game:
//      - Make sure there are four players
//      - Distribute cards
// - Make sure the current player is valid
// - Run new play
// - Check winner

interface VerifyPlay {
    function verifyProof(uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[21] memory input) external view returns (bool r);
}

contract Jakaroo {
    
    // Global Variables
    uint32 turnOn=0; // Who is the current turn for ?
    uint32 roundCounter=0; // 3 rounds per play
    uint32 playCounter = 0;

    address[4] players;

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
        _;
    }

    modifier CheckPlayer {
        require(players[turnOn] == msg.sender, "It is not your turn");
        _;
    }

    // Structures
    struct PlayGround {
        uint[16] balls;
        uint current_commit;
        uint[4] players_cards_commit;
    }
    
    uint[16] balls = [100, 100, 100, 100, 
                      100, 100, 100, 100,
                      100, 100, 100, 100,
                      100, 100, 100, 100];
    uint[4] cardsCommit = [0, 0, 0, 0];
    PlayGround playGround = PlayGround(balls, PoseidonT3.poseidon([uint256(0), uint256(0)]), cardsCommit);

    
    // Events
    event NewPlayEvent(uint indexed playCounter, uint round, uint playerId, uint playedCard);
    event ThereIsWinner(uint32 playerId);
    
    constructor(address[4] memory _players) {
        
    }

    function DistributeCards() public {
        
    }

    function NewPlay() public CheckPlayer {
        // Verify player play

        // Update structure
        uint[16] memory new_playground; // equal something
        uint playedCard;
        uint cardCommit;

        playGround.balls = new_playground;
        playGround.players_cards_commit[turnOn] = cardCommit;


        // Emit event
        emit NewPlayEvent(playCounter, roundCounter, turnOn, playedCard);

        // Increase roundCounter
        if(turnOn == 3){
            roundCounter = (roundCounter+1)%3;
        }

        // Move the turn
        turnOn = (turnOn+1)%4;

        // Increase player counter
        playCounter++;
    }

    function CheckWinner() public {
        // Check for winner in playground array
        
    }
}