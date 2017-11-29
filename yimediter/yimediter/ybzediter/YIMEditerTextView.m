//
//  YIMEditerTextView.m
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <Availability.h>
#import <CoreText/CoreText.h>

#import "YIMEditerTextView.h"
#import "YIMEditerInputAccessoryView.h"
#import "YIMEditerSetting.h"
#import "YIMEditerFontView.h"
#import "YIMEditerFontFamilyManager.h"


@interface YIMEditerTextView()<YIMEditerInputAccessoryViewDelegate,UITextViewDelegate,YIMEditerFontViewDelegate>{
    
}
@property(nonatomic,strong)YIMEditerFontView* fontView;
@property(nonatomic,strong)YIMEditerTextStyle *defualtStyle;
/**到新window时是否进入第一响应者*/
@property(nonatomic,assign)BOOL toNewWindowIsBecomeFirstResponder;
@end

@implementation YIMEditerTextView


#pragma override super
-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}
-(void)setUp{
    self.delegate = self;
    
    //初始化字体样式
    self.defualtStyle = [YIMEditerTextStyle createDefualtStyle];
    
    YIMEditerInputAccessoryView *accessoryView = [[YIMEditerInputAccessoryView alloc]init];
    accessoryView.delegate = self;
    accessoryView.frame = CGRectMake(0, 0, self.frame.size.width, 38);
    YIMEditerAccessoryMenuItem *item1 = [[YIMEditerAccessoryMenuItem alloc]initWithImage:[UIImage imageNamed:@"keyboard"]];
    YIMEditerAccessoryMenuItem *item2 = [[YIMEditerAccessoryMenuItem alloc]initWithImage:[UIImage imageNamed:@"font"]];
    accessoryView.items = @[item1,item2];
    self.inputAccessoryView = accessoryView;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.inputAccessoryView.frame;
    rect.size.width = CGRectGetWidth(self.frame);
    self.inputAccessoryView.frame = rect;
}
-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        if(self.toNewWindowIsBecomeFirstResponder)
            [self becomeFirstResponder];
    }else{
        self.toNewWindowIsBecomeFirstResponder = self.isFirstResponder;
    }
}
-(BOOL)resignFirstResponder{
    
    NSLog(@"a");
    return [super resignFirstResponder];
}

/**AccessoryView选择时*/
-(void)YIMEditerInputAccessoryView:(YIMEditerInputAccessoryView*)accessoryView clickItemAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            self.inputView = nil;
            break;
        case 1:{
            self.inputView = self.fontView;
            break;
        }
        default:
            break;
    }
    [self reloadInputViews];
}

#pragma -mark get set
-(YIMEditerFontView*)fontView{
    if (!_fontView) {
        _fontView = [[YIMEditerFontView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 280)];
        _fontView.textStyle = self.defualtStyle;
        _fontView.delegate = self;
    }
    return _fontView;
}


