//
//  SCPageScrubberBar.m
//  SCPageScrubberBar
//
//  Created by ohsc on 12-9-5.
//  Copyright (c) 2013年 Chao Shen. All rights reserved.
//

#import "SCPageScrubberBar.h"
#import "SCCalloutView.h"
#import <QuartzCore/QuartzCore.h>

#define kSCDotImageSpacing 10.0f

@interface SCPageScrubberBar ()
@property (nonatomic, strong) UIImage* dotsImage;
@property (nonatomic, strong) UIImage* clearImage;
@property (nonatomic, strong) CALayer* backgroundLayer;
@property (nonatomic, strong) SCCalloutView* calloutView;
- (CGRect)_thumbRect;
- (void)_fadeCalloutViewInAndOut:(BOOL)aFadeIn;
- (void)_updateCalloutViewPosition;
- (void)_updateCalloutViewText;
- (UIImage*)_generateDotsImage;
@end

@implementation SCPageScrubberBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.layer addSublayer:self.backgroundLayer];
        UIImage* thumbImage = [UIImage imageNamed:@"SCPageScrubberBar.bundle/thumb.png"];
        [self setMaximumTrackImage:self.clearImage forState:UIControlStateNormal];
        [self setMinimumTrackImage:self.clearImage forState:UIControlStateNormal];
        [self setThumbImage:thumbImage forState:UIControlStateNormal];

        [self addSubview:self.calloutView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect nFrame = self.backgroundLayer.frame;
    nFrame.size.width = self.bounds.size.width;
    self.backgroundLayer.frame = nFrame;
    
    [self _updateCalloutViewText];
    [self _updateCalloutViewPosition];
}

#pragma mark - Self Private Methods

- (CGRect)_thumbRect
{
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbR = [self thumbRectForBounds:self.bounds
                                   trackRect:trackRect
                                       value:self.value];
    return thumbR;
}

- (void)_fadeCalloutViewInAndOut:(BOOL)aFadeIn
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (aFadeIn) {
        self.calloutView.alpha = 1.0;
    } else {
        self.calloutView.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)_updateCalloutViewPosition
{
    CGRect calloutViewRect = self.calloutView.bounds;
    CGRect _thumbRect = [self _thumbRect];
    calloutViewRect.origin.y = CGRectGetMinY(_thumbRect) - CGRectGetHeight(calloutViewRect) - 16.0f;
    if (self.isPopoverMode) {
        calloutViewRect.origin.x = (int)(CGRectGetMidX(_thumbRect) - CGRectGetWidth(calloutViewRect) / 2);
    } else {
        calloutViewRect.origin.x = (int)(CGRectGetMidX(self.bounds) - CGRectGetWidth(calloutViewRect) / 2 );
    }
    self.calloutView.frame = calloutViewRect;
    
}

- (void)_updateCalloutViewText
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrubberBar:titleTextForValue:)]) {
        self.calloutView.titleLabel.text = [self.delegate scrubberBar:self titleTextForValue:self.value];
    } else {
        self.calloutView.titleLabel.text = @"";
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrubberBar:subtitleTextForValue:)]) {
        self.calloutView.subtitleLabel.text = [self.delegate scrubberBar:self subtitleTextForValue:self.value];
    } else {
        self.calloutView.subtitleLabel.text = [NSString stringWithFormat:@"Page: %f", self.value];
    }
    
    [self.calloutView sizeToFit];
}

- (UIImage*)_generateDotsImage
{
    // Get the image of one dot
    UIImage *image = [UIImage imageNamed:@"SCPageScrubberBar.bundle/dot.png"];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(self.bounds.size.width, image.size.height);
    // The total width of one dot including spacing
    CGFloat oneDotWidth = image.size.width + kSCDotImageSpacing;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw dotImage repeatly
    NSInteger len = (int)(size.width / oneDotWidth);
    for (NSInteger i = 0; i < len; i++) {
        CGPoint drawPoint = CGPointMake(i * oneDotWidth + kSCDotImageSpacing / 2, 0);
        CGContextDrawImage(ctx, (CGRect){drawPoint, image.size}, image.CGImage);
    }
    
    // Generate the image
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


#pragma mark - UIControl touch event tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Fade in and update the callout view
    CGPoint touchPoint = [touch locationInView:self];
    // Check if the knob is touched. Only in this case show the callout view
    if(CGRectContainsPoint(CGRectInset([self _thumbRect], -12.0, -12.0), touchPoint)) {
        if (!self.alwaysShowTitleView) {
            [self _fadeCalloutViewInAndOut:YES];
        }
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Fade out the popoup view
    if (!self.alwaysShowTitleView) {
        [self _fadeCalloutViewInAndOut:NO];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrubberBar:valueSelected:)]) {
        [self.delegate scrubberBar:self valueSelected:self.value];
    }
    [super endTrackingWithTouch:touch withEvent:event];
}

- (UIImage *)dotsImage
{
    if (_dotsImage == nil) {
        UIImage *image = [UIImage imageNamed:@"SCPageScrubberBar.bundle/dot.png"];
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize size = CGSizeMake(self.bounds.size.width, image.size.height);
        CGFloat oneDotWidth = image.size.width + kSCDotImageSpacing;
        
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        NSInteger len = (int)(size.width / oneDotWidth);
        for (NSInteger i = 0; i < len; i++) {
            CGPoint drawPoint = CGPointMake(i * oneDotWidth + kSCDotImageSpacing / 2, 0);
            CGContextDrawImage(ctx, (CGRect){drawPoint, image.size}, image.CGImage);
        }
        
        _dotsImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _dotsImage;
}

- (UIImage *)clearImage
{
    if (_clearImage == nil) {
        CGFloat scale = [UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
        _clearImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _clearImage;
}

- (CALayer *)backgroundLayer
{
    if (_backgroundLayer == nil) {
        _backgroundLayer = [[CALayer alloc] init];
        CGFloat y = (int)(CGRectGetHeight(self.bounds) - self.dotsImage.size.height) / 2;
        _backgroundLayer.frame = (CGRect){CGPointMake(0, y), self.dotsImage.size};
        _backgroundLayer.contents = (id)self.dotsImage.CGImage;
        _backgroundLayer.contentsGravity = kCAGravityTopLeft;
        _backgroundLayer.contentsScale = [UIScreen mainScreen].scale;
        _backgroundLayer.masksToBounds = YES;
    }
    return _backgroundLayer;
}

- (SCCalloutView *)calloutView
{
    if (_calloutView == nil) {
        _calloutView = [[SCCalloutView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _calloutView.alpha = 0;
        _calloutView.anchorDirection = self.isPopoverMode ? SCCalloutViewAnchorBottom : SCCalloutViewAnchorNone;
    }
    return _calloutView;
}

- (void)setAlwaysShowTitleView:(BOOL)alwaysShowTitleView
{
    if (_alwaysShowTitleView != alwaysShowTitleView) {
        _alwaysShowTitleView = alwaysShowTitleView;
        if (_alwaysShowTitleView) {
            self.calloutView.alpha = 1;
        } else {
            self.calloutView.alpha = 0;
        }
    }
}

- (void)setIsPopoverMode:(BOOL)isPopoverMode
{
    if (_isPopoverMode != isPopoverMode) {
        _isPopoverMode = isPopoverMode;
        self.calloutView.anchorDirection = self.isPopoverMode ? SCCalloutViewAnchorBottom : SCCalloutViewAnchorNone;
    }
}
@end


