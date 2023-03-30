//
//  UITextField+Creat.m
//  Test
//
//  Created by ybd on 2019/4/30.
//  Copyright © 2019 ybd. All rights reserved.
//

#import "UITextField+Valid.h"
#import "NSString+Expansion.h"
#import <objc/runtime.h>

static const void *stylePropertyKey = &stylePropertyKey;
static const void *numberPropertyKey = &numberPropertyKey;
static const void *limitPropertyKey = &limitPropertyKey;
static const void *phonePropertyKey = &phonePropertyKey;

@implementation UITextField (Valid)

- (void)setPhone:(NSString *)phone{
    objc_setAssociatedObject(self, phonePropertyKey, phone, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString*)phone {
    return [self.text stringRemoveBlank];
}
- (void)setStyle:(UITextFieldViewStyle)style {
    objc_setAssociatedObject(self, stylePropertyKey, [NSNumber numberWithInteger:style], OBJC_ASSOCIATION_ASSIGN);
}

- (UITextFieldViewStyle)style {
    return [objc_getAssociatedObject(self, stylePropertyKey) integerValue];
}

- (void)setNumber:(NSUInteger)number{
    objc_setAssociatedObject(self, numberPropertyKey, [NSNumber numberWithInteger:number], OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)number {
    return [objc_getAssociatedObject(self, numberPropertyKey) integerValue];
}

- (void)setLimit:(NSUInteger)limit {
    objc_setAssociatedObject(self, limitPropertyKey, [NSNumber numberWithInteger:limit], OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)limit {
    return [objc_getAssociatedObject(self, limitPropertyKey) integerValue];
}

- (void)loadStyle:(UITextFieldViewStyle)style decimalNumber:(NSInteger)number limit:(NSUInteger)limit{
    self.style=style;
    self.limit=limit;
    self.number=number;
    self.delegate=self;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    switch (self.style) {
        case UITextFieldViewStyleText:{
            return [self qd_isValidCharacter:range replacementString:string limit:self.limit];
        }
            break;
        case UITextFieldViewStyleNumber:{
            return [self qd_isValidNember:range replacementString:string limit:self.limit];
        }
            break;
        case UITextFieldViewStyleDecimalNumber:{
            return [self qd_isValidShouldChangeCharactersInRange:range replacementString:string decimalNumber:self.number limit:self.limit];
        }
            break;
        case UITextFieldViewStylePhone:{
            return [self qd_formatPhoneWithRange:range replacementString:string];
        }
            break;
        default:
            break;
    }
    return YES;
}


- (BOOL)qd_isValidShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string decimalNumber:(NSInteger)number limit:(NSUInteger)limit {
    NSScanner      *scanner    = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers;
    NSRange         pointRange = [self.text rangeOfString:@"."];
    
    if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) ){
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        
    }else{
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        
    }
    if ( [self.text isEqualToString:@""] && [string isEqualToString:@"."] ){
        self.text = @"0.";
        return NO;
    }
    short remain = number; //保留 number位小数
    NSString *tempStr = [self.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
        if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
            return NO;
        }
        if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
            return NO;
        }
    }
    NSRange zeroRange = [self.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
        if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [self.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
            self.text = string;
            return NO;
        }else{
            if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                if([string isEqualToString:@"0"]){
                    return NO;
                }
            }
        }
    }
    
    NSString *buffer;
    if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) ){
        return NO;
    }
    
    ///拼接了参数string的afterStr
    NSString *afterStr = [self.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger maxLimit = limit;
    
    
    if((pointRange.length > 0 && pointRange.location > 0) || [string isEqualToString:@"."]) { // 判断输入框内已经有"."或者正在输入"."
        maxLimit = number + 1;
    }
    ///限制长度
    if (afterStr.length > maxLimit) {
        self.text = [afterStr substringToIndex:maxLimit];
        return NO;
    }
    return YES;
}


- (BOOL)qd_isValidNember:(NSRange)range replacementString:(NSString *)string limit:(NSUInteger)limit {
    NSString *text = self.text;
    if (!text) {
        return NO;
    }
    
    ///拼接了参数string的afterStr
    NSString *afterStr = [text stringByReplacingCharactersInRange:range withString:string];
    ///限制长度
    if (afterStr.length > limit) {
        self.text = [afterStr substringToIndex:limit];
        return NO;
    }
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"].invertedSet;
    NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    if ([string isEqualToString:filteredStr]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)qd_isValidCharacter:(NSRange)range replacementString:(NSString *)string limit:(NSUInteger)limit {
    NSString *text = self.text;
    if (!text) {
        return NO;
    }
    
    ///拼接了参数string的afterStr
    NSString *afterStr = [text stringByReplacingCharactersInRange:range withString:string];
    ///限制长度
    if (afterStr.length > limit) {
        self.text = [afterStr substringToIndex:limit];
        return NO;
    }
    return YES;
}

- (BOOL)qd_formatPhoneWithRange:(NSRange)range replacementString:(NSString *)string {
    
    //    NSString *text = self.text;
    
    if (self.text.length == 13 && range.length == 0) {
        return NO;
    }
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableString *mStr = [NSMutableString stringWithString:self.text];
    // 删减字符
    if(string.length == 0 && range.location < self.text.length) {
        NSString *removeTemp = [self.text substringWithRange:NSMakeRange(range.location, range.length)];
        
        NSString *removeTempFontier = @"";
        if(range.location >= 1) {
            removeTempFontier = [self.text substringWithRange:NSMakeRange(range.location - 1, range.length)];
        }
        if(![removeTemp isEqualToString:@" "]) {
            [mStr deleteCharactersInRange:NSMakeRange(range.location, range.length)];
            NSMutableString *tempMutableStr = [NSMutableString stringWithString:[mStr stringRemoveBlank]];
            
            if(tempMutableStr.length >= 4) {
                [tempMutableStr insertString:@" " atIndex:3];
            }
            if(tempMutableStr.length >= 9) {
                [tempMutableStr insertString:@" " atIndex:8];
            }
            
            [self setText:tempMutableStr];
        }
        
        // 判断当前位置往前一个字符是否为空格
        if([removeTempFontier isEqualToString:@" "]) {
            [self qd_setTextRangeWithOffset:range.location - 1];
        } else {
            [self qd_setTextRangeWithOffset:range.location];
        }
        return NO;
    }
    
    // 输入字符
    if(string.length >0) {
        [mStr deleteCharactersInRange:NSMakeRange(range.location, range.length)];
        NSUInteger location = range.location + 1;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\\b"];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        if(location==1&&![string isEqualToString:@"1"]){
            return NO;
        }
        
        
        if(range.location == 3 || range.location == 8) {
            location += 1;
        }
        
        [mStr insertString:string atIndex:range.location];
        // 每次输入都先清除空格
        NSMutableString *noBlankString = [NSMutableString stringWithString:[mStr stringRemoveBlank]];
        
        // 插入空格
        if(noBlankString.length >= 4 && noBlankString.length < 8) {
            [noBlankString insertString:@" " atIndex:3];
        } else if(noBlankString.length > 7) {
            [noBlankString insertString:@" " atIndex:3];
            [noBlankString insertString:@" " atIndex:8];
        }
        [self setText:noBlankString];
        
        [self qd_setTextRangeWithOffset:location];
        return NO;
    }
    return YES;
    
    
    
}

- (void)qd_setTextRangeWithOffset:(NSUInteger)offset {
    UITextPosition* beginning = self.beginningOfDocument;
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:offset];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:offset];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}


@end
