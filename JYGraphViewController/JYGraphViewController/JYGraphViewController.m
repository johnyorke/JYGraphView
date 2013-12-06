//
//  JYGraphViewController.m
//  JYGraph
//
//  Created by John Yorke on 28/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYGraphViewController.h"
#import "JYSimpleWeatherGraphPoint.h"

NSUInteger const graphWidth = 1136;
NSUInteger const graphHeight = 320;
NSUInteger const gapBetweenBackgroundVerticalBars = 4;
float const percentageOfScreenHeightToUse = 0.87;
NSInteger const pointLabelOffsetFromPointCenter = -24;

@interface JYGraphViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *graphView;

@end

@implementation JYGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view addSubview:_scrollView];
        [_scrollView setContentSize:CGSizeMake(graphWidth, graphHeight)];
        [_scrollView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height)];
        [_scrollView addSubview:_graphView];
    }
    return self;
}

#pragma mark - viewDid/Will

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self enableRotation];
}

- (void) viewWillAppear:(BOOL)animated
{
    // Set defaults colours if none are set
    if (!_graphStrokeColour) {
        _graphStrokeColour = [UIColor colorWithRed:0.71 green: 1 blue: 0.196 alpha: 1];
    }
    if (!_graphFillColour) {
        _graphFillColour = [UIColor colorWithRed: 0.219 green: 0.657 blue: 0 alpha: 1];
    }
    
    NSInteger xCoordOffset = (graphWidth / [_graphData count]) / 2;
    [_graphView setFrame:CGRectMake(0 - xCoordOffset, 0, graphWidth, graphHeight)];
    
    [self plotGraphData];
}

#pragma mark - Graph plotting

- (void) plotGraphData
{
    NSMutableArray *pointsCenterLocations = [[NSMutableArray alloc] init];
    
    NSDictionary *graphRange = [self workOutRangeFromArray:_graphData];
    NSInteger range = [[graphRange objectForKey:@"range"] integerValue];
    NSInteger lowest = [[graphRange objectForKey:@"lowest"] integerValue];
    
    CGPoint lastPoint = CGPointMake(0, 0);
    
    for (NSUInteger counter = 1; counter <= [_graphData count]; counter++) {
        
        NSInteger xCoord = (graphWidth / [_graphData count]) * counter;
        
        CGPoint point = CGPointMake(xCoord,
                                    graphHeight - (([[_graphData objectAtIndex:counter - 1] integerValue] * ((graphHeight * percentageOfScreenHeightToUse) / range)) - (lowest * ((graphHeight * percentageOfScreenHeightToUse) / range ))));
        
        [self createPointLabelForPoint:point withLabelText:[NSString stringWithFormat:@"%@",[_graphData objectAtIndex:counter - 1]]];
        
        [self createBackgroundVerticalBarWithXCoord:point];
        
        if (lastPoint.x != 0) {
            [self drawPointBetweenPoint:lastPoint andPoint:point withColour:_graphStrokeColour];
        }
        
        NSValue *pointValue = [[NSValue alloc] init];
        pointValue = [NSValue valueWithCGPoint:point];
        [pointsCenterLocations addObject:pointValue];
        lastPoint = point;
    }
    
    // Now draw all the points
    [self drawPointswithStrokeColour:_graphStrokeColour
                             andFill:_graphFillColour
                           fromArray:pointsCenterLocations];
}

- (NSDictionary *) workOutRangeFromArray: (NSArray *) array
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

- (void) createPointLabelForPoint: (CGPoint) point withLabelText: (NSString *) string
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x , point.y, 30, 20)];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    [tempLabel setTextColor:[UIColor whiteColor]];
    [tempLabel setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]];
    [tempLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:12]];
    [tempLabel setAdjustsFontSizeToFitWidth:YES];
    [tempLabel setMinimumScaleFactor:0.6];
    [_graphView addSubview:tempLabel];
    [tempLabel setCenter:CGPointMake(point.x, point.y + pointLabelOffsetFromPointCenter)];
    [tempLabel setText:string];
}

- (void) createBackgroundVerticalBarWithXCoord:(CGPoint)xCoord
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, (graphWidth / [_graphData count]) - gapBetweenBackgroundVerticalBars, graphHeight * 2)];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor colorWithRed:181 green:255 blue:50 alpha:0.07]];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setMinimumScaleFactor:0.6];
    [label setFont:[UIFont fontWithName:@"Futura-Medium" size:12]];
    
    [_graphView addSubview:label];
    
    [label setCenter:CGPointMake(xCoord.x,0)];
}

- (void) drawPointBetweenPoint:(CGPoint)origin andPoint:(CGPoint)destination withColour:(UIColor *)colour
{
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    
    lineShape.lineWidth = 2.5f;
    lineShape.lineCap = kCALineCapRound;;
    lineShape.lineJoin = kCALineJoinBevel;
    
    lineShape.strokeColor = [colour CGColor];
    
    NSInteger x = origin.x; NSInteger y = origin.y;
    NSInteger toX = destination.x; NSInteger toY = destination.y;                            
    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    
    lineShape.path = linePath;
    CGPathRelease(linePath);
    
    [_graphView.layer insertSublayer:lineShape atIndex:0];
    
    lineShape = nil;
}

- (void) drawPointswithStrokeColour:(UIColor *)stroke 
                            andFill:(UIColor *)fill 
                          fromArray:(NSMutableArray *)pointsArray
{
    NSMutableArray *pointCenterLocations = pointsArray;
    
    for (int i = 0; i < [pointCenterLocations count]; i++) {
        CGRect pointRect = CGRectMake(0, 0, 20, 20);
        
        JYSimpleWeatherGraphPoint *point = [[JYSimpleWeatherGraphPoint alloc] initWithFrame:pointRect];
        
        [point setStrokeColour:stroke];
        [point setFillColour:fill];
        
        [point setCenter:[[pointCenterLocations objectAtIndex:i] CGPointValue]];
        
        [point setBackgroundColor:[UIColor clearColor]];
        
        [_graphView addSubview:point];
    }
}

#pragma mark - Rotation methods

- (void) enableRotation
{
    // Start generating notifications for orientation change
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) 
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void) didRotate
{
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - Memory warning and status bar

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
