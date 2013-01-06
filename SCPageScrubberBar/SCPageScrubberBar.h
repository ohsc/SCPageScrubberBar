//
//  SCPageScrubberBar.h
//  SCPageScrubberBar
//
//  Created by ohsc on 12-9-5.
//  Copyright (c) 2013年 Chao Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCPageScrubberBarDelegate;
@interface SCPageScrubberBar : UISlider
@property (nonatomic, weak) id <SCPageScrubberBarDelegate> delegate;
@property (nonatomic, assign) BOOL alwaysShowTitleView;
@property (nonatomic, assign) BOOL isPopoverMode;
@end

@protocol SCPageScrubberBarDelegate <NSObject>
@required
- (NSString*)scrubberBar:(SCPageScrubberBar*)scrubberBar titleTextForValue:(CGFloat)value;
- (NSString*)scrubberBar:(SCPageScrubberBar*)scrubberBar subtitleTextForValue:(CGFloat)value;
@optional
- (void)scrubberBar:(SCPageScrubberBar*)scrubberBar valueSelected:(CGFloat)value;
@end
