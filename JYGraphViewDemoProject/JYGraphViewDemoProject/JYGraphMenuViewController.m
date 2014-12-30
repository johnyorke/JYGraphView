//
//  JYGraphMenuViewController.m
//  JYGraph
//
//  Created by John Yorke on 28/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYGraphMenuViewController.h"
#import "JYGraphView.h"

@interface JYGraphMenuViewController ()

@property (strong, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colourSegment;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UIView *colourPreview;
@property (weak, nonatomic) IBOutlet UISwitch *hideLines;
@property (weak, nonatomic) IBOutlet UISwitch *hidePoints;
@property (weak, nonatomic) IBOutlet UISwitch *curvedLine;
@property (weak, nonatomic) IBOutlet UISwitch *hidelabels;
@property (weak, nonatomic) IBOutlet UIPickerView *fontPicker;
@property (weak, nonatomic) IBOutlet UISlider *xAxisValueSlider;
@property (weak, nonatomic) IBOutlet UILabel *xAxisValueLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIColor *strokeColour;
@property (strong, nonatomic) UIColor *pointColour;
@property (strong, nonatomic) UIColor *graphBackgroundColour;
@property (strong, nonatomic) UIColor *barColour;
@property (strong, nonatomic) UIColor *fontColour;
@property (strong, nonatomic) UIColor *labelColour;

@property (weak, nonatomic) IBOutlet UIView *graphContainerView;

@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *alphaLabel;


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
    [self.scrollView addSubview:self.settingsView];
    self.scrollView.contentSize = self.settingsView.frame.size;
    
    self.fontPicker.delegate = self;
    self.fontPicker.dataSource = self;
    
    self.redSlider.value = 43;
    self.greenSlider.value = 94;
    self.blueSlider.value = 155;
    self.alphaSlider.value = 1;
    
    self.curvedLine.on = YES;
    
    self.colourPreview.backgroundColor = [self colourFromSliders];
    
    self.strokeColour = [self colourFromSliders];
    self.pointColour = [UIColor colorWithRed:106.0f/255.0f green:166.0f/255.0f blue:220.0f/255.0f alpha:1];
    self.graphBackgroundColour = [UIColor whiteColor];
    self.barColour = [UIColor colorWithRed:230.0f/255 green:230.0f/255 blue:230.0f/255 alpha:1];
    self.fontColour = [UIColor grayColor];
    self.labelColour = [UIColor colorWithRed:60.0f/255 green:60.0f/255 blue:60.0f/255 alpha:0];
        
    [self.fontPicker selectRow:5 inComponent:0 animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showGraph:nil];
    
    [self updateSliderLabels];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[UIFont familyNames] count];
}

