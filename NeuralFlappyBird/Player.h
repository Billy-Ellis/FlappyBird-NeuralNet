//
//  Player.h
//  NeuralFlappyBird
//
//  Created by Billy Ellis on 13/11/2018.
//  Copyright © 2018 Billy Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeuralNetwork.h"
#import "ViewController.h"

@interface Player : UIView

{
    float playerFlight;
    // pipe information
    CGRect upperPipe;
    CGRect lowerPipe;
    
    NSTimer *gravityTimer;
}

@property (nonatomic) int fitness;
@property (nonatomic) NeuralNetwork *brain;

-(void)jump;
-(void)die;
-(NeuralNetwork*)viewBrain;
-(void)updatePlayerBrainWithLayer1Weights:(NSMutableArray*)l1 layer2Weights:(NSMutableArray*)l2;
-(void)loadPlayerBrainWithLayer1Weights:(NSMutableArray*)l1 layer2Weights:(NSMutableArray*)l2;
-(void)pipeInformationUpperPipe:(CGRect)upper lowerPipe:(CGRect)lower;

@end

