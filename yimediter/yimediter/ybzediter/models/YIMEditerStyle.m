//
//  YIMEditerStyle.m
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyle.h"
#import "YIMEditerDrawAttributes.h"

@implementation YIMEditerStyle

+(instancetype)createDefualtStyle{
    return [self init];
}
-(instancetype)initWithAttributed:(YIMEditerDrawAttributes *)attributed{
    return [super init];
}
-(YIMEditerDrawAttributes*)outPutAttributed{
    YIMEditerDrawAttributes *att = [[YIMEditerDrawAttributes alloc]init];
    return att;
}

-(instancetype)copyWithZone:(NSZone *)zone{
    return [[YIMEditerStyle alloc]init];
}
-(instancetype)copy{
    return [[YIMEditerStyle alloc]init];
}

@end
