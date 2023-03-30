//
//  UIImage+Expansion.m
//  Test
//
//  Created by ybd on 2019/4/26.
//  Copyright © 2019 ybd. All rights reserved.
//

#import "UIImage+Expansion.h"

@implementation UIImage (Expansion)

- (NSString *)base64Encrypt {
    if (self == nil) {
        return @"";
    }
    NSData *data = UIImageJPEGRepresentation(self, .5);
    NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}

+ (UIImage *)getImageToColor:(UIColor *)color {
    return [self getImageToColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)getImageToColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

///将view转化为图片
+ (UIImage *)convertViewToImage:(UIView*)contentView {
    CGSize s =contentView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageBlurLevel:(CGFloat)blur {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage, @"inputRadius", @(blur), nil];
    
    CIImage *outputImage = filter.outputImage;
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    return [UIImage imageWithCGImage:outImage];
}

- (UIImage *)getWaterMarkImageWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    if (font == nil) {
        font = [UIFont systemFontOfSize:23];
    }
    if (color == nil) {
        color = [self mostColor];
    }
    //原始image的宽高
    CGFloat viewWidth = self.size.width;
    CGFloat viewHeight = self.size.height;
    //为了防止图片失真，绘制区域宽高和原始图片宽高一样
    UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
    //先将原始image绘制上
    [self drawInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
    CGFloat sqrtLength = sqrt(viewWidth*viewWidth + viewHeight*viewHeight);
    //文字的属性
    NSDictionary *attr = @{
                           //设置字体大小
                           NSFontAttributeName: font,
                           //设置文字颜色
                           NSForegroundColorAttributeName :color,
                           };
    NSString* mark = title;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
    //绘制文字的宽高
    CGFloat strWidth = attrStr.size.width;
    CGFloat strHeight = attrStr.size.height;
    
    //开始旋转上下文矩阵，绘制水印文字
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将绘制原点（0，0）调整到源image的中心
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
    //以绘制原点为中心旋转
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(kCG_TRANSFORM_ROTATION));
    //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
    // 抗锯齿关闭或开启
    CGContextSetShouldAntialias(context, YES);
    
    //计算需要绘制的列数和行数
    int horCount = sqrtLength / (strWidth + kHORIZONTAL_SPACE) + 1;
    int verCount = sqrtLength / (strHeight + kVERTICAL_SPACE) + 1;
    
    //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
    CGFloat orignX = -(sqrtLength-viewWidth)/2;
    CGFloat orignY = -(sqrtLength-viewHeight)/2;
    
    //在每列绘制时X坐标叠加
    CGFloat tempOrignX = orignX;
    //在每行绘制时Y坐标叠加
    CGFloat tempOrignY = orignY;
    for (int i = 0; i < horCount * verCount; i++) {
        [mark drawInRect:CGRectMake(tempOrignX, tempOrignY, strWidth, strHeight) withAttributes:attr];
        if (i % horCount == 0 && i != 0) {
            tempOrignX = orignX;
            tempOrignY += (strHeight + kVERTICAL_SPACE);
        }else{
            tempOrignX += (strWidth + kHORIZONTAL_SPACE);
        }
    }
    //根据上下文制作成图片
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    return finalImg;
}

//根据图片获取图片的主色调
- (UIColor*)mostColor {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(self.size.width/2, self.size.height/2);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) return nil;
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha>0) {//去除透明
                if (red==255&&green==255&&blue==255) {//去除白色
                }else{
                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
                
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}
- (UIImage *)drawRoundedRectImage:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 1.0f);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:cornerRadius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:CGRectMake(0, 0, width, height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (UIImage *)drawCircleImage {
    CGFloat side = MIN(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), NO, 1.0f);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    CGFloat originX = -(self.size.width - side) / 2.f;
    CGFloat originY = -(self.size.height - side) / 2.f;
    [self drawInRect:CGRectMake(originX, originY, self.size.width, self.size.height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}
+ (UIImage *)getButtonBgImage:(CGSize)size cornerRadius:(CGFloat)cornerRadius{
    UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,size.width,size.height);
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:54/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:54/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:119/255.0 blue:1/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(0.2f),@(1.0f)];
    
    [btnView.layer addSublayer:gl];
    btnView.layer.cornerRadius = cornerRadius;
    btnView.clipsToBounds=YES;
    return [self convertViewToImage:btnView];
}
+ (UIImage *)getBlueButtonBgImage:(CGSize)size cornerRadius:(CGFloat)cornerRadius{
    UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,size.width,size.height);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:147/255.0 green:113/255.0 blue:252/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:83/255.0 green:86/255.0 blue:229/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    [btnView.layer addSublayer:gl];
    btnView.layer.cornerRadius = cornerRadius;
    btnView.clipsToBounds=YES;
    return [self convertViewToImage:btnView];
}
@end
