//
//  YIMEditerTextStyle.m
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "YIMEditerTextStyle.h"
#import "YIMEditerFontFamilyManager.h"
#import "YIMEditerDrawAttributes.h"


@implementation YIMEditerTextStyle




-(instancetype)initWithAttributed:(YIMEditerDrawAttributes *)drawAttributes{
    NSDictionary *attribute = drawAttributes.textAttributed;
    self = [[self class]createDefualtStyle];
    if ([attribute.allKeys containsObject:NSFontAttributeName]) {
        UIFont *font = [attribute objectForKey:NSFontAttributeName];
        UIFontDescriptor *descroptor = font.fontDescriptor;
        BOOL isItalic = descroptor.fontAttributes[@"NSCTFontMatrixAttribute"] != nil;
        
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
        CTFontSymbolicTraits traits = CTFontGetSymbolicTraits(ctFont);
        BOOL isBold = ((traits & kCTFontBoldTrait) == kCTFontBoldTrait);
        CFRelease(ctFont);
        
        self.fontName = font.familyName;
        self.italic = isItalic;
        self.bold = isBold;
        self.fontSize = font.pointSize;
    }
    if ([attribute.allKeys containsObject:NSForegroundColorAttributeName]) {
        self.textColor = [attribute objectForKey:NSForegroundColorAttributeName];
    }
    if ([attribute.allKeys containsObject:NSUnderlineStyleAttributeName]) {
        if ([attribute[NSUnderlineStyleAttributeName] integerValue] == NSUnderlineStyleNone) {
            self.underline = false;
        }else{
            self.underline = true;
        }
    }
    return self;
}
-(YIMEditerDrawAttributes*)outPutAttributed{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSNumber *weight = [NSNumber numberWithFloat:0];
    NSValue *matrix = [NSValue valueWithCGAffineTransform:CGAffineTransformIdentity];
    if (self.bold) {
        weight = [NSNumber numberWithFloat:0.4];
    }
    if (self.italic) {
        matrix = [NSValue valueWithCGAffineTransform:CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0)];
    }
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:
                                        @{
                                          UIFontDescriptorFamilyAttribute:self.fontName,
                                          UIFontDescriptorSizeAttribute:@(self.fontSize),
                                          UIFontDescriptorMatrixAttribute:matrix,
                                          UIFontDescriptorTraitsAttribute:@{UIFontWeightTrait:weight}
                                          }];
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:self.fontSize];
    if (self.underline) {
        [attributes setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    }else{
        [attributes setObject:@(NSUnderlineStyleNone) forKey:NSUnderlineStyleAttributeName];
    }
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:self.textColor forKey:NSForegroundColorAttributeName];
    YIMEditerMutableDrawAttributes *drawAttributes = [[YIMEditerMutableDrawAttributes alloc]init];
    drawAttributes.textAttributed = attributes;
    return drawAttributes;
}

+(instancetype)createDefualtStyle{
    YIMEditerTextStyle *style = [[YIMEditerTextStyle alloc]init];
    style.textColor = [UIColor whiteColor];
    style.fontSize = 16;
    style.fontName = [self styleAllFontName].firstObject;
    style.textColor = [self styleAllColor].firstObject;
    return style;
}
+(NSArray<NSString*>*)styleAllFontName{
    return [[YIMEditerFontFamilyManager defualtManager]allRegistFontName];
}
+(NSArray<UIColor*>*)styleAllColor{
    return @[
             [UIColor blackColor],
             [UIColor colorWithRed:10/255.f green:41/255.f blue:147/255.f alpha:1],
             [UIColor colorWithRed:218/255.f green:101/255.f blue:320/255.f alpha:1],
             [UIColor colorWithRed:135/255.f green:135/255.f blue:135/255.f alpha:1],
             [UIColor colorWithRed:101/255.f green:152/255.f blue:201/255.f alpha:1],
             [UIColor colorWithRed:240/255.f green:200/255.f blue:50/255.f alpha:1],
             [UIColor colorWithRed:103/255.f green:18/255.f blue:124/255.f alpha:1],
             [UIColor colorWithRed:27/255.f green:131/255.f blue:79/255.f alpha:1],
             [UIColor colorWithRed:207/255.f green:7/255.f blue:29/255.f alpha:1],
             [UIColor colorWithRed:163/255.f green:125/255.f blue:207/255.f alpha:1],
             [UIColor colorWithRed:164/255.f green:195/255.f blue:108/255.f alpha:1],
             [UIColor colorWithRed:244/255.f green:169/255.f blue:135/255.f alpha:1],
             ];
}

-(instancetype)copy{
    YIMEditerTextStyle *s = [[YIMEditerTextStyle alloc]init];
    s.textColor = self.textColor;
    s.fontName = self.fontName;
    s.fontSize = self.fontSize;
    s.bold = self.bold;
    s.italic = self.italic;
    s.underline = self.underline;
    return s;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [self copy];
}

@end
