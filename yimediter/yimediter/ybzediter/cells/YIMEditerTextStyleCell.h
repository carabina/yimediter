//
//  YIMEditerTextStyleCell.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyleBaseCell.h"

@interface YIMEditerTextStyleCell : YIMEditerStyleBaseCell

@property(nonatomic,assign)BOOL isBold;
@property(nonatomic,assign)BOOL isItalic;
@property(nonatomic,assign)BOOL isUnderline;

@property(nonatomic,copy)void(^boldChangeBlock)(BOOL isSelected);
@property(nonatomic,copy)void(^italicChangeBlock)(BOOL isSelected);
@property(nonatomic,copy)void(^underlineChangeBlock)(BOOL isSelected);

@end
