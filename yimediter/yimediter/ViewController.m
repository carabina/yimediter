//
//  ViewController.m
//  yimediter
//
//  Created by ybz on 2017/11/17.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "ViewController.h"
#import "YIMEditerInputAccessoryView.h"
#import "YIMEditerSetting.h"
#import "YIMEditerFontView.h"
#import "YIMEditerTextView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
//    for (NSString* f in fonts.allKeys) {
//        [str appendAttributedString:[[NSAttributedString alloc]initWithString:f]];
//        [str appendAttributedString:[[NSAttributedString alloc]initWithString:@"我随手一打就是漂亮的十五个字\n" attributes:@{NSFontAttributeName:fonts[f]}]];
//    }
    
    YIMEditerTextView *textView = [[YIMEditerTextView alloc]init];
//    textView.attributedText = str;
    
    [self.view addSubview:textView];
    textView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[textView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,textView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[textView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,textView)]];
}


#pragma -mark delegates



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
