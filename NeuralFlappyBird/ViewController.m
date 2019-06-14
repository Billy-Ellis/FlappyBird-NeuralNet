//
//  ViewController.m
//  NeuralFlappyBird
//
//  Created by Billy Ellis on 12/11/2018.
//  Copyright © 2018 Billy Ellis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)loadBirdButtonPressed:(id)sender {
    
    // read back in the saved weights from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject1 = [defaults objectForKey:@"save_l1"];
    NSData *encodedObject2 = [defaults objectForKey:@"save_l2"];
    
    loadedLayer1Weights = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject1];
    loadedLayer2Weights = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject2];
    
    // set isLoadedBird to true/YES
    isLoadedBird = YES;
    // invalidate the pipe timer
    [pipeTimer invalidate];
    pipeTimer = nil;
    
    // call the restart method
    [self restart];
}

- (IBAction)startButtonPressed:(id)sender {
    
    // call the restart method to set up the scene and start the timer for the movement of the pipes
    [self restart];
    pipeTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(pipesMove) userInfo:nil repeats:YES];
}

- (IBAction)birdsToSpawnSliderChanged:(id)sender {
    
    // update the number of birds to spawn as well as the label displaying this information
    numberOfBirdsToSpawn = birdsToSpawnSlider.value * 1000;
    birdsToSpawnLabel.text = [NSString stringWithFormat:@"spawn %d birds per generation",numberOfBirdsToSpawn];
}

-(void)restart{
    
    // check if a bird is being loaded
    if (isLoadedBird == YES){
        
        // if so, remove all currently playing birds
        for (int i = 0; i < [playerArray count]; i++){
            [[playerArray objectAtIndex:i]die];
            [playerArray removeObjectAtIndex:i];
            deadPlayers++;
        }
        
        // set the number of birds to spawn to 1
        numberOfBirdsToSpawn = 1;
        
        highscoreLabel.text = [NSString stringWithFormat:@"Highscore: %d",highscore];
        generationLabel.text = [NSString stringWithFormat:@"Loaded bird!"];
        
        score = 0;
        scoreLabel.text = @"0";
        
        // set the playerFlight to 1 and playerCount to 0
        playerFlight = 1;
        playerCount = 0;
        
        // clear the current playerArray
        [playerArray removeAllObjects];
        playerArray = [[NSMutableArray alloc]init];
        
        // set the number of birds and number of dead birds to 0
        numberOfBirds = 0;
        deadPlayers = 0;
        
        numberOfBirds++;
        
        // create a single instance of a Player
        Player *p = [[Player alloc]initWithFrame:CGRectMake(40, 250, 50, 50)];
        p.backgroundColor = [UIColor clearColor];
        // load this bird with weights read back in from NSUserDefaults
        [p loadPlayerBrainWithLayer1Weights:loadedLayer1Weights layer2Weights:loadedLayer2Weights];
        [playerArray insertObject:p atIndex:0];
        // add the Player to the game view
        [gameView addSubview:p];
        // set the player count to 1
        playerCount = 1;
        
        // update the label showing the number of birds that will be spawned
        numberOfBirdsLabel.text = [NSString stringWithFormat:@"%d",numberOfBirds];
        [self spawnPipes];
        usleep(50000);
        
        pipeTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(pipesMove) userInfo:nil repeats:YES];
        
    }else{
    
        // if not, the birds need to be trained, so continue as normal
        highscoreLabel.text = [NSString stringWithFormat:@"Highscore: %d",highscore];
        
        // increment the generation number and the corresponding label
        generationNumber++;
        generationLabel.text = [NSString stringWithFormat:@"Generation: %d",generationNumber];
        
        // set the score and the score label to 0
        score = 0;
        scoreLabel.text = @"0";
        
        // set the playerFlight to 1 and playerCount to 0
        playerFlight = 1;
        playerCount = 0;
        
        // clear the current playerArray
        [playerArray removeAllObjects];
        playerArray = [[NSMutableArray alloc]init];
        
        // set the number of birds and number of dead birds to 0
        numberOfBirds = 0;
        deadPlayers = 0;
        
        // check if there exist any 'best' weights i.e. from a previous generation of birds
        if (!bestLayer1Weights && !bestLayer2Weights){
            // if not, generate players with random weights (first time)
            for (int i = 0; i < numberOfBirdsToSpawn; i++){
                numberOfBirds++;
                [self createPlayer];
            }
        }else{
            // if so, generate birds based on these existing weights
            for (int i = 0; i < numberOfBirdsToSpawn; i++){
                numberOfBirds++;
                [self createPlayerWithLayer1Weights:bestLayer1Weights layer2Weights:bestLayer2Weights];
            }
        }
        
        // update the label showing the number of birds that will be spawned
        numberOfBirdsLabel.text = [NSString stringWithFormat:@"%d",numberOfBirds];
        [self spawnPipes];
        
        // this prevents what i assume was a race condition, causing the next round of the game to not work
        usleep(50000);
    
    }
}

-(void)fallBirds{
    
    // update the position of the birds, making them fall by gravity
    for (int i = 0; i < [playerArray count]; i++){
        [playerArray[i] setFrame:CGRectMake(40, [playerArray[i] frame].origin.y+playerFlight, 50, 50)];
    }
    playerFlight = playerFlight + 0.2;
}

