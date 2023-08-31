//
//  WYUISlider.h
//  IOT-PRO-NEW
//
//  Created by 李凯 on 2023/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WYSliderBehavior) {
    RSSliderBehaviorAbsoluteTouch, // Jumps/animates to tapped position, default
    RSSliderBehaviorRelativeDrag, // Touch-drag from current position, never jumps
};

@interface WYUISlider : UIView

@property(nonatomic, assign) float value;
@property(nonatomic, assign) float minimumValue;
@property(nonatomic, assign) float maximumValue;
@property(nonatomic, strong) UIView *thumbView;
@property(nonatomic, assign) BOOL thumbHidden;
@property(nonatomic, assign) int radius;
@property(nonatomic, assign) float thumbViewWidth;
@property (nonatomic, assign) float iconImageHeight;
@property (nonatomic, assign) float iconImageWidth;
@property (nonatomic, assign) float iconImageOffsetLeft;

@property(nonatomic, strong) UIColor *foregroundColor;
@property(nonatomic, strong) UIColor *laygroundColor;
@property(nonatomic, strong) UIColor *borderColor;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIColor *thumbColor;

@property (nonatomic, assign) WYSliderBehavior behavior;
@property (nonatomic, strong) NSString *mininumImage;
@property (nonatomic, strong) NSString *maxinumImage;

@property (nonatomic,copy)void (^touchSliderValueChange)(CGFloat value, BOOL isChangeEnd);

@end

NS_ASSUME_NONNULL_END