#pragma -mark private methods
-(NSDictionary*)attributeWithTextStyle:(YIMEditerTextStyle*)style{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSNumber *weight = [NSNumber numberWithFloat:0];
    NSValue *matrix = [NSValue valueWithCGAffineTransform:CGAffineTransformIdentity];
    if (style.bold) {
        weight = [NSNumber numberWithFloat:0.4];
    }
    if (style.italic) {
        matrix = [NSValue valueWithCGAffineTransform:CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0)];
    }
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:
                                        @{
                                          UIFontDescriptorNameAttribute:style.fontName,
                                          UIFontDescriptorSizeAttribute:@(style.fontSize),
                                          UIFontDescriptorMatrixAttribute:matrix,
                                          UIFontDescriptorTraitsAttribute:@{UIFontWeightTrait:weight}
                                          }];
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:style.fontSize];
    if (style.underline) {
        [attributes setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    }
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:style.textColor forKey:NSForegroundColorAttributeName];
    return attributes;
}
-(YIMEditerTextStyle*)styleWithAttributeString:(NSAttributedString*)string{
    YIMEditerTextStyle *style = [YIMEditerTextStyle createDefualtStyle];
    NSRange range = {0,0};
    NSDictionary *attribute = [string attributesAtIndex:0 effectiveRange:&range];
    if (NSEqualRanges(NSMakeRange(0, string.string.length), range)) {
        if ([attribute.allKeys containsObject:NSFontAttributeName]) {
            UIFont *font = [attribute objectForKey:NSFontAttributeName];
            UIFontDescriptor *descroptor = font.fontDescriptor;
            BOOL isItalic = descroptor.fontAttributes[@"NSCTFontMatrixAttribute"] != nil;
            
            CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
            CTFontSymbolicTraits traits = CTFontGetSymbolicTraits(ctFont);
            BOOL isBold = ((traits & kCTFontBoldTrait) == kCTFontBoldTrait);
            CFRelease(ctFont);
            
            style.fontName = font.fontName;
            style.italic = isItalic;
            style.bold = isBold;
            style.fontSize = font.pointSize;
        }
        if ([attribute.allKeys containsObject:NSForegroundColorAttributeName]) {
            style.textColor = [attribute objectForKey:NSForegroundColorAttributeName];
        }
        if ([attribute.allKeys containsObject:NSUnderlineStyleAttributeName]) {
            style.underline = true;
        }
    }
    return style;
}

#pragma -mark YIMEditerFontViewDelegate Function
-(void)fontView:(YIMEditerFontView*)fontView styleDidChange:(YIMEditerTextStyle*)style{
    if (self.selectedRange.length != 0) {
        [self.textStorage setAttributes:[self attributeWithTextStyle:style] range:self.selectedRange];
        NSLog(@"selected");
    }else{
        NSLog(@"not selected");
    }
    self.defualtStyle = [style copy];;
}

#pragma -mark Delegate Functions
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"ShouldBeginEditing");
    if ([self.userDelegates respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.userDelegates textViewShouldBeginEditing:textView];
    }
    return true;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"ShouldEndEditing");
    if ([self.userDelegates respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.userDelegates textViewShouldEndEditing:textView];
    }
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"DidBeginEditing");
    if ([self.userDelegates respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.userDelegates textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"DidEndEditing");
    if ([self.userDelegates respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.userDelegates textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"shouldChangeTextInRange");
    self.typingAttributes = [self attributeWithTextStyle:self.fontView.textStyle];
    if ([self.userDelegates respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.userDelegates textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return true;
}
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"DidChange");
    if ([self.userDelegates respondsToSelector:@selector(textViewDidChange:)]) {
        [self.userDelegates textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"DidChangeSelection");
    YIMEditerTextStyle *style = nil;
    if (self.selectedRange.length) {
        style = [self styleWithAttributeString:[self.textStorage attributedSubstringFromRange:self.selectedRange]];
    }else{
        if(self.text.length == 0){
            style = self.defualtStyle;
        }else if(self.selectedRange.location == self.text.length){
            style = [self styleWithAttributeString:[self.textStorage attributedSubstringFromRange:NSMakeRange(self.text.length - 1, 1)]];
        }else{
            style = [self styleWithAttributeString:[self.textStorage attributedSubstringFromRange:NSMakeRange(self.selectedRange.location - 1, 1)]];
        }
    }
    self.fontView.textStyle = style;
    self.defualtStyle = [style copy];;
    if ([self.userDelegates respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.userDelegates textViewDidChangeSelection:textView];
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){
    NSLog(@"shouldInteractWithURL");
    if([self.userDelegates respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:interaction:)]){
        return [self.userDelegates textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    }
    return true;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){\
    NSLog(@"shouldInteractWithTextAttachment");
    if([self.userDelegates respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]){
        [self.userDelegates textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    }
    return true;
}

#else
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if([self.userDelegates respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]){
        return [self.userDelegates textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return true;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    if([self.userDelegates respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]){
        [self.userDelegates textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return true;
}
#endif
@end
