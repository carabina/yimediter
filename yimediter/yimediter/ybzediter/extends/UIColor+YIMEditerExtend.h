//
//  UIColor+YIMEditerExtend.h
//  yimediter
//
//  Created by ybz on 2017/12/3.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YIMEditerExtend)

-(NSString*)hexString;
+(nonnull UIColor*)colorWithHexString:(NSString*)hexStr;

@end
