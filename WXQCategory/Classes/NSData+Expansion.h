//
//  NSData+Expansion.h
//  Test
//
//  Created by ybd on 2019/4/27.
//  Copyright © 2019 ybd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Expansion)

/**
 * AES256加密
 *
 * @param key 加密key（注：加密和解密的key必须一样）
 & @return 加密值
 */
- (NSData *)aes256EncryptWithKey:(NSString *)key;

/**
 * AES256解密
 *
 * @param key 解密key（注：加密和解密的key必须一样）
 & @return 解密值
 */
- (NSData *)aes256DecryptWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
