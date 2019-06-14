//
//  Player.m
//  NeuralFlappyBird
//
//  Created by Billy Ellis on 13/11/2018.
//  Copyright © 2018 Billy Ellis. All rights reserved.
//

#import "Player.h"

@implementation Player

-(UIView*)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.brain = [[NeuralNetwork alloc]initWithLayer1:4 layer2:6 layer3:1];
        
        playerFlight = 1;
        
        gravityTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(gravity) userInfo:nil repeats:YES];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        img.image = [UIImage imageNamed:@"bird.png"];
        [self addSubview:img];
    }
    return self;
}

-(void)updatePlayerBrainWithLayer1Weights:(NSMutableArray*)l1 layer2Weights:(NSMutableArray*)l2{
    
    [self.brain setLayer1Weights:l1];
    [self.brain setLayer2Weights:l2];
    
}

-(void)loadPlayerBrainWithLayer1Weights:(NSMutableArray*)l1 layer2Weights:(NSMutableArray*)l2{
    
    [self.brain loadLayer1Weights:l1];
    [self.brain loadLayer2Weights:l2];
}

-(void)gravity{
    
    // update inputs to the neural network
    NSMutableArray *inputs = [NSMutableArray arrayWithCapacity:4];
    inputs[0] = [NSNumber numberWithFloat:self.frame.origin.y / 834];
    inputs[1] = [NSNumber numberWithFloat:(upperPipe.origin.x+20) / 510];
    inputs[2] = [NSNumber numberWithFloat:upperPipe.size.height / 834];
    inputs[3] = [NSNumber numberWithFloat:lowerPipe.size.height / 834];
    
    [self.brain updateInputNodes:inputs];
    
    [self.brain forwardPropogate];
    
    if ([[[self.brain getOutputNodes]objectAtIndex:0]floatValue] > 0.5){
        [self jump];
    }

  //  NSLog(@"%@",[brain getOutputNodes]);
    
    [self.brain updateInputNodes:inputs];
    
    playerFlight = playerFlight + 0.2;
    [self setFrame:CGRectMake(40, self.frame.origin.y+playerFlight, 50, 50)];
   // NSLog(@"player is falling and playerFlight is %f",playerFlight);
    
    if (self.frame.origin.y < 0){
        [self die];
    }
    
}

-(void)jump{
    playerFlight = -5;
}

-(void)die{
    // fix the memory leak
    [self.brain deactivate];
    [gravityTimer invalidate];
    gravityTimer = nil;
    self.brain = nil;
    [self removeFromSuperview];
}

-(void)pipeInformationUpperPipe:(CGRect)upper lowerPipe:(CGRect)lower{
    upperPipe = upper;
    lowerPipe = lower;
}

-(NeuralNetwork*)viewBrain{
    return self.brain;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
