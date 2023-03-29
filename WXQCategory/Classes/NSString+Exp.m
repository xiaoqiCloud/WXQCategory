//
//  NSString+Expansion.m
//  Test
//
//  Created by ybd on 2019/4/26.
//  Copyright © 2019 ybd. All rights reserved.
//

#import "NSString+Exp.h"
#import <CommonCrypto/CommonCryptor.h>
#import "CommonCrypto/CommonDigest.h"
#import "NSData+Exp.h"
#import <CoreText/CTFramesetter.h>
#import <CoreText/CTFont.h>
#import <CoreText/CTStringAttributes.h>

@implementation NSString (Exp)

+ (NSString *)qd_appVersion {
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)qd_appName {
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
}

#pragma mark - 基础判断

- (NSString *)qd_emptyStringByWhitespace {
    if (![self qd_isString] && [self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",self];
}

- (BOOL)qd_isString {
    return [self isKindOfClass:[NSString class]];
}

- (BOOL)qd_isEmptyString {
    if ([[self qd_emptyStringByWhitespace] isEqualToString:@""] || [self qd_emptyStringByWhitespace].length == 0 || [[self qd_emptyStringByWhitespace] isEqualToString:@"null"] || [[self qd_emptyStringByWhitespace] isEqualToString:@"<null>"] || [[self qd_emptyStringByWhitespace] isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

- (NSString *)qd_removeSpaces {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString *)qd_stringRemoveBlank {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)qd_getUTF8 {
    return [[self qd_emptyStringByWhitespace] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSData *)qd_stringTurnData {
    return [[self qd_emptyStringByWhitespace] dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - 字符串加密解密

- (NSString *)qd_base64Encrypt {
    return [[[self qd_emptyStringByWhitespace] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)qd_base64Decrypt {
    NSData * baseStrData = [[NSData alloc] initWithBase64EncodedString:[self qd_emptyStringByWhitespace] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc]initWithData:baseStrData encoding:NSUTF8StringEncoding];
}

- (NSString *)qd_aesEncrypyForKey:(NSString *)key {
    NSString *value = self;
    //    if (value.length>15) {
    //        value = [value substringToIndex:15];
    //    }
    NSData *data = [[value qd_emptyStringByWhitespace] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [[data qd_aes256EncryptWithKey:key] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    result=[result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    result=[result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"\n加密值------%@\n加密key------%@\n加密结果------%@",value,@"bWFsbHB3ZA==WNST",result);
    return result;
}

- (NSString *)qd_aesDecrypyForKey:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:[self qd_emptyStringByWhitespace] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:[data qd_aes256DecryptWithKey:key] encoding:NSUTF8StringEncoding];
}

- (NSString *)qd_stringMD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

- (NSString *)qd_bateNum:(NSInteger)bateNum isLowercaseStr:(BOOL)isLowercaseStr {
    NSString *md5Str = nil;
    const char *input = [self UTF8String];//UTF8转码
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digestStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];//直接先获取32位md5字符串,16位是通过它演化而来
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digestStr appendFormat:isLowercaseStr ? @"%02x" : @"%02X", result[i]];//%02x即小写,%02X即大写
    }
    if (bateNum == 32) {
        md5Str = digestStr;
    } else {
        for (int i = 0; i < 24; i++) {
            md5Str = [digestStr substringWithRange:NSMakeRange(8, 16)];
        }
    }
    return md5Str;
}

#pragma mark - 常用正则表达式判断

-(BOOL)qd_isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:[self qd_emptyStringByWhitespace]];
}

- (BOOL)qd_isValidateURL {
    NSString *phoneNumberRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumberRegex];
    BOOL B = [userNamePredicate evaluateWithObject:[self qd_emptyStringByWhitespace]];
    return B;
}

- (BOOL)qd_isValidatePhone {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"1[3|4|5|6|7|8|9][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:[self qd_emptyStringByWhitespace]];
}

- (BOOL)qd_isValidateIdentityCard {
    /*
     18位的身份证正则：
     [1-9]\d{5}                 前六位地区，非0打头
     (18|19|([23]\d))\d{2}      出身年份，覆盖范围为 1800-3999 年
     ((0[1-9])|(10|11|12))      月份，01-12月
     (([0-2][1-9])|10|20|30|31) 日期，01-31天
     \d{3}[0-9Xx]：              顺序码三位 + 一位校验码
     ————————————————
     */
    NSString *regex2 = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:[self qd_emptyStringByWhitespace]];
}

- (BOOL)qd_isValidateCarNo {
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:[self qd_emptyStringByWhitespace]];
}

//
//- (BOOL)qd_isValidatePassword {
//    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
//    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
//    return [passWordPredicate evaluateWithObject:[self qd_emptyStringByWhitespace]];
//}

#pragma mark - 字符串和时间之间的转化

+ (NSString *)qd_getSystemDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getSystemDateWithYMD {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)qd_dateString {
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dataFormatter dateFromString:[self qd_emptyStringByWhitespace]];
    if (!date) {
        return @"";
    }
    int minites = [[NSDate date] timeIntervalSinceDate:date]/60;
    if (minites <= 0 && minites < 1) {
        return @"刚刚";
    }else if (minites < 60) {
        //不到一小时
        return [NSString stringWithFormat:@"%d分钟前",minites];
        
    }else if(minites < 60 * 24) {
        //不到一天
        return [NSString stringWithFormat:@"%d小时前",minites / 60];
    }else if(minites < 60 * 24 * 3) {
        //不大于三天
        return [NSString stringWithFormat:@"%d天前",minites / 60 / 24];
        
    }else {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        
        if ([components year] == [today year]) {
            // 今年
            [dataFormatter setDateFormat:@"MM-dd"];
            return [dataFormatter stringFromDate:date];
        }else {
            // 往年
            [dataFormatter setDateFormat:@"yyyy-MM-dd"];
            return [dataFormatter stringFromDate:date];
        }
    }
}

- (NSString *)qd_changeTimeFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[self qd_emptyStringByWhitespace]];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:date];
}

