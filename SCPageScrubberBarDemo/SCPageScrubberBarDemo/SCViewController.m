//
//  SCViewController.m
//  SCPageScrubberBarDemo
//
//  Created by ohsc on 13-1-5.
//  Copyright (c) 2013年 Chao Shen. All rights reserved.
//

#import "SCViewController.h"
#import "SCPageScrubberBar.h"

@interface SCViewController () <SCPageScrubberBarDelegate>
@property (nonatomic, strong) SCPageScrubberBar* scrubberBar;
@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.scrubberBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SCPageScrubberBar *)scrubberBar
{
    if (_scrubberBar == nil) {
        CGRect nFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(20.0f, 900.0f, 728.0f, 30.0f) : CGRectMake(20.0f, 400.0f, 280.0f, 30.0f);
        _scrubberBar = [[SCPageScrubberBar alloc] initWithFrame:nFrame];
        _scrubberBar.delegate = self;
        _scrubberBar.minimumValue = 0;
        _scrubberBar.maximumValue = 100;
        _scrubberBar.isPopoverMode = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    }
    return _scrubberBar;
}

#pragma mark - DSPopupSliderDelegate

- (NSString*)scrubberBar:(SCPageScrubberBar*)scrubberBar titleTextForValue:(CGFloat)value
{
    NSInteger current = (int)value % 20 + 1;
    return [NSString stringWithFormat:@"Chapter %d", current];
}

- (NSString *)scrubberBar:(SCPageScrubberBar *)scrubberBar subtitleTextForValue:(CGFloat)value
{
    NSInteger current = (int)value + 1;
    return [NSString stringWithFormat:@"Page %d", current];
}

- (void)scrubberBar:(SCPageScrubberBar*)scrubberBar valueSelected:(CGFloat)value
{
}

@end
