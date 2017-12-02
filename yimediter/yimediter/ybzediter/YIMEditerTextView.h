//
//  YIMEditerTextView.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIMEditerProtocol.h"

@class YIMEditerAccessoryMenuItem;


/**
 YIMEditer的TextView
 */
@interface YIMEditerTextView : UITextView

/**菜单栏*/
@property(nonatomic,strong)NSArray<YIMEditerAccessoryMenuItem*>* menus;
/**不要直接使用该textView的delegate，请使用userDelegate*/
@property(nonatomic,strong)id<UITextViewDelegate> userDelegates;
/**到新window时是否进入第一响应者 默认是true*/
@property(nonatomic,assign)BOOL toNewWindowIsBecomeFirstResponder;




/**
 添加一个样式对象
 
 */
-(void)addStyleChangeObject:(id<YIMEditerStyleChangeObject>)styleChangeObj;

@end
