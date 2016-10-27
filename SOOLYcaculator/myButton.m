//
//  myButton.m
//  SOOLYcaculator
//
//  Created by SOOLY on 16/6/12.
//  Copyright © 2016年 SOOLY. All rights reserved.
//

#import "myButton.h"
#define R 42
#define G 42
#define B 42
#define RH 252
#define GH 59
#define BH 96
@implementation myButton



-(void)setNumButtonUI{
    [self setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8] forState:UIControlStateNormal];
    [[self titleLabel] setFont:[UIFont systemFontOfSize:30]];
    [self setBackgroundColor:[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]];
//    [self setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]] forState:UIControlStateNormal];
    [self setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:RH/255.0 green:GH/255.0 blue:BH/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [self setAdjustsImageWhenHighlighted:NO];
}

-(void)setOtherButtonUI{
    [self setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4] forState:UIControlStateNormal];
//    [self setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]];
    [self setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:RH/255.0 green:GH/255.0 blue:BH/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [[self titleLabel]setFont:[UIFont systemFontOfSize:30]];
}

//颜色转图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

