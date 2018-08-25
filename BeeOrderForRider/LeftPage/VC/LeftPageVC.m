//
//  LeftPageVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/7.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "LeftPageVC.h"
#import "LoginVC.h"
#import "HistoryOrderVC.h"
#import "ChangePasswordVC.h"
#import "CellForLeftPage.h"
#import "ChangelanguageVC.h"
#import "AboutVC.h"
#import "NewWatchMoneyVC.h"
#import "CellForChooseLag.h"
#import "QCNavigationController.h"
#import "HomeVC.h"
#define headViewHeight SCREENH_HEIGHT * 0.225
#define buttomViewHeight SCREENH_HEIGHT * 0.150
@interface LeftPageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSString *orderType;
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)NSString *workState;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIImageView *headView;
@property (nonatomic , strong)UIView *buttomView;
@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , assign)CGFloat width;
@property (nonatomic , strong)UIButton *workupBtn;
@property (nonatomic , strong)UIButton *buzyBtn;
@property (nonatomic , strong)UIButton *stopBtn;
@property (nonatomic , strong)UIImageView *workUpImg;
@property (nonatomic , strong)UILabel *workLab;
@property (nonatomic , strong)UIImageView *buzyUpImg;
@property (nonatomic , strong)UILabel *buzyLab;
@property (nonatomic , strong)UIImageView *StopUpImg;
@property (nonatomic , strong)UILabel *StopLab;

@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)UIImageView *headImage;
@property (nonatomic , strong)UILabel *userNameLab;
@property (nonatomic , strong)UILabel *userPhoneLab;
@property (nonatomic , strong) UITableView *tableViewToChage;
@property (nonatomic , strong)UIView *windowBackView;
@property (nonatomic , strong)UIView *changeLagView;
@property (nonatomic , strong)NSIndexPath *lastIndexPath;
@end

@implementation LeftPageVC
-(void)viewWillAppear:(BOOL)animated{
    //[self getNetWorkForStats];
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *imgUrl  = [NSString stringWithFormat:@"%@%@",IMGBaesURL,[defaults objectForKey:UD_USERLOGO]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_qishoutouxiang"]];
    NSString *userName  = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERNAME]];
    self.userNameLab.text = userName;
    NSString *userPhone  = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERPHONE]];
    self.userPhoneLab.text = userPhone;
    
    NSString *userState  = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERState]];
    [self setWorkStateStr:userState];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)getNetWorkForStats{
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *userState  = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERState]];
    [self setWorkStateStr:userState];
    NSString *Account = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERAccount]];
    NSString *Password = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERPassword]];
     NSString * uuidStr= [UUID getUUID];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,LoginURL];
    NSDictionary *parameters = @{@"name":Account,
                                 @"pwd":Password,
                                  @"imei":uuidStr
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
            NSDictionary *dic = responseObject[@"value"];
            NSString *userState =[NSString stringWithFormat:@"%@",dic[@"originallyState"]];
           [self setWorkStateStr:userState];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userState forKey:UD_USERState];
            [defaults synchronize];
            
        }else{
            [MBManager showBriefAlert:ZBLocalized(@"账号异常，请重新登录", nil)];
            [self logOut];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *userState  = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERState]];
        [self setWorkStateStr:userState];
        
    }];
   
}
-(void)getNetForChangeWorkState:(NSString *)str{
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *useriD = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,ChangeWorkStatesURL];
    NSDictionary *parameters = @{@"flg":str,
                                 @"qsid":useriD
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    //请求的方式：POST
    [managers POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self netWorkSussToChangeState:str];
        }else{
            [MBManager showBriefAlert:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor colorWithHexString:BaseBackgroundGray];
    
    [self createNaviView];
    [self createBottomView];
    [self createTableView];
   
}

#pragma mark - ui
-(void)createNaviView{
//    self.width = [UIScreen mainScreen].bounds.size.width - 50;
//    if ([UIScreen mainScreen].bounds.size.width > 375) {
//        self.width -= 50;
//    } else if ([UIScreen mainScreen].bounds.size.width > 320) {
//        self.width = self.width - 25;
//    }

   self.width = [UIScreen mainScreen].bounds.size.width * 0.8;
    self.view.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    self.naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, SafeAreaStatsBarHeight )];
    self.naviView.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [self.view addSubview:self.naviView];
    
    __weak typeof(self) ws = self;
