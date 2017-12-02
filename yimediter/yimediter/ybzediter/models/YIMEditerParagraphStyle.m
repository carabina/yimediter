//
//  YIMEditerParagraphStyle.m
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerParagraphStyle.h"
#import "YIMEditerDrawAttributes.h"

@implementation YIMEditerParagraphStyle

-(instancetype)initWithAttributed:(YIMEditerMutableDrawAttributes *)drawAttributed{
    NSDictionary *attributed = drawAttributed.textAttributed;
    self = [[self class]createDefualtStyle];
    if ([attributed.allKeys containsObject:NSParagraphStyleAttributeName]) {
        NSParagraphStyle *s = [attributed objectForKey:NSParagraphStyleAttributeName];
        self.firstLineIndent = s.firstLineHeadIndent > 0;
        self.alignment = s.alignment;
        self.lineSpacing = s.lineSpacing;
    }
    return self;
}
-(YIMEditerDrawAttributes*)outPutAttributed{
    NSMutableParagraphStyle *s = [[NSMutableParagraphStyle alloc]init];
    if(self.firstLineIndent)
        s.firstLineHeadIndent = 28;
    else
        s.firstLineHeadIndent = 0;
    s.alignment = self.alignment;
    s.lineSpacing = self.lineSpacing;
    s.paragraphSpacing = self.lineSpacing;
    YIMEditerMutableDrawAttributes *drawAttributed = [[YIMEditerMutableDrawAttributes alloc]init];
    drawAttributed.textAttributed = @{NSParagraphStyleAttributeName:s};
    drawAttributed.paragraphAttributed = @{NSParagraphStyleAttributeName:s};
    return drawAttributed;
}

+(instancetype)createDefualtStyle{
    YIMEditerParagraphStyle *style = [[YIMEditerParagraphStyle alloc]init];
    style.firstLineIndent = false;
    style.alignment = NSTextAlignmentNatural;
    style.lineSpacing = 7;
    return style;
}

-(BOOL)isParagraphStyle{
    return true;
}

-(instancetype)copy{
    YIMEditerParagraphStyle *paragraphStyle = [[YIMEditerParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = self.lineSpacing;
    paragraphStyle.firstLineIndent = self.firstLineIndent;
    paragraphStyle.alignment = self.alignment;
    return paragraphStyle;
}
-(instancetype)copyWithZone:(NSZone *)zone{
    return [self copy];
}


@end
