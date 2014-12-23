<img src="https://raw.github.com/johnyorke/JYGraphViewController/master/JYGraphViewController/Screenshots/photo.jpg">

# JYGraphViewController

JYGraphViewController is an easy way to graph data in a simple and minimalist style and is highly customisable.

<img src="https://raw.github.com/johnyorke/JYGraphViewController/master/JYGraphViewController/Screenshots/graph.gif">

# Intro

JYGraphViewController is a slightly adapted version of the graph that appears in [Tempo/Weather](http://www.appstore.com/tempoweather). JYGraphView is a sublass of UIScrollView. You can get one on screen easily using code:

```obj-c
JYGraphView *graphView = [[JYGraphView alloc] initWithFrame:frame];

// Set the data for the graph
graphView.graphData = @[@2,@4,@5,@7,@8,@10,@10,@10,@12,@10,@20,@21];

// Set the xAxis labels (optional)
graphView.graphXAxisLabels = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];

// NB. call this to graw the graph or refresh it if data has changed
[graphView plotGraphData]

[self.view addSubview:graphView];
```

Alternatively, if you use xibs you can drop a UIView into your xib > Identity Inspector > change the class name to JYGraphView.

If you don't set any of the colours, fonts, etc, the graph will be displayed in its default style (same as [Tempo/Weather](http://www.appstore.com/tempoweather)). 

The default content width of the `graphView` is twice the width of the frame. You can set your own width to either narrower or wider values simply by setting `graphWidth` before calling .


# Files you'll need

Drag the following files into your project:

* JYGraphViewController.h
* JYGraphViewController.m
* JYGraphPoint.h
* JYGraphPoint.m

By default the graph uses a UIView subclass (JYGraphPoint) to draw each point.

# Customisation

If you wish to customise the look of the graph a bit, you can set the strokeColor and fillColor with any UIColor before you present the graph.

```obj-c
graphView.pointFillColor = [UIColor colorWithRed:0.21 green:0.00f blue:0.40 alpha:1.0];
graphView.strokeColor = [UIColor colorWithRed:0.53 green:0.00 blue:0.98 alpha:1.0];
```

You can further customise the graphView by setting the following before calling `plotGraphData`:

`backgroundColor`, `barColor`, `labelFont`, `labelFontColor`, `labelBackgroundColor`, `strokeWidth`, `hidePoints`, `useCurvedLine` and `hideLabels`.

You can opt to hide the lines, points or labels setting their respective properties to **NO**.

You can opt for the curved line that uses the [Catmull-Rom spline](http://en.wikipedia.org/wiki/Centripetal_Catmull–Rom_spline) by setting `useCurvedLine` to **YES**. Default is **NO**.

So a fully customised graph might look something like this:

```obj-c
// Customisation options
graphView.fillColor = [UIColor colorWithRed:0.94 green:0.32 blue:0.59 alpha:1.0];
graphView.strokeColor = [UIColor darkGrayColor];
graphView.useCurvedLine = YES;
graphView.graphWidth = 720;
graphView.backgroundColor = [UIColor grayColor];
graphView.barColor = [UIColor lightGrayColor];
graphView.labelFont = [UIFont fontWithName:@"AvenieNextCondensed-Regular" size:12];
graphView.labelFontColor = [UIColor whiteColor];
graphView.labelBackgroundColor = [UIColor grayColor];
```

Some examples of customised graphs:

<img src="https://raw.github.com/johnyorke/JYGraphViewController/master/JYGraphViewController/Screenshots/graphs.gif">


# What the graph controller actually does

The graph takes your numbers, works out the range, translates them into coordinates, then draws the elements:
* background bar (which is actually a label)
* the line joining the points
* the label above each point
* and finally, the points

# Possible use case

1. Use the motion chip on the iPhone to show step counter data for the last 7/10/30 days
2. Link it to your app sales and show the trend for the last 30 days/12 months
3. Use it in your weather app to show predicted temperature for the next 24 hours/7 days

# Known issues

1. No tests. I know. I'm a bad programmer.

# Thanks

First of all I would be thrilled if someone used this in their project and let me know about it. Secondly, I would be equally thrilled if someone gets in touch with ways in which to improve JYGraphView.

You can email me ([hello@johnyorke.me](mailto:hello@johnyorke.me)) or get in touch on Twitter [@johnyorke](http://www.twitter.com/johnyorke)

# License

MIT License (enclosed in project folder). So in other words...fill ya' boots!