//    UIImageView *backImg = [[UIImageView alloc]init];
//    [backImg setImage:[UIImage imageNamed:@"back_icon"]];
//    [self.naviView addSubview:backImg];
//    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight + 5);
//        make.left.equalTo(ws.naviView.mas_left).offset(15);
//        make.width.equalTo(@(30));
//        make.height.equalTo(@(30));
//    }];
//
//    UIButton *backBTN = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBTN addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.naviView addSubview:backBTN];
//    [backBTN mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight);
//        make.left.equalTo(ws.naviView.mas_left).offset(10);
//        make.width.equalTo(@(40));
//        make.height.equalTo(@(SafeAreaTopHeight - SafeAreaStatsBarHeight));
//    }];
//
//    self.titleLabel = [[UILabel alloc]init];
//    self.titleLabel.text = self.workState;
//    self.titleLabel.textColor = [UIColor blackColor];
//    [self.naviView addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(ws.view);
//        make.centerY.equalTo(backImg);
//    }];
    self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SafeAreaStatsBarHeight, self.width, headViewHeight)];
    self.headView.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    self.headView.image = [UIImage imageNamed:@"bg_qishougerizhongxin"];
    [self.view addSubview:self.headView];
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *imgUrl  = [NSString stringWithFormat:@"%@%@",IMGBaesURL,[defaults objectForKey:UD_USERLOGO]];
    self.headImage = [[UIImageView alloc]init];
    self.headImage.image = [UIImage imageNamed:@"icon_qishoutouxiang"];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_qishoutouxiang"]];
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = (headViewHeight - 60) / 2;
    [self.headView addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.headView.mas_left).offset(25);
        make.centerY.equalTo(ws.headView);
        make.top.equalTo(ws.headView.mas_top).offset(30);
        make.width.equalTo(ws.headImage.mas_height);
    }];
    
    self.userNameLab = [[UILabel alloc]init];
    NSString *userName  = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERNAME]];
    self.userNameLab.text = userName;
    [self.headView addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.headImage.mas_top);
        make.bottom.equalTo(ws.headImage.mas_centerY);
        make.left.equalTo(ws.headImage.mas_right).offset(20);
    }];
    
    self.userPhoneLab = [[UILabel alloc]init];
    NSString *userPhone  = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERPHONE]];
    self.userPhoneLab.text = userPhone;
    [self.headView addSubview:self.userPhoneLab];
    [self.userPhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.headImage.mas_bottom);
        make.top.equalTo(ws.headImage.mas_centerY);
        make.left.equalTo(ws.headImage.mas_right).offset(20);
    }];
}

