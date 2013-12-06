//
//  JYGraphViewController.h
//  JYGraph
//
//  Created by John Yorke on 28/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYGraphViewController : UIViewController

@property (strong, nonatomic) NSArray *graphData;
@property (strong, nonatomic) UIColor *graphStrokeColour;
@property (strong, nonatomic) UIColor *graphFillColour;

@end
