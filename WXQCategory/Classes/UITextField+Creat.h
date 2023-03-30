//
//  UITextField+Creat.h
//  Test
//
//  Created by ybd on 2019/4/30.
//  Copyright © 2019 ybd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Creat)

/**
 * 限制最大输入字数

 @param count “”
 */
@property(assign,nonatomic)NSInteger maxWordCount;
//- (void)maxWordWithCount:(NSInteger)count;

/**
 创建一个文本输入框
 
 @param frame 坐标
 @param text 内容
 @param placeholder 占位符
 @param font 字体
 @param textColor 文本颜色
 @param keyboardType 键盘样式
 @param textAlignment 对齐方式
 @param leftItem 左边item（目前只支持NSString，UIImage类型）
 @param delegate 代理
 @return UITextField
 */
+ (UITextField *)creatFieldWithFrame:(CGRect)frame text:(NSString *)text placeholder:(NSString *)placeholder textFont:(UIFont *)font textColor:(UIColor *)textColor keyboardType:(UIKeyboardType)keyboardType textAlignment:(NSTextAlignment)textAlignment leftItem:(id)leftItem delegate:(id<UITextFieldDelegate>)delegate;

+ (UITextField *)creatLoginFieldWithFrame:(CGRect)frame text:(NSString *)text placeholder:(NSString *)placeholder textFont:(UIFont *)font textColor:(UIColor *)textColor keyboardType:(UIKeyboardType)keyboardType textAlignment:(NSTextAlignment)textAlignment leftItem:(id)leftItem delegate:(id<UITextFieldDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