-(void)createBottomView{
    __weak typeof(self) ws = self;
    self.buttomView = [[UIView alloc]init];
    self.buttomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttomView];
    [self.buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.naviView);
        make.top.equalTo(ws.headView.mas_bottom);
        make.left.equalTo(ws.naviView);
        make.height.equalTo(@(buttomViewHeight));
    }];
    
    self.workupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttomView addSubview:self.workupBtn];
    [self.workupBtn addTarget:self action:@selector(choooseWork) forControlEvents:UIControlEventTouchUpInside];
    [self.workupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ws.width / 3));
        make.top.equalTo(ws.buttomView);
        make.left.equalTo(ws.buttomView);
        make.bottom.equalTo(ws.buttomView);
    }];
    self.workUpImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_kaigong"]];
    [self.workupBtn addSubview:self.workUpImg];
    [self.workUpImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.workupBtn);
        make.top.equalTo(ws.workupBtn.mas_top).offset(15);
        make.bottom.equalTo(ws.workupBtn.mas_centerY);
        make.width.equalTo(ws.workUpImg.mas_height);
    }];
    self.workLab = [[UILabel alloc]init];
    self.workLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
    self.workLab.text = ZBLocalized(@"开工", nil);
    self.workLab.font = [UIFont systemFontOfSize:14];
    [self.workupBtn addSubview:self.workLab];
    [self.workLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.workupBtn);
        make.top.equalTo(ws.workupBtn.mas_centerY).offset(10);
    }];
    
    self.buzyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttomView addSubview:self.buzyBtn];
    [self.buzyBtn addTarget:self action:@selector(choooseBuzy) forControlEvents:UIControlEventTouchUpInside];
    [self.buzyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ws.width / 3));
        make.top.equalTo(ws.buttomView);
        make.left.equalTo(ws.workupBtn.mas_right);
        make.bottom.equalTo(ws.buttomView);
    }];
    self.buzyUpImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_manglu"]];
    [self.buzyBtn addSubview:self.buzyUpImg];
    [self.buzyUpImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.buzyBtn);
        make.top.equalTo(ws.buzyBtn.mas_top).offset(15);
        make.bottom.equalTo(ws.buzyBtn.mas_centerY);
        make.width.equalTo(ws.buzyUpImg.mas_height);
    }];
    self.buzyLab = [[UILabel alloc]init];
    self.buzyLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
    self.buzyLab.text = ZBLocalized(@"忙碌", nil);
    self.buzyLab.font = [UIFont systemFontOfSize:14];
    [self.buzyBtn addSubview:self.buzyLab];
    [self.buzyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.buzyBtn);
        make.top.equalTo(ws.buzyBtn.mas_centerY).offset(10);
    }];
    
    
    
    
    self.stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttomView addSubview:self.stopBtn];
    [self.stopBtn addTarget:self action:@selector(choooseStop) forControlEvents:UIControlEventTouchUpInside];
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ws.width / 3));
        make.top.equalTo(ws.buttomView);
        make.left.equalTo(ws.buzyBtn.mas_right);
        make.bottom.equalTo(ws.buttomView);
    }];
    self.StopUpImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_shougong"]];
    [self.stopBtn addSubview:self.StopUpImg];
    [self.StopUpImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.stopBtn);
        make.top.equalTo(ws.stopBtn.mas_top).offset(15);
        make.bottom.equalTo(ws.stopBtn.mas_centerY);
        make.width.equalTo(ws.StopUpImg.mas_height);
    }];
    self.StopLab = [[UILabel alloc]init];
    self.StopLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
    self.StopLab.text = ZBLocalized(@"收工", nil);
    self.StopLab.font = [UIFont systemFontOfSize:14];
    [self.stopBtn addSubview:self.StopLab];
    [self.StopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.stopBtn);
        make.top.equalTo(ws.stopBtn.mas_centerY).offset(10);
    }];
 
}

