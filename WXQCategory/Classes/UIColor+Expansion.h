//
//  UIColor+Expansion.h
//  Test
//
//  Created by ybd on 2019/4/27.
//  Copyright © 2019 ybd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Expansion)

/**
 * 从十六进制字符串获取颜色，
 *
 * @param hexString 十六进制字符串（注：支持@“#123456”、 @“0X123456”、 @“123456”三种格式）
 * @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 * 从十六进制字符串获取颜色
 *
 * @param hexString 六进制字符串（注：支持@“#123456”、 @“0X123456”、 @“123456”三种格式）
 * @param alpha 透明度
 * @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)mainColor;
+ (UIColor *)titleColor;
+ (UIColor *)priceColor;
+ (UIColor *)subTitleColor;
+ (UIColor *)contentColor;
+ (UIColor *)dateColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)lineColor;

@end

NS_ASSUME_NONNULL_END
