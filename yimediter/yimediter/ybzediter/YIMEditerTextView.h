//
//  YIMEditerTextView.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YIMEditerAccessoryMenuItem;


/**
 YIMEditer的TextView
 */
@interface YIMEditerTextView : UITextView

@property(nonatomic,strong)NSArray<YIMEditerAccessoryMenuItem*>* menus;
/**不要直接使用该textView的delegate，请使用userDelegate*/
@property(nonatomic,strong)id<UITextViewDelegate> userDelegates;

@end