-(void)createTableView{
    __weak typeof(self) ws = self;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    UIView *footView =[[UIView alloc]init];
    footView.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    
    self.tableView.tableFooterView = footView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.buttomView.mas_bottom).offset(15);
        make.centerX.equalTo(ws.buttomView);
        make.width.equalTo(ws.buttomView);
        make.bottom.equalTo(ws.view);
    }];
    
    UILabel *versonLab = [[UILabel alloc]init];
    versonLab.font = [UIFont systemFontOfSize:14];
    versonLab.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    [self.view addSubview:versonLab];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    versonLab.text =[NSString stringWithFormat:@"V %@ (%@)",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[infoDictionary objectForKey:@"CFBundleVersion"]];
    [versonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.tableView);
        make.bottom.equalTo(ws.tableView);
    }];
}
#pragma mark- UITabelViewDataSource/delegat
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 5;
    }else{
        return 3;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        CellForLeftPage *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if(cell == nil)
        {
            cell = [[CellForLeftPage alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.img.image = [UIImage imageNamed:@"icon_erjidingdan"];
            cell.Tlabel.text = ZBLocalized(@"订单查询", nil);
        }
        else if (indexPath.row ==2){
            cell.img.image = [UIImage imageNamed:@"icon_erjimimaxiugai"];
            cell.Tlabel.text = ZBLocalized(@"修改密码", nil);
        }else if (indexPath.row == 1){
            cell.img.image = [UIImage imageNamed:@"icon_erjichakanyeji"];
            cell.Tlabel.text = ZBLocalized(@"历史账单", nil);
        }
        else if (indexPath.row == 3){
            cell.img.image = [UIImage imageNamed:@"icon_erjiyuyanqiehuan"];
            cell.Tlabel.text = ZBLocalized(@"语言切换", nil);
        }
     
        
        else if (indexPath.row == 4){
            cell.img.image = [UIImage imageNamed:@"icon_erjituichu"];
            cell.Tlabel.text = ZBLocalized(@"退出登录", nil);
        }
        return cell;
    }else{
        CellForChooseLag *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if(cell == nil)
        {
            cell = [[CellForChooseLag alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (indexPath == self.lastIndexPath) {
            [cell.img setImage:[UIImage imageNamed:@"icon_xuankuang_down"]];
        }else{
            [cell.img setImage:[UIImage imageNamed:@"icon_xuankuang"]];
        }
        if (indexPath.section == 0) {
            if (indexPath.row == 0){
                cell.name.text = @"ภาษาไทย";
            }else if (indexPath.row == 1){
                cell.name.text = @"简体中文";
            }else if (indexPath.row == 2){
                cell.name.text = @"English";
            }
        }
        
        return cell;
        
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return 50;
    }else{
        return 40;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (indexPath.row == 0) {
            HistoryOrderVC *history = [[HistoryOrderVC alloc]init];
            [self.navigationController pushViewController:history animated:YES];
        }else if (indexPath.row == 1){
            NewWatchMoneyVC *view = [[NewWatchMoneyVC alloc]init];
            [self.navigationController pushViewController:view animated:YES];
            
        }
        else if (indexPath.row == 2){
            ChangePasswordVC *pasVc = [[ChangePasswordVC alloc]init];
            [self.navigationController pushViewController:pasVc animated:YES];
        }
        else if (indexPath.row == 3){
            [self createChangeLag];
            //[self.navigationController pushViewController:lang animated:YES];
        }
        
        
        else if (indexPath.row == 4){
            [self creatLogoutAction];
        }
        
    }else{
        self.lastIndexPath = indexPath;
        [self.tableViewToChage reloadData];
    }
   
}

#pragma mark - 切换状态点击事件
//1.第一次获取工作状态，更具存储数值或者拉取，改变侧边标题
-(void )setWorkStateStr:(NSString *)str{
    if ([str isEqualToString:@"1"]) {
        self.workState = ZBLocalized(@"开工", nil);
        [self choooseWork];
    }else if ([str isEqualToString:@"2"]){
        self.workState = ZBLocalized(@"忙碌", nil);
        [self choooseBuzy];
    }else if ([str isEqualToString:@"3"]){
        self.workState = ZBLocalized(@"收工", nil);
        [self choooseStop];
    }
    self.titleLabel.text = self.workState;
}

//2.更具获取的数值，出发按钮点击事件，进行网络请求改变按钮状态
-(void)choooseWork{
   
    [self getNetForChangeWorkState:@"1"];
   
}
-(void)choooseBuzy{
    [self getNetForChangeWorkState:@"2"];
    
}
-(void)choooseStop{
    [self getNetForChangeWorkState:@"3"];
    
}
//3.网络请求成功后改变按钮状态
-(void )netWorkSussToChangeState:(NSString *)str{
    if ([str isEqualToString:@"1"]) {
        self.workUpImg.image = [UIImage imageNamed:@"icon_kaigong_down"];
        self.workLab.textColor = [UIColor blackColor];
        
        self.buzyUpImg.image = [UIImage imageNamed:@"icon_manglu"];
        self.buzyLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
        
        self.StopUpImg.image = [UIImage imageNamed:@"icon_shougong"];
        self.StopLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:UD_USERState];
        [defaults synchronize];
        self.workState = ZBLocalized(@"开工", nil);
        self.titleLabel.text = self.workState;
        [self toGetAC];
    }else if ([str isEqualToString:@"2"]){
        self.workUpImg.image = [UIImage imageNamed:@"icon_kaigong"];
        self.workLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
        
        self.buzyUpImg.image = [UIImage imageNamed:@"icon_manglu_down"];
        self.buzyLab.textColor = [UIColor blackColor];
        
        self.StopUpImg.image = [UIImage imageNamed:@"icon_shougong"];
        self.StopLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"2" forKey:UD_USERState];
        [defaults synchronize];
        self.workState = ZBLocalized(@"忙碌", nil);
        self.titleLabel.text = self.workState;
        [self toGetAC];
    }else if ([str isEqualToString:@"3"]){
        self.workUpImg.image = [UIImage imageNamed:@"icon_kaigong"];
        self.workLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
        
        self.buzyUpImg.image = [UIImage imageNamed:@"icon_manglu"];
        self.buzyLab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
        
        self.StopUpImg.image = [UIImage imageNamed:@"icon_shougong_down"];
        self.StopLab.textColor = [UIColor blackColor];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"3" forKey:UD_USERState];
        [defaults synchronize];
        self.workState = ZBLocalized(@"收工", nil);
        self.titleLabel.text = self.workState;
        [self toGetAC];
    }
   
}



#pragma mark - 点击事件
-(void)back{
    if (self.blockCloceSide) {
        self.blockCloceSide(self.workState);
    }
}
-(void)LogoutAction{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,qsLogOUTURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERLogOutID]];
  //NSString *userId = [defaults objectForKey:UD_USERLogOutID];
    NSDictionary *parameters = @{@"id":userId,
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    [managers POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self logOut];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBManager showBriefAlert:ZBLocalized(@"服务器异常", nil)];
    }];
}
-(void)logOut{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        NSLog(@"删除Alias==%ld",(long)iResCode);
        
    } seq:0];

    NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    NSString *strTag = [NSString stringWithFormat:@"%@%@",JGPushAlias,userId];
    NSSet *set = [[NSSet alloc] initWithObjects:strTag,nil];
    [JPUSHService deleteTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        
        NSLog(@"删除Tag====%ld",(long)iResCode);
    } seq:0];
    [JPUSHService setTags:nil completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        
    } seq:0];
    [defaults setObject:nil forKey:UD_USERID];
    [defaults setObject:nil forKey:UD_USERNAME];
    [defaults setObject:nil forKey:UD_USERPHONE];
    [defaults setObject:nil forKey:UD_USERLOGO];
    [defaults setObject:nil forKey:UD_USERACTYPE];
    [defaults setObject:nil forKey:UD_USERAccount];
    [defaults setObject:nil forKey:UD_USERPassword];
    [defaults setObject:nil forKey:UD_USERState];
    [defaults setObject:nil forKey:UD_USERLogOutID];
    [defaults synchronize];
    
    
    
    LoginVC *login = [[LoginVC alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:login animated:YES];
    
    
}
-(void)creatLogoutAction{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:ZBLocalized(@"退出登录", nil) message:ZBLocalized(@"是否退出登录?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    /*
     typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
     UIAlertActionStyleDefault = 0,
     UIAlertActionStyleCancel,         取消按钮
     UIAlertActionStyleDestructive     破坏性按钮，比如：“删除”，字体颜色是红色的
     } NS_ENUM_AVAILABLE_IOS(8_0);
     
     */
    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
  
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:ZBLocalized(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:ZBLocalized(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self LogoutAction];
    }];
   
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    
    
    //相当于之前的[actionSheet show];
    //[self.navigationController pushViewController:actionSheet animated:NO];
    [self presentViewController:actionSheet animated:YES completion:nil];
}


