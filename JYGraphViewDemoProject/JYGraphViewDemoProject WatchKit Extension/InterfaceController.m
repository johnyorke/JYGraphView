//
//  InterfaceController.m
//  JYGraphViewDemoProject WatchKit Extension
//
//  Created by John Yorke on 12/03/2015.
//  Copyright (c) 2015 John Yorke. All rights reserved.
//

#import "InterfaceController.h"
#import "JYGraphView.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *groupOne;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *groupTwo;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *groupThree;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *groupFour;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    CGRect rect = CGRectMake(0, 0,self.contentFrame.size.width , 160);
    NSArray *data = @[@-5,@-1,@0,@0,@2,@3];
    
    JYGraphView *one = [[JYGraphView alloc] initWithFrame:rect];
    one.graphData = data;
    one.useCurvedLine = YES;
    one.backgroundColor = [UIColor whiteColor];
    one.barColor = [UIColor whiteColor];
    one.strokeColor = [UIColor blackColor];
    one.backgroundViewColor = [UIColor whiteColor];
    one.pointFillColor = [UIColor blackColor];
    one.labelBackgroundColor = [UIColor clearColor];
    one.labelFontColor = [UIColor blackColor];
    one.strokeWidth = 4;
    [one plotGraphData];
    [_groupOne setBackgroundImage:[one graphImage]];
    
    JYGraphView *two = [[JYGraphView alloc] initWithFrame:rect];
    two.graphData = data;
    [two plotGraphData];
    [_groupTwo setBackgroundImage:[two graphImage]];
    
    JYGraphView *three = [[JYGraphView alloc] initWithFrame:rect];
    three.graphData = data;
    three.strokeColor = [UIColor orangeColor];
    three.hidePoints = YES;
    three.hideLabels = YES;
    three.barColor = [UIColor clearColor];
    [three plotGraphData];
    [_groupThree setBackgroundImage:[three graphImage]];
    
    JYGraphView *four = [[JYGraphView alloc] initWithFrame:rect];
    four.graphData = data;
    four.hideLines = YES;
    four.strokeColor = [UIColor purpleColor];
    four.pointFillColor = [UIColor clearColor];
    [four plotGraphData];
    [_groupFour setBackgroundImage:[four graphImage]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



