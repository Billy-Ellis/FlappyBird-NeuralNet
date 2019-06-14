//
//  GameView.h
//  NeuralFlappyBird
//
//  Created by Billy Ellis on 13/11/2018.
//  Copyright © 2018 Billy Ellis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameView : UIView

{
    IBOutlet UIView *player;
    IBOutlet UIView *upper;
    IBOutlet UIView *lower;
    IBOutlet UIView *floor;
    IBOutlet UILabel *score;
}

@end

