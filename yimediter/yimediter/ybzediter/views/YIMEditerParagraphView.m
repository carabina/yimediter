//
//  YIMEditerParagraphView.m
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerParagraphView.h"
#import "YIMEditerParagraphAlignmentCell.h"
#import "YIMEditerParagraphLineIndentCell.h"

@interface YIMEditerParagraphView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,weak)id<YIMEditerStyleChangeDelegate> delegate;
@property(nonatomic,strong)YIMEditerParagraphAlignmentCell *alignmentCell;
@property(nonatomic,strong)YIMEditerParagraphLineIndentCell *lineIndentCell;
@end

@implementation YIMEditerParagraphView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        tableView.frame = self.bounds;
        [tableView registerClass:[YIMEditerParagraphAlignmentCell class] forCellReuseIdentifier:@"alignmentCell"];
        [tableView registerClass:[YIMEditerParagraphLineIndentCell class] forCellReuseIdentifier:@"lineIndentCell"];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:tableView];
        
        self.tableView = tableView;
    }
    return self;
}

#pragma  -mark tableview delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.lineIndentCell;
        }
        if (indexPath.row == 1) {
            return self.alignmentCell;
        }
    }
    return [UITableViewCell new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 54;
        }
    }
    return 44;
}

#pragma -mark get set
-(void)setParagraphStyle:(YIMEditerParagraphStyle *)paragraphStyle{
    _paragraphStyle = paragraphStyle;
    self.alignmentCell.currentTextAlignment = paragraphStyle.alignment;
    self.lineIndentCell.isRightTab = paragraphStyle.firstLineIndent;
}
-(YIMEditerParagraphAlignmentCell*)alignmentCell{
    if (!_alignmentCell) {
        _alignmentCell = [self.tableView dequeueReusableCellWithIdentifier:@"alignmentCell"];
        __weak typeof(self) weakSelf = self;
        [_alignmentCell setAlignmentChangeBlock:^(NSTextAlignment alignment) {
            [weakSelf alignmentChange:alignment];
        }];
    }
    return _alignmentCell;
}
-(YIMEditerParagraphLineIndentCell*)lineIndentCell{
    if (!_lineIndentCell) {
        _lineIndentCell = [self.tableView dequeueReusableCellWithIdentifier:@"lineIndentCell"];
        __weak typeof(self) weakSelf = self;
        [_lineIndentCell setLineIndentChange:^(BOOL isLineIndent) {
            [weakSelf firstLineIndentChange:isLineIndent];
        }];
    }
    return _lineIndentCell;
}

-(void)firstLineIndentChange:(BOOL)newValue{
    if (self.paragraphStyle.firstLineIndent != newValue) {
        self.paragraphStyle.firstLineIndent = newValue;
    }
    [self valueChange];
}
-(void)alignmentChange:(NSTextAlignment)newValue{
    if (self.paragraphStyle.alignment != newValue) {
        self.paragraphStyle.alignment = newValue;
    }
    [self valueChange];
}
-(void)valueChange{
    if ([self.delegate respondsToSelector:@selector(style:didChange:)]) {
        [self.delegate style:self didChange:self.paragraphStyle];
    }
}

#pragma -mark 
-(void)setStyleDelegate:(id<YIMEditerStyleChangeDelegate>)styleDelegate{
    self.delegate = styleDelegate;
}
-(id<YIMEditerStyleChangeDelegate>)styleDelegate{
    return self.delegate;
}
-(YIMEditerStyle*)defualtStyle{
    return [YIMEditerParagraphStyle createDefualtStyle];
}
-(YIMEditerStyle*)currentStyle{
    return self.paragraphStyle;
}
-(void)updateUIWithTextAttributes:(YIMEditerDrawAttributes *)attributed{
    self.paragraphStyle = [[YIMEditerParagraphStyle alloc]initWithAttributed:attributed];
}

@end
