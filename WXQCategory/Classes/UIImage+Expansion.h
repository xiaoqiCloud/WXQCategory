//
//  UIImage+Expansion.h
//  Test
//
//  Created by ybd on 2019/4/26.
//  Copyright © 2019 ybd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHORIZONTAL_SPACE 30//水平间距
#define kVERTICAL_SPACE 50//竖直间距
#define kCG_TRANSFORM_ROTATION (M_PI_2 / 3)//旋转角度(正旋45度 || 反旋45度)

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Expansion)

/**
 * 图片转换成base64字符串
 *
 * @return 转换后的字符串
 */
- (NSString *)base64Encrypt;

/**
 * 色块图片
 *
 * @param color 颜色
 * @return image
 */
+ (UIImage *)getImageToColor:(UIColor *)color;

/**
 * 色块图片
 *
 * @param color 颜色
 * @param size 大小
 * @return image
 */
+ (UIImage *)getImageToColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)getButtonBgImage:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)getBlueButtonBgImage:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

///将view转化为图片
+ (UIImage *)convertViewToImage:(UIView*)contentView;

/**
 * 模糊图片
 *
 * @param blur 模糊度
 * @return image
 */
- (UIImage *)imageBlurLevel:(CGFloat)blur;

/**
 * 根据目标图片制作一个盖水印的图片
 *
 * @param title 水印文字
 * @param font 水印文字font(如果不传默认为23)
 * @param color 水印文字颜色(如果不传递默认为源图片的对比色)
 * @return 返回盖水印的图片
 */
- (UIImage *)getWaterMarkImageWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color;


- (UIImage *)drawRoundedRectImage:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height;

- (UIImage *)drawCircleImage;
@end

NS_ASSUME_NONNULL_END