-(void)createPlayerWithLayer1Weights:(NSMutableArray*)l1weights layer2Weights:(NSMutableArray*)l2weights{
    
    // create a new instance of a player
    Player *p = [[Player alloc]initWithFrame:CGRectMake(40, 250, 50, 50)];
    //set the background color to clearColor so that we can use an image
    p.backgroundColor = [UIColor clearColor];
    
    // initialise the birds' brain with existing weights
    [p updatePlayerBrainWithLayer1Weights:l1weights layer2Weights:l2weights];
    // insert the new player into the player array
    [playerArray insertObject:p atIndex:playerCount];
    // add the player to the game view
    [gameView addSubview:p];
    // increment the player count
    playerCount++;
}

-(void)createPlayer{
    
    // create a new instance of a player
    Player *p = [[Player alloc]initWithFrame:CGRectMake(40, 250, 50, 50)];
    
    // set the background color to clearColor so that we can use an image
    p.backgroundColor = [UIColor clearColor];
    
    // add the player to the game view
    [gameView addSubview:p];
    // insert the new player into the player array
    [playerArray insertObject:p atIndex:playerCount];
    // increment the player count
    playerCount++;
}

-(void)spawnPipes{
    
    // generate upper and lower pipes with random heights
    int upperPipeLength = arc4random() % 635;
    int lowerPipeLength = 834 - upperPipeLength - 150;
    
    // set the frames on the pipe objects
    upperPipe.frame = CGRectMake(520, 0, 70, upperPipeLength);
    lowerPipe.frame = CGRectMake(520, gameView.frame.size.height-lowerPipeLength, 70, lowerPipeLength);
    
}

-(void)pipesMove{
    
    // update all of the labels representing the nodes in the neural network with the values of the nodes
    inputNodeLabel1.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getInputNodes]objectAtIndex:0]floatValue]];
    inputNodeLabel2.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getInputNodes]objectAtIndex:1]floatValue]];
    inputNodeLabel3.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getInputNodes]objectAtIndex:2]floatValue]];
    inputNodeLabel4.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getInputNodes]objectAtIndex:3]floatValue]];
    
    middleNodeLabel1.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getMiddleNodes]objectAtIndex:0]floatValue]];
    middleNodeLabel2.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getMiddleNodes]objectAtIndex:1]floatValue]];
    middleNodeLabel3.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getMiddleNodes]objectAtIndex:2]floatValue]];
    middleNodeLabel4.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getMiddleNodes]objectAtIndex:3]floatValue]];
    middleNodeLabel5.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getMiddleNodes]objectAtIndex:4]floatValue]];
    middleNodeLabel6.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getMiddleNodes]objectAtIndex:5]floatValue]];
    
    outputNodeLabel.text = [NSString stringWithFormat:@"%f",[[[[[playerArray objectAtIndex:0]viewBrain]getOutputNodes]objectAtIndex:0]floatValue]];
    
    upperPipe.center = CGPointMake(upperPipe.center.x - 1, upperPipe.center.y);
    lowerPipe.center = CGPointMake(lowerPipe.center.x - 1, lowerPipe.center.y);
    
    // iterate through all of the players
    for (int i = 0; i < [playerArray count]; i++){
        
        Player *p = [playerArray objectAtIndex:i];
        
        // constantly be saving the 'best' weights
        bestLayer1Weights = [p.brain getLayer1Weights];
        bestLayer2Weights = [p.brain getLayer2Weights];
        // update the inputs to the birds' brain (neural network)
        [p pipeInformationUpperPipe:upperPipe.frame lowerPipe:lowerPipe.frame];
        
        // check if the player view intersects with the upper or lower pipe or the top or bottom of the game view
        if (CGRectIntersectsRect(p.frame, upperPipe.frame) || CGRectIntersectsRect(p.frame, lowerPipe.frame) || CGRectIntersectsRect(p.frame, floor.frame) || p.frame.origin.y < 0){
            
            // kill the player and remove it from the player array
            [[playerArray objectAtIndex:i]die];
            [playerArray removeObjectAtIndex:i];
            // increment the number of dead players
            deadPlayers++;
            // update the label displaying how many players are currently alive
            numberOfBirdsLabel.text = [NSString stringWithFormat:@"%d",numberOfBirds-deadPlayers];
            
            // when all players are dead, restart
            if (!(numberOfBirds - deadPlayers)){
            
                // if this isn't a loaded bird...
                if (isLoadedBird == NO){
                    NSLog(@"Saving bird...");
                    // save the current smartest bird to NSUserDefaults
                    NSData *save_l1 = [NSKeyedArchiver archivedDataWithRootObject:bestLayer1Weights];
                    NSData *save_l2 = [NSKeyedArchiver archivedDataWithRootObject:bestLayer2Weights];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:save_l1 forKey:@"save_l1"];
                    [defaults setObject:save_l2 forKey:@"save_l2"];
                    
                    [defaults synchronize];
                    
                }
                //before restarting, check if the highscore was beaten, and if so, set the current score as the new highscore
                if (score > highscore){
                    highscore = score;
                }
                [self restart];
            }
        }
    }
    
    // when the bird passes through the pipe, increment the score and update the score label
    if (upperPipe.center.x == 50){
        score++;
        scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    }
    // when the pipe goes off the screen, respawn the pipes
    if (upperPipe.center.x < -20){
        [self spawnPipes];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the default values of the labels on the game view
    scoreLabel.text = @"0";
    numberOfBirdsLabel.text = @"100";
    
    // set the highscore and generation number to 0
    generationNumber = 0;
    highscore = 0;
    
    // set isLoadedBird to NO by default
    isLoadedBird = NO;
}

@end
