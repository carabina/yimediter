//
//  YIMEditerProtocol.h
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#ifndef YIMEditerProtocol_h
#define YIMEditerProtocol_h

@class YIMEditerStyle;
@class YIMEditerDrawAttributes;

@protocol YIMEditerStyleChangeDelegate <NSObject>
-(void)style:(id)sender didChange:(YIMEditerStyle*)newStyle;
@end

/**
 比较重要的一个接口
 表示一个可以改变文本样式的的对象接口
 实现该接口可以更改文本属性
 */
@protocol YIMEditerStyleChangeObject <NSObject>

/**样式修改的代理，在样式需要修改时，对象需要调用代理的didChange方法*/
@property(nonatomic,weak)id<YIMEditerStyleChangeDelegate> styleDelegate;
/**提供一个默认样式*/
@property(nonatomic,strong,readonly)YIMEditerStyle *defualtStyle;
/** 对象当前的样式 */
-(YIMEditerStyle*)currentStyle;
/** 使用Attributes更新样式，需要在此处更新UI以适应新的样式**/
-(void)updateUIWithTextAttributes:(YIMEditerDrawAttributes*)attributed;

@end


#endif /* YIMEditerProtocol_h */
