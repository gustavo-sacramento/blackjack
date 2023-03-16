
// main.swift
//  FirstPlayground
//
//  Created by Gustavo Sacramento on 14/03/23.
//
//

import Foundation


enum CardSuits: String, CaseIterable {
    case Hearts = "Hearts"
    case Spades = "Spades"
    case Clubs = "Clubs"
    case Diamonds = "Diamonds"
}

enum CardValue: String, CaseIterable {
    case ace = "Ace", two = "Two", three = "Three", four = "Four", five = "Five", six = "Six", seven = "Seven", eight = "Eight", nine = "Nine", ten = "Ten", jack = "Jack", queen = "Queen", king = "King"
}

struct PlayingCard {
    var cardValue: CardValue
    var cardSuit: CardSuits

    init(value: CardValue, suit: CardSuits)
    {
        self.cardValue = value
        self.cardSuit = suit
    }

    func cardName() {
        print("\(cardValue) of \(cardSuit)")
    }
}

class CardDeck {
    var cardsRemaining: Int
    var deck: [PlayingCard]

    init() {
        cardsRemaining = 104
        deck = []
    }

    func createDeck() {
        for suit in CardSuits.allCases {
            for value in CardValue.allCases {
                deck.append(PlayingCard(value: value, suit: suit))
                deck.append(PlayingCard(value: value, suit: suit))
            }
        }
    }

    func listDeck() {
        var count = 0

        for card in deck {
            print(card)
            count += 1
        }
        print(count)
    }

    func shuffleDeck() {
        deck.shuffle()
    }

    func drawCard() -> PlayingCard? {
        guard let cardDrawn = deck.popLast() else {
            print("No cards left in deck!")
            return nil
        }

        if self.cardsRemaining >= 1 {
            self.cardsRemaining -= 1
            // print("You drew:")
            // print("\(cardDrawn.cardName())\n")
            // print(cardsRemaining)
            return cardDrawn
        }

        else {
            print("No cards left in deck!")
        }
        return nil
    }
}

func hit(points: inout Int, cards: inout [String], deck: inout CardDeck) {
    if let cardDrawn = deck.drawCard() {
        if cardDrawn.cardValue == .ace {
            cards.append(String(describing: cardDrawn.cardValue))
            if points + 11 > 21 {
                points += 1
            }
            else {
                points += 11
            }
        }
        
        if let value = cardValues[cardDrawn.cardValue] {
            cards.append(String(describing: cardDrawn.cardValue))
            points += value
        }
    }
}

func gameInit(deck: inout CardDeck, newRound: Bool = false) -> (deck: CardDeck, playerPoints: Int, dealerPoints: Int, playerCards: [String], dealerCards: [String], holeCard: PlayingCard) {
    if !newRound {  // If your starting the game and not just the round
        deck = CardDeck()
        deck.createDeck()
        deck.shuffleDeck()
    }
    
    var playerPoints = 0
    var dealerPoints = 0
    var playerCards = [String]()
    var dealerCards = [String]()
    var holeCard = PlayingCard(value: .ace, suit: .Clubs);
    
    hit(points: &playerPoints, cards: &playerCards, deck: &deck)
    hit(points: &dealerPoints, cards: &dealerCards, deck: &deck)
    hit(points: &playerPoints, cards: &playerCards, deck: &deck)
    
    if let cardDrawn = deck.drawCard() {
        holeCard = cardDrawn
    }
    
    return (deck, playerPoints, dealerPoints, playerCards, dealerCards, holeCard)
}


let cardValues = [CardValue.two : 2, CardValue.three : 3, CardValue.four : 4, CardValue.five : 5, CardValue.six : 6, CardValue.seven : 7, CardValue.eight : 8, CardValue.nine : 9, CardValue.ten : 10, CardValue.jack : 10, CardValue.queen : 10, CardValue.king : 10]
var defaultDeck = CardDeck()
var (deck, playerPoints, dealerPoints, playerCards, dealerCards, holeCard) = gameInit(deck: &defaultDeck)
var gameEnd = false

var greeting = """
                                                        WELCOME TO BLACKJACK!!!

"""
print(greeting)

