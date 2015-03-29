//
//  JYGraphView.h
//  JYGraphViewController
//
//  Created by John Yorke on 23/08/2014.
//  Copyright (c) 2014 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYGraphView : UIScrollView

// Array of NSNumbers used to plot points on graph
@property (strong, nonatomic) NSArray *graphData;

// Labels to match graphData points
@property (strong, nonatomic) NSArray *graphDataLabels;

// Colour of the graph line
@property (strong, nonatomic) UIColor *strokeColor;

// Fill colour for the point on the graph
@property (strong, nonatomic) UIColor *pointFillColor;

// Width of the stroke of the graph line
@property NSUInteger strokeWidth;

// Choose whether to hide the graph line and just show points
// defaults to NO
@property (assign) BOOL hideLines;

// Choose whether to hide the points and just show line
// defaults to NO
@property (assign) BOOL hidePoints;

// Choose to show curved line that passes through all points
// defaults to NO (straight lines between points)
@property (assign) BOOL useCurvedLine;

// Choose whether to hide the labels floating above the points
@property (assign) BOOL hideLabels;

// Choose how wide in pts the graph should be
// defaults to width of screen (landscape) x2
@property (assign) NSUInteger graphWidth;

// Background colour for the scrollView
@property (strong, nonatomic) UIColor *backgroundViewColor;

// Colour of the vertical bar that defines each x axis values
@property (strong, nonatomic) UIColor *barColor;

// Font to use on the x and y axis labels
@property (strong, nonatomic) UIFont *labelFont;

// Font colour of the x and y axis labels
@property (strong, nonatomic) UIColor *labelFontColor;

// Colour of the background for the x and y axis UILabels
@property (strong, nonatomic) UIColor *labelBackgroundColor;

- (void)plotGraphData;

- (UIImage *)graphImage;

@end
