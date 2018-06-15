//
//  LoginVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/8.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "LoginVC.h"
#import "UserPhotoVC.h"
#import "RegisVC.h"
@interface LoginVC ()<UITextFieldDelegate>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UITextField *userTextFile;
@property (nonatomic , strong)UITextField *passWordTextFile;
@property (nonatomic , strong)NSString *phoneNumStr;
@property (nonatomic , strong)NSString *codeNumStr;

@property (nonatomic , strong)UIButton *loginBtn;
@property (nonatomic , strong)UIButton *regisBtn;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviView];
    [self setUpui];
    [self isappstore];
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    // 禁用iOS7返回手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    // 开启
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}
#pragma mark - ui
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)createNaviView{
    self.view.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    self.naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight )];
    self.naviView.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [self.view addSubview:self.naviView];
    
    __weak typeof(self) ws = self;
    UIImageView *backImg = [[UIImageView alloc]init];
   
    [self.naviView addSubview:backImg];
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight + 5);
        make.left.equalTo(ws.naviView.mas_left).offset(15);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = ZBLocalized(@"登录", nil);
    titleLabel.textColor = [UIColor blackColor];
    [self.naviView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(backImg);
    }];
}
-(void)setUpui{
    __weak typeof(self) ws = self;
    
    UIView *nameBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 30, SCREEN_WIDTH, 60)];
    nameBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameBackView];
    
    UIView *passwordBackview = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 30 + 60 + 30, SCREEN_WIDTH, 60)];
    passwordBackview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordBackview];
    
    self.userTextFile = [[UITextField alloc]init];
    self.userTextFile.delegate = self;
    self.userTextFile.placeholder = ZBLocalized(@"请输入BeeRider账号",nil);
    [self.userTextFile addTarget:self action:@selector(phoneTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.userTextFile];
    [self.userTextFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameBackView);
        make.left.equalTo(nameBackView.mas_left).offset(20);
        make.height.equalTo(@(50));
        make.centerX.equalTo(ws.view);
    }];
    
    self.passWordTextFile = [[UITextField alloc]init];
    self.passWordTextFile.delegate = self;
    self.passWordTextFile.secureTextEntry = YES;
    self.passWordTextFile.placeholder = ZBLocalized(@"请输入密码",nil);
    [self.passWordTextFile addTarget:self action:@selector(passWordFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.passWordTextFile];
    [self.passWordTextFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBackview);
        make.left.equalTo(passwordBackview.mas_left).offset(20);
        make.height.equalTo(@(50));
        make.centerX.equalTo(ws.view);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setBackgroundColor:[UIColor grayColor]];
    self.loginBtn.layer.cornerRadius=6;
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.enabled = NO;
    [self.loginBtn setTitle:ZBLocalized(@"登录", nil) forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.left.equalTo(ws.view.mas_left).offset(SCREEN_WIDTH / 7);
        make.height.equalTo(@(50));
        make.top.equalTo(ws.passWordTextFile.mas_bottom).offset(40);
    }];
    
    self.regisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.regisBtn.layer.cornerRadius=6;
    self.regisBtn.clipsToBounds = YES;
    [self.regisBtn setTitle:ZBLocalized(@"注册", nil) forState:UIControlStateNormal];
    [self.regisBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.regisBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:self.regisBtn];
    [self.regisBtn addTarget:self action:@selector(regis) forControlEvents:UIControlEventTouchUpInside];
    [self.regisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.left.equalTo(ws.view.mas_left).offset(SCREEN_WIDTH / 7);
        make.height.equalTo(@(50));
        make.top.equalTo(ws.loginBtn.mas_bottom).offset(20);
    }];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSDate *date = [dateFormatter dateFromString:@"18-06-2018-000000"];
    int isLate = [self compareOneDay:[self getCurrentTime] withAnotherDay:date];
    if (isLate < 0) {
        self.regisBtn.hidden = NO;
    }else{
        self.regisBtn.hidden = YES;
    }
    
    
    UILabel *hintLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, SCREENH_HEIGHT - TabbarHeight - 30, SCREEN_WIDTH - 60, 50)];
    hintLabel.numberOfLines=0;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hintLabel];
    hintLabel.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:ZBLocalized(@"登录代表您已同意《BeeRider用户协议》", nil)];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:ZBLocalized(@"《BeeRider用户协议》", nil)];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:BaseYellow] range:range1];
    hintLabel.attributedText=hintString;
    
    UIButton *changeType = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:changeType];
    changeType.frame = CGRectMake(30, SCREENH_HEIGHT - TabbarHeight - 30, SCREEN_WIDTH - 60, 50);
    [changeType addTarget:self action:@selector(toUserProto) forControlEvents:UIControlEventTouchUpInside];
}
-(void)isappstore{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,isappstoreURL];
    NSDictionary *parameters = @{@"vnum":Vsion,
                                 @"flg":@"1",
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    [managers POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"is匹配：%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSString *isShow = [NSString stringWithFormat:@"%@",responseObject[@"value"]];
            if ([isShow isEqualToString:@"1"]) {
                self.regisBtn.hidden = NO;
            }else{
                self.regisBtn.hidden = YES;
            }
        }else{
            [MBManager showBriefAlert:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark -得到当前时间
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}
-(void)regis{
    RegisVC *regis = [[RegisVC alloc]init];
    [self.navigationController pushViewController:regis animated:YES];
}
-(void)login{
     NSString * md5Code = [MD5encryption MD5ForLower32Bate:self.codeNumStr];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,LoginURL];
    NSDictionary *parameters = @{@"name":self.phoneNumStr,
                                 @"pwd":md5Code,
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    //请求的方式：POST
    /*
     {
     name = 13222222222;
     pwd = e10adc3949ba59abbe56e057f20f883e;
     }
     */
    [managers POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            if ([responseObject[@"value"]  isEqual:@""]) {
                [MBManager showBriefAlert:ZBLocalized(@"账号异常", nil)];
                return ;
            }
            NSLog(@"res:%@",responseObject);
             NSDictionary *dic = responseObject[@"value"];
            NSString *userId = dic[@"id"];
            NSString *userImgUrl = dic[@"originallyLog"];
            NSString *userName = dic[@"originallyName"];
            NSString *userPhone = dic[@"originallyPhone"];
            NSString *userState =[NSString stringWithFormat:@"%@",dic[@"originallyState"]];
 
            NSString * md5CodeStr = [MD5encryption MD5ForLower32Bate:self.codeNumStr];
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:md5CodeStr forKey:UD_USERPassword];
            [defaults setObject:self.phoneNumStr forKey:UD_USERAccount];
            [defaults setObject:userId forKey:UD_USERID];
            if([userImgUrl isEqual:[NSNull null]]) {

                [defaults setObject:nil forKey:UD_USERLOGO];
            }else{
                [defaults setObject:userImgUrl forKey:UD_USERLOGO];
            }
            
            [defaults setObject:userName forKey:UD_USERNAME];
            [defaults setObject:userPhone forKey:UD_USERPHONE];
            [defaults setObject:userState forKey:UD_USERState];
            [defaults synchronize];
            
            [JPUSHService setAlias:@"qs" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"注册Alias==%ld",(long)iResCode);
            } seq:0];
            NSString *strTag = [NSString stringWithFormat:@"qs%@",userId];
            NSSet *set = [[NSSet alloc] initWithObjects:strTag,nil];
            [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                NSLog(@"注册Tag===%ld",(long)iResCode);
            } seq:0];
            
            [MBManager showBriefAlert:ZBLocalized(@"登录成功", nil)];
            [self performSelector:@selector(back) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
        }else{
            [MBManager showBriefAlert:ZBLocalized(@"用户名或密码错误", nil)];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBManager showBriefAlert:ZBLocalized(@"服务器异常", nil)];
    }];
}
#pragma mark - 监听textFile
-(void)phoneTextFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    self.phoneNumStr = theTextField.text;
    if (self.phoneNumStr != nil && self.codeNumStr != nil && self.phoneNumStr.length != 0 && self.codeNumStr.length != 0) {
        [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:BaseYellow]];
        self.loginBtn.enabled = YES;
    }else{
        [self.loginBtn setBackgroundColor:[UIColor grayColor]];
        self.loginBtn.enabled = NO;
    }
}
-(void)passWordFiledDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    self.codeNumStr = theTextField.text;
    if (self.phoneNumStr != nil && self.codeNumStr != nil && self.phoneNumStr.length != 0 && self.codeNumStr.length != 0) {
        [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:BaseYellow]];
        self.loginBtn.enabled = YES;
    }else{
        [self.loginBtn setBackgroundColor:[UIColor grayColor]];
        self.loginBtn.enabled = NO;
    }
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toUserProto{
    UserPhotoVC *user = [[UserPhotoVC alloc]init];
    [self.navigationController presentViewController:user animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
