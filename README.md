# SCPageScrubberBar

SCPageScrubberBar is a page scrubber bar like ibooks.
SCPageScrubberBar works with iOS5.0+ and ARC.

Screenshot:

<img src="https://raw.github.com/ohsc/SCPageScrubberBar/master/Resources/scrubber_bar.png" /> &nbsp;
<img src="https://raw.github.com/ohsc/SCPageScrubberBar/master/Resources/scrubber_bar_drag.png" /> &nbsp;
<img src="https://raw.github.com/ohsc/SCPageScrubberBar/master/Resources/scrubber_bar_drag_popover.png" />

## Getting Started

### Manually

1. Download the source from [here](https://github.com/ohsc/SCPageScrubberBar/archive/master.zip)
2. Add all under `SCPageScrubberBar/SCPageScrubberBar` to your project
3. Add `QuartzCore.framework` to your project
4. Add `#import "SCPageScrubberBar.h"` before using it

### CocoaPods

Add SCPageScrubberBar to your `Podfile` and `pod install`.

```ruby
pod 'SCPageScrubberBar', '~> 0.0.1'
```
## Example Usage

### Basic

```objc
SCPageScrubberBar *scrubberBar = [[SCPageScrubberBar alloc] initWithFrame:CGRectMake(20.0f, 400.0f, 280.0f, 30.0f)];
scrubberBar.delegate = self;
scrubberBar.minimumValue = 0;
scrubberBar.maximumValue = 100;
scrubberBar.isPopoverMode = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
[self.view addSubview:scrubberBar];
```

### SCPageScrubberBarDelegate

```objc
@required
// Return the text of main titleLabel
- (NSString*)scrubberBar:(SCPageScrubberBar*)scrubberBar titleTextForValue:(CGFloat)value;
// Return the text of sub titleLabel
- (NSString*)scrubberBar:(SCPageScrubberBar*)scrubberBar subtitleTextForValue:(CGFloat)value;
@optional
// This method will be called when a page is selected
- (void)scrubberBar:(SCPageScrubberBar*)scrubberBar valueSelected:(CGFloat)value;
```

### Properties

```objc
// The delegate
@property (nonatomic, weak) id <SCPageScrubberBarDelegate> delegate;
// Default value is NO
@property (nonatomic, assign) BOOL alwaysShowTitleView;
// Default value is NO
@property (nonatomic, assign) BOOL isPopoverMode;
```

## LICENSE
Copyright (c) 2013 Chao Shen. This software is licensed under the BSD License.



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/ohsc/scpagescrubberbar/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

