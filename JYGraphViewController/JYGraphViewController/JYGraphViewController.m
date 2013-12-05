//
//  JYGraphViewController.m
//  JYGraph
//
//  Created by John Yorke on 28/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYGraphViewController.h"
#import "JYSimpleWeatherGraphPoint.h"

@interface JYGraphViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *graphView;

@property (strong, nonatomic) NSArray *graphData;

@end

@implementation JYGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view addSubview:_scrollView];
        [self.view addSubview:_graphView];
        
        NSNumber *one = @10;
        NSNumber *two = @12;
        NSNumber *three = @14;
        NSNumber *four = @12;
        NSNumber *five = @20;
        NSNumber *six = @22;
        NSNumber *seven = @6;
        NSNumber *eight = @9;
        
        _graphData = @[one,two,three,four,five,six,seven,eight];
        
        [self plotGraphData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_scrollView setContentSize:CGSizeMake(1136, 320)];
    
    [_scrollView setScrollEnabled:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self enableRotation];
}

- (void) viewWillAppear:(BOOL)animated
{    
    [_graphView setFrame:CGRectMake(self.view.bounds.origin.x, _graphView.bounds.origin.y, 1140, self.view.frame.size.height)];
    
    [_scrollView setFrame:CGRectMake(self.view.bounds.origin.x, _graphView.bounds.origin.y, self.view.bounds.size.width, self.view.frame.size.height)];
        
    [_scrollView addSubview:_graphView];
}

- (void) plotGraphData
{
//    NSMutableArray *temperatures = [[NSMutableArray alloc] init];
//    NSMutableArray *timesArray = [[NSMutableArray alloc] init];
    NSMutableArray *pointsCenterLocations = [[NSMutableArray alloc] init];
        
//    for (counter = 0; counter < [_graphData count]; counter++) {
//        
//        NSNumber *tempNumber = [_graphData objectAtIndex:counter];
//        
//        [temperatures addObject:[NSNumber numberWithInt:tempInt]];
//        
//        NSString *timeString = [tempDic objectForKey:@"time"];
//        
//        [timesArray addObject:timeString];
//    }
    
    NSArray *arrayToOrder = [NSArray arrayWithArray:_graphData];
    
    NSDictionary *graphRange = [self workOutRangeFromArray:arrayToOrder];
    
    NSInteger range = [[graphRange objectForKey:@"range"] integerValue];
    
    NSInteger lowest = [[graphRange objectForKey:@"lowest"] integerValue];
    
    CGPoint lastPoint = CGPointMake(0, 0);
    
    for (NSUInteger counter = 1; counter <= [_graphData count]; counter++) {
        
        CGPoint point = CGPointMake(((_graphView.frame.size.width / 12) * counter) - 22, 
                                    _graphView.frame.size.height - (([[_graphData objectAtIndex:counter - 1] integerValue] * (_graphView.frame.size.height / (range * 2.5))) - (lowest * (_graphView.frame.size.height / (range * 2.5)))) - 130);
        
        UIColor *tempoGreen = [UIColor colorWithRed: 0.71 green: 1 blue: 0.196 alpha: 1];
        
        if (lastPoint.x != 0) {
            [self drawPointBetweenPoint:lastPoint andPoint:point withColour:tempoGreen];
        }
        
        NSValue *pointValue = [[NSValue alloc] init];
        
        pointValue = [NSValue valueWithCGPoint:point];
        
        [pointsCenterLocations addObject:pointValue];
        
        lastPoint = point;
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x , point.y, 30, 20)];
        
        tempLabel.textAlignment = NSTextAlignmentCenter;
        
        [tempLabel setTextColor:[UIColor whiteColor]];
        
        [tempLabel setBackgroundColor:[UIColor colorWithRed:181 green:255 blue:50 alpha:0.1]];
        
        [tempLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:12]];
        
        [tempLabel setAdjustsFontSizeToFitWidth:YES];
        
        [tempLabel setMinimumScaleFactor:0.6];
        
        [_graphView addSubview:tempLabel];
        
        [tempLabel setCenter:CGPointMake(point.x, point.y - 20)];
        
        [tempLabel setText:[NSString stringWithFormat:@" %d\u00B0",[[_graphData objectAtIndex:counter - 1] intValue]]];
        
        //[self createDateLabelWithXCoord:point andTime:[timesArray objectAtIndex:counter - 1]];
    }
    
    UIColor* stroke = [UIColor colorWithRed: 0.71 green: 1 blue: 0.196 alpha: 1];
    UIColor* fill = [UIColor colorWithRed: 0.219 green: 0.657 blue: 0 alpha: 1];
    
    // Draw all the point
    [self drawPointswithStrokeColour:stroke 
                             andFill:fill
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
        
        JYSimpleWeatherGraphPoint *point = [[JYSimpleWeatherGraphPoint alloc] initWithFrame:pointRect];
        
        [point setStrokeColour:stroke];
        [point setFillColour:fill];
        
        [point setCenter:[[pointCenterLocations objectAtIndex:i] CGPointValue]];
        
        [point setBackgroundColor:[UIColor clearColor]];
        
        [_graphView addSubview:point];
    }
}

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
