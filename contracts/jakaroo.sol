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

contract Jakaroo is Verifier{
    
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

    JakarooStages currentStage = JakarooStages.Player1_Turn;
    modifier CheckStage(JakarooStages stage) {
        require(currentStage == stage, "Trying to run function you are not allowed to run");
        _;
    }

    JakarooStages stagePlayer = JakarooStages.Player1_Turn;
    modifier CheckStages {
        
        require(currentStage == stagePlayer, "Trying to run function you are not allowed to run");
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
    event ThereIsWinner(uint playerId);
    
    constructor(address[4] memory _players) {
        
        for (uint i = 0; i < _players.length; i++) {
            players[i] = _players[i];
        }
    }

    function DistributeCards() public {
        
    }

    function NewPlay(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[21] memory input) public CheckPlayer CheckStages returns (bool r) {
        
        // Verify player play
        r = super.verifyProof(a, b, c, input);

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

        if(currentStage == JakarooStages.Player1_Turn){
            currentStage = JakarooStages.Player2_Turn;
            stagePlayer = JakarooStages.Player2_Turn;
        }
        else if(currentStage == JakarooStages.Player2_Turn){
            currentStage = JakarooStages.Player3_Turn;
            stagePlayer = JakarooStages.Player3_Turn;
        }
        else if(currentStage == JakarooStages.Player3_Turn){
            currentStage = JakarooStages.Player4_Turn;
            stagePlayer = JakarooStages.Player4_Turn;
        }
        else if(currentStage == JakarooStages.Player4_Turn){
            currentStage = JakarooStages.Player1_Turn;
            stagePlayer = JakarooStages.Player1_Turn;
        }
    }

    function CheckWinner(uint[16] memory playground) public returns (uint) {
        // Check for winner in playground array
        
        bool win = false;
        uint winnerId;
        for(uint player=0; player<4; player++){
            win = true;
            winnerId = player;
            for(uint ball=0; ball<4; ball++){
                if(playground[player*4+ball] != 200){
                    win = false;
                    break;
                }
            }
            if(win){
                emit ThereIsWinner(winnerId); 
                return winnerId;
            }
        }
        return 5;
    }

    function getTurn() public view returns (uint) {
        return turnOn;
    }

    function getRound() public view returns (uint) {
        return roundCounter;
    }

    function getPlayCounter() public view returns (uint) {
        return playCounter;
    }

    function getCurrentStage() public view returns (JakarooStages) {
        return currentStage;
    }

    function getStagePlayer() public view returns (JakarooStages) {
        return stagePlayer;
    }

    function getPlayersAddresses() public view returns (address[4] memory) {
        return players;
    }

}