-(void)toGetAC{
    NSDictionary *dic = @{
                          @"name":self.workState,
                          };
    NSNotification *noti = [NSNotification notificationWithName:@"homePageType" object:dic];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}


#pragma mark - 切换语言
-(void)createwindowBackView{
    self.windowBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    self.windowBackView.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:self.windowBackView];
    
}
-(void)createChangeLag{
    [self createwindowBackView];
    __weak typeof(self) ws = self;
    self.changeLagView = [[UIView alloc]init];
    self.changeLagView.layer.cornerRadius=10;
    
    self.changeLagView.clipsToBounds = YES;
    self.changeLagView.backgroundColor = [UIColor whiteColor];
    [self.windowBackView addSubview:self.changeLagView];
    [self.changeLagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.windowBackView);
        make.centerY.equalTo(ws.windowBackView);
        make.left.equalTo(ws.view.mas_left).offset(30);
        make.height.equalTo(@(185));
    }];
    
    
    [self createTableViewChage];
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.layer.cornerRadius=15;
    [backBtn setImage:[UIImage imageNamed:@"icon_guanbianniu"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    backBtn.clipsToBounds = YES;
    [self.windowBackView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.changeLagView.mas_right).offset(-5);
        make.centerY.equalTo(ws.changeLagView.mas_top).offset(5);
        make.width.and.height.equalTo(@(30));
    }];
    NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    NSLog(@"切换后的语言:%@",language);
    if ([language isEqualToString:@"th"]) {
        self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else if ([language isEqualToString:@"zh-Hans"]) {
        self.lastIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    else if ([language isEqualToString:@"en"]) {
        self.lastIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }
    [self.tableViewToChage reloadData];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn addTarget:self action:@selector(chooseLugOk) forControlEvents:UIControlEventTouchUpInside];
    okBtn.layer.cornerRadius=5;
    okBtn.clipsToBounds = YES;
    [okBtn setTitle:ZBLocalized(@"确定", nil) forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setBackgroundColor:[UIColor colorWithHexString:BaseYellow]];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.windowBackView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.tableViewToChage.mas_bottom).offset(5);
        make.bottom.equalTo(ws.changeLagView.mas_bottom).offset(-15);
        make.left.equalTo(ws.changeLagView.mas_centerX).offset(10);
        make.right.equalTo(ws.changeLagView.mas_right).offset(-15);
        
    }];
    
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cleanBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    cleanBtn.layer.cornerRadius=5;
    cleanBtn.clipsToBounds = YES;
    [cleanBtn setTitle:ZBLocalized(@"取消", nil) forState:UIControlStateNormal];
    [cleanBtn setTitleColor:[UIColor colorWithHexString:BaseYellow] forState:UIControlStateNormal];
    [cleanBtn setBackgroundColor:[UIColor whiteColor]];
    cleanBtn.layer.borderColor = [UIColor colorWithHexString:BaseYellow].CGColor;
    cleanBtn.layer.borderWidth = 1;
    okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.windowBackView addSubview:cleanBtn];
    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.tableViewToChage.mas_bottom).offset(5);
        make.bottom.equalTo(ws.changeLagView.mas_bottom).offset(-15);
        make.right.equalTo(ws.changeLagView.mas_centerX).offset(-10);
        make.left.equalTo(ws.changeLagView.mas_left).offset(15);
    }];
    
}
-(void)closeWindow{
    [self.windowBackView removeFromSuperview];
}
-(void)chooseLugOk{
    NSIndexPath *indexPath = self.lastIndexPath;
    if (indexPath.row==0) {
        
        [[ZBLocalized sharedInstance]setLanguage:@"th"];
        
    }
    if (indexPath.row==1) {
        
        [[ZBLocalized sharedInstance]setLanguage:@"zh-Hans"];
        
    }
    if (indexPath.row==2) {
        
        [[ZBLocalized sharedInstance]setLanguage:@"en"];
    }
    
    [self initRootVC];
    
    NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    NSLog(@"切换后的语言:%@",language);
}

- (void)initRootVC{
    HomeVC *home = [[HomeVC alloc]init];
    home.showLeft = @"1";
    [UIApplication sharedApplication].keyWindow.rootViewController = [[QCNavigationController alloc] initWithRootViewController:home];
    
}
-(void)createTableViewChage{
    __weak typeof(self) ws = self;
    self.tableViewToChage = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableViewToChage.delegate = self;
    self.tableViewToChage.dataSource = self;
    self.tableViewToChage.scrollEnabled = NO;
    self.tableViewToChage.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableViewToChage registerClass:[CellForChooseLag class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.windowBackView addSubview:self.tableViewToChage];
    [self.tableViewToChage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(ws.changeLagView);
        make.top.equalTo(ws.changeLagView).offset(10) ;
        make.left.equalTo(ws.changeLagView).offset(5);
        make.bottom.equalTo(ws.changeLagView).offset(-55);
    }];
    
    
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
