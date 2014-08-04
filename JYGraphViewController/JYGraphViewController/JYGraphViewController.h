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
@property (strong, nonatomic) NSArray *graphDataLabels;
@property (strong, nonatomic) UIColor *graphStrokeColor;
@property (strong, nonatomic) UIColor *graphFillColor;

@property NSUInteger graphStrokeWidth;
@property (assign) BOOL hideLines;
@property (assign) BOOL hidePoints;
@property (assign) BOOL useCurvedLine;
@property (assign) BOOL hideLabels;

@property (assign) NSUInteger graphWidth;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *barColor;
@property (strong, nonatomic) UIFont *labelFont;
@property (strong, nonatomic) UIColor *labelFontColor;
@property (strong, nonatomic) UIColor *labelBackgroundColor;

@end
