//
//  SCCalloutView.m
//  SCPageScrubberBar
//
//  Created by ohsc on 13-1-6.
//  Copyright (c) 2013年 Chao Shen. All rights reserved.
//

#import "SCCalloutView.h"
#define kSCCalloutViewHeight 43.0f
#define kSCCalloutViewMinWidth 20.0f
#define kSCCalloutViewMinWidthWidthAnthor 41.0f
#define kSCCalloutViewLeftCapShadowInsets UIEdgeInsetsMake(2, 7, 12, 0)
#define kSCCalloutViewRightCapShadowInsets UIEdgeInsetsMake(2, 0, 12, 7)
#define kSCCalloutViewBottomAnchorShadowInsets UIEdgeInsetsMake(2, 0, 25, 0)
#define kSCCalloutViewBackgroundShadowInsets UIEdgeInsetsMake(2, 0, 12, 0)

@interface SCCalloutView ()
{
    UIImageView *_leftCap;
    UIImageView *_rightCap;
    UIImageView *_bottomAnchor;
    UIImageView *_leftBackground;
    UIImageView *_rightBackground;
}

@property (nonatomic, strong) UILabel *titleLabel, *subtitleLabel;

- (UIImageView*)_imageViewWithImageName:(NSString*)imageName
                                 repeat:(BOOL)shouldRepeat;
- (CGFloat)_minWidth;
@end

@implementation SCCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.anchorDirection = SCCalloutViewAnchorBottom;
        self.maxWidth = 320.0f;
        self.minWidth = 20.0f;
        self.titleLabelInsets = UIEdgeInsetsMake(6, 17, 21, 17);
        self.subtitleLabelInsets = UIEdgeInsetsMake(24, 17, 4, 17);

        _leftCap = [self _imageViewWithImageName:@"UICalloutViewLeftCap" repeat:NO];
        _rightCap = [self _imageViewWithImageName:@"UICalloutViewRightCap" repeat:NO];
        _bottomAnchor = [self _imageViewWithImageName:@"UICalloutViewBottomAnchor" repeat:NO];
        _leftBackground = [self _imageViewWithImageName:@"UICalloutViewBackground" repeat:YES];
        _rightBackground = [self _imageViewWithImageName:@"UICalloutViewBackground" repeat:YES];;
        
        [self addSubview:_leftCap];
        [self addSubview:_rightCap];
        [self addSubview:_bottomAnchor];
        [self addSubview:_leftBackground];
        [self addSubview:_rightBackground];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLabel];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize titleLabelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize subTitleLabelSize = [self.subtitleLabel.text sizeWithFont:self.subtitleLabel.font];
    // Get the max width of the two labels
    CGFloat maxLabelsWidth = MAX(titleLabelSize.width, subTitleLabelSize.width);
    
    CGFloat width = maxLabelsWidth + CGRectGetWidth(_leftCap.bounds) + CGRectGetWidth(_rightCap.bounds);
    width = MAX(width, self.minWidth);
    width = MIN(width, self.maxWidth);
    return CGSizeMake(width, kSCCalloutViewHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect nFrame, anchorFrame;
    CGFloat boundsWidth = CGRectGetWidth(self.bounds);
    
    // Set the height of self to be fixed
    nFrame = self.bounds;
    nFrame.size.height = kSCCalloutViewHeight;
    self.bounds = nFrame;
    
    // Layout the titleLabel
    nFrame = UIEdgeInsetsInsetRect(self.bounds, self.titleLabelInsets);
    self.titleLabel.frame = nFrame;
    // Layout the subTitleLabel
    nFrame = UIEdgeInsetsInsetRect(self.bounds, self.subtitleLabelInsets);
    self.subtitleLabel.frame = nFrame;
    
    // Layout the LeftCap
    nFrame = _leftCap.bounds;
    _leftCap.frame = (CGRect){CGPointMake(0, - kSCCalloutViewLeftCapShadowInsets.top), nFrame.size};
    
    // Layout the RightCap
    nFrame = _rightCap.bounds;
    _rightCap.frame = (CGRect){CGPointMake(boundsWidth - CGRectGetWidth(nFrame), - kSCCalloutViewRightCapShadowInsets.top), nFrame.size};
    
    // Hide the Anchor according to self.anchorDirection
    _bottomAnchor.hidden = !(self.anchorDirection == SCCalloutViewAnchorBottom);
    
    // Layout the anchor, and store the position in anchorFrame.
    switch (self.anchorDirection) {
        case SCCalloutViewAnchorBottom:
        {
            nFrame = _bottomAnchor.bounds;
            anchorFrame = (CGRect){CGPointMake((boundsWidth - CGRectGetWidth(nFrame)) / 2, - kSCCalloutViewBottomAnchorShadowInsets.top), nFrame.size};
            _bottomAnchor.frame = anchorFrame;
            break;
        }
        default:
        {
            anchorFrame = CGRectMake((boundsWidth - CGRectGetWidth(nFrame)) / 2, - kSCCalloutViewBottomAnchorShadowInsets.top, 0, kSCCalloutViewHeight);
            break;
        }
    }
    
    // Layout the LeftBackground
    nFrame = _leftBackground.bounds;
    nFrame.origin.x = CGRectGetMaxX(_leftCap.frame);
    nFrame.origin.y = - kSCCalloutViewBackgroundShadowInsets.top;
    nFrame.size.width = CGRectGetMinX(anchorFrame) - CGRectGetMaxX(_leftCap.frame);
    _leftBackground.frame = nFrame;
    
    // Layout the RightBackground
    nFrame = _rightBackground.bounds;
    nFrame.origin.x = CGRectGetMaxX(anchorFrame);
    nFrame.origin.y = - kSCCalloutViewBackgroundShadowInsets.top;
    nFrame.size.width = CGRectGetMinX(_rightCap.frame) - CGRectGetMaxX(anchorFrame);
    _rightBackground.frame = nFrame;
    
}

#pragma mark - Self Private Methods

- (UIImageView*)_imageViewWithImageName:(NSString*)imageName
                                 repeat:(BOOL)shouldRepeat
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"SCPageScrubberBar.bundle/%@.png", imageName]];
    if (shouldRepeat) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (CGFloat)_minWidth
{
    return (self.anchorDirection == SCCalloutViewAnchorNone) ? kSCCalloutViewMinWidth : kSCCalloutViewMinWidthWidthAnthor;
}

#pragma mark - Self Property Methods

- (void)setAnchorDirection:(SCCalloutViewAnchorDirection)anchorDirection
{
    if (_anchorDirection != anchorDirection) {
        _anchorDirection = anchorDirection;
        [self setNeedsLayout];
    }
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset = CGSizeMake(0, -1);
        _titleLabel.contentMode = UIViewContentModeCenter;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
            _titleLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            _titleLabel.textAlignment = UITextAlignmentCenter;
        }
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _subtitleLabel.shadowColor = [UIColor blackColor];
        _subtitleLabel.shadowOffset = CGSizeMake(0, -1);
        _subtitleLabel.contentMode = UIViewContentModeCenter;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
            _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            _subtitleLabel.textAlignment = UITextAlignmentCenter;
        }
    }
    return _subtitleLabel;
}

- (void)setMinWidth:(CGFloat)minWidth
{
    if (_minWidth != minWidth) {
        _minWidth = MAX([self _minWidth], minWidth);
    }
}
@end
