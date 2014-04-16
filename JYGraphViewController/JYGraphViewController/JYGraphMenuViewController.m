//
//  JYGraphMenuViewController.m
//  JYGraph
//
//  Created by John Yorke on 28/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYGraphMenuViewController.h"
#import "JYGraphViewController.h"

@interface JYGraphMenuViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *fieldOne;
@property (weak, nonatomic) IBOutlet UITextField *fieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *fieldThree;
@property (weak, nonatomic) IBOutlet UITextField *fieldFour;
@property (weak, nonatomic) IBOutlet UITextField *fieldFive;
@property (weak, nonatomic) IBOutlet UITextField *fieldSix;
@property (weak, nonatomic) IBOutlet UITextField *fieldSeven;
@property (weak, nonatomic) IBOutlet UITextField *fieldEight;
@property (weak, nonatomic) IBOutlet UITextField *fieldNine;
@property (weak, nonatomic) IBOutlet UITextField *fieldTen;
@property (weak, nonatomic) IBOutlet UITextField *fieldEleven;
@property (weak, nonatomic) IBOutlet UITextField *fieldTwelve;
@property (weak, nonatomic) IBOutlet UITextField *fieldThirteen;
@property (weak, nonatomic) IBOutlet UITextField *fieldFourteen;
@property (weak, nonatomic) IBOutlet UITextField *fieldFifteen;
@property (weak, nonatomic) IBOutlet UITextField *fieldSixteen;
@property (weak, nonatomic) IBOutlet UITextField *fieldSeventeen;
@property (weak, nonatomic) IBOutlet UITextField *fieldEighteen;
@property (weak, nonatomic) IBOutlet UITextField *fieldNineteen;
@property (weak, nonatomic) IBOutlet UITextField *fieldTwenty;
@property (weak, nonatomic) IBOutlet UITextField *fieldTwentyOne;
@property (weak, nonatomic) IBOutlet UITextField *fieldTwentyTwo;
@property (weak, nonatomic) IBOutlet UITextField *fieldTwentyThree;
@property (weak, nonatomic) IBOutlet UITextField *fieldTwentyFour;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation JYGraphMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self enableRotation];
}

#pragma mark - Sample data

- (NSArray *)createArrayToPassToGraph
{
    // For test purposes only, set the values in the text fields
    // and pass them to the graph
    
    NSArray *arrayOfFields = @[self.fieldOne,self.fieldTwo,self.fieldThree,self.fieldFour,self.fieldFive,self.fieldSix,self.fieldSeven,self.fieldEight,self.fieldNine,self.fieldTen,self.fieldEleven,self.fieldTwelve,self.fieldThirteen,self.fieldFourteen,self.fieldFifteen,self.fieldSixteen,self.fieldSeventeen,self.fieldEighteen,self.fieldNineteen,self.fieldTwenty,self.fieldTwentyOne,self.fieldTwentyTwo,self.fieldTwentyThree,self.fieldTwentyFour];
    
    NSMutableArray *arrayToPass = [NSMutableArray new];
    
    long int xAxisCount = [self.textLabel.text integerValue];
    
    for (NSInteger x = 0; x < xAxisCount; x++) {
        UITextField *textField = [arrayOfFields objectAtIndex:x];
        NSRange range = [textField.text rangeOfString:@"."];
        if (range.location == NSNotFound) {
            NSNumber *num = [NSNumber numberWithInteger:[textField.text integerValue]];
            [arrayToPass addObject:num];
        } else {
            NSNumber *num = [NSNumber numberWithFloat:[textField.text floatValue]];
            [arrayToPass addObject:num];
        }
    }
    
    return [NSArray arrayWithArray:arrayToPass];
}

- (NSArray *)createXAxisLabelArray
{
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    NSInteger sliderValue = [self.textLabel.text integerValue];
    
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
    
    for (int x = 0; x <= sliderValue ; x++) {
        NSRange range = NSMakeRange(x, 1);
        NSString *letter = [[alphabet substringWithRange:range] uppercaseString];
        [mutableArray addObject:letter];
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

#pragma mark - Rotation methods (required)

- (void)didRotate
{
    [self setNeedsStatusBarAppearanceUpdate];
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        
        JYGraphViewController *graphView = [[JYGraphViewController alloc]
                                            initWithNibName:@"JYGraphViewController" bundle:nil];
        
        // Set the data for the graph
        // Send only an array of number values
        graphView.graphData = [self createArrayToPassToGraph];
        
        // Set the xAxis labels
        // Can send numbers or strings (it's printed using stringWithFormat:"%@")
        graphView.graphDataLabels = [self createXAxisLabelArray];
        
        // Customisation options
                graphView.graphFillColor = [UIColor colorWithRed: 0.286 green: 0 blue: 0.429 alpha: 1];
                graphView.graphStrokeColor = [UIColor colorWithRed: 0.59 green: 0 blue: 0.886 alpha: 1];
        //        graphView.hideLines = YES;
        //        graphView.graphWidth = 720;
        //        graphView.backgroundColor = [UIColor grayColor];
        //        graphView.barColor = [UIColor lightGrayColor];
        //        graphView.labelFont = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:12];
        //        graphView.labelFontColor = [UIColor whiteColor];
        //        graphView.labelBackgroundColor = [UIColor grayColor];
        
        if (![self.presentedViewController isBeingPresented]) {
            [self presentViewController:graphView animated:YES completion:nil];
        }
    }
}

- (void)enableRotation
{
    // Start generating notifications for orientation change
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)valueChanged:(id)sender 
{
    int value = roundl(self.slider.value);
    self.textLabel.text = [NSString stringWithFormat:@"%d",value];
}

#pragma mark - Label and notifications

- (void)keyboardUp:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + kbSize.height);
}

- (void)keyboardDown:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height - kbSize.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
