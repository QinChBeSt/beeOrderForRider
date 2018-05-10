//
//  HistoryOrderVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "HistoryOrderVC.h"
#import "CGXPickerView.h"
#import "ModelForHistory.h"
#import "ModelForOrderDetail.h"
#import "CellForHistoryOrder.h"
@interface HistoryOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UIButton *openBtn;
@property (nonatomic , strong)UIButton *closeBtn;
@property (nonatomic , strong)NSString *openStr;
@property (nonatomic , strong)NSString *closeStr;
@property (nonatomic , strong)UILabel *addPicLabel;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *arrForHistory;

@property (nonatomic , strong) NSString *parOpenStr;

@property (nonatomic , strong) NSString *parCloseStr;
/**
 *   页数
 */
@property (nonatomic,assign) int pageIndex;
@end

@implementation HistoryOrderVC
-(NSMutableArray *)arrForHistory{
    if (_arrForHistory == nil) {
        _arrForHistory = [NSMutableArray array];
    }
    return _arrForHistory;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviView];
    [self createBtnView];
    [self createTableView];
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
    
    UIButton *searchBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBTN setTitle:ZBLocalized(@"搜索", nil) forState:UIControlStateNormal];
    searchBTN.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBTN addTarget:self action:@selector(toSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:searchBTN];
    [searchBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight);
        make.right.equalTo(ws.naviView.mas_right).offset(-10);
        make.width.equalTo(@(60));
        make.height.equalTo(@(SafeAreaTopHeight - SafeAreaStatsBarHeight));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = ZBLocalized(@"历史订单", nil);
    titleLabel.textColor = [UIColor blackColor];
    [self.naviView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(backImg);
    }];
}
-(void)createBtnView{
    self.openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.openBtn];
    self.openBtn.backgroundColor= [UIColor colorWithHexString:BaseYellow];
    [self.openBtn setTitle:ZBLocalized(@"开始时间", nil) forState:UIControlStateNormal];
    self.openBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.openBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.openBtn.layer.cornerRadius=10;
     self.openBtn.clipsToBounds = YES;
    self.openBtn.layer.borderColor = [UIColor colorWithHexString:BaseYellow].CGColor;
    [self.openBtn addTarget:self action:@selector(actionToChooseOpen) forControlEvents:UIControlEventTouchUpInside];
    self.openBtn.frame = CGRectMake(10, SafeAreaTopHeight + 10, 100, 40);
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.closeBtn];
    self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.closeBtn.backgroundColor= [UIColor colorWithHexString:BaseYellow];
    [self.closeBtn setTitle:ZBLocalized(@"结束时间", nil) forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.closeBtn.layer.cornerRadius=10;
    self.closeBtn.clipsToBounds = YES;
    self.closeBtn.layer.borderColor = [UIColor colorWithHexString:BaseYellow].CGColor;
    [self.closeBtn addTarget:self action:@selector(actionToChooseClose) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.frame = CGRectMake(10 + 100 + 20, SafeAreaTopHeight + 10, 100, 40);
    __weak typeof(self) ws = self;
    self.addPicLabel = [[UILabel alloc]init];
    self.addPicLabel.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    self.addPicLabel.textAlignment = NSTextAlignmentRight;
    self.addPicLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.addPicLabel];
    [self.addPicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.openBtn);
        make.right.equalTo(ws.view.mas_right).offset(-10);
        make.left.equalTo(ws.closeBtn.mas_right).offset(10);
    }];
}
-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 60, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight - 60) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self toSearchHistory];
    }];
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreBills];
    }];
    self.tableView.mj_footer = footer;
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    [self.view addSubview:self.tableView];
}
#pragma mark- UITabelViewDataSource/delegat
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrForHistory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellForHistoryOrder *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil)
    {
        cell = [[CellForHistoryOrder alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    ModelForHistory *mod = [[ModelForHistory alloc]init];
    mod = [self.arrForHistory objectAtIndex:indexPath.row];
    cell.mod = mod;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}


- (NSString *)pp_formatDateWithArrYMDToMD:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSInteger year = [array[0] integerValue];
    NSInteger month = [array[1] integerValue];
    NSInteger day = [array[2] integerValue];
    
    return [NSString stringWithFormat:@"%lu-%lu-%lu",(long)year,(long)month, (long)day];
}

-(void)actionToChooseOpen{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr;
    if (self.closeStr.length == 0) {
        nowStr = [fmt stringFromDate:now];
    }else{
        nowStr = self.closeStr;
    }
    
   
    [CGXPickerView showDatePickerWithTitle:ZBLocalized(@"开始时间", nil) DateType:UIDatePickerModeDate DefaultSelValue:self.openStr MinDateStr:@"2017-01-01" MaxDateStr:nowStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
        self.openStr = selectValue;
        [self.openBtn setTitle:self.openStr forState:UIControlStateNormal];
        
    }];
}
-(void)actionToChooseClose{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr = [fmt stringFromDate:now];
    NSString *beginStr;
    if (self.openStr.length == 0) {
        beginStr = @"2017-01-01";
    }else{
        beginStr = self.openStr;
    }
   
    
    [CGXPickerView showDatePickerWithTitle:ZBLocalized(@"结束时间", nil) DateType:UIDatePickerModeDate DefaultSelValue:self.closeStr MinDateStr:beginStr MaxDateStr:nowStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
        self.closeStr = selectValue;
        [self.closeBtn setTitle:self.closeStr forState:UIControlStateNormal];
        
    }];
}
-(void)toSearchHistory{
    self.pageIndex = 1;
    if (self.openStr.length == 0) {
        [MBManager showBriefAlert:ZBLocalized(@"请选择开始时间", nil)];
    }else if(self.closeStr.length == 0){
        [MBManager showBriefAlert:ZBLocalized(@"请选择结束时间", nil)];
    }else{
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        NSUserDefaults *defaults;
        defaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
        
        self.parOpenStr = [self pp_formatDateWithArrYMDToMD:self.openStr];
       self.parCloseStr = [self pp_formatDateWithArrYMDToMD:self.closeStr];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,GetHistoryURL];
        NSDictionary *parameters = @{@"stime":self.parOpenStr,
                                     @"etime":self.parCloseStr,
                                     @"page":@"1",
                                     @"qsid":userId
                                     };

        //请求的方式：POST
        [self.arrForHistory removeAllObjects];
        [self.tableView.mj_header setHidden:NO];
        [MHNetWorkTask getWithURL:url withParameter:parameters withHttpHeader:nil withResponseType:ResponseTypeJSON withSuccess:^(id result) {
            NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSDictionary *dic = result[@"value"];
                self.addPicLabel.text = [NSString stringWithFormat:@"%@ %@%@",ZBLocalized(@"总计", nil),dic[@"totalspic"],ZBLocalized(@"元", nil)];
                NSMutableArray *arr = dic[@"getorderlist"];
                for (NSMutableDictionary *dicRes in arr) {
                    
                    ModelForHistory *mod = [ModelForHistory yy_modelWithDictionary:dicRes];
                   
                    [self.arrForHistory addObject:mod];
                    
                }
                if (self.arrForHistory.count == 0) {
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    [self.tableView reloadData];
                }else{
                    [self.tableView.mj_footer resetNoMoreData];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView reloadData];
                }
            }
            
            else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [MBManager showBriefAlert:result[@"msg"]];
            }
        } withFail:^(NSError *error) {
            
        }];
    }
}
-(void)loadMoreBills{
     self.pageIndex ++;
    if (self.openStr.length == 0) {
        [MBManager showBriefAlert:ZBLocalized(@"请选择开始时间", nil)];
    }else if(self.closeStr.length == 0){
        [MBManager showBriefAlert:ZBLocalized(@"请选择结束时间", nil)];
    }else{
        
        
        NSUserDefaults *defaults;
        defaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
        
        NSString *page = [NSString stringWithFormat:@"%d",self.pageIndex];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,GetHistoryURL];
        NSDictionary *parameters = @{@"stime":self.parOpenStr,
                                     @"etime":self.parCloseStr,
                                     @"page":page,
                                     @"qsid":userId
                                     };
        
        //请求的方式：POST

        [MHNetWorkTask getWithURL:url withParameter:parameters withHttpHeader:nil withResponseType:ResponseTypeJSON withSuccess:^(id result) {
            NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSDictionary *dic = result[@"value"];
                self.addPicLabel.text = [NSString stringWithFormat:@"%@ %@%@",ZBLocalized(@"总计", nil),dic[@"totalspic"],ZBLocalized(@"元", nil)];
                NSMutableArray *arr = dic[@"getorderlist"];
                if (arr.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                for (NSMutableDictionary *dicRes in arr) {
                    
                    ModelForHistory *mod = [ModelForHistory yy_modelWithDictionary:dicRes];
                    
                    [self.arrForHistory addObject:mod];
                    
                }
                if (self.arrForHistory.count == 0) {
                   [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                }
            }
            
            else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [MBManager showBriefAlert:result[@"msg"]];
            }
        } withFail:^(NSError *error) {
            
        }];
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
