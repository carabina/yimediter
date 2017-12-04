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



@interface YIMEditerTextView()<YIMEditerInputAccessoryViewDelegate,UITextViewDelegate,YIMEditerStyleChangeDelegate>{
    
}
/**所有样式对象*/
@property(nonatomic,strong)NSMutableArray<id<YIMEditerStyleChangeObject>> *allObjects;
/**默认的绘制属性，emmmmmmm....没啥用的时候就用它就是了*/
@property(nonatomic,strong)YIMEditerDrawAttributes *defualtDrawAttributed;

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
    self.toNewWindowIsBecomeFirstResponder = true;
    self.defualtDrawAttributed = [self createDefualtDrawAttributes];
    self.allObjects = [NSMutableArray array];
    
    YIMEditerInputAccessoryView *accessoryView = [[YIMEditerInputAccessoryView alloc]init];
    accessoryView.delegate = self;
    accessoryView.frame = CGRectMake(0, 0, self.frame.size.width, 38);
    self.inputAccessoryView = accessoryView;
    
    //添加默认字体编辑项
    DefualtFontItem *item = [[DefualtFontItem alloc]init];
    //添加默认段落编辑项
    DefualtParagraphItem *item1 = [[DefualtParagraphItem alloc]init];
    
    self.menus = @[item,item1];
    [self addStyleChangeObject:item.fontView];
    [self addStyleChangeObject:item1.paragraphView];
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
    }
}
-(void)setDelegate:(id<UITextViewDelegate>)delegate{
    if (delegate != self) {
        return;
    }
    [super setDelegate:delegate];
}


#pragma -mark get set
-(void)setMenus:(NSArray<YIMEditerAccessoryMenuItem *> *)menus{
    NSMutableArray* arr = [NSMutableArray array];
    [arr addObject:[[YIMEditerAccessoryMenuItem alloc]initWithImage:[UIImage imageNamed:@"keyboard"]]];
    [arr addObjectsFromArray:menus];
    _menus = arr;
    ((YIMEditerInputAccessoryView*)self.inputAccessoryView).items = arr;
}

#pragma -mark public method
//添加一个Object时
-(void)addStyleChangeObject:(id<YIMEditerStyleChangeObject>)styleChangeObj{
    //设置样式变更的代理
    styleChangeObj.styleDelegate = self;
    [self.defualtDrawAttributed updateAttributed:[styleChangeObj.defualtStyle outPutAttributed]];
    [self.allObjects addObject:styleChangeObj];
}
-(NSString*)outPutHtmlString{
    NSMutableString* htmlString = [NSMutableString string];
    
    BOOL isNewParagraph = true;
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < self.text.length) {
        NSDictionary *attributes = [self.attributedText attributesAtIndex:effectiveRange.location+effectiveRange.length effectiveRange:&effectiveRange];
        YIMEditerDrawAttributes *drawAttributes = [[YIMEditerDrawAttributes alloc]initWithAttributeString:attributes];
        
        NSMutableString *htmlStyleString = [NSMutableString string];
        NSMutableArray<NSString*>* htmlAttributes = [NSMutableArray array];
        NSMutableString *paragraphHtmlStyleString = [NSMutableString string];
        NSMutableArray<NSString*>* paragraphHtmlAttributes = [NSMutableArray array];
        for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
            YIMEditerStyle *style = [obj styleUseAttributed:drawAttributes];
            if(style.isParagraphStyle){
                [paragraphHtmlStyleString appendString:[style htmlStyle]];
                [paragraphHtmlAttributes addObjectsFromArray:[style htmlAttributed]];
            }else{
                [htmlStyleString appendString:[style htmlStyle]];
                [htmlAttributes addObjectsFromArray:[style htmlAttributed]];
            }
        }
        if (isNewParagraph) {
            [htmlString appendFormat:@"<p style=\"%@\">",paragraphHtmlStyleString];
            for (NSString* htmlAttr in paragraphHtmlAttributes) {
                [htmlString appendFormat:@"<%@>",htmlAttr];
            }
            isNewParagraph = false;
        }
        [htmlString appendFormat:@"<font style=\"%@\">",htmlStyleString];
        for (NSString* htmlAttr in htmlAttributes) {
            [htmlString appendFormat:@"<%@>",htmlAttr];
        }
        [htmlString appendString:[self.text substringWithRange:effectiveRange]];
        for (NSString* htmlAttr in [htmlAttributes reverseObjectEnumerator]) {
            [htmlString appendFormat:@"</%@>",htmlAttr];
        }
        [htmlString appendString:@"</font>"];
        if ([[self.text substringWithRange:NSMakeRange(effectiveRange.location + effectiveRange.length - 1, 1)] isEqualToString:@"\n"]) {
            [htmlString appendString:@"</p>"];
            isNewParagraph = true;
        }
    }
    [htmlString appendString:@"</p>"];
    return htmlString;
}

