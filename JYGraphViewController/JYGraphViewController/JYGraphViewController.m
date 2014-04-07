//
//  JYGraphViewController.m
//  JYGraph
//
//  Created by John Yorke on 28/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYGraphViewController.h"
#import "JYGraphPoint.h"

NSUInteger const kDefaultGraphHeight = 320;
NSUInteger const gapBetweenBackgroundVerticalBars = 4;
float const percentageOfScreenHeightToUse = 0.8f;
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
    }
    return self;
}

#pragma mark - viewDid/Will

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set defaults colours if none are set
    if (!_graphStrokeColor) {
        _graphStrokeColor = [UIColor colorWithRed:0.71f green: 1.0f blue: 0.196f alpha: 1.0f];
    }
    if (!_graphFillColor) {
        _graphFillColor = [UIColor colorWithRed: 0.219f green: 0.657f blue: 0 alpha: 1.0f];
    }
    if (!self.graphWidth || self.graphWidth < [UIScreen mainScreen].bounds.size.height) {
        self.graphWidth = [UIScreen mainScreen].bounds.size.height * 2;
    }
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor blackColor];
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
    
    NSInteger xCoordOffset = (self.graphWidth / [_graphData count]) / 2;
    [_graphView setFrame:CGRectMake(0 - xCoordOffset, 0, self.graphWidth, kDefaultGraphHeight)];
    
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(self.graphWidth, kDefaultGraphHeight)];
    [_scrollView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height)];
    [_scrollView addSubview:_graphView];
    
    self.graphView.backgroundColor = [UIColor clearColor];
    self.scrollView.backgroundColor = self.backgroundColor;
    
    [self plotGraphData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self enableRotation];
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
        
        NSInteger xCoord = (self.graphWidth / [_graphData count]) * counter;
        
        CGPoint point = CGPointMake(xCoord,
                                    kDefaultGraphHeight - (([[_graphData objectAtIndex:counter - 1] integerValue] * ((kDefaultGraphHeight * percentageOfScreenHeightToUse) / range)) - (lowest * ((kDefaultGraphHeight * percentageOfScreenHeightToUse) / range ))));
        
        [self createBackgroundVerticalBarWithXCoord:point withXAxisLabelIndex:counter-1];
        
        [self createPointLabelForPoint:point withLabelText:[NSString stringWithFormat:@"%@",[_graphData objectAtIndex:counter - 1]]];
        
        // Check it's not the first item
        if (lastPoint.x != 0) {
            if (!self.hideLines) {
                [self drawLineBetweenPoint:lastPoint andPoint:point withColour:_graphStrokeColor];
            }
        }
        
        NSValue *pointValue = [[NSValue alloc] init];
        pointValue = [NSValue valueWithCGPoint:point];
        [pointsCenterLocations addObject:pointValue];
        lastPoint = point;
    }
    
    // Now draw all the points
    [self drawPointswithStrokeColour:_graphStrokeColor
                             andFill:_graphFillColor
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

- (void) createPointLabelForPoint:(CGPoint) point 
                    withLabelText:(NSString *) string
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x , point.y, 30, 20)];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    [tempLabel setTextColor:self.labelFontColor];
    [tempLabel setBackgroundColor:self.labelBackgroundColor];
    [tempLabel setFont:self.labelFont];
    [tempLabel setAdjustsFontSizeToFitWidth:YES];
    [tempLabel setMinimumScaleFactor:0.6];
    [_graphView addSubview:tempLabel];
    [tempLabel setCenter:CGPointMake(point.x, point.y + pointLabelOffsetFromPointCenter)];
    [tempLabel setText:string];
}

- (void) createBackgroundVerticalBarWithXCoord:(CGPoint)xCoord 
                           withXAxisLabelIndex:(NSInteger)indexNumber
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, (self.graphWidth / [_graphData count]) - gapBetweenBackgroundVerticalBars, kDefaultGraphHeight * 2)];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [label setTextColor:self.labelFontColor];
    [label setBackgroundColor:self.barColor];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setMinimumScaleFactor:0.6];
    [label setFont:self.labelFont];
    [label setNumberOfLines:2];
    
    if (self.graphXAxisLabels) {
        label.text = [NSString stringWithFormat:@"%@",[self.graphXAxisLabels objectAtIndex:indexNumber]];
    }
    
    [_graphView addSubview:label];
    
    [label setCenter:CGPointMake(xCoord.x,16)];
}

- (void) drawLineBetweenPoint:(CGPoint)origin 
                     andPoint:(CGPoint)destination 
                   withColour:(UIColor *)colour
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
    
    [_graphView.layer addSublayer:lineShape];
    
    lineShape = nil;
}

- (void) drawPointswithStrokeColour:(UIColor *)stroke 
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
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
