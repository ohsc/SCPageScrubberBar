//
//  SCCalloutView.h
//  SCPageScrubberBar
//
//  Created by ohsc on 13-1-6.
//  Copyright (c) 2013年 Chao Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SCCalloutViewAnchorNone, // hidden the anchor
    SCCalloutViewAnchorBottom, // anchor down
} SCCalloutViewAnchorDirection;

@interface SCCalloutView : UIView
@property (nonatomic, assign) SCCalloutViewAnchorDirection anchorDirection;
@property (nonatomic, strong, readonly) UILabel *titleLabel, *subtitleLabel;
@property (nonatomic, assign) UIEdgeInsets titleLabelInsets, subtitleLabelInsets;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat minWidth;
@end