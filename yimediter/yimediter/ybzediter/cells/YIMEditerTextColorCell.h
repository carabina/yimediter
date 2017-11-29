//
//  YIMEditerTextColorCell.h
//  yimediter
//
//  Created by ybz on 2017/11/23.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyleBaseCell.h"

@interface YIMEditerTextColorCell : YIMEditerStyleBaseCell

@property(nonatomic,strong)UIColor *color;

@property(nonatomic,copy)void(^colorChangeBlock)(UIColor *color);

@end