- (NSString *)qd_timeWithTimestamp {
    return [self qd_timeWithTimestampWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)qd_timeWithTimestampWithFormatter:(NSString *)dateFormatter {
    NSString *timestamp = [self qd_emptyStringByWhitespace];
    if ([timestamp qd_isEmptyString]) {
        return @"1970-01-01";
    }
    NSTimeInterval imterval = [timestamp doubleValue]/1000;///1000.f;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:imterval];
    NSDateFormatter *dateFormart = [[NSDateFormatter alloc] init];
    [dateFormart setDateFormat:dateFormatter];
    return [dateFormart stringFromDate:date];
}

- (NSString *)qd_dateFormart:(NSString *)formart {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *currentDate = [dateFormatter dateFromString:[self qd_emptyStringByWhitespace]];
    [dateFormatter setDateFormat:formart];
    return [dateFormatter stringFromDate:currentDate];
}
- (NSDate *)qd_getDateWithFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:self];
}
+ (NSString *)qd_getSystemDateWithFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:[NSDate date]];
}
- (NSString *)qd_getConstellation {
    
    NSString *timeString = [[self qd_emptyStringByWhitespace] qd_dateFormart:@"MM-dd"];
    NSArray *tmpArray = [timeString componentsSeparatedByString:@"-"];
    NSInteger month = [[tmpArray firstObject] integerValue];
    NSInteger day = [[tmpArray lastObject] integerValue];
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (month<1||month>12||day<1||day>31){
        return @"错误日期格式!";
    }
    if(month==2 && day>29){
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
}

#pragma mark - 数据转换

+ (NSString *)qd_convertToJsonData:(id)object {
    if (!object) {
        return @"";
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    [mutStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return mutStr;
}

+ (NSDictionary *)qd_dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)qd_digitalToChineseDigital {
    
    //NSString *str = [NSString stringWithFormat:@"%d",self];
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < [self qd_emptyStringByWhitespace].length; i ++) {
        NSString *substr = [[self qd_emptyStringByWhitespace] substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[[self qd_emptyStringByWhitespace].length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]]) {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]]) {
                    [sums removeLastObject];
                }
            }else {
                sum = chinese_numerals[9];
            }
            if ([[sums lastObject] isEqualToString:sum]) {
                continue;
            }
        }
        [sums addObject:sum];
    }
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    return chinese;
}

