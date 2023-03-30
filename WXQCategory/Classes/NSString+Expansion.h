//
//  NSString+Expansion.h
//  Test
//
//  Created by ybd on 2019/4/26.
//  Copyright © 2019 ybd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Expansion)

/**
 * 获取APP版本号
 *
 * @return 返回版本号
 */
+ (NSString *)appVersion;

/**
 * 获取APP名称
 *
 * @return 返回APP名称
 */
+ (NSString *)appName;

#pragma mark - 基础判断

/**
 *  将 nil 的字符串转 @""
 *
 *  @return 将 nil 的字符串转 @""
 */
- (NSString *)emptyStringByWhitespace;

/**
 * 判断是否是字符串
 *
 * @return YES or NO
 */
- (BOOL)isString;

/**
 * 判断是否是空字符串
 *
 * @return YES or NO
 */
- (BOOL)isEmptyString;

/**
 * 去掉空格
 *
 * @return 去除空格后的字符串
 */
- (NSString *)removeSpaces;

- (NSString *)stringRemoveBlank;

/**
 *  字符串转UTF-8
 *
 *  @return UTF-8 后的字符串
 */
- (NSString *)getUTF8;

/**
 * 字符串转data
 *
 * @return data
 */
- (NSData *)stringTurnData;

#pragma mark - 字符串加密解密

/**
 * base64加密
 *
 * @return 加密后的base64字符串
 */
- (NSString *)base64Encrypt;

/**
 * base64解密
 *
 * @return 解密后的字符串
 */
- (NSString *)base64Decrypt;

/**
 * AES加密
 *
 * @param key 加密的key
 * @return 加密后的字符串
 */
- (NSString *)aesEncrypyForKey:(NSString *)key;

/**
 * AES解密
 *
 * @param key 加密的key
 * @return 解密后的字符串
 */
- (NSString *)aesDecrypyForKey:(NSString *)key;

/**
 * MD5加密
 *
 * @return MD5加密之后的字符串
 */
- (NSString *)stringMD5;

/**
 md5加密区分32、16位与大小写

 @param bateNum 填32即32位md5，16或32之外的即16位md5
 @param isLowercaseStr YES即小写，NO即大写
 @return md5加密后的字符串
 */
- (NSString *)bateNum:(NSInteger)bateNum isLowercaseStr:(BOOL)isLowercaseStr;


#pragma mark - 常用正则表达式判断

/**
 * 判断是否是标准邮箱
 *
 * @return YES or NO
 */
-(BOOL)isValidateEmail;

/**
 * 判断是否是标准的URL
 *
 * @return YES or NO
 */
- (BOOL)isValidateURL;

/**
 * 判断是否是标准的电话号码（注：该方法只支持中国大陆地区标准电话号码）
 *
 * @return YES or NO
 */
- (BOOL)isValidatePhone;

/**
 * 判断是否是标准的身份证号 (注：该方法只支持中国大陆地区身份证号）
 *
 * @return YES or NO
 */
- (BOOL)isValidateIdentityCard;

/**
 * 判断是否是标准的车牌号 (注：该方法只支持中国大陆地区车牌号）
 *
 * @return YES or NO
 */
- (BOOL)isValidateCarNo;

///**
// * 判断输入的密码是否符合规则（默认为6~20位字母加数字组合）
// *
// * @return YES or NO
// */
- (BOOL)isValidatePassword;

#pragma mark - 字符串和时间之间的转化

/**
 * 获取系统时间
 *
 * @return 返回获取系统时间（格式为：yyyy-MM-dd HH:mm:ss）
 */
+ (NSString *)getSystemDate;

/**
* 获取系统时间
*
* @return 返回获取系统时间（格式为：yyyy-MM-dd）
*/
+ (NSString *)getSystemDateWithYMD;

/**
 * 时间字符串转xx前（注：时间格式必须为“yyyy-MM-dd HH:mm:ss”）
 *
 * @return xx前
 */
- (NSString *)dateString;

/**
* 时间格式转换 时间字符串转xx前（注：时间格式必须为“yyyy-MM-dd HH:mm:ss”）
*
* @return 返回时间字符串
*/
- (NSString *)changeTimeFormatter:(NSString *)formatter;
/**
 * 时间戳转时间
 *
 * @return 返回时间（默认时间格式：yyyy-MM-dd HH:mm:ss）
 */
