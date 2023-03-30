//
//  UITableView+Extend.h
//  ColorfulVideo
//
//  Created by 王旗 on 2021/8/24.
//  Copyright © 2021 万宇智能. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Extend)

/// 给cell画圆角 (注：需要在“tableView:willDisplayCell:forRowAtIndexPath:”里面调用该方法）
/// @param cell cell
/// @param indexPath indexPath
/// @param cornerRadius 圆角
/// @param fillColor 填充色
/// @param topBottomMargin 上下间距
/// @param leftRightMargin 左右间距
- (void)drawCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath cornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor topBottomMargin:(CGFloat)topBottomMargin leftRightMargin:(CGFloat)leftRightMargin;


@end

NS_ASSUME_NONNULL_END
