//
//  JYGraphView.m
//  JYGraphViewController
//
//  Created by John Yorke on 23/08/2014.
//  Copyright (c) 2014 John Yorke. All rights reserved.
//

#import "JYGraphView.h"
#import "JYGraphPoint.h"

NSUInteger const kGapBetweenBackgroundVerticalBars = 4;
NSInteger const kPointLabelOffsetFromPointCenter = 20;
NSInteger const kBarLabelHeight = 20;
NSInteger const kPointLabelHeight = 20;

@interface JYGraphView ()

@property (nonatomic, strong) UIView *graphView;

@end

#import "JYGraphView.h"

@implementation JYGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if ([self.graphData count] > 0 && newSuperview != nil) {
        [self plotGraphData];
    }
}

- (void)setDefaultValues
{
    // Set defaults values/options if none are set
    if (!_strokeColor) {
        _strokeColor = [UIColor colorWithRed:0.71f green: 1.0f blue: 0.196f alpha: 1.0f];
    }
    if (!_pointFillColor) {
        _pointFillColor = [UIColor colorWithRed: 0.219f green: 0.657f blue: 0 alpha: 1.0f];
    }
    if (!self.graphWidth) {
        self.graphWidth = self.frame.size.width * 2;
    }
    if (!self.backgroundViewColor) {
        self.backgroundViewColor = [UIColor blackColor];
    }
    if (!self.barColor) {
        self.barColor = [UIColor colorWithRed:0.05f green:0.05f blue:0.05f alpha:1.0f];
    }
    if (!self.labelFont) {
        self.labelFont = [UIFont fontWithName:@"Futura-Medium" size:12];
    }
    if (!self.labelFontColor) {
        self.labelFontColor = [UIColor whiteColor];
    }
    if (!self.labelBackgroundColor) {
        self.labelBackgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.5f];
    }
    if (!self.strokeWidth) {
        self.strokeWidth = 2;
    }
}

#pragma mark - Graph plotting

- (void)plotGraphData
{
    self.userInteractionEnabled = YES;
    [self setDefaultValues];
    
    self.graphView = [[UIView alloc] initWithFrame:self.frame];
    self.backgroundColor = self.backgroundViewColor;
    [self setContentSize:CGSizeMake(self.graphWidth, self.frame.size.height)];
    [self addSubview:_graphView];
    
    NSInteger xCoordOffset = (self.graphWidth / [_graphData count]) / 2;
    [_graphView setFrame:CGRectMake(0 - xCoordOffset, 0, self.graphWidth, self.frame.size.height)];
            
    NSMutableArray *pointsCenterLocations = [[NSMutableArray alloc] init];
    
    NSDictionary *graphRange = [self workOutRangeFromArray:_graphData];
    NSInteger range = [[graphRange objectForKey:@"range"] integerValue];
    NSInteger lowest = [[graphRange objectForKey:@"lowest"] integerValue];
    NSInteger highest = [[graphRange objectForKey:@"highest"] integerValue];
    
    // in case all numbers are zero or all the same value
    if (range == 0) {
        lowest = 0;
        if (highest == 0) highest = 10; //arbitary number in case all numbers are 0
        range = highest * 2;
    }
    
    CGPoint lastPoint = CGPointMake(0, 0);
    
    for (NSUInteger counter = 1; counter <= [_graphData count]; counter++) {
        
        NSInteger xCoord = (self.graphWidth / [_graphData count]) * counter;
        
        NSInteger offsets = kPointLabelHeight + kPointLabelOffsetFromPointCenter;
        if (_hideLabels == NO && _graphDataLabels != nil) {
            offsets += kBarLabelHeight;
        }
        
        NSInteger offSetFromTop = 10;
        NSInteger offsetFromBottom = 10;
        float screenHeight = (self.frame.size.height - (offsets)) / (self.frame.size.height + offSetFromTop + offsetFromBottom);
        
        CGPoint point = CGPointMake(xCoord,
                                    self.frame.size.height - (([[_graphData objectAtIndex:counter - 1] integerValue] * 
                                                               ((self.frame.size.height * screenHeight) / range)) - 
                                                              (lowest * ((self.frame.size.height * screenHeight) / range ))+
                                                              offsetFromBottom));
        
        [self createBackgroundVerticalBarWithXCoord:point withXAxisLabelIndex:counter-1];
        
        if (self.hideLabels == NO) {
            [self createPointLabelForPoint:point withLabelText:[NSString stringWithFormat:@"%@",[_graphData objectAtIndex:counter - 1]]];
        }
        
        if (self.useCurvedLine == NO) {
            // Check it's not the first item
            if (lastPoint.x != 0) {
                if (!self.hideLines) {
                    [self drawLineBetweenPoint:lastPoint andPoint:point withColour:_strokeColor];
                }
            }
        }
        
        NSValue *pointValue = [[NSValue alloc] init];
        pointValue = [NSValue valueWithCGPoint:point];
        [pointsCenterLocations addObject:pointValue];
        lastPoint = point;
    }
    
    if (self.useCurvedLine == YES && self.hideLines == NO) {
        [self drawCurvedLineBetweenPoints:pointsCenterLocations];
    }
    
    // Now draw all the points
    if (self.hidePoints == NO) {
        [self drawPointswithStrokeColour:_strokeColor
                                 andFill:_pointFillColor
                               fromArray:pointsCenterLocations];
    }
    
}

