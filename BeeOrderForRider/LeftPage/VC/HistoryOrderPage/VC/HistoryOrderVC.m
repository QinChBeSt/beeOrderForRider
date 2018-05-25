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
#import "OrderDetilVC.h"
#define lineHeight 40
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

@property (nonatomic , strong)UILabel *tolitLab;
@property (nonatomic , strong)UILabel *openLab;
@property (nonatomic , strong)UILabel *closeLab;
@property (nonatomic , strong)UIView *topView;
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
    [self createTopView];
    [self createTableView];
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;// 屏幕左侧边缘响应
    [self.view addGestureRecognizer:leftEdgeGesture];
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
-(void)createTopView{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, lineHeight * 3 + 10)];
    self.topView.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.view addSubview:self.topView];
 
    UIView *totilView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lineHeight)];
    totilView.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:totilView];
    UILabel *totilTit = [[UILabel alloc]init];
    totilTit.font = [UIFont systemFontOfSize:14];
    totilTit.textColor = [UIColor colorWithHexString:@"4b4b4b"];
    totilTit.text = ZBLocalized(@"总计", nil);
    [totilView addSubview:totilTit];
    [totilTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totilView);
        make.left.equalTo(totilView.mas_left).offset(20);
    }];
    
    self.tolitLab = [[UILabel alloc]init];
    self.tolitLab.font = [UIFont systemFontOfSize:14];
    self.tolitLab.textColor = [UIColor colorWithHexString:@"4b4b4b"];
    self.tolitLab.text = ZBLocalized(@"￥0", nil);
    [totilView addSubview:self.tolitLab];
    [self.tolitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totilView);
        make.right.equalTo(totilView.mas_right).offset(-20);
    }];
    
   
    
    UIView *openView = [[UIView alloc]initWithFrame:CGRectMake( 0,lineHeight + 10, SCREEN_WIDTH, lineHeight)];
    openView.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:openView];
    UILabel *openTit = [[UILabel alloc]init];
    [openView addSubview:openTit];
    openTit.font = [UIFont systemFontOfSize:14];
    openTit.textColor = [UIColor colorWithHexString:@"4b4b4b"];
    openTit.text = ZBLocalized(@"派送时间", nil);
    [openTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(openView);
        make.left.equalTo(openView.mas_left).offset(20);
    }];
    UIImageView *openIcon = [[UIImageView alloc]init];
    openIcon.image = [UIImage imageNamed:@"右箭头"];
    [openView addSubview:openIcon];
    [openIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(openView);
        make.right.equalTo(openView.mas_right).offset(-20);
        make.width.and.height.equalTo(@(15));
    }];
    self.openLab = [[UILabel alloc]init];
    self.openLab.text = ZBLocalized(@"请选择送达时间", nil);
    self.openLab.font = [UIFont systemFontOfSize:14];
    self.openLab.textColor = [UIColor colorWithHexString:@"959595"];
    [openView addSubview:self.openLab];
    [self.openLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(openView);
        make.right.equalTo(openIcon.mas_left).offset(-2);
    }];
    UIButton *openBtnn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openBtnn addTarget:self action:@selector(actionToChooseOpen) forControlEvents:UIControlEventTouchUpInside];
    [openView addSubview:openBtnn];
    [openBtnn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(openView);
        make.centerX.equalTo(openView);
        make.width.and.height.equalTo(openView);
    }];
    
    UIView *closeView = [[UIView alloc]initWithFrame:CGRectMake(0, lineHeight * 2 + 10, SCREEN_WIDTH, lineHeight)];
    closeView.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:closeView];
    
    UILabel *closeTit = [[UILabel alloc]init];
    [closeView addSubview:closeTit];
    closeTit.font = [UIFont systemFontOfSize:14];
    closeTit.textColor = [UIColor colorWithHexString:@"4b4b4b"];
    closeTit.text = ZBLocalized(@"送达时间", nil);
    [closeTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeView);
        make.left.equalTo(closeView.mas_left).offset(20);
    }];
    
    UIImageView *closeIcon = [[UIImageView alloc]init];
    closeIcon.image = [UIImage imageNamed:@"右箭头"];
    [closeView addSubview:closeIcon];
    [closeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeView);
        make.right.equalTo(closeView.mas_right).offset(-20);
        make.width.and.height.equalTo(@(15));
    }];
    
    self.closeLab = [[UILabel alloc]init];
    self.closeLab.text = ZBLocalized(@"请选择送达时间", nil);
    self.closeLab.font = [UIFont systemFontOfSize:14];
    self.closeLab.textColor = [UIColor colorWithHexString:@"959595"];
    [closeView addSubview:self.closeLab];
    [self.closeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeView);
        make.right.equalTo(closeIcon.mas_left).offset(-2);
    }];
    
    UIButton *closeBtnn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtnn addTarget:self action:@selector(actionToChooseClose) forControlEvents:UIControlEventTouchUpInside];
    [closeView addSubview:closeBtnn];
    [closeBtnn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeView);
        make.centerX.equalTo(closeView);
        make.width.and.height.equalTo(closeView);
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + lineHeight* 3 + 10, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight - lineHeight* 3 - 10) style:UITableViewStylePlain];
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
     return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH  tableView:self.tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetilVC *order = [[OrderDetilVC alloc]init];
    ModelForHistory *mod = [[ModelForHistory alloc]init];
    mod = [self.arrForHistory objectAtIndex:indexPath.row];
    order.mod = mod;
    [self.navigationController pushViewController:order animated:YES];
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
        self.openLab.text = self.openStr;
        
        
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
        self.closeLab.text = self.closeStr;
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
                self.tolitLab.text = [NSString stringWithFormat:@"%@ %@",ZBLocalized(@"￥", nil),dic[@"totalspic"]];
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
