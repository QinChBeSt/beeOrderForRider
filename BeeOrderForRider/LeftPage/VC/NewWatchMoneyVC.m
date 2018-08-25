//
//  NewWatchMoneyVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//
#pragma mark - 全部历史账单 最外面

#import "NewWatchMoneyVC.h"
#import "DateDeatilOrderVC.h"
#import "AllHistroyOrderVC.h"
#import "CellForHistory.h"
#import "ModelForHisDate.h"
@interface NewWatchMoneyVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UIView *headView;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)UILabel *todayMoneyLab;
@property (nonatomic , strong)UILabel *addMoeyLab;
@property (nonatomic , strong)UILabel *addOrderCountLab;
@property (nonatomic , strong)UIProgressView *progressView;
@property (nonatomic , strong)NSMutableArray *arrForHIsDate;
@property (nonatomic , assign)NSInteger todayIndex;
@property (nonatomic , strong)NSString *isHaveTodayDate;
@property (nonatomic , strong)NSMutableArray *arrForToday;
@end

@implementation NewWatchMoneyVC
-(NSMutableArray *)arrForHIsDate{
    if (_arrForHIsDate == nil) {
        _arrForHIsDate = [NSMutableArray array];
        
    }
    return _arrForHIsDate;
}
-(NSMutableArray *)arrForToday{
    if (_arrForToday == nil) {
        _arrForToday = [NSMutableArray array];
        
    }
    return _arrForToday;
}
-(void)getnetwork{
    self.isHaveTodayDate = @"no";
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *useriD = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,historyDaysOrderURL];
    NSDictionary *parameters = @{@"qsid":useriD,
                                 @"page":@"1"
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    [self.arrForHIsDate removeAllObjects];
    [managers POST:url parameters:parameters progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
               if ([code isEqualToString:@"1"]) {
                   int i = 0;
                   for (NSDictionary *dic in responseObject[@"value"]) {
                       ModelForHisDate *mod = [ModelForHisDate yy_modelWithDictionary:dic];
                       [self.arrForHIsDate addObject:mod];
                      
                       
                       
                       NSDate *now = [NSDate date];
                       NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                       fmt.dateFormat = @"yyyy-MM-dd";
                       NSString *nowDate = [fmt stringFromDate:now];
                      
                       if ([mod.cdate isEqualToString:nowDate]) {
                           self.todayMoneyLab.text =[NSString stringWithFormat:@"฿%.2f",[mod.givepic floatValue]] ;
                           self.addMoeyLab.text =[NSString stringWithFormat:@"฿%.2f", [mod.givepic floatValue]];
                           self.addOrderCountLab.text = [NSString stringWithFormat:@"%@%@%@",ZBLocalized(@"共", nil),mod.orderallnum,ZBLocalized(@"笔", nil)];
                           self.todayIndex = i;
                           ModelForHisDate *modtoday = [self.arrForHIsDate objectAtIndex:i];
                           [self.arrForToday addObject:modtoday];
                           [self.arrForHIsDate removeObjectAtIndex:i];
                           self.isHaveTodayDate = @"yes";
                       }
                        i++;
                       
                   }
                  
               }else{
                   [MBManager showBriefAlert:responseObject[@"msg"]];
               }
               NSLog(@"%lu",(unsigned long)self.arrForHIsDate.count);
//               self.arrForHIsDate=(NSMutableArray *)[[self.arrForHIsDate reverseObjectEnumerator] allObjects];
               [self.tableView reloadData];
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
           }];
    
}
-(void)createNaviView{
    self.view.backgroundColor = [UIColor whiteColor];
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
    titleLabel.text = ZBLocalized(@"历史账单", nil);
    titleLabel.textColor = [UIColor blackColor];
    [self.naviView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(backImg);
    }];
}
#pragma mark - 点击事件
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviView];
    [self createTableView];
    [self getnetwork];
}
-(void)createHeadView{
    __weak typeof(self) ws = self;
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 180)];
    [self.view addSubview:self.headView];
    
    UIView *todayTopBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.headView addSubview:todayTopBack];
    
    UILabel *todayTit = [[UILabel alloc]init];
    todayTit.text = ZBLocalized(@"今日预计收入", nil);
    todayTit.numberOfLines = 2;
    [self.headView addSubview:todayTit];
    [todayTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH / 3 ));
        make.left.equalTo(ws.headView).offset(15);
        make.centerY.equalTo(todayTopBack);
    }];
    
    
    UILabel *todayDateLab = [[UILabel alloc]init];
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    todayDateLab.font = [UIFont systemFontOfSize:12];
    NSString *nowDate = [fmt stringFromDate:now];
    todayDateLab.text = [self pp_formatDateWithArrYMDToMD:nowDate];
    [self.headView addSubview:todayDateLab];
    [todayDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(todayTit);
        make.left.equalTo(todayTit.mas_right).offset(1);
    }];
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    rightIcon.image  = [UIImage imageNamed:@"右箭头"];
    [self.headView addSubview:rightIcon];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(todayTit);
        make.right.equalTo(ws.headView.mas_right).offset(-15);
        make.width.and.height.equalTo(@(15));
    }];
    
    self.todayMoneyLab = [[UILabel alloc]init];
    self.todayMoneyLab.textColor = [UIColor colorWithHexString:BaseYellow];
    [self.headView addSubview:self.todayMoneyLab];
    [self.todayMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(todayTit);
        make.right.equalTo(rightIcon.mas_left).offset(-5);
    }];
    
    UIButton *toTodaydeatilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toTodaydeatilBtn addTarget:self action:@selector(toDatail) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:toTodaydeatilBtn];
    [toTodaydeatilBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(todayTit);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.centerX.equalTo(ws.view);
        make.height.equalTo(todayTopBack);
    }];
    
    
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor colorWithHexString:BaseTextBlack];
    [self.headView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(toTodaydeatilBtn);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.centerX.equalTo(ws.view);
        make.height.equalTo(@(0.5));
    }];
    
    UILabel *midTit = [[UILabel alloc]init];
    midTit.text = ZBLocalized(@"外卖订单", nil);
    midTit.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:midTit];
    [midTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(todayTit);
        make.height.equalTo(@(40));
        make.top.equalTo(topLine.mas_bottom);
    }];
    
    self.addMoeyLab = [[UILabel alloc]init];
    self.addMoeyLab.font = [UIFont systemFontOfSize:14];
    self.addMoeyLab.textColor = [UIColor blackColor];
    [self.headView addSubview:self.addMoeyLab];
    [self.addMoeyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(midTit);
        make.right.equalTo(ws.headView.mas_right).offset(-20);
    }];
    
    self.addOrderCountLab = [[UILabel alloc]init];
    self.addOrderCountLab.font = [UIFont systemFontOfSize:16];
    self.addOrderCountLab.textColor = [UIColor blackColor];
    [self.headView addSubview:self.addOrderCountLab];
    [self.addOrderCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(midTit);
        make.right.equalTo(ws.addMoeyLab.mas_left).offset(-20);
    }];
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 30)];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 5.0f);
    self.progressView.transform = transform;
    //甚至进度条的风格颜色值，默认是蓝色的
    self.progressView.progressTintColor=[UIColor colorWithHexString:BaseYellow];
    //表示进度条未完成的，剩余的轨迹颜色,默认是灰色
    self.progressView.trackTintColor =[UIColor clearColor];
    [self.headView addSubview:self.progressView];
    
    UIView *midLine = [[UIView alloc]init];
    midLine.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
    [self.headView addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(10));
        make.bottom.equalTo(ws.headView.mas_bottom).offset(-50);
    }];
    
    
    UILabel *histroyTit = [[UILabel alloc]init];
    histroyTit.text = ZBLocalized(@"历史账单", nil);
    [self.headView addSubview:histroyTit];
    [histroyTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(todayTit);
        make.top.equalTo(midLine.mas_bottom);
        make.bottom.equalTo(ws.headView);
    }];
    
    UIImageView *hisrightIcon = [[UIImageView alloc]init];
    hisrightIcon.image  = [UIImage imageNamed:@"右箭头"];
    [self.headView addSubview:hisrightIcon];
    [hisrightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(histroyTit);
        make.right.equalTo(ws.headView.mas_right).offset(-15);
        make.width.and.height.equalTo(@(15));
    }];
    
    UILabel *hisSub = [[UILabel alloc]init];
    hisSub.text = ZBLocalized(@"历史账单", nil);
    hisSub.font = [UIFont systemFontOfSize:13];
    hisSub.textColor = [UIColor blackColor];
    [self.headView addSubview:hisSub];
    [hisSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(histroyTit);
        make.right.equalTo(rightIcon.mas_left).offset(-5);
    }];
    
    UIView *buttomLine = [[UIView alloc]init];
    buttomLine.backgroundColor = [UIColor colorWithHexString:BaseTextBlack];
    [self.headView addSubview:buttomLine];
    [buttomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.headView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.centerX.equalTo(ws.view);
        make.height.equalTo(@(0.5));
    }];
    
    UIButton *toAllhistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toAllhistoryBtn addTarget:self action:@selector(toAllhistory) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:toAllhistoryBtn];
    [toAllhistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(histroyTit);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.centerX.equalTo(ws.view);
        make.bottom.equalTo(ws.headView);
    }];
    
    
    self.todayMoneyLab.text = @"฿0";
    self.addMoeyLab.text = @"฿0";
    self.addOrderCountLab.text =[NSString stringWithFormat:@"%@0%@",ZBLocalized(@"共", nil),ZBLocalized(@"笔", nil)];;
    self.progressView.progress=1.0;
}
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self createHeadView];
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
}
#pragma mark- UITabelViewDataSource/delegat
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrForHIsDate.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellForHistory *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil)
    {
        cell = [[CellForHistory alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    ModelForHisDate *Mod = [self.arrForHIsDate objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([Mod.starts isEqualToString:@"2"]) {
        cell.orderState.text = ZBLocalized(@"待交账", nil);
    }else{
        cell.orderState.text = ZBLocalized(@"已交账", nil);
    }
    cell.dateLab.text = Mod.cdate;
    cell.picLab.text = [NSString stringWithFormat:@"฿%.2f",[ Mod.givepic floatValue]];;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DateDeatilOrderVC *dateDetaul = [[DateDeatilOrderVC alloc]init];
     ModelForHisDate *Mod = [self.arrForHIsDate objectAtIndex:indexPath.row];
    dateDetaul.modHISdate = Mod;
    [self.navigationController pushViewController:dateDetaul animated:YES];
}
- (NSString *)pp_formatDateWithArrYMDToMD:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSInteger year = [array[0] integerValue];
    NSInteger month = [array[1] integerValue];
    NSInteger day = [array[2] integerValue];
    
    return [NSString stringWithFormat:@"(%lu.%lu.%lu)",(long)year,(long)month, (long)day];
}
- (NSString *)pp_NoformatDateWithArrYMDToMD:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSInteger year = [array[0] integerValue];
    NSInteger month = [array[1] integerValue];
    NSInteger day = [array[2] integerValue];
    
    return [NSString stringWithFormat:@"%lu-%lu-%lu",(long)year,(long)month, (long)day];
}
-(void)toDatail{
    
    if ([self.isHaveTodayDate isEqualToString:@"no"]) {
        [MBManager showBriefAlert:ZBLocalized(@"暂无今日数据", nil)];
    }else{
        DateDeatilOrderVC *dateDetaul = [[DateDeatilOrderVC alloc]init];
        ModelForHisDate *mod = [self.arrForToday objectAtIndex:0];
        dateDetaul.modHISdate = mod;
        dateDetaul.isToday = @"yes";
        [self.navigationController pushViewController:dateDetaul animated:YES];
    }
    
}
-(void)toAllhistory{
    AllHistroyOrderVC *dateDetaul = [[AllHistroyOrderVC alloc]init];
    [self.navigationController pushViewController:dateDetaul animated:YES];
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
