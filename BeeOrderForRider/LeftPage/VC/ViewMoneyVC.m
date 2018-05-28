//
//  ViewMoneyVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "ViewMoneyVC.h"
#import "CGXPickerView.h"
#import "CellForTodayMoney.h"
@interface ViewMoneyVC ()<UITableViewDelegate,UITableViewDataSource >
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UIView *headView;
@property (nonatomic , strong)UILabel *dataLabel;
@property (nonatomic , strong)NSString *selectDate;
@property (nonatomic , strong)UILabel *todayMoney;
@property (nonatomic , strong)UILabel *todayCount;
@property (nonatomic , strong)UITableView *tableView;
@end

@implementation ViewMoneyVC
#pragma mark - ui
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
    titleLabel.text = ZBLocalized(@"查看今日收益", nil);
    titleLabel.textColor = [UIColor blackColor];
    [self.naviView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(backImg);
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviView];
    [self setUpUI];
    [self createTableView];
    [self getNetworkForToday];
    // Do any additional setup after loading the view.
}
-(void)setUpUI{
    __weak typeof(self) ws = self;
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 0.387 * SCREEN_WIDTH + 50)];
    self.headView.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.view addSubview:self.headView];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.387)];
    headImg.backgroundColor = [UIColor orangeColor];
    [self.headView addSubview:headImg];
    
    UILabel *todayMoneyTit = [[UILabel alloc]init];
    todayMoneyTit.text = ZBLocalized(@"当日总金额", nil);
    todayMoneyTit.textColor = [UIColor whiteColor];
    [headImg addSubview:todayMoneyTit];
    [todayMoneyTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImg.mas_centerX).offset(-SCREEN_WIDTH / 4);
        make.centerY.equalTo(headImg.mas_centerY).offset(-SCREEN_WIDTH * 0.387 / 4);
    }];
    
    self.todayMoney = [[UILabel alloc]init];
    self.todayMoney.text = @"100.00";
    self.todayMoney.font = [UIFont systemFontOfSize:24];
    self.todayMoney.textColor = [UIColor whiteColor];
    [headImg addSubview:self.todayMoney];
    [self.todayMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImg.mas_centerX).offset(-SCREEN_WIDTH / 4);
        make.centerY.equalTo(headImg.mas_centerY).offset(SCREEN_WIDTH * 0.387 / 4);
    }];
    
    UILabel *todayCountTit = [[UILabel alloc]init];
    todayCountTit.text = ZBLocalized(@"当日总单数", nil);
    todayCountTit.textColor = [UIColor whiteColor];
    [headImg addSubview:todayCountTit];
    [todayCountTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImg.mas_centerX).offset(SCREEN_WIDTH / 4);
        make.centerY.equalTo(headImg.mas_centerY).offset(-SCREEN_WIDTH * 0.387 / 4);
    }];
    self.todayCount = [[UILabel alloc]init];
    self.todayCount.text = @"100.00";
    self.todayCount.font = [UIFont systemFontOfSize:24];
    self.todayCount.textColor = [UIColor whiteColor];
    [headImg addSubview:self.todayCount];
    [self.todayCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImg.mas_centerX).offset(SCREEN_WIDTH / 4);
        make.centerY.equalTo(headImg.mas_centerY).offset(SCREEN_WIDTH * 0.387 / 4);
    }];
    
    
    UIView *chooseDate = [[UIView alloc]init];
    chooseDate.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:chooseDate];
    [chooseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.width.equalTo(ws.view);
        make.top.equalTo(headImg.mas_bottom).offset(10) ;
        make.bottom.equalTo(ws.headView.mas_bottom);
    }];
    
    UIImageView *dataImg = [[UIImageView alloc]init];
    dataImg.backgroundColor = [UIColor orangeColor];
    [chooseDate addSubview:dataImg];
    [dataImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseDate);
        make.left.equalTo(chooseDate.mas_left).offset(25);
        make.top.equalTo(chooseDate.mas_top).offset(10);
        make.width.equalTo(dataImg.mas_height);
    }];
    
    self.dataLabel = [[UILabel alloc]init];
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowDate = [fmt stringFromDate:now];
    self.dataLabel.text = [self pp_formatDateWithArrYMDToMD:nowDate];
    [chooseDate addSubview:self.dataLabel];
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseDate);
        make.left.equalTo(dataImg.mas_right).offset(15);
    }];
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    rightIcon.image = [UIImage imageNamed:@"右箭头"];
    [chooseDate addSubview:rightIcon];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseDate);
        make.width.and.height.equalTo(@(20));
        make.right.equalTo(chooseDate.mas_right).offset(-20);
    }];
    
    UIButton *chooseDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseDate addSubview:chooseDateBtn];
    [chooseDateBtn addTarget:self action:@selector(toChooseDate) forControlEvents:UIControlEventTouchUpInside];
    [chooseDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.width.equalTo(ws.view);
        make.top.equalTo(headImg.mas_bottom).offset(10) ;
        make.bottom.equalTo(ws.headView.mas_bottom);
    }];
}
- (NSString *)pp_formatDateWithArrYMDToMD:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSInteger year = [array[0] integerValue];
    NSInteger month = [array[1] integerValue];
    NSInteger day = [array[2] integerValue];
    
    return [NSString stringWithFormat:@"%lu-%lu-%lu",(long)year,(long)month, (long)day];
}
-(void)toChooseDate{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr;
    nowStr = [fmt stringFromDate:now];
    
    [CGXPickerView showDatePickerWithTitle:ZBLocalized(@"选择时间", nil) DateType:UIDatePickerModeDate DefaultSelValue:self.selectDate MinDateStr:@"2017-01-01" MaxDateStr:nowStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
       self.dataLabel.text = [self pp_formatDateWithArrYMDToMD:selectValue];
        self.selectDate =selectValue;
        [self getNetWorkForDate:selectValue];
    }];
}
-(void)getNetworkForToday{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowDate = [fmt stringFromDate:now];
    [self getNetWorkForDate:nowDate];
}
-(void)getNetWorkForDate:(NSString *)dateStr{
    NSString *date = [self pp_formatDateWithArrYMDToMD:dateStr];
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,watchTodayMoney];
    NSDictionary *parameters = @{@"date":date,
                                 @"id":userId,
                                
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
//    [managers GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    //请求的方式：POST
    [managers POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@,",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"value"];
            self.todayMoney.text = [NSString stringWithFormat:@"%@",dic[@"sumPric"]];
            self.todayCount.text = [NSString stringWithFormat:@"%@",dic[@"sumNum"]];
        }else{
            [MBManager showBriefAlert:responseObject[@"msg"]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight +  0.387 * SCREEN_WIDTH + 50, SCREEN_WIDTH, SCREENH_HEIGHT  - SafeAreaTopHeight -  0.387 * SCREEN_WIDTH - 50) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
#pragma mark- UITabelViewDataSource/delegat
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellForTodayMoney *cell= [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil)
    {
        cell = [[CellForTodayMoney alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
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
