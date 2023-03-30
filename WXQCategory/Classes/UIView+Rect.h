//
//  UIView+Rect.h
//  Test
//
//  Created by ybd on 2019/4/27.
//  Copyright © 2019 ybd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Rect)

@property(nonatomic) CGFloat x;
@property(nonatomic) CGFloat y;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat leading;
@property(nonatomic) CGFloat heading;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic) CGPoint origin;

@property(nonatomic) CGSize size;

- (void)removeAllSubview;

- (void)viewBorderRadius:(CGFloat)radius;
- (void)viewBorderRadius:(CGFloat)radius lineWidth:(CGFloat)width color:(UIColor *)color;
- (void)viewByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii;
// 添加高斯模糊（毛玻璃效果）
- (void)addBlurEffectLight;
- (void)addBlurEffectDark;
//阴影
- (void)viewShadowWithShadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset;

// 开始旋转
- (void)startRotating;
// 停止旋转
- (void)stopRotating;
// 恢复旋转
- (void)resumeRotate;

/**
 设置view弹出动画效果
 */
- (void)animationWithAlertView;

@end

NS_ASSUME_NONNULL_END
