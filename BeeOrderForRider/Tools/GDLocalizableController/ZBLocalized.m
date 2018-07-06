//
//  ZBLocalized.m
//  takeOut
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "ZBLocalized.h"

@implementation ZBLocalized
+ (ZBLocalized *)sharedInstance{
    static ZBLocalized *language=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        language = [[ZBLocalized alloc] init];
    });
    return language;
}

- (void)initLanguage{
    NSString *language=[self currentLanguage];
    if (language.length>0) {
        NSLog(@"自设置语言:%@",language);
    }else{
        [self systemLanguage];
    }
}

- (NSString *)currentLanguage{
    NSString *language=[[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
    return language;
}

- (void)setLanguage:(NSString *)language{
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:AppLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)systemLanguage{
    NSString *languageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    NSLog(@"系统语言:%@",languageCode);
    if([languageCode hasPrefix:@"zh-Hant"]){
        languageCode = @"th";//繁体中文
    }else if([languageCode hasPrefix:@"zh-Hans"]){
        languageCode = @"zh-Hans";//简体中文
    }else if([languageCode hasPrefix:@"pt"]){
        languageCode = @"th";//葡萄牙语
    }else if([languageCode hasPrefix:@"es"]){
        languageCode = @"th";//西班牙语
    }else if([languageCode hasPrefix:@"th"]){
        languageCode = @"th";//泰语
    }else if([languageCode hasPrefix:@"hi"]){
        languageCode = @"th";//印地语
    }else if([languageCode hasPrefix:@"ru"]){
        languageCode = @"th";//俄语
    }else if([languageCode hasPrefix:@"ja"]){
        languageCode = @"th";//日语
    }else if([languageCode hasPrefix:@"en"]){
        languageCode = @"en";//英语
    }else{
        languageCode = @"th";//英语
    }
    [self setLanguage:languageCode];
}
@end