#pragma -mark private method
/**从选中range中找到选中的段落range*/
-(NSRange)paragraphRangeWithSelectRange:(NSRange)range{
    NSInteger minRangIndex = range.location;
    for (; minRangIndex > 0 && [self.text characterAtIndex:minRangIndex - 1] != '\n'; minRangIndex--)
        ;
    NSInteger maxRangeIndex = range.location + range.length;
    for (; maxRangeIndex < self.text.length && [self.text characterAtIndex:MIN(maxRangeIndex - 1,0)] != '\n'; maxRangeIndex++)
        ;
    return NSMakeRange(minRangIndex, maxRangeIndex - minRangIndex);
}
-(void)setTypingWithAttributed:(YIMEditerDrawAttributes*)attr{
    self.typingAttributes = attr.textAttributed;
}
/**设置文字属性到指定区间*/
-(void)setTextWithAttributed:(YIMEditerDrawAttributes *)attr range:(NSRange)range{
    [self.textStorage setAttributes:attr.textAttributed range:range];
    NSRange paragraphRange = [self paragraphRangeWithSelectRange:range];
    [self.textStorage addAttributes:attr.paragraphAttributed  range:paragraphRange];
}
/**从指定样式文字中提取绘制属性*/
-(YIMEditerDrawAttributes*)attributedFromAttributedText:(NSAttributedString*)text{
    NSRange range = {0,0};
    NSDictionary *attribute = [text attributesAtIndex:0 effectiveRange:&range];
    if (NSEqualRanges(NSMakeRange(0, text.string.length), range)) {
        return [[YIMEditerDrawAttributes alloc]initWithAttributeString:attribute];
    }
    return [self createDefualtDrawAttributes];
}
/**从指定区间提取绘制属性*/
-(YIMEditerDrawAttributes*)attributedFromRange:(NSRange)range{
    YIMEditerMutableDrawAttributes *attributes = [[YIMEditerMutableDrawAttributes alloc]init];
    //获取选中文字的属性
    NSDictionary *textAttributed = [self.textStorage attributesAtIndex:range.location longestEffectiveRange:NULL inRange:range];
    attributes.textAttributed = textAttributed;
    
    //获取选中段落
    NSRange paragraphRange = [self paragraphRangeWithSelectRange:range];
    //获取选中段落的属性
    NSDictionary *paragraphAttributed = [self.textStorage attributesAtIndex:paragraphRange.location longestEffectiveRange:NULL inRange:paragraphRange];
    attributes.paragraphAttributed = paragraphAttributed;
    return attributes;
}
/**创建一个默认属性*/
-(YIMEditerDrawAttributes*)createDefualtDrawAttributes{
    YIMEditerDrawAttributes *attr = [[YIMEditerDrawAttributes alloc]init];
    for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
        [attr updateAttributed:[obj.defualtStyle outPutAttributed]];
    }
    return attr;
}
/**获取当前属性，allObject的属性拼在一块儿得出的文字属性*/
-(YIMEditerDrawAttributes*)currentAttributes{
    YIMEditerDrawAttributes *attr = [[YIMEditerDrawAttributes alloc]init];
    for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
        [attr updateAttributed:[obj.currentStyle outPutAttributed]];
    }
    return attr;
}

#pragma -mark delegate functions
/**样式切换时*/
-(void)style:(id)sender didChange:(YIMEditerStyle *)newStyle{
    //获取当前文字属性
    YIMEditerDrawAttributes *currentAttributes = [self currentAttributes];
    //更新变更的属性
    [currentAttributes updateAttributed:[newStyle outPutAttributed]];
    //修改选中文字属性
    [self setTextWithAttributed:currentAttributes range:self.selectedRange];
    //修改下一个字符属性
    [self setTypingWithAttributed:currentAttributes];
}
/**AccessoryView选择时*/
-(void)YIMEditerInputAccessoryView:(YIMEditerInputAccessoryView*)accessoryView clickItemAtIndex:(NSInteger)index{
    //执行菜单item对象的点击方法
    [self.menus[index] clickAction];
    //把inputView设置为菜单item对象返回的inputView
    self.inputView = [self.menus[index] menuItemInputView];
    //刷新inputView
    [self reloadInputViews];
}


#pragma -mark TextView Delegate Functions
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
    YIMEditerDrawAttributes *attributes = [[YIMEditerDrawAttributes alloc]init];
    //获取所有Object上的当前样式
    for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
        [attributes updateAttributed:[obj.currentStyle outPutAttributed]];
    }
    //把样式更新到下一个字符属性
    [self setTypingWithAttributed:attributes];
    self.defualtDrawAttributed = attributes;
    
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
    YIMEditerDrawAttributes *attributes = nil;
    //如果有选中文字，修改选中文字的样式
    if (self.selectedRange.length) {
        attributes = [self attributedFromRange:self.selectedRange];
    }else{
        //当前没有文字 使用默认样式
        if(self.text.length == 0){
            attributes = self.defualtDrawAttributed;
        }else if(self.selectedRange.location > 0){
            //通常取光标前一个字符的属性为当前样式
            //但是如果前一个字符是换行符时，需要取换行符后面的字符样式为当前样式。因为换行符的属性属于上一个段落的，而当前光标位置并不希望得到上一个段落的样式
            if ([self.text characterAtIndex:(self.selectedRange.location + self.selectedRange.length - 1)] == '\n') {
                //如果光标后面还有字符，取后一个字符，否则使用默认样式
                if (self.text.length > self.selectedRange.location + self.selectedRange.length) {
                    attributes = [self attributedFromRange:NSMakeRange(self.selectedRange.location, 1)];
                }else{
                    attributes = [self defualtDrawAttributed];
                }
            }else{
                //使用光标前一个字符的属性
                attributes = [self attributedFromRange:NSMakeRange(self.selectedRange.location - 1, 1)];
            }
        }else{
            attributes = [[YIMEditerDrawAttributes alloc]init];
        }
    }
    //通知所有object更新UI
    for (id<YIMEditerStyleChangeObject> obj in self.allObjects) {
        [obj updateUIWithTextAttributes:attributes];
    }
    //更新默认文字属性
    self.defualtDrawAttributed = attributes;
    //设置下一个字符的属性
    [self setTypingWithAttributed:attributes];
    if ([self.userDelegates respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.userDelegates textViewDidChangeSelection:textView];
    }
    NSLog(@"%@",self.typingAttributes);
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
