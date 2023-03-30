//
//  MBProgressHUD+XQLoad.h
//  Demo
//
//  Created by yibingding/王 on 16/10/17.
//  Copyright © 2016年 yibingding.com. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Load)

+ (void)showSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (void)showError:(NSString *)error afterDelay:(NSTimeInterval)delay;
+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
