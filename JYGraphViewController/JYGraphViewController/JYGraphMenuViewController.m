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

@end

@implementation JYGraphMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self enableRotation];
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
    [self setNeedsStatusBarAppearanceUpdate];
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        
        JYGraphViewController *graphView = [[JYGraphViewController alloc]
                                                         initWithNibName:@"JYGraphViewController" bundle:nil];
        
        
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
        
        NSArray *arrayToPass = @[one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve];
        
        graphView.graphData = arrayToPass;
        
        [self presentViewController:graphView animated:YES completion:nil];
                
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }
    
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
