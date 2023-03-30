//
//  MBProgressHUD+XQLoad.m
//  Demo
//
//  Created by yibingding/王 on 16/10/17.
//  Copyright © 2016年 yibingding.com. All rights reserved.
//

#import "MBProgressHUD+Load.h"

@implementation MBProgressHUD (Load)
/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)delay {
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //hud.labelText = text;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    //设置菊花框为白色
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].tintColor=[UIColor whiteColor];
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color=[UIColor whiteColor];
    hud.tintColor = [UIColor whiteColor];
    hud.contentColor = [UIColor whiteColor];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.detailsLabel.textColor=[UIColor whiteColor];
  
    
    
    hud.square = NO;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:delay];
    //[hud hide:YES afterDelay:delay];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay
{
    [self showSuccess:success toView:nil afterDelay:delay];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)delay {
    [self show:success icon:@"icons8-完成-144" view:view afterDelay:delay];
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error afterDelay:(NSTimeInterval)delay {
    [self showError:error toView:nil afterDelay:delay];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)delay {
    [self show:error icon:nil view:view afterDelay:delay];
}

/**
 *  显示错误信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //设置菊花框为白色
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].tintColor=[UIColor whiteColor];
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color=[UIColor whiteColor];
    hud.tintColor = [UIColor whiteColor];
    hud.contentColor = [UIColor whiteColor];
    //hud.labelText = message;
    hud.label.text = message;
    hud.label.textColor=[UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //hud.customView = [[UIView alloc] init];
    //hud.dimBackground = NO;
    return hud;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    [self hideHUDForView:view animated:YES];
}
@end
