//
//  WYUISlider.m
//  IOT-PRO-NEW
//
//  Created by 李凯 on 2023/8/23.
//
#define kBackgroundColor [UIColor grayColor] //默认未滑过颜色
#define kForegroundColor [UIColor orangeColor] //默认颜色
#define kThumbColor [UIColor whiteColor] //默认颜色
#define kCornerRadius 5.0  //默认圆角为5
#define kThumbRadius 5.0  //默认圆角为5
#define kBorderWidth 0.2 //默认边框为2
#define kAnimationSpeed 0.5 //默认动画移速
#define kThumbW 15 //默认的thumb的宽度
#define kThumbW 15 //默认的thumb的宽度
#define kIconImageHeight 25
#define kIconImageWidth 25
#define kIconImageOffsetLeft 20

#import "WYUISlider.h"

@interface WYUISlider ()

@property (nonatomic, strong)UIView *foregroundView;
@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)UIImageView *iconImage;

@property (nonatomic, strong) UITouch *touchTracker;
@property (nonatomic, assign) CGPoint touchLastPoint;
@property (nonatomic, strong) UIPanGestureRecognizer * recognizer;

@end

@implementation WYUISlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[self roundRect:frame]]) {
        [self mainInit];
        [self addPan];
        self.maximumValue = 1;
        self.minimumValue = 0;
    }
    
    return self;
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:[self roundRect:bounds]];
    [self setThumbValue: self.value];
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame{
    [super setBounds:[self roundRect:frame]];
    [self setNeedsLayout];
}

- (CGRect)roundRect:(CGRect)frameOrBounds{
    CGRect newRect = frameOrBounds;
    
    newRect.size.height = frameOrBounds.size.height;
    newRect.size.width = frameOrBounds.size.width;
    
    [self updateTagViewLayout:newRect];
    
    return newRect;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)mainInit {
    self.foregroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.foregroundView.layer.cornerRadius = kCornerRadius;
    self.foregroundView.backgroundColor = kForegroundColor;

    self.thumbView.userInteractionEnabled = YES;
    self.thumbView.backgroundColor = kThumbColor;
    self.thumbView.layer.cornerRadius = kThumbRadius;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconImageWidth, kIconImageHeight)];
    self.iconImage = imageView;
    
    [self addSubview:self.foregroundView];
    [self addSubview:self.thumbView];
    [self addSubview: imageView];
    
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = kBorderWidth;
    self.backgroundColor = kBackgroundColor;
}

#pragma mark - Touch Events
- (void)addPan{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveSlider:)];
    [self.thumbView addGestureRecognizer:recognizer];
    [self addGestureRecognizer:recognizer];
    self.recognizer = recognizer;
}

#pragma mark - void
- (void)moveSlider:(UIPanGestureRecognizer *)recognizer{
    //NSLog(@"----%ld",recognizer.state);
    if (recognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"self.thumbView.frame.origin.x==%f",self.thumbView.frame.origin.x);
        if (self.thumbView.frame.origin.x + self.thumbView.frame.size.width <= self.frame.size.width &&
            self.thumbView.frame.origin.x >= 0) {
            CGPoint translation = [recognizer translationInView:self];
            translation = CGPointApplyAffineTransform(translation, self.thumbView.transform);
            CGFloat moveY;
            moveY = self.thumbView.center.x + translation.x;
            if (self.thumbView.center.x + translation.x > self.frame.size.width - self.thumbView.frame.size.width/2 ) {
                moveY = self.frame.size.width - self.thumbView.frame.size.width/2;
                
            }else if (self.thumbView.center.x + translation.x < self.thumbView.frame.size.width/2){
                moveY = self.thumbView.frame.size.width/2;
            }else if (self.thumbView.frame.origin.x < 0){
                moveY = self.thumbView.frame.size.width/2;
            }
            //NSLog(@"MOVEY=%f",(moveY-self.thumbView.frame.size.width/2));
            self.thumbView.center = CGPointMake(moveY, self.thumbView.center.y);
            self.foregroundView.frame = CGRectMake(0, 0, ((moveY-self.thumbView.frame.size.width/2)+self.thumbView.frame.size.width/2), self.bounds.size.height);
            [recognizer setTranslation:CGPointZero inView:self]; // 移动的时候，注意在最后重设当前的 translation。
            
//            CGFloat value =  (self.frame.size.width - self.thumbView.center.x - self.thumbView.frame.size.width/2)/(self.frame.size.width-self.thumbView.frame.size.width) * (self.maximumValue-self.minimumValue) + self.minimumValue;
            CGFloat value =  (moveY-self.thumbView.frame.size.width/2)/(self.frame.size.width-self.thumbView.frame.size.width) * (self.maximumValue-self.minimumValue) + self.minimumValue;
            
            [self fillWithValue:value];
            
            if (self.touchSliderValueChange) {
                self.touchSliderValueChange(value,NO);
            }
        }
    }else if(recognizer.state != 1) {
        if (self.touchSliderValueChange) {
            self.touchSliderValueChange(self.value,YES);
        }
    }
}

