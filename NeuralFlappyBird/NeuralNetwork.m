//
//  NeuralNetwork.m
//  NeuralFlappyBird
//
//  Created by Billy Ellis on 13/11/2018.
//  Copyright © 2018 Billy Ellis. All rights reserved.
//

#import "NeuralNetwork.h"

@implementation NeuralNetwork

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:layer_one_weights forKey:@"layer_one_weights"];
    [encoder encodeObject:layer_two_weights forKey:@"layer_two_weights"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        layer_one_weights = [decoder decodeObjectForKey:@"layer_one_weights"];
        layer_two_weights = [decoder decodeObjectForKey:@"layer_two_weights"];
    }
    return self;
}

-(void)deactivate{
    input_nodes = nil;
    middle_nodes = nil;
    output_nodes = nil;
    layer_one_weights = nil;
    layer_two_weights = nil;
}

-(void)loadLayer1Weights:(NSMutableArray*)weights{
    [layer_one_weights removeAllObjects];
    
    for (int i = 0; i < (number_input_nodes*number_middle_nodes); i++){
        [layer_one_weights insertObject:[weights objectAtIndex:i] atIndex:i];
    }
}

-(void)loadLayer2Weights:(NSMutableArray*)weights{
    [layer_two_weights removeAllObjects];
    
    for (int i = 0; i < (number_middle_nodes*number_output_nodes); i++){
        [layer_two_weights insertObject:[weights objectAtIndex:i] atIndex:i];
    }
}

-(void)setLayer1Weights:(NSMutableArray*)weights{
    [layer_one_weights removeAllObjects];
    
    for (int i = 0; i < (number_input_nodes*number_middle_nodes); i++){
        int rand = arc4random() % 600;
        if (rand == 1){
            float r = arc4random() % 20;
            float weight = (float)((r / 10)- 1);
            [layer_one_weights insertObject:[NSNumber numberWithFloat:weight] atIndex:i];
        }else{
            [layer_one_weights insertObject:[weights objectAtIndex:i] atIndex:i];
        }
    }
}

-(void)setLayer2Weights:(NSMutableArray*)weights{
    [layer_two_weights removeAllObjects];
    
    for (int i = 0; i < (number_middle_nodes*number_output_nodes); i++){
        int rand = arc4random() % 600;
        if (rand == 1){
            float r = arc4random() % 20;
            float weight = (float)((r / 10)- 1);
            [layer_two_weights insertObject:[NSNumber numberWithFloat:weight] atIndex:i];
        }else{
            [layer_two_weights insertObject:[weights objectAtIndex:i] atIndex:i];
        }
    }
}

-(id)initWithLayer1:(int)l1 layer2:(int)l2 layer3:(int)l3{
    self = [super init];
    
    if (self){
        number_input_nodes = l1;
        number_middle_nodes = l2;
        number_output_nodes = l3;
        
        input_nodes = [NSMutableArray arrayWithCapacity:number_input_nodes];
        middle_nodes = [NSMutableArray arrayWithCapacity:number_middle_nodes];
        output_nodes = [NSMutableArray arrayWithCapacity:number_output_nodes];
        
        layer_one_weights = [NSMutableArray arrayWithCapacity:number_input_nodes*number_middle_nodes];
        layer_two_weights = [NSMutableArray arrayWithCapacity:number_middle_nodes*number_output_nodes];
        
        // layer one-two weights
        for (int i = 0; i < (number_input_nodes*number_middle_nodes); i++){
            float r = arc4random() % 20;
            float weight = (float)((r / 10)- 1);
            [layer_one_weights insertObject:[NSNumber numberWithFloat:weight] atIndex:i];
        }
        // layer two-three weights
        for (int i = 0; i < (number_middle_nodes*number_output_nodes); i++){
            float r = arc4random() % 20;
            float weight = (float)((r / 10)- 1);
            [layer_two_weights insertObject:[NSNumber numberWithFloat:weight] atIndex:i];
        }
    }
    return self;
}

-(void)forwardPropogate{
    [self calculateMiddleLayer];
    [self activateMiddleLayer];
    [self calculateOutputLayer];
    [self activateOutputLayer];
}

-(void)calculateMiddleLayer{
    // set middle nodes back to 0
    for (int i = 0; i < number_middle_nodes; i++){
        [middle_nodes insertObject:[NSNumber numberWithFloat:0] atIndex:i];
    }
    // multiply weights & nodes
    int c = 0;
    for (int a = 0; a < number_middle_nodes; a++){
        for (int b = 0; b < number_input_nodes; b++){
            [middle_nodes insertObject:[NSNumber numberWithFloat:[[middle_nodes objectAtIndex:a]floatValue] + ([[input_nodes objectAtIndex:b]floatValue] * [[layer_one_weights objectAtIndex:c]floatValue])] atIndex:a];
            c++;
        }
    }
}

-(void)calculateOutputLayer{
    // set output nodes back to 0
    for (int i = 0; i < number_output_nodes; i++){
        [output_nodes insertObject:[NSNumber numberWithFloat:0] atIndex:i];
    }
    // multiply weights & nodes
    int c = 0;
    for (int a = 0; a < number_output_nodes; a++){
        for (int b = 0; b < number_middle_nodes; b++){
            [output_nodes insertObject:[NSNumber numberWithFloat:[[output_nodes objectAtIndex:a]floatValue] + ([[middle_nodes objectAtIndex:b]floatValue] * [[layer_two_weights objectAtIndex:c]floatValue])] atIndex:a];
            c++;
        }
    }
}

-(void)activateMiddleLayer{
    for (int i = 0; i < number_middle_nodes; i++){
        [middle_nodes replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:[self sigmoid:[[middle_nodes objectAtIndex:i]floatValue]]]];
    }
}

-(void)activateOutputLayer{
    for (int i = 0; i < number_output_nodes; i++){
        [output_nodes replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:[self sigmoid:[[output_nodes objectAtIndex:i]floatValue]]]];
    }
}


-(void)updateInputNodes:(NSMutableArray*)inputs{
    for (int i = 0; i < [inputs count]; i++){
        [input_nodes insertObject:[inputs objectAtIndex:i] atIndex:i];
    }
}

-(NSMutableArray*)getInputNodes{
    return input_nodes;
}

-(NSMutableArray*)getMiddleNodes{
    return middle_nodes;
}

-(NSMutableArray*)getOutputNodes{
    return output_nodes;
}

-(NSMutableArray*)getLayer1Weights{
    return layer_one_weights;
}

-(NSMutableArray*)getLayer2Weights{
    return layer_two_weights;
}

-(float)sigmoid:(float)x{
    float exp_value;
    float return_value;
    
    exp_value = exp((double) -x);
    return_value = 1 / (1 + exp_value);
    
    return return_value;
}

@end
