//
//  UIColor+YIMEditerExtend.m
//  yimediter
//
//  Created by ybz on 2017/12/3.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "UIColor+YIMEditerExtend.h"

@implementation UIColor (YIMEditerExtend)

-(NSString*)hexString{
    NSString *colorString = [[CIColor colorWithCGColor:self.CGColor] stringRepresentation];
    NSArray *parts = [colorString componentsSeparatedByString:@" "];
    
    NSMutableString *hexString = [NSMutableString stringWithString:@"#"];
    for (int i = 0; i < 3; i ++) {
        [hexString appendString:[NSString stringWithFormat:@"%02X", (int)([parts[i] floatValue] * 255)]];
    }
    return [hexString copy];
}

@end
