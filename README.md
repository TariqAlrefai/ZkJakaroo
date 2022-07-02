# Jakaroo Game


## Table of Contents <!-- omit in toc -->

- [How to run]()
- [Project Structure]()
  - [circuits]() 
  - [contracts]()
    - [Card Distribution]()
    - [Winning Stage]()
  - [front-end]()
- [Game description]()
  - [Card Functionality]()
  - [The Plaground]()
- [Game Screen]()
- [How to Win?]()
- [Things to be Noted]()



## How to run


## Game description
Four players compute to place their balls in the playground, then to complete one cycle to win the game, it is a traditional game in Middle East. 


### Card Functionality

  1. **Normal Cards:** 2,3,5,6,7,8,9,10, are moving the balls step forward according to thier value.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Playing_card_club_2.svg/300px-Playing_card_club_2.svg.png" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/8/82/Playing_card_diamond_3.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/5/52/Playing_card_heart_5.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/d/d2/Playing_card_spade_6.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/9/94/Playing_card_heart_7.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Playing_card_diamond_8.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/2/27/Playing_card_club_9.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/3/34/Playing_card_diamond_10.svg" width="80" height="100">

  2. **Card no. 4:** moving the ball backword.
 
<img src="https://upload.wikimedia.org/wikipedia/commons/3/3d/Playing_card_club_4.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/2/20/Playing_card_diamond_4.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/2/2c/Playing_card_spade_4.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/a/a2/Playing_card_heart_4.svg" width="80" height="100">

  5. **King Card K:** ONLY using this for placing new ball.
 
<img src="https://upload.wikimedia.org/wikipedia/commons/2/22/Playing_card_club_K.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Playing_card_diamond_K.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/9/9f/Playing_card_spade_K.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/d/dc/Playing_card_heart_K.svg" width="80" height="100">


  7. **Queen Card Q:** moving ball forward for 12 steps.

<img src="https://upload.wikimedia.org/wikipedia/commons/f/f2/Playing_card_club_Q.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/0/0b/Playing_card_diamond_Q.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/5/51/Playing_card_spade_Q.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/7/72/Playing_card_heart_Q.svg" width="80" height="100">


  9. **Jack Card J:** moving ball backword 11 steps.

<img src="https://upload.wikimedia.org/wikipedia/commons/b/b7/Playing_card_club_J.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/4/46/Playing_card_heart_J.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/b/bd/Playing_card_spade_J.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/a/af/Playing_card_diamond_J.svg" width="80" height="100">

  11. **Ace Card A:** moving ball forward 11 steps 11.

<img src="https://upload.wikimedia.org/wikipedia/commons/3/36/Playing_card_club_A.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/d/d3/Playing_card_diamond_A.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/2/25/Playing_card_spade_A.svg" width="80" height="100"> <img src="https://upload.wikimedia.org/wikipedia/commons/5/57/Playing_card_heart_A.svg" width="80" height="100">

### The Plaground
1. Playground consists of **73 postions**. 
2. Each player has a base to place his ball in.
3. Each player has a 4 postions for winning.
4. Each player has 4 balls.
5. Players have to place all thier balls and move them to **winning area**.
6. In the begnning, all four players has four balls in **Hive**

<img src="https://i.ibb.co/7RZyrwX/JAKAROO-4-0.png">

## Game Screen

## How to Win?
  - The player must enter all of his four balls into the winning area.

## Things to be Noted 
  1. There is no difference beteween the type of the cards (Clubs, Diamonds, Hearts, Spades). 
  2. You must play a playable card or burn your card, see some examples: 
        
      * **You have balls in hive**: you can only play the king to place your ball in base, if you don't have, you must burn any card you need. 
  
      * **You have a ball in playground**: you need to play a card to move your ball, you can't burn any movable card unless you can't move your ball (e.g it will over come another ball). 

      * **You must specify that you need to burn**: Once you have to burn a card, you must specify that you will burn a card, there are two values for burnning, 0: for playing normal, 1: to burn a card. 


***
## Game Algorithm

<img src="https://i.ibb.co/WnLnSft/Block-Diagram.png">


## Project Structure
* Circuits:

  *Description*
* Contracts: 
  * Card Distribution: 
  * Winning Stage: 

* Front-End: 

# Don't delete for now tariq, I will do later
## Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
