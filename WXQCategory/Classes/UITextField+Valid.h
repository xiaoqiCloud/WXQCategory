//
//  UITextField+Creat.h
//  Test
//
//  Created by ybd on 2019/4/30.
//  Copyright © 2019 ybd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UITextFieldViewStyle) {
    UITextFieldViewStyleText,
    UITextFieldViewStyleNumber,
    UITextFieldViewStyleDecimalNumber,
    UITextFieldViewStylePhone
};

@interface UITextField (Valid)

- (void)loadStyle:(UITextFieldViewStyle)style decimalNumber:(NSInteger)number limit:(NSUInteger)limit;

/// 设置输入框只能输入数字和小数点，且可以设置小数点后面几位，该函数在-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string调用；
/// @param range range
/// @param string string
/// @param number 小数点后几位
/// @param limit 小数点前几位
- (BOOL)qd_isValidShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string decimalNumber:(NSInteger)number limit:(NSUInteger)limit;

/// 限制输入的全部是数字并且限制最多能输入的位数
/// @param range rang
/// @param string string
/// @param limit 最多能输入几位
- (BOOL)qd_isValidNember:(NSRange)range replacementString:(NSString *)string limit:(NSUInteger)limit;

/// 限制输入字符
/// @param range rang
/// @param string string
/// @param limit 最多输入位数
- (BOOL)qd_isValidCharacter:(NSRange)range replacementString:(NSString *)string limit:(NSUInteger)limit;

/// 输入手机号时格式化（3-4-4格式）
/// @param range rang
/// @param string string
- (BOOL)qd_formatPhoneWithRange:(NSRange)range replacementString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