- (NSString *)qd_meterToKm {
    
    CGFloat m = [self qd_emptyStringByWhitespace].floatValue;
    if (m < 1000.) {
        return [NSString stringWithFormat:@"%dm",(int)m];
    }else {
        return [NSString stringWithFormat:@"%.2fkm",m/1000.];
    }
}

- (NSString *)qd_yuanToMillionYuan {
    if ([self qd_isEmptyString]) return self;
    CGFloat yuan = [self qd_emptyStringByWhitespace].floatValue;
    if (yuan < 10000.f) {
        return [NSString stringWithFormat:@"%.2f",yuan];
    }else {
        return [NSString stringWithFormat:@"%.2f万",yuan/10000.];
    }
}

#pragma mark - 计算字符串宽高

- (CGSize)qd_getSize:(CGSize)size attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes {
    return [[self qd_emptyStringByWhitespace] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

- (CGSize)qd_getSize:(CGSize)size font:(UIFont *)font {
    return [self qd_getSize:size attributes:@{NSFontAttributeName:font}];
}

- (CGFloat)qd_getWidthToMaxHeight:(CGFloat)maxHeight font:(UIFont *)font {
    return [self qd_getSize:CGSizeMake(MAXFLOAT, maxHeight) font:font].width;
}

- (CGFloat)qd_getHeightToMaxWidth:(CGFloat)maxWidth font:(UIFont *)font {
    return [self qd_getSize:CGSizeMake(maxWidth, MAXFLOAT) font:font].height;
}

#pragma mark - 获取沙盒路径

+ (NSString *)qd_getApplicationTmpPath {
    return NSTemporaryDirectory();
}

+ (NSString *)qd_getApplicationDocumentPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)qd_getApplicationCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark - 其他

- (NSString *)qd_replacingPhone {
    if (![self qd_isValidatePhone]) return self;
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

- (NSString *)qd_replacingBankCard {
    if (self.length < 8) return self;
    NSString *leftStr = [self substringToIndex:4];
    NSString *rightStr = [self substringWithRange:NSMakeRange(self.length-4, 4)];
    return [NSString stringWithFormat:@"%@ **** **** %@",leftStr,rightStr];
}

- (NSString *)qd_emptyBeforeParagraph {
    NSString *content=[NSString stringWithFormat:@"\t%@",self];
    content=[content stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    return [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}

- (BOOL)qd_callPhone {
    if ([self qd_isEmptyString]) {
        //YBDShowErrorLoading(@"暂无法联系当前联系人");
        return NO;
    }
    NSString *mode = [[UIDevice currentDevice].model substringWithRange:NSMakeRange(0, 4)];
    if ([mode isEqualToString:@"iPad"]||[mode isEqualToString:@"ipod"]||[mode isEqualToString:@"iPod"]){
        //YBDShowErrorLoading(@"该设备不可拨打电话");
        return NO;
    }else {
        if (@available(iOS 10.0, *)) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
                //OpenSuccess=选择 呼叫 为 1  选择 取消 为0
                NSLog(@"OpenSuccess=%d",success);
            }];
        } else {
            // Fallback on earlier versions
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        return YES;
    }
}

#pragma mark --- 行间距设置
- (NSAttributedString *)qd_getAttributedStringWithLineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, self.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

#pragma mark --- 行数
- (NSInteger)qd_getLabelStringRowCountWithWidth:(CGFloat)width font:(UIFont *)font {
    
    //CGSize textMaxSize = CGSizeMake(width, MAXFLOAT);
    CGFloat textH = [self qd_getHeightToMaxWidth:width font:font];
    
    NSNumber *count = @((textH) / font.lineHeight);
    //NSLog(@"共 %td 行", [count integerValue]);
    return [count integerValue];
}

#pragma mark --- 图片地址拼接
+ (NSString *)qd_stringWithImagePath:(NSString *)path {
    if ([path hasPrefix:@"http"]) {
        return path;
    }else {
        return @"";//[NSString stringWithFormat:@"%@%@",BaseUrl,path];
    }
}


//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)qd_singleLineSizeWithAttributeText:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}

//固定宽度计算多行文本高度，支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围、
- (CGSize)qd_multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineBreakMode, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    //  Create an empty mutable string big enough to hold our test
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    //  Inject our text into it
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    //  Apply our font and line spacing attributes over the span
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(width, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    
    return size;
}

//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。
- (CGSize)qd_singleLineSizeWithText:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (NSString *) qd_md5 {
    const char *str = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( str, (CC_LONG)strlen(str), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

- (NSURL *)qd_urlScheme:(NSString *)scheme {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:self] resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    return [components URL];
}

+ (NSString *)qd_formatCount:(NSInteger)count {
    if(count < 10000) {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }else {
        return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
    }
}


+ (NSString *)qd_currentTime {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time * 1000];
    return timeString;
}
/*
 根据时间动态生成文件名称
 */
+ (NSString *)qd_getFileNameBySystemDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
- (NSMutableAttributedString *)qd_modifyDigitalColor:(UIColor *)color normalColor:(UIColor *)normalColor;
{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]\\d*\\.?\\d*)" options:0 error:NULL];
    
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSForegroundColorAttributeName : normalColor}];
    
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName : color} range:ranges[i].range];
    }
    return attStr;
}
#pragma mark  密码强度判断
+(NSString*)qd_isValidataPassword:(NSString*)password{
    if (password.length<6||password.length>16) {
        return @"密码长度必须为8~16位";
    }
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    //    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    //    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    NSString* result1 = [NSString stringWithFormat:@"%d",[self qd_judgeRange:termArray1 Password:password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self qd_judgeRange:termArray2 Password:password]];
    //    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:password]];
    //    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    //    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    //    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    
    int intResult=0;
    for (int j=0; j<[resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    if (intResult!=2) {
        return @"密码必须包含字母和数字";
    }
    return @"";
    //    NSString* resultString = [[NSString alloc] init];
    //    if (intResult <2)
    //    {
    //        resultString = @"密码强度低，建议修改";
    //    }
    //    else if (intResult == 2&&[password length]>=6)
    //    {
    //        resultString = @"密码强度一般";
    //    }
    //    if (intResult > 2&&[password length]>=6)
    //    {
    //        resultString = @"密码强度高";
    //    }
    //    return resultString;
}
//判断是否包含

+ (BOOL) qd_judgeRange:(NSArray*)termArray Password:(NSString*)password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[termArray count]; i++)
    {
        range = [password rangeOfString:[termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}
+ (NSString *)qd_autoImageJS:(NSString *)content webWidth:(float)webWidth{
    return [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var myimg,oldwidth;"
                       "var maxwidth = %f;"
                       "for(i=0;i <document.images.length;i++){"
                       "myimg = document.images[i];"
                       "if(myimg.width > maxwidth){"
                       "oldwidth = myimg.width;"
                       "myimg.width = %f;"
                       "}"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
            "</html>",webWidth,webWidth,content];
}
+ (NSString *)qd_deleteHtmlTag:(NSString*)html{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                             options:0
                                              error:nil];
    html=[regularExpretion stringByReplacingMatchesInString:html options:NSMatchingReportProgress range:NSMakeRange(0, html.length) withTemplate:@""];
     return html;
}
@end
