//
//  ViewController.h
//  NeuralFlappyBird
//
//  Created by Billy Ellis on 12/11/2018.
//  Copyright © 2018 Billy Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeuralNetwork.h"
#import "Player.h"

@interface ViewController : UIViewController

{
    bool isLoadedBird;
    
    __weak IBOutlet UILabel *highscoreLabel;
    int highscore;
    
    __weak IBOutlet UILabel *generationLabel;
    int generationNumber;
    
    __weak IBOutlet UILabel *inputNodeLabel1;
    __weak IBOutlet UILabel *inputNodeLabel2;
    __weak IBOutlet UILabel *inputNodeLabel3;
    __weak IBOutlet UILabel *inputNodeLabel4;
    
    __weak IBOutlet UILabel *middleNodeLabel1;
    __weak IBOutlet UILabel *middleNodeLabel2;
    __weak IBOutlet UILabel *middleNodeLabel3;
    __weak IBOutlet UILabel *middleNodeLabel4;
    __weak IBOutlet UILabel *middleNodeLabel5;
    __weak IBOutlet UILabel *middleNodeLabel6;
    
    
    __weak IBOutlet UILabel *outputNodeLabel;
    
    
    IBOutlet UIButton *startButton;
    int numberOfBirdsToSpawn;
    IBOutlet UILabel *birdsToSpawnLabel;
    IBOutlet UISlider *birdsToSpawnSlider;
    
    
    IBOutlet UILabel *numberOfBirdsLabel;
    int numberOfBirds;
    
    float playerFlight;
    int score;
    
    NSTimer *pipeTimer;
    
    NSMutableArray *playerArray;
    int playerCount;
    int deadPlayers;
    
    IBOutlet UIView *gameView;
    IBOutlet UIView *floor;
    
    IBOutlet UILabel *scoreLabel;
    IBOutlet UIView *lowerPipe;
    IBOutlet UIView *upperPipe;
    
    NSMutableArray *bestLayer1Weights;
    NSMutableArray *bestLayer2Weights;
    
    NSMutableArray *loadedLayer1Weights;
    NSMutableArray *loadedLayer2Weights;
    
}


@end

