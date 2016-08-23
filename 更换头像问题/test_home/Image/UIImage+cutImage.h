//
//  PersonalCenterViewController.m
//  HC_PromoteBusiness
//
//  Created by ztp on 16/6/29.
//  Copyright © 2016年 ztp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (cutImage)

//颜色转换成图片(带圆角的)
+ (UIImage *)imageWithColor:(UIColor *)color redius:(CGFloat)redius size:(CGSize)size;
//将图片截成圆形图片
+ (UIImage *)imagewithImage:(UIImage *)image;

//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
