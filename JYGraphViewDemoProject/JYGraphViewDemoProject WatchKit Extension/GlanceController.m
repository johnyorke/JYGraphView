//
//  GlanceController.m
//  JYGraphViewDemoProject WatchKit Extension
//
//  Created by John Yorke on 12/03/2015.
//  Copyright (c) 2015 John Yorke. All rights reserved.
//

#import "GlanceController.h"
#import "JYGraphView.h"

@interface GlanceController()

@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *label;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    CGFloat width = self.contentFrame.size.width;
    CGFloat height = self.contentFrame.size.height;
    
    JYGraphView *graphView = [[JYGraphView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    graphView.graphData = @[@10,@11,@14,@13,@15,@18];
    graphView.useCurvedLine = YES;
    graphView.hidePoints = YES;
    graphView.backgroundViewColor = [UIColor clearColor];
    graphView.barColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    graphView.labelBackgroundColor = [UIColor clearColor];
    graphView.labelFont = [UIFont systemFontOfSize:18];
    graphView.strokeWidth = 4;
    
    [graphView plotGraphData];
    
    [_image setImage:[graphView graphImage]];
    
    [self.label setText:@"\u00B0C - Next 6 hours"];
    
    [self.titleLabel setText:@"11\u00B0C"];
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



