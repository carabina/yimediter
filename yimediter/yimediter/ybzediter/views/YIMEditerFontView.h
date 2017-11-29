//
//  YIMEditerFontView.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerView.h"
#import "YIMEditerTextStyle.h"

@class YIMEditerFontView;

@protocol YIMEditerFontViewDelegate <NSObject>
@required
/**当字体样式改变时*/
-(void)fontView:(YIMEditerFontView*)fontView styleDidChange:(YIMEditerTextStyle*)style;
@end

/**
 字体样式选择视图
 */
@interface YIMEditerFontView : YIMEditerView

@property(nonatomic,weak)id<YIMEditerFontViewDelegate> delegate;
@property(nonatomic,strong)YIMEditerTextStyle *textStyle;

@end
