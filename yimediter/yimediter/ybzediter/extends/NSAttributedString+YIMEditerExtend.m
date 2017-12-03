//
//  NSAttributedString+YIMEditerExtend.m
//  yimediter
//
//  Created by ybz on 2017/12/3.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSAttributedString+YIMEditerExtend.h"

@implementation NSAttributedString (YIMEditerExtend)

/**
 这里只是针对已有的YIMEditerTextStyle和YIMEditerParagraphStyle的属性进行html转换   如果有自定义的样式需要自己修改代码

 @return html
 */
-(NSString*)htmlString{
    NSMutableString* htmlString = [NSMutableString string];
    
    BOOL isNewParagraph = true;
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < self.length) {
        NSDictionary *attributes = [self attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        
        if (isNewParagraph) {
            if ([attributes.allKeys containsObject:NSParagraphStyleAttributeName]) {
                NSParagraphStyle *paragraphStyle = [attributes objectForKey:NSParagraphStyleAttributeName];
                NSMutableString *paragraphClassString = [NSMutableString string];
                
                
            }else{
                [htmlString appendString:@"<p>"];
            }
        }
        
        
        
        
    }
    
    return htmlString;
}

@end
