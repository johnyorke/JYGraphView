//
//  JYGraphAppDelegate.h
//  JYGraphViewController
//
//  Created by John Yorke on 02/12/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYGraphMenuViewController.h"

@interface JYGraphAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JYGraphMenuViewController *viewController;

@end