while true {
    if playerPoints > 21 {
        print("""
                                                            BUST, YOU LOSE!!!

            """)
        
        if holeCard.cardValue == .ace {
            dealerCards.append(String(describing: holeCard.cardValue))
            
            if dealerPoints + 11 > 21 {
                dealerPoints += 1
            }
            else {
                dealerPoints += 11
            }
        }
        
        
        else if let value = cardValues[holeCard.cardValue] {
            dealerCards.append(String(describing: holeCard.cardValue))
            dealerPoints += value
        }
        
        gameEnd.toggle()
    }
    
    else {
        print("""
                                                            So far you've drawn: \(playerCards)
                                                            Your Points: \(playerPoints)
                                                            Dealer's Hand: [ ? ], \(dealerCards)
                                                            Dealer's Points: \(dealerPoints)
                                                        
                                                            Choose your next move:
            
                                                            HIT - Take another card     --- (Type 1)
                                                            STAND - Take no more cards  --- (Type 2)
            
            """)
        
        var decision = readLine()
        while decision != "1" && decision != "2" {
            print("Try again, please type 1 or 2")
            decision = readLine()
        }
        
        if decision == "1" {  // HIT
            hit(points: &playerPoints, cards: &playerCards, deck: &deck)
        }
        
        else {  // STAND, the player will have 21 points or less
            // Dealer shows hole card
            if holeCard.cardValue == .ace {
                dealerCards.append(String(describing: holeCard.cardValue))
                
                if dealerPoints + 11 > 21 {
                    dealerPoints += 1
                }
                else {
                    dealerPoints += 11
                }
            }
            
            else if let value = cardValues[holeCard.cardValue] {
                dealerCards.append(String(describing: holeCard.cardValue))
                dealerPoints += value
            }
            
            // if dealer hasn't won and has chance to win
            while (dealerPoints < playerPoints) || (dealerPoints == playerPoints && dealerPoints < 17){
                print("""
                                                                THE DEALER IS HITTING!!

                """)
                sleep(1)
                hit(points: &dealerPoints, cards: &dealerCards, deck: &deck)
                
            }
            
            var dealerBlackjack = false
            var playerBlackjack = false
            
            if dealerPoints == 21 && dealerCards.count == 2 {
                dealerBlackjack = true
            }
            
            if playerPoints == 21 && playerCards.count == 2 {
                playerBlackjack = true
            }
            
            if dealerBlackjack && playerBlackjack {
                // PUSH
                print("""
                                                                    IT'S A PUSH, BOTH HAVE BLACKJACK!!
                
                """)
            }
            
            else if dealerBlackjack && !playerBlackjack {
                // Dealer wins automatically
                print("""
                                                                    YOU LOSE, THE DEALER HAS BLACKJACK!!

                """)
            }
            
            else if !dealerBlackjack && playerBlackjack {
                // Player wins automatically
                print("""
                                                                    YOU WIN, YOU HAVE BLACKJACK!!
                
                """)
            }
            
            else {
                if playerPoints > dealerPoints {
                    // Player Wins
                    print("""
                                                                    YOU WIN!!
                    
                    """)
                }
                
                else if playerPoints < dealerPoints && dealerPoints <= 21 {
                    // Dealer wins
                    print("""
                                                                    YOU LOSE!!
                    
                    """)
                }
                
                else if playerPoints == dealerPoints {
                    // PUSH
                    print("""
                                                                    IT'S A TIE, BOTH HAVE EQUAL POINTS!!
                    
                    """)
                }
                
                else {
                    // PLAYER WINS
                    print("""
                                                                    YOU WIN!!
                    
                    """)
                    
                }
            }
            gameEnd.toggle()
        }
    }
        
    if gameEnd {
        print("""
                                                            Your Hand: \(playerCards)
                                                            Your Points: \(playerPoints)
                                                            Dealer's Hand: \(dealerCards)
                                                            Dealer's Points: \(dealerPoints)
                                                            Cards Remaining in Deck: \(deck.cardsRemaining)
            
            
                                                            Do you want to play again?
                
                                                            YES --- (Type 1)
                                                            NO  --- (Type 2)
            """)
        
        var decision = readLine()
        while decision != "1" && decision != "2" {
            print("Try again, please type 1 or 2")
            decision = readLine()
        }
        
        if decision == "1" {
            (deck, playerPoints, dealerPoints, playerCards, dealerCards, holeCard) = gameInit(deck: &deck, newRound: true)
            gameEnd.toggle()
            continue
        }
        
        break
    }
}
