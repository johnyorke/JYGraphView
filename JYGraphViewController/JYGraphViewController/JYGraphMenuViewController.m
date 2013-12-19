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
    [_slider addTarget:self action:@selector(updateLabel) forControlEvents:UIControlEventValueChanged];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self enableRotation];
}

#pragma mark - Sample data

- (NSArray *) createArrayToPassToGraph
{
    // For test purposes only, set the values in the text fields 
    // and pass them to the graph
    
    NSNumber *one = [NSNumber numberWithInteger:[_fieldOne.text integerValue]];
    NSNumber *two = [NSNumber numberWithInteger:[_fieldTwo.text integerValue]];
    NSNumber *three = [NSNumber numberWithInteger:[_fieldThree.text integerValue]];
    NSNumber *four = [NSNumber numberWithInteger:[_fieldFour.text integerValue]];
    NSNumber *five = [NSNumber numberWithInteger:[_fieldFive.text integerValue]];
    NSNumber *six = [NSNumber numberWithInteger:[_fieldSix.text integerValue]];
    NSNumber *seven = [NSNumber numberWithInteger:[_fieldSeven.text integerValue]];
    NSNumber *eight = [NSNumber numberWithInteger:[_fieldEight.text integerValue]];
    NSNumber *nine = [NSNumber numberWithInteger:[_fieldNine.text integerValue]];
    NSNumber *ten = [NSNumber numberWithInteger:[_fieldTen.text integerValue]];
    NSNumber *eleven = [NSNumber numberWithInteger:[_fieldEleven.text integerValue]];
    NSNumber *twelve = [NSNumber numberWithInteger:[_fieldTwelve.text integerValue]];
    NSNumber *thirteen = [NSNumber numberWithInteger:[_fieldThirteen.text integerValue]];
    NSNumber *fourteen = [NSNumber numberWithInteger:[_fieldFourteen.text integerValue]];
    NSNumber *fifteen = [NSNumber numberWithInteger:[_fieldFifteen.text integerValue]];
    NSNumber *sixteen = [NSNumber numberWithInteger:[_fieldSixteen.text integerValue]];
    NSNumber *seventeen = [NSNumber numberWithInteger:[_fieldSeventeen.text integerValue]];
    NSNumber *eighteen = [NSNumber numberWithInteger:[_fieldEighteen.text integerValue]];
    NSNumber *nineteen = [NSNumber numberWithInteger:[_fieldNineteen.text integerValue]];
    NSNumber *twenty = [NSNumber numberWithInteger:[_fieldTwenty.text integerValue]];
    NSNumber *twentyOne = [NSNumber numberWithInteger:[_fieldTwentyOne.text integerValue]];
    NSNumber *twentyTwo = [NSNumber numberWithInteger:[_fieldTwentyTwo.text integerValue]];
    NSNumber *twentyThree = [NSNumber numberWithInteger:[_fieldTwentyThree.text integerValue]];
    NSNumber *twentyFour = [NSNumber numberWithInteger:[_fieldTwentyFour.text integerValue]];
    
    NSArray *arrayOfValues = @[one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen,
                    fifteen,sixteen,seventeen,eighteen,nineteen,twenty,twentyOne,twentyTwo,twentyThree,twentyFour];
    
    NSMutableArray *arrayToPass = [NSMutableArray new];
    
    for (NSInteger x = 0; x < _slider.value - 1; x++) {
        [arrayToPass addObject:[arrayOfValues objectAtIndex:x]];
    }
    
    return [NSArray arrayWithArray:arrayToPass];
}

#pragma mark - Rotation methods (required)

- (void) didRotate
{
    [self setNeedsStatusBarAppearanceUpdate];
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        
        JYGraphViewController *graphView = [[JYGraphViewController alloc]
                                            initWithNibName:@"JYGraphViewController" bundle:nil];
        
        // Set the data for the graph
        // Send only an array of number values
        graphView.graphData = [self createArrayToPassToGraph];
        
        // Set the colours for the stroke and fill
        // If not set, default green values will be used
        graphView.graphFillColour = [UIColor colorWithRed:0.21f green:0.00f blue:0.40f alpha:1.0f];
        graphView.graphStrokeColour = [UIColor colorWithRed:0.53f green:0.00f blue:0.98f alpha:1.0f];
        
        [self presentViewController:graphView animated:YES completion:nil];
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

- (BOOL) shouldAutorotate
{
    return NO;
}

#pragma mark - Label and notifications

- (void) updateLabel
{
    _textLabel.text = [NSString stringWithFormat:@"%ld values being passed to graph. Rotate to display.",(long)_slider.value];
}

- (void) keyboardUp: (NSNotification *) notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + kbSize.height);
}

- (void) keyboardDown: (NSNotification *) notification
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
