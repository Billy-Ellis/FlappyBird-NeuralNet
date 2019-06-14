//
//  NeuralNetwork.h
//  NeuralFlappyBird
//
//  Created by Billy Ellis on 13/11/2018.
//  Copyright © 2018 Billy Ellis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeuralNetwork : NSObject

{
    int number_input_nodes;
    int number_middle_nodes;
    int number_output_nodes;
    
    NSMutableArray *input_nodes;
    NSMutableArray *middle_nodes;
    NSMutableArray *output_nodes;
    
    NSMutableArray *layer_one_weights;
    NSMutableArray *layer_two_weights;
}

-(id)initWithLayer1:(int)l1 layer2:(int)l2 layer3:(int)l3;
-(void)updateInputNodes:(NSMutableArray*)inputs;
-(NSMutableArray*)getInputNodes;
-(NSMutableArray*)getMiddleNodes;
-(NSMutableArray*)getOutputNodes;
-(NSMutableArray*)getLayer1Weights;
-(NSMutableArray*)getLayer2Weights;
-(void)setLayer1Weights:(NSMutableArray*)weights;
-(void)setLayer2Weights:(NSMutableArray*)weights;
-(void)loadLayer1Weights:(NSMutableArray*)weights;
-(void)loadLayer2Weights:(NSMutableArray*)weights;
-(void)forwardPropogate;
-(void)deactivate;

@end