- (NSArray *)createArrayToPassToGraph
{
    // For test purposes only, set the values in the text fields
    // and pass them to the graph
    
    NSMutableArray *randomNumbers = [NSMutableArray new];
    
    for (int x = 1; x <= 24; x++) {
        NSInteger low = x * 5;
        NSInteger high = (x * 5) + low;
        
        NSInteger num = low + arc4random_uniform(high);
        
        [randomNumbers addObject:[NSNumber numberWithInteger:num]];
    }
        
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    int value = roundl(self.xAxisValueSlider.value);
    
    for (int x = 0; x < value  ; x++) {
        [mutableArray addObject:[randomNumbers objectAtIndex:x]];
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

- (NSArray *)createXAxisLabelArray
{
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    NSInteger sliderValue = [self.xAxisValueLabel.text integerValue];
    
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
    
    for (int x = 0; x <= sliderValue ; x++) {
        NSRange range = NSMakeRange(x, 1);
        NSString *letter = [[alphabet substringWithRange:range] uppercaseString];
        [mutableArray addObject:letter];
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *fontName = [[UIFont familyNames] objectAtIndex:row];
    
    return fontName;
}

- (IBAction)showGraph:(id)sender 
{
    for (UIView *subview in self.graphContainerView.subviews) {
        if ([subview isKindOfClass:[JYGraphView class]]) {
            [subview removeFromSuperview];
        }
    }
    JYGraphView *graphView = [[JYGraphView alloc] initWithFrame:self.graphContainerView.bounds];
        
    // Set the data for the graph
    // Send only an array of number values
    graphView.graphData = [self createArrayToPassToGraph];
    
    // Set the xAxis labels
    // Can send numbers or strings (it's printed using stringWithFormat:"%@")
    graphView.graphDataLabels = [self createXAxisLabelArray];
    
    // Customisation options
    graphView.pointFillColor = self.pointColour;
    graphView.strokeColor = self.strokeColour;
    graphView.useCurvedLine = self.curvedLine.isOn;
    graphView.hideLabels = self.hidelabels.isOn;
    graphView.strokeWidth = 4;
    graphView.graphWidth = graphView.frame.size.width * 2;
    graphView.hidePoints = self.hidePoints.isOn;
    graphView.hideLines = self.hideLines.isOn;
    graphView.backgroundViewColor = self.graphBackgroundColour;
    graphView.barColor = self.barColour;
    NSArray *fontArray = [UIFont fontNamesForFamilyName:[self pickerView:self.fontPicker titleForRow:[self.fontPicker selectedRowInComponent:0] forComponent:0]];
    graphView.labelFont = [UIFont fontWithName:[fontArray firstObject] size:12];
    graphView.labelFontColor = self.fontColour;
    graphView.labelBackgroundColor = self.labelColour;
        
    [self.graphContainerView addSubview:graphView];
}


- (IBAction)valueChanged:(id)sender 
{
    if (sender == self.xAxisValueSlider) {
        int value = roundl(self.xAxisValueSlider.value);
        self.xAxisValueLabel.text = [NSString stringWithFormat:@"%d",value];
    }
    
    if (sender == self.redSlider || sender == self.greenSlider || sender == self.blueSlider || sender == self.alphaSlider) {
        self.colourPreview.backgroundColor = [self colourFromSliders];
        [self setColourForCurrentlySelectedSegment];
        [self updateSliderLabels];
    }
}

- (void)updateSliderLabels
{
    int red = roundl(self.redSlider.value);
    self.redLabel.text = [NSString stringWithFormat:@"%d",red];
    int green = roundl(self.greenSlider.value);
    self.greenLabel.text = [NSString stringWithFormat:@"%d",green];
    int blue = roundl(self.blueSlider.value);
    self.blueLabel.text = [NSString stringWithFormat:@"%d",blue];
    float alpha = self.alphaSlider.value;
    self.alphaLabel.text = [NSString stringWithFormat:@"%.2f",alpha];
}

- (UIColor *)colourFromSliders
{
    return [UIColor colorWithRed:self.redSlider.value/255 green:self.greenSlider.value/255 blue:self.blueSlider.value/255 alpha:self.alphaSlider.value];
}

- (void)setColourForCurrentlySelectedSegment
{    
    UIColor *colour = [self colourFromSliders];
    
    switch (self.colourSegment.selectedSegmentIndex) {
        case 0:
            self.strokeColour = colour;
            break;
        case 1:
            self.pointColour = colour;
            break;
        case 2:
            self.graphBackgroundColour = colour;
            break;
        case 3:
            self.barColour = colour;
            break;
        case 4:
            self.fontColour = colour;
            break;
        case 5:
            self.labelColour = colour;
            break;
            
        default:
            break;
    }
    
}

- (UIColor *)getColourForCurrentlySelectedSegment
{    
    UIColor *colour;
    
    switch (self.colourSegment.selectedSegmentIndex) {
        case 0:
            colour = self.strokeColour;
            break;
        case 1:
            colour = self.pointColour;
            break;
        case 2:
            colour = self.graphBackgroundColour;
            break;
        case 3:
            colour = self.barColour;
            break;
        case 4:
            colour = self.fontColour;
            break;
        case 5:
            colour = self.labelColour;
            break;
            
        default:
            break;
    }
    
    return colour;
}

- (IBAction)segmentChanged:(id)sender 
{
    UIColor *colour = [self getColourForCurrentlySelectedSegment];
    
    if (colour) {
        CGFloat red,green,blue,alpha;
        
        BOOL gotColours = [colour getRed:&red green:&green blue:&blue alpha:&alpha];
        
        if (gotColours) {
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.redSlider setValue:red*255 animated:YES];
                [self.greenSlider setValue:green*255 animated:YES];
                [self.blueSlider setValue:blue*255 animated:YES];
                [self.alphaSlider setValue:alpha animated:YES];
            } completion:nil];
        }
    } else {
        self.redSlider.value = 255 / 2;
        self.greenSlider.value = 255 / 2;
        self.blueSlider.value = 255 / 2;
        self.alphaSlider.value = 1;
    }
    
    [self updateSliderLabels];
    self.colourPreview.backgroundColor = colour;
}

@end
