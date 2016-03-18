//
//  GameScene.swift
//  WhackABlock
//
//  Created by Greg Willis on 3/16/16.
//  Copyright (c) 2016 Willis Programming. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var squares = [SKSpriteNode]()
    var greenColor = UIColor.greenColor()
    var redColor = UIColor.redColor()
    var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    var grayColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    
    var mainLabel: UILabel!
    var scoreLabel: SKLabelNode!
    
    var score = 0
    var timer = 32
    var waitTimer = 0.8
    var pauseTimer = 0.7
    var isAlive = true
    var squareSize = 120
    var offset: CGFloat = 70
    
    override func didMoveToView(view: SKView) {
        backgroundColor = grayColor
        mainLabel = spawnMainLabel()
        scoreLabel = spawnScoreLabel()
        spawnSquares()
        countDownTimer()
        squareSpawnTimer()
        increaseSpeed()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            if let touchedNode = nodeAtPoint(location) as? SKSpriteNode {
                if touchedNode.color.description == greenColor.description {
                    touchedNode.color = greenColor
                    addToScore()
                } else {
                    gameOver()
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
}

// MARK: - Spawn Functions
extension GameScene {
    
    func spawnMainLabel() -> UILabel {
        mainLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: view!.frame.height * 0.4))
        if let mainLabel = mainLabel {
            let mainLabelString = "Choose the GREEN Square"
            let stringToColor = "GREEN"
            let range = (mainLabelString as NSString).rangeOfString(stringToColor)
            let attributedString = NSMutableAttributedString(string: mainLabelString)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: range)
            mainLabel.textColor = offWhiteColor
            mainLabel.font = UIFont(name: "Futura", size: CGRectGetWidth(frame) * 0.14)
            mainLabel.textAlignment = .Center
            mainLabel.numberOfLines = 0
            mainLabel.text = "\(mainLabelString)"
            view!.addSubview(mainLabel)
        }
        return mainLabel
    }
    
    func spawnScoreLabel() -> SKLabelNode {
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.fontColor = offWhiteColor
        scoreLabel.fontSize = CGRectGetWidth(frame) * 0.15
        scoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame) * 0.2)
        scoreLabel.text = "Score: \(score)"
        
        addChild(scoreLabel)
        
        
        return scoreLabel
    }
    
    func spawnSquares() {
        squares.append(createSquare(redColor, size: squareSize, position: CGPoint(x: CGRectGetMidX(frame) - offset, y: CGRectGetMidY(frame) + offset)))
        squares.append(createSquare(redColor, size: squareSize, position: CGPoint(x: CGRectGetMidX(frame) + offset, y: CGRectGetMidY(frame) + offset)))
        squares.append(createSquare(redColor, size: squareSize, position: CGPoint(x: CGRectGetMidX(frame) - offset, y: CGRectGetMidY(frame) - offset)))
        squares.append(createSquare(redColor, size: squareSize, position: CGPoint(x: CGRectGetMidX(frame) + offset, y: CGRectGetMidY(frame) - offset)))
    }

    
}


// MARK: - Timer functions
extension GameScene {
    
    func squareSpawnTimer() {
        if isAlive {
            let sequenceTimer = waitTimer + pauseTimer
            let wait = SKAction.waitForDuration(sequenceTimer)
            let spawn = SKAction.runBlock {
                self.randomSquareColor()
            }
            let sequence = SKAction.sequence([wait, spawn])
            runAction(SKAction.repeatActionForever(sequence))
        }
    }
    
    func countDownTimer() {
        let wait = SKAction.waitForDuration(1.0)
        let countDown = SKAction.runBlock {
            self.timer--
            
            if self.timer <= 30 && self.timer > 0 {
                self.mainLabel.text = "\(self.timer)"
            }
            
            if self.timer < 0 {
                self.gameOver()
            }
        }
        let sequence = SKAction.sequence([wait, countDown])
        runAction(SKAction.repeatActionForever(sequence))
    }
    
    
}

// MARK: - Helper Functions
extension GameScene {
    
    func createSquare(color: UIColor, size: Int, position: CGPoint) -> SKSpriteNode {
        let square = SKSpriteNode(color: color, size: CGSize(width: size, height: size))
        square.position = position
        
        addChild(square)
        
        return square
    }
    
    func addToScore() {
        score++
        scoreLabel.text = "Score: \(score)"
    }
    
    func gameOver() {
        isAlive = false
        timer = 0
        scoreLabel.removeFromParent()
        mainLabel.text = "Game Over"
        
        let wait = SKAction.waitForDuration(2.0)
        let transition = SKAction.runBlock {
            self.mainLabel.removeFromSuperview()
            if let gameScene = GameScene(fileNamed: "GameScene"), view = self.view {
                gameScene.scaleMode = .ResizeFill
                view.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(0.5))
            }
        }
        runAction(SKAction.sequence([wait, transition]))
    }
    
    
    func randomSquareColor() {
        let colorSelector = Int(arc4random_uniform(4))
        let wait = SKAction.waitForDuration(waitTimer)
        let pause = SKAction.waitForDuration(pauseTimer)
        let changeColorGreen = SKAction.runBlock {
            self.squares[colorSelector].color = self.greenColor
        }
        let changeColorRed = SKAction.runBlock {
            self.squares[colorSelector].color = self.redColor
        }
        let sequence = SKAction.sequence([wait, changeColorGreen, pause, changeColorRed])
        runAction(sequence)
    }
    
    func increaseSpeed() {
        let wait = SKAction.waitForDuration(5.0)
        let speedUp = SKAction.runBlock {
            self.waitTimer = self.waitTimer - 0.1
            self.pauseTimer = self.pauseTimer - 0.1
        }
        let sequence = SKAction.sequence([wait, speedUp])
        runAction(SKAction.repeatActionForever(sequence))
    }
    
    
}


