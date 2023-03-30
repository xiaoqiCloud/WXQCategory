//
//  UITextField+Creat.m
//  Test
//
//  Created by ybd on 2019/4/30.
//  Copyright © 2019 ybd. All rights reserved.
//

#import "UITextField+Creat.h"
#import "NSString+Expansion.h"

@implementation UITextField (Creat)


+ (UITextField *)creatFieldWithFrame:(CGRect)frame text:(NSString *)text placeholder:(NSString *)placeholder textFont:(UIFont *)font textColor:(UIColor *)textColor keyboardType:(UIKeyboardType)keyboardType textAlignment:(NSTextAlignment)textAlignment leftItem:(id)leftItem delegate:(id<UITextFieldDelegate>)delegate {
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.text = text;
    field.textColor = textColor;
    field.font = font;
    field.placeholder = placeholder;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.keyboardType = keyboardType;
    field.returnKeyType = UIReturnKeyDone;
    field.textAlignment = textAlignment;
    field.delegate = delegate;
    
    if (leftItem) {
        field.leftViewMode = UITextFieldViewModeAlways;
        if ([leftItem isKindOfClass:[NSString class]]) {
            NSString *leftText = leftItem;
            CGFloat textWidth = [leftText getWidthToMaxHeight:frame.size.height font:font];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, textWidth + 10, frame.size.height)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor lightGrayColor];
            label.font = font;
            label.text = leftText;
            label.textAlignment = NSTextAlignmentCenter;
            field.leftView = label;
        }else if ([leftItem isKindOfClass:[NSAttributedString class]]) {
            NSAttributedString *attributed = leftItem;
            CGFloat textWidth = [attributed.string getWidthToMaxHeight:frame.size.height font:font];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, textWidth + 10, frame.size.height)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor lightGrayColor];
            label.font = font;
            label.attributedText = attributed;
            field.leftView = label;
        }else if ([leftItem isKindOfClass:[UIImage class]]) {
            UIImage *leftImage = leftItem;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, leftView.frame.size.width-16, leftView.frame.size.height-16)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            imageView.image = leftImage;
            [leftView addSubview:imageView];
            field.leftView = leftView;
        }else if ([leftItem isKindOfClass:[NSArray class]]) {
            UIImage *image = leftItem[0];
            NSString *leftText = leftItem[1];
            CGFloat textWidth = [leftText getWidthToMaxHeight:frame.size.height font:font];
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textWidth+32, frame.size.height)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, (frame.size.height-20)/2., 20, 20)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            imageView.image = image;
            [leftView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, textWidth, frame.size.height)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = textColor;
            label.font = font;
            label.text = leftText;
            label.textAlignment = NSTextAlignmentLeft;
            [leftView addSubview:label];
            
            field.leftView = leftView;
        }
    }
    
    return field;
}

+ (UITextField *)creatLoginFieldWithFrame:(CGRect)frame text:(NSString *)text placeholder:(NSString *)placeholder textFont:(UIFont *)font textColor:(UIColor *)textColor keyboardType:(UIKeyboardType)keyboardType textAlignment:(NSTextAlignment)textAlignment leftItem:(id)leftItem delegate:(id<UITextFieldDelegate>)delegate {
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.text = text;
    field.textColor = textColor;
    field.font = font;
    field.placeholder = placeholder;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.keyboardType = keyboardType;
    field.returnKeyType = UIReturnKeyDone;
    field.textAlignment = textAlignment;
    field.delegate = delegate;
    //    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:WhiteColor}];
    //    field.attributedPlaceholder = placeholder1;
    
    if (leftItem) {
        field.leftViewMode = UITextFieldViewModeAlways;
        if ([leftItem isKindOfClass:[NSString class]]) {
            NSString *leftText = leftItem;
            CGFloat textWidth = [leftText getWidthToMaxHeight:frame.size.height font:font];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, textWidth + 10, frame.size.height)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = textColor;
            label.font = font;
            label.text = leftText;
            label.textAlignment = NSTextAlignmentCenter;
            field.leftView = label;
        }else if ([leftItem isKindOfClass:[UIImage class]]) {
            UIImage *leftImage = leftItem;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, leftView.frame.size.width-20, leftView.frame.size.height-20)];
            imageView.image = leftImage;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [leftView addSubview:imageView];
            field.leftView = leftView;
        }
    }
    
    return field;
}

@end
