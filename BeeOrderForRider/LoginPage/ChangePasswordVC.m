//
//  ChangePasswordVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()<UITextFieldDelegate>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UITextField *userTextFile;
@property (nonatomic , strong)UITextField *passWordTextFile;
@property (nonatomic , strong)UITextField *surePassWordTextFile;
@property (nonatomic , strong)NSString *phoneNumStr;
@property (nonatomic , strong)NSString *codeNumStr;
@property (nonatomic , strong)NSString *surePassWordStr;
@property (nonatomic , strong)UIButton *loginBtn;
@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNaviView];
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;// 屏幕左侧边缘响应
    [self.view addGestureRecognizer:leftEdgeGesture];
    
    [self setUpui];
}
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    if (panGes.state == UIGestureRecognizerStateEnded) {
        [self back];
    }
}
#pragma mark - ui
-(void)createNaviView{
    self.view.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    self.naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight )];
    self.naviView.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [self.view addSubview:self.naviView];
    
    __weak typeof(self) ws = self;
    UIImageView *backImg = [[UIImageView alloc]init];
    [backImg setImage:[UIImage imageNamed:@"back_icon"]];
    [self.naviView addSubview:backImg];
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight + 5);
        make.left.equalTo(ws.naviView.mas_left).offset(15);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
    UIButton *backBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBTN addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:backBTN];
    [backBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight);
        make.left.equalTo(ws.naviView.mas_left).offset(10);
        make.width.equalTo(@(40));
        make.height.equalTo(@(SafeAreaTopHeight - SafeAreaStatsBarHeight));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = ZBLocalized(@"修改密码", nil);
    titleLabel.textColor = [UIColor blackColor];
    [self.naviView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(backImg);
    }];
}
-(void)setUpui{
    __weak typeof(self) ws = self;
    
 
    
    UIView *passwordBackview = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 30 , SCREEN_WIDTH, 60)];
    passwordBackview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordBackview];
    
    UIView *SUREpasswordBackview = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 30 + 60 + 30 , SCREEN_WIDTH, 60)];
    SUREpasswordBackview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SUREpasswordBackview];
    
    self.passWordTextFile = [[UITextField alloc]init];
    self.passWordTextFile.delegate = self;
    self.passWordTextFile.secureTextEntry = YES;
    self.passWordTextFile.placeholder = ZBLocalized(@"请输入旧密码",nil);
    [self.passWordTextFile addTarget:self action:@selector(passWordFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.passWordTextFile];
    [self.passWordTextFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBackview);
        make.left.equalTo(passwordBackview.mas_left).offset(20);
        make.height.equalTo(@(50));
        make.centerX.equalTo(ws.view);
    }];
    
    self.surePassWordTextFile = [[UITextField alloc]init];
    self.surePassWordTextFile.delegate = self;
    self.surePassWordTextFile.secureTextEntry = YES;
    self.surePassWordTextFile.placeholder = ZBLocalized(@"请输入新密码",nil);
    [self.surePassWordTextFile addTarget:self action:@selector(SUREpassWordFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.surePassWordTextFile];
    [self.surePassWordTextFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(SUREpasswordBackview);
        make.left.equalTo(SUREpasswordBackview.mas_left).offset(20);
        make.height.equalTo(@(50));
        make.centerX.equalTo(ws.view);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setBackgroundColor:[UIColor grayColor]];
    self.loginBtn.layer.cornerRadius=6;
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.enabled = NO;
    [self.loginBtn setTitle:ZBLocalized(@"修改密码", nil) forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.left.equalTo(ws.view.mas_left).offset(SCREEN_WIDTH / 7);
        make.height.equalTo(@(50));
        make.top.equalTo(ws.surePassWordTextFile.mas_bottom).offset(40);
    }];
    
    
    
}
-(void)login{
    NSString * md5Code = [MD5encryption MD5ForLower32Bate:self.codeNumStr];
    
    NSString * md5CodeNew = [MD5encryption MD5ForLower32Bate:self.surePassWordStr];
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,changePasswordURL];
    NSDictionary *parameters = @{@"qsid":userId,
                                 @"pwd":md5Code,
                                 @"nowpwd":md5CodeNew
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
            [defaults setObject:md5CodeNew forKey:UD_USERPassword];
            [defaults synchronize];
            [MBManager showBriefAlert:ZBLocalized(@"成功", nil)];
            [self performSelector:@selector(back) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
        }else{
            [MBManager showBriefAlert:ZBLocalized(@"密码错误", nil)];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBManager showBriefAlert:@"error"];
    }];
}

-(void)passWordFiledDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    self.codeNumStr = theTextField.text;
    if ( self.codeNumStr != nil &&self.surePassWordStr != nil &&  self.codeNumStr.length != 0&& self.surePassWordStr.length != 0) {
        [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:BaseYellow]];
        self.loginBtn.enabled = YES;
    }else{
        [self.loginBtn setBackgroundColor:[UIColor grayColor]];
        self.loginBtn.enabled = NO;
    }
}
-(void)SUREpassWordFiledDidChange:(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    self.surePassWordStr = theTextField.text;
    if ( self.codeNumStr != nil &&self.surePassWordStr != nil &&  self.codeNumStr.length != 0&& self.surePassWordStr.length != 0) {
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