- (void)setValue:(float)value animated:(BOOL)animated{
    if (value < self.minimumValue) {
        value = self.minimumValue;
        return;
    }
    _value = value;
    if (animated == YES) {
        [UIView animateWithDuration:.1 animations:^{
            CGFloat p = (self.maximumValue-value)*(self.frame.size.width-self.thumbView.frame.size.width)/(self.maximumValue-self.minimumValue)-self.frame.size.width + self.thumbView.frame.size.width/2;
            CGPoint center = CGPointMake(-p, self.thumbView.center.x);
            self.thumbView.center = center;
            self.foregroundView.frame = CGRectMake(0, 0, center.x, self.frame.size.height);
        }];
        
    }else{
        [self fillWithValue:value];
        CGFloat p = (self.maximumValue-value)*(self.frame.size.width-self.thumbView.frame.size.width)/(self.maximumValue-self.minimumValue)-self.frame.size.width + self.thumbView.frame.size.width/2;
        CGPoint center = CGPointMake(-p, self.thumbView.center.y);
        self.thumbView.center = center;
        self.foregroundView.frame = CGRectMake(0, 0, center.x, self.frame.size.height);
    }
}

- (void)fillWithValue:(CGFloat)value{
    if (value < self.minimumValue) {
        value = self.minimumValue;
        return;
    }
    _value = value;
    //NSLog(@"----%f", value);
    if (self.mininumImage){
        [self setFillIconImage: value];
    }
}

- (void)setFillIconImage:(CGFloat)value{
    if (value <= self.minimumValue){
        self.iconImage.image = [UIImage imageNamed:self.mininumImage];
    }else if (value > self.minimumValue && value <= self.maximumValue){
        self.iconImage.image = [UIImage imageNamed:self.maxinumImage];
    }
    self.iconImage.center = CGPointMake(self.iconImageOffsetLeft > 0 ? self.iconImageOffsetLeft : kIconImageOffsetLeft, self.frame.size.height/2);
}

#pragma mark - Get/Set
- (void)setMinimumValue:(float)minimumValue{
    _minimumValue = minimumValue;
    if (_value == 0) {
        _value = minimumValue;
    }
}

- (void)setForegroundColor:(UIColor *)foregroundColor{
    self.foregroundView.backgroundColor = foregroundColor;
}

- (void)setLaygroundColor:(UIColor *)laygroundColor{
    self.backgroundColor = laygroundColor;
}

- (void)setThumbColor:(UIColor *)thumbColor{
    self.thumbView.backgroundColor = thumbColor;
}

- (void)setRadius:(int)radius{
    self.layer.cornerRadius = radius;
    self.foregroundView.layer.cornerRadius = radius;
}

- (void)setThumbValue:(float)value{
    if (value < self.minimumValue) {
        value = self.minimumValue;
    }
    _value = value;
    [self setValue:value animated:NO];
    //[self layoutIfNeeded];
}

- (UIView *)thumbView{
    if (!_thumbView) {
        _thumbView = [[UIImageView alloc] init];
        _thumbView.userInteractionEnabled = YES;
    }
    return _thumbView;
}

- (void)setThumbViewWidth:(float)thumbViewWidth{
    _thumbViewWidth = thumbViewWidth;
}

- (void)setThumbHidden:(BOOL)thumbHidden{
    _thumbHidden = thumbHidden;
}

- (void)setMininumImage:(NSString *)mininumImage{
    _mininumImage = mininumImage;
}

- (void)setMaxinumImage:(NSString *)maxinumImage{
    _maxinumImage = maxinumImage;
}

- (void)setIconImageWidth:(float)iconImageWidth{
    if (_iconImageWidth != iconImageWidth)
        _iconImageWidth = iconImageWidth;
    
    CGRect frame = self.iconImage.frame;
    frame.size.width = iconImageWidth;
    self.iconImage.frame = frame;
}

- (void)setIconImageHeight:(float)iconImageHeight{
    if (_iconImageHeight != iconImageHeight)
        _iconImageHeight = iconImageHeight;
    
    CGRect frame = self.iconImage.frame;
    frame.size.height = iconImageHeight;
    self.iconImage.frame = frame;
}

- (void)setIconImageOffsetLeft:(float)iconImageOffsetLeft{
    _iconImageOffsetLeft = iconImageOffsetLeft;
}

- (void)updateTagViewLayout: (CGRect)frameOrBounds{
    float height = frameOrBounds.size.height;
    float width = self.thumbViewWidth > 0 ? self.thumbViewWidth : kThumbW;
    if (self.thumbHidden == YES){
        width = 0;
    }
    
    CGRect frame = self.thumbView.frame;
    frame.size.height = height;
    frame.size.width = width;
    self.thumbView.frame = frame;
}

@end
