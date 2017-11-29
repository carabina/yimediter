//
//  YIMEditerFontView.m
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerFontView.h"
#import "YIMEditerTextStyleCell.h"
#import "YIMEditerTextFontSizeCell.h"
#import "YIMEditerTextColorCell.h"
#import "YIMEditerTextFontFamilyCell.h"
#import "YIMFontFamilyViewController.h"

@interface YIMEditerFontView()<UITableViewDelegate,UITableViewDataSource>{
    YIMFontFamilyViewController *_fontFamilyViewController;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)YIMEditerTextStyleCell *textStyleCell;
@property(nonatomic,strong)YIMEditerTextFontSizeCell *textFontCell;
@property(nonatomic,strong)YIMEditerTextColorCell *textColorCell;
@end

@implementation YIMEditerFontView

-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[YIMEditerTextStyleCell class] forCellReuseIdentifier:@"textStyleCell"];
        [tableView registerClass:[YIMEditerTextFontSizeCell class] forCellReuseIdentifier:@"textFontSizeCell"];
        [tableView registerClass:[YIMEditerTextColorCell class] forCellReuseIdentifier:@"textColorCell"];
        [tableView registerClass:[YIMEditerTextFontFamilyCell class] forCellReuseIdentifier:@"textFontFamilyCell"];
        tableView.tableFooterView = [UIView new];
        tableView.frame = self.bounds;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:tableView];
        
        self.tableView = tableView;
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 64;
        }
        if (indexPath.row == 2) {
            return 70;
        }
        if (indexPath.row == 3) {
            return 39;
        }
    }
    return 54;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.textStyleCell;
        }
        if (indexPath.row == 1) {
            return self.textFontCell;
        }
        if (indexPath.row == 2) {
            return self.textColorCell;
        }
        if (indexPath.row == 3) {
            return [tableView dequeueReusableCellWithIdentifier:@"textFontFamilyCell"];
        }
    }
    return [UITableViewCell new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [self showSelectFontViewController];
        }
    }
}
-(void)setTextStyle:(YIMEditerTextStyle *)textStyle{
    _textStyle = textStyle;
    self.textStyleCell.isBold = textStyle.bold;
    self.textStyleCell.isItalic = textStyle.italic;
    self.textStyleCell.isUnderline = textStyle.underline;
    self.textFontCell.fontSize = textStyle.fontSize;
    self.textColorCell.color = textStyle.textColor;
}

#pragma -mark get set
-(YIMEditerTextStyleCell*)textStyleCell{
    if (!_textStyleCell) {
        _textStyleCell = [self.tableView dequeueReusableCellWithIdentifier:@"textStyleCell"];
        __weak typeof(self) weakSelf = self;
        [_textStyleCell setBoldChangeBlock:^(BOOL isSelected) {
            [weakSelf boldValueChange:isSelected];
        }];
        [_textStyleCell setItalicChangeBlock:^(BOOL isSelected) {
            [weakSelf italicValueChange:isSelected];
        }];
        [_textStyleCell setUnderlineChangeBlock:^(BOOL isSelected) {
            [weakSelf underlineValueChange:isSelected];
        }];
    }
    return _textStyleCell;
}
-(YIMEditerTextFontSizeCell*)textFontCell{
    if (!_textFontCell) {
        _textFontCell = [self.tableView dequeueReusableCellWithIdentifier:@"textFontSizeCell"];
        __weak typeof(self) weakSelf = self;
        [_textFontCell setFontSizeChangeBlock:^(NSInteger fontSize) {
            [weakSelf fontSizeValueChange:fontSize];
        }];
    }
    return _textFontCell;
}
-(YIMEditerTextColorCell*)textColorCell{
    if (!_textColorCell) {
        _textColorCell = [self.tableView dequeueReusableCellWithIdentifier:@"textColorCell"];
        __weak typeof(self) weakSelf = self;
        [_textColorCell setColorChangeBlock:^(UIColor *color) {
            [weakSelf textColorValueChange:color];
        }];
    }
    return _textColorCell;
}


#pragma private methods
/**显示字体选择控制器*/
-(void)showSelectFontViewController{
    YIMFontFamilyViewController *fontFamilyViewController = [[YIMFontFamilyViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    void(^backFontFamilySelect)(void) = ^{
        if(fontFamilyViewController.navigationController.viewControllers.firstObject == fontFamilyViewController){
            [fontFamilyViewController.navigationController dismissViewControllerAnimated:true completion:nil];
        }else{
            [fontFamilyViewController.navigationController popViewControllerAnimated:true];
        }
    };
    [fontFamilyViewController setCompleteSelect:^(NSString *fontName) {
        [weakSelf fontNameValueChange:fontName];
        backFontFamilySelect();
    }];
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:fontFamilyViewController animated:true];
    }else if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]
              &&[((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController isKindOfClass:[UINavigationController class]]){
        [((UINavigationController*)((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController)pushViewController:fontFamilyViewController animated:true];
    }else{
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:fontFamilyViewController];
        fontFamilyViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSelectFont:)];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:true completion:nil];
    }
    _fontFamilyViewController = fontFamilyViewController;
}
/**当 当前无法通过UINavigationController的pop来返回字体选择控制器时，通过这个点击取消来取消字体选择*/
-(void)cancelSelectFont:(UIBarButtonItem*)sender{
    [_fontFamilyViewController.navigationController dismissViewControllerAnimated:true completion:nil];
}


-(void)boldValueChange:(BOOL)newValue{
    if(self.textStyle.bold != newValue){
        self.textStyle.bold = newValue;
        [self valueChange];
    }
}
-(void)italicValueChange:(BOOL)newValue{
    if(self.textStyle.italic != newValue){
        self.textStyle.italic = newValue;
        [self valueChange];
    }
}
-(void)underlineValueChange:(BOOL)newValue{
    if(self.textStyle.underline != newValue){
        self.textStyle.underline = newValue;
        [self valueChange];
    }
}
-(void)fontSizeValueChange:(NSInteger)newValue{
    if (self.textStyle.fontSize != newValue) {
        self.textStyle.fontSize = newValue;
        [self valueChange];
    }
}
-(void)textColorValueChange:(UIColor*)newValue{
    if (self.textStyle.textColor != newValue) {
        self.textStyle.textColor = newValue;
        [self valueChange];
    }
}
-(void)fontNameValueChange:(NSString*)newValue{
    if (![self.textStyle.fontName isEqualToString:newValue]) {
        self.textStyle.fontName = newValue;
        [self valueChange];
    }
}
-(void)valueChange{
    if([self.delegate respondsToSelector:@selector(fontView:styleDidChange:)]){
        [self.delegate fontView:self styleDidChange:self.textStyle];
    }
}


@end