- (NSDictionary *)workOutRangeFromArray:(NSArray *)array
{
    array = [array sortedArrayUsingSelector:@selector(compare:)];
    
    float lowest = [[array objectAtIndex:0] floatValue];
    
    float highest = [[array objectAtIndex:[array count] - 1] floatValue];
    
    float range = highest - lowest;
    
    NSDictionary *graphRange = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithFloat:lowest], @"lowest",
                                [NSNumber numberWithFloat:highest], @"highest",
                                [NSNumber numberWithFloat:range], @"range", nil];
    
    return graphRange;
}

#pragma mark - Drawing methods

- (void)createPointLabelForPoint:(CGPoint)point
                   withLabelText:(NSString *)string
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x , point.y, 30, kPointLabelHeight)];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    [tempLabel setTextColor:self.labelFontColor];
    [tempLabel setBackgroundColor:self.labelBackgroundColor];
    [tempLabel setFont:self.labelFont];
    [tempLabel setAdjustsFontSizeToFitWidth:YES];
    [tempLabel setMinimumScaleFactor:0.6];
    [_graphView addSubview:tempLabel];
    [tempLabel setCenter:CGPointMake(point.x, point.y - kPointLabelOffsetFromPointCenter)];
    [tempLabel setText:string];
}

- (void)createBackgroundVerticalBarWithXCoord:(CGPoint)xCoord
                          withXAxisLabelIndex:(NSInteger)indexNumber
{
    CGFloat x = self.graphWidth % _graphData.count;
    
    // Update the frame size for graphData.count results that don't fit into graphWidth
    [self setContentSize:CGSizeMake(self.graphWidth - x, self.frame.size.height)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, (self.graphWidth / [_graphData count]) - kGapBetweenBackgroundVerticalBars, self.frame.size.height * 2)];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [label setTextColor:self.labelFontColor];
    [label setBackgroundColor:self.barColor];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setMinimumScaleFactor:0.6];
    [label setFont:self.labelFont];
    [label setNumberOfLines:2];
    
    if (self.graphDataLabels) {
        label.text = [NSString stringWithFormat:@"%@",[self.graphDataLabels objectAtIndex:indexNumber]];
    }
    
    [_graphView addSubview:label];
    
    [label setCenter:CGPointMake(xCoord.x,16)];
}

- (void)drawLineBetweenPoint:(CGPoint)origin
                    andPoint:(CGPoint)destination
                  withColour:(UIColor *)colour
{
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    
    lineShape.lineWidth = self.strokeWidth;
    lineShape.lineCap = kCALineCapRound;;
    lineShape.lineJoin = kCALineJoinBevel;
    
    lineShape.strokeColor = [colour CGColor];
    
    NSInteger x = origin.x; NSInteger y = origin.y;
    NSInteger toX = destination.x; NSInteger toY = destination.y;
    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    
    lineShape.path = linePath;
    CGPathRelease(linePath);
        
    [_graphView.layer addSublayer:lineShape];
    
    lineShape = nil;
}

