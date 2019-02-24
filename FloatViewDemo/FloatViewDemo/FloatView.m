//
//  FloatView.m
//  FloatViewDemo
//
//  Created by dulf on 2019/2/3.
//  Copyright © 2019 dulf. All rights reserved.
//

#import "FloatView.h"

@interface FloatView () {
    CGPoint lastPoint;
    CGPoint pointInSelf;
}

@end

@implementation FloatView
static FloatView *shareFloatView;

+ (void)show {
    FloatView *fview = [FloatView sharedView];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (!shareFloatView.superview) {
        [window addSubview:fview];
    }
    [window bringSubviewToFront:fview];
    
    [fview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        if (@available (iOS 11, *)) {
            make.top.mas_equalTo(window.mas_safeAreaLayoutGuideTop);
        }else {
            make.top.mas_equalTo(20);
        }
        make.width.height.mas_equalTo(60);
    }];
    
}

+ (instancetype)sharedView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareFloatView = [[FloatView alloc] init];
    });
    shareFloatView.layer.contents = (__bridge id)[UIImage imageNamed:@"yuan"].CGImage;
    return shareFloatView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.superview];
    
    pointInSelf = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    CGFloat centerX = currentPoint.x + (self.frame.size.width/2 - pointInSelf.x);
    CGFloat centerY = currentPoint.y + (self.frame.size.height/2 - pointInSelf.y);
    
    CGFloat resultX = MAX(self.frame.size.width/2, MIN(centerX, [UIScreen mainScreen].bounds.size.width - self.frame.size.width/2));
    CGFloat resultY = MAX(self.frame.size.height, MIN(centerY, [UIScreen mainScreen].bounds.size.height - self.frame.size.height/2));
    
    self.center = CGPointMake(resultX, resultY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    if (CGPointEqualToPoint(currentPoint, lastPoint)) {
        return;
    }
}

@end
