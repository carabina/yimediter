//
//  AppDelegate.m
//  yimediter
//
//  Created by ybz on 2017/11/17.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YIMEditerFontFamilyManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"0123456789" attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSTextEffectAttributeName:@"1"}];
    [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:@"0123456789" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSTextEffectAttributeName:@"1"}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:@"0123456789" attributes:@{NSForegroundColorAttributeName:[UIColor greenColor],NSTextEffectAttributeName:@"1"}]];
    [attributedString addAttributes:@{NSTextEffectAttributeName:@"2"} range:NSMakeRange(0, attributedString.length)];
    
    NSRange range = NSMakeRange(0, 0);
    NSDictionary *dict = [attributedString attributesAtIndex:0 longestEffectiveRange:&range inRange:NSMakeRange(0, 2)];
    
    NSLog(@"%@",dict);
    
    
    
    
    YIMEditerFontFamilyManager *manager = [YIMEditerFontFamilyManager defualtManager];
    //注册字体
    [manager regiestFont:@"Kaiti"];
    [manager regiestFont:@"Xingkai SC"];
    [manager regiestFont:@"YRDZST"];
    [manager regiestFont:@"ShanWenFeng"];
    [manager regiestFont:@"®ÀÖ"];
    [manager regiestFont:@"?"];
    
    ViewController *vc = [ViewController new];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController: vc];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
