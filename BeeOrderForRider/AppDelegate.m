//
//  AppDelegate.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/7.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "AppDelegate.h"
#import "QCNavigationController.h"
#import "HomeVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<UITabBarDelegate,JPUSHRegisterDelegate>
{
    AVAudioPlayer *avAudioPlayer;   //播放器player
    
    
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //国际化===============
    [[ZBLocalized sharedInstance]initLanguage];//放在tabbar前初始化
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyboardManager.enableAutoToolbar = NO;
    //极光推送=============
    //初始化APNs
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *channel = @"iOS";
    // 初始化JPush====================
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:channel
                 apsForProduction:JPushIsProduction
            advertisingIdentifier:advertisingId];
    
   
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    NSString *userID = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    if (userID == nil || [userID isEqualToString:@""]) {
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
            NSLog(@"删除 ==%ld",(long)iResCode);
            
        } seq:0];
        [JPUSHService setTags:nil completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            
        } seq:0];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor =[UIColor whiteColor];
    
    // 设置窗口的根控制器
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeVC alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
    
}


#pragma mark - JPushDelegate
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken===========%@",deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSLog(@"收到的推送消息 userinfo %@",userInfo);
    
    //判断应用是在前台还是后台
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        //     前台收到消息后，做的对应页面跳转操作
        
        NSNotification *notification =[NSNotification notificationWithName:@"needReLoad" object:nil userInfo:nil];
        
        //通过通知中心发送通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"前台收到消息");
        [self StartSound];
        HomeVC *home = [[HomeVC alloc]init];
        home.showLeft = @"2";
        [UIApplication sharedApplication].keyWindow.rootViewController = [[QCNavigationController alloc] initWithRootViewController:home];
        

    }
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
       
    }
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
}
// NS_DEPRECATED_IOS(3_0, 10_0, "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
//程序在运行时收到通知，点击通知栏进入app


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    [self StartSound];
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
}
// 通过点击推送弹出的通知调用,包括前台和后台(didReceiveNotificationResponse)

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self StartSound];
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        
        //[self SetMainTabbarController2]; //收到推送消息，需要调整的界面
        
        // 消息界面监听刷新
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveMessageNotification object:nil];
        
        //        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        
    }
    
    completionHandler();  // 系统要求执行这个方法
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)StartSound{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSString *string = [[NSBundle mainBundle] pathForResource:@"WMDDSOUND" ofType:@"caf"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //初始化音频类 并且添加播放文件
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    //设置代理
    avAudioPlayer.delegate = self;
    
    //设置初始音量大小
    // avAudioPlayer.volume = 1;
    
    //设置音乐播放次数  -1为一直循环
    avAudioPlayer.numberOfLoops = -1;
    
    //预播放
    [avAudioPlayer prepareToPlay];
    [avAudioPlayer play];
}

@end
