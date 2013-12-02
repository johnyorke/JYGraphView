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