- (NSString *)timeWithTimestamp;

/**
 * 时间戳转时间
 *
 * @return 返回设置的时间格式
 */
- (NSString *)timeWithTimestampWithFormatter:(NSString *)dateFormatter;

/**
 时间格式转换 (调用格式为：yyyy-MM-dd HH:mm:ss)
 *
 * @param formart 需要显示的格式
 * @return 返回设置的时间格式
 */
- (NSString *)dateFormart:(NSString *)formart;
+ (NSString *)getSystemDateWithFormatter:(NSString *)formatter;
- (NSDate *)getDateWithFormatter:(NSString *)formatter;
/**
 * 计算星座 (调用格式为：yyyy-MM-dd HH:mm:ss)
 *
 * @return 星座
 */
- (NSString *)getConstellation;

#pragma mark - 数据转换

/**
 * 字典，数组转JSON
 *
 * @param object 需要转换的对象
 * @return 返回JSON
 */
+ (NSString *)convertToJsonData:(id)object;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;

/**
 * 数字转汉语数字
 *
 * @return 汉语数字
 */
- (NSString *)digitalToChineseDigital;

/**
 * 单位米转千米
 *
 @return 返回“xxm”,“xxkm”
 */
- (NSString *)meterToKm;

/**
 * 若商品金额大于一万则转化为万元
 *
 * @return 返回“xx万”
 */
- (NSString *)yuanToMillionYuan;

#pragma mark - 计算字符串宽高

/**
 * 计算字符串宽高
 *
 * @param size 最大宽高
 * @param attributes 富文本属性
 * @return 返回字符串宽高
 */
- (CGSize)getSize:(CGSize)size attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes;

/**
 * 计算字符串宽高
 *
 * @param size 最大宽高
 * @param font 字体
 * @return 返回字符串宽高
 */
- (CGSize)getSize:(CGSize)size font:(UIFont *)font;

/**
 * 计算字符的宽
 *
 * @param maxHeight 最大高度
 * @param font 字体
 * @return 返回字符串宽
 */
- (CGFloat)getWidthToMaxHeight:(CGFloat)maxHeight font:(UIFont *)font;

/**
 * 计算字符的高
 *
 * @param maxWidth 最大宽度
 * @param font 字体
 * @return 返回字符串高
 */
- (CGFloat)getHeightToMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;

#pragma mark - 获取沙盒路径

/**
 * 获取tmp
 *
 * @return 路径
 */
+ (NSString *)getApplicationTmpPath;

/*
 * 获取Documents路径
 *
 * @return 路径
 */
+ (NSString *)getApplicationDocumentPath;

/*
 * 获取沙盒 Cache
 *
 * @return 路径
 */
+ (NSString *)getApplicationCachePath;

#pragma mark - 其他

/**
 * 替换手机号（隐藏手机号中间四位）
 *
 * @return 替换后的手机号
 */
- (NSString *)replacingPhone;

/**
 * 段前空两格
 *
 * @return 字符串
 */
- (NSString *)emptyBeforeParagraph;

/**
 *  拨打电话
 */
- (BOOL)callPhone;

/**
* 行间距设置
*
@return NSAttributedString
*/
- (NSAttributedString *)getAttributedStringWithLineSpace:(CGFloat)lineSpace;

/**
* 行数
*
@return NSInteger
*/
- (NSInteger)getLabelStringRowCountWithWidth:(CGFloat)width font:(UIFont *)font;

- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font;

- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font;

- (CGSize)singleLineSizeWithText:(UIFont *)font;

- (NSString *)md5;

- (NSURL *)urlScheme:(NSString *)scheme;

+ (NSString *)formatCount:(NSInteger)count;


+ (NSString *)currentTime;
/*
 根据时间动态生成文件名称
 */
+ (NSString *)getFileNameBySystemDate;
/*
 字符中数字变色
 */
- (NSMutableAttributedString *)modifyDigitalColor:(UIColor *)color normalColor:(UIColor *)normalColor;

#pragma mark  密码强度判断
+(NSString*)isValidataPassword:(NSString*)password;
+ (NSString *)autoImageJS:(NSString *)content webWidth:(float)webWidth;
#pragma mark  删除HTML标签
+ (NSString *)deleteHtmlTag:(NSString*)html;
@end

NS_ASSUME_NONNULL_END
