//
//  JYSimpleWeatherGraphPoint.m
//  SimpleWeather
//
//  Created by John Yorke on 04/06/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYGraphPoint.h"

@implementation JYGraphPoint

@synthesize strokeColour, fillColour;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* stroke = strokeColour;
    UIColor* fill = fillColour;
    
    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 2, 16, 16)];
    [fill setFill];
    [oval2Path fill];
    [stroke setStroke];
    oval2Path.lineWidth = 2.5;
    [oval2Path stroke];
}


@end
