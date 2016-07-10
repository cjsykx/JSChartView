//
//  NSString+Extension.m
//  QQChat
//
//  Created by administrator on 15-1-30.
//  Copyright (c) 2015年 Cjs. All rights reserved.
//+------------------------------------------------------------
// 工具类，用来获得处理后的文字高度和宽度(size)
//+------------------------------------------------------------
// 主要接口
//+------------------------------------------------------------

#import "NSString+Extension.h"

@implementation NSString (Extension)
/**
 *  得到 字体 size
 */
- (CGSize) sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize{
    
    NSDictionary *attr = @{NSFontAttributeName : font };
    
    return   [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;


}


/**
 *  是否为中文
 */
-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

@end