- (void)drawCurvedLineBetweenPoints:(NSArray *)points
{
    float granularity = 100;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:points];
    
    [mutableArray insertObject:[points firstObject] atIndex:0];
    
    [mutableArray addObject:[points lastObject]];
    
    points = [NSArray arrayWithArray:mutableArray];
    
    [path moveToPoint:[self pointAtIndex:0 ofArray:points]];
    
    for (int index = 1; index < points.count - 2 ; index++) {
        
        CGPoint point0 = [self pointAtIndex:index - 1 ofArray:points];
        CGPoint point1 = [self pointAtIndex:index ofArray:points];
        CGPoint point2 = [self pointAtIndex:index + 1 ofArray:points];
        CGPoint point3 = [self pointAtIndex:index + 2 ofArray:points];
        
        for (int i = 1; i < granularity ; i++) {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi;
            pi.x = 0.5 * (2*point1.x+(point2.x-point0.x)*t + (2*point0.x-5*point1.x+4*point2.x-point3.x)*tt + (3*point1.x-point0.x-3*point2.x+point3.x)*ttt);
            pi.y = 0.5 * (2*point1.y+(point2.y-point0.y)*t + (2*point0.y-5*point1.y+4*point2.y-point3.y)*tt + (3*point1.y-point0.y-3*point2.y+point3.y)*ttt);
            
            if (pi.y > self.graphView.frame.size.height) {
                pi.y = self.graphView.frame.size.height;
            }
            else if (pi.y < 0){
                pi.y = 0;
            }
            
            if (pi.x > point0.x) {
                [path addLineToPoint:pi];
            }
        }
        
        [path addLineToPoint:point2];
    }
    
    [path addLineToPoint:[self pointAtIndex:[points count] - 1 ofArray:points]];
    
    CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
    
    shapeView.path = [path CGPath];
    
    shapeView.strokeColor = self.strokeColor.CGColor;
    shapeView.fillColor = [UIColor clearColor].CGColor;
    shapeView.lineWidth = self.strokeWidth;
    [shapeView setLineCap:kCALineCapRound];
        
    [self.graphView.layer addSublayer:shapeView];
}

- (CGPoint)pointAtIndex:(NSUInteger)index ofArray:(NSArray *)array
{
    NSValue *value = [array objectAtIndex:index];
    
    return [value CGPointValue];
}

- (void)drawPointswithStrokeColour:(UIColor *)stroke
                           andFill:(UIColor *)fill
                         fromArray:(NSMutableArray *)pointsArray
{
    NSMutableArray *pointCenterLocations = pointsArray;
    
    for (int i = 0; i < [pointCenterLocations count]; i++) {
        CGRect pointRect = CGRectMake(0, 0, 20, 20);
        
        JYGraphPoint *point = [[JYGraphPoint alloc] initWithFrame:pointRect];
        
        [point setStrokeColour:stroke];
        [point setFillColour:fill];
        
        [point setCenter:[[pointCenterLocations objectAtIndex:i] CGPointValue]];
        
        [point setBackgroundColor:[UIColor clearColor]];
        
        [_graphView addSubview:point];
    }
}

- (UIImage *)graphImage
{
    // These lines are to prevent cutting off of image
    // on watch. Related to scrollview frame vs content size
    CGRect scrollViewFrame = self.frame; // original frame to revert to
    self.frame = _graphView.frame;
    
    CGFloat scale = [self screenScale];
    
    if (scale > 1) {
        UIGraphicsBeginImageContextWithOptions(_graphView.frame.size, NO, scale);
    } else {
        UIGraphicsBeginImageContext(_graphView.frame.size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext: context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Now revert it
    self.frame = scrollViewFrame;
    
    return viewImage;
}

- (float) screenScale {
    if ([ [UIScreen mainScreen] respondsToSelector: @selector(scale)] == YES) {
        return [ [UIScreen mainScreen] scale];
    }
    return 1;
}

@end
