//
//  DateDeatilOrderVC.m
//  BeeOrderForBusiness
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "DateDeatilOrderVC.h"
#import "CellForDateDetai.h"
#import "HistoryDetailOrderVC.h"
#import "ModelForHis.h"
#import "ModelForHisorder.h"
#define topGrayViewH 70
#define topTitLineH 40
#define midSubGrayH 120
#define buttomTwoLineH 30
#define tableTitH 40

#define kHeadHeight topGrayViewH + topTitLineH + midSubGrayH + buttomTwoLineH + tableTitH

@interface DateDeatilOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UIView *topView;
@property (nonatomic , strong)UILabel *stateLab;
@property (nonatomic , strong)UILabel *orderPic;
@property (nonatomic , strong)UILabel *orderCount;

@property (nonatomic , strong)UILabel *yjPicLab;
@property (nonatomic , strong)UILabel *sjhdPicLab;
@property (nonatomic , strong)UILabel *ptfwfPicLab;
@property (nonatomic , strong)UILabel *chPicLab;
@property (nonatomic , strong)UITableView *tableView;

@property (nonatomic , strong)NSMutableArray *arrForGoodList;

@property (nonatomic , strong)NSString *dateStr;
@property (nonatomic , strong)NSString *datePicStr;
@property (nonatomic , strong)NSString *goodsPicStr;
@property (nonatomic , strong)NSString *SJHDZCStr;
@property (nonatomic , strong)NSString *PSFstr;
@property (nonatomic , strong)NSString *boxStr;
@property (nonatomic , strong)NSString *orderCountStr;
@property (nonatomic , strong)NSString *jzztStr;


/**
 *   页数
 */
@property (nonatomic,assign) int pageIndex;
@end

@implementation DateDeatilOrderVC

-(NSMutableArray *)arrForGoodList{
    if (_arrForGoodList == nil) {
        _arrForGoodList = [NSMutableArray array];
    }
    return _arrForGoodList;
}
#pragma mark - ui
-(void)getNetWork{
    self.pageIndex = 1;
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,historyOrderDetail];
    NSDictionary *parameters = @{@"qsid":userId,
                                 @"cdate":self.dateStr,
                                 @"page":@"1"
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    [self.arrForGoodList removeAllObjects];
    [managers POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *arr = responseObject[@"value"];
          
            for (NSMutableDictionary *dic in arr) {
                NSMutableDictionary *dicOrder = dic[@"orders"];
                ModelForHisorder *modOneOrder = [ModelForHisorder yy_modelWithDictionary:dicOrder];
                
                ModelForHis *mod = [[ModelForHis alloc]init];
                mod.prdergoods =dic[@"prdergoods"]; ;
                mod.order = modOneOrder;
                mod.orderYhxEntities = dic[@"orderYhxEntities"];
                mod.goodspic = dic[@"goodspic"];
                mod.okpic = dic[@"okpic"];
                [self.arrForGoodList addObject:mod];
            }
            
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
            [MBManager showBriefAlert:responseObject[@"msg"]];
        }
        if (self.arrForGoodList.count == 0) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
            
        }else{
            
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)loadMoreBills{
    self.pageIndex ++;
    NSString *page = [NSString stringWithFormat:@"%d",self.pageIndex];
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,historyOrderDetail];
    NSDictionary *parameters = @{@"qsid":userId,
                                 @"cdate":self.dateStr,
                                 @"page":page
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    [managers POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *arr = responseObject[@"value"];
            if (arr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            for (NSMutableDictionary *dic in arr) {
                NSMutableDictionary *dicOrder = dic[@"orders"];
                ModelForHisorder *modOneOrder = [ModelForHisorder yy_modelWithDictionary:dicOrder];
                
                ModelForHis *mod = [[ModelForHis alloc]init];
                mod.prdergoods =dic[@"prdergoods"]; ;
                mod.order = modOneOrder;
                mod.orderYhxEntities = dic[@"orderYhxEntities"];
                mod.goodspic = dic[@"goodspic"];
                mod.okpic = dic[@"okpic"];
                [self.arrForGoodList addObject:mod];
            }
            
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
            [MBManager showBriefAlert:responseObject[@"msg"]];
        }
        if (self.arrForGoodList.count == 0) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
            
        }else{
            
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
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
    titleLabel.text = ZBLocalized(@"订单明细", nil);
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
    
    [self createTopView];
    [self createTableView];
    
    [self getNetWork];
}
-(void)createTopView{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, kHeadHeight)];
    [self.view addSubview:self.topView];
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topline.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
    [self.topView addSubview:topline];
    
    UIView *topbackView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, topGrayViewH)];
    topbackView.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.topView addSubview:topbackView];
    
    UILabel *topDatelab = [[UILabel alloc]init];
    [topbackView addSubview:topDatelab];
    [topDatelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topbackView);
        make.left.equalTo(topbackView).offset(10);
        make.height.equalTo(@(30));
    }];
    UILabel *toppiclab = [[UILabel alloc]init];
    [topbackView addSubview:toppiclab];
    [toppiclab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topbackView);
        make.right.equalTo(topbackView).offset(-10);
        make.height.equalTo(@(30));
    }];
    
    self.stateLab = [[UILabel alloc]init];
    self.stateLab.layer.borderWidth = 1;
    self.stateLab.numberOfLines = 2;
    self.stateLab.font = [UIFont systemFontOfSize:13];
    self.stateLab.backgroundColor = [UIColor whiteColor];
    self.stateLab.textColor = [UIColor colorWithHexString:BaseYellow];
    [topbackView addSubview:self.stateLab];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topDatelab.mas_bottom);
        make.left.equalTo(topbackView).offset(10);
        make.bottom.equalTo(topbackView.mas_bottom).offset(-10);
    }];
    
    __weak typeof(self) ws = self;
    UILabel *midTitlab = [[UILabel alloc]init];
    midTitlab.text = ZBLocalized(@"外卖订单", nil);
    [self.topView addSubview:midTitlab];
    [midTitlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topbackView.mas_bottom);
        make.left.equalTo(ws.topView).offset(10);
        make.height.equalTo(@(topTitLineH));
    }];
    self.orderPic  = [[UILabel alloc]init];
    self.orderPic.font = [UIFont systemFontOfSize:14];
    [self.topView addSubview:self.orderPic];
    [self.orderPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topbackView.mas_bottom);
        make.right.equalTo(ws.topView).offset(-10);
        make.height.equalTo(@(topTitLineH));
    }];
    
    self.orderCount  = [[UILabel alloc]init];
    self.orderCount.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:self.orderCount];
    [self.orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topbackView.mas_bottom);
        make.left.equalTo(ws.topView.mas_centerX);
        make.height.equalTo(@(topTitLineH));
    }];
    
    UIView *midGrayView = [[UIView alloc]init];
    midGrayView.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.topView addSubview:midGrayView];
    [midGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.topView);
        make.top.equalTo(midTitlab.mas_bottom);
        make.left.equalTo(ws.topView.mas_left).offset(10);
        make.height.equalTo(@(midSubGrayH));
    }];
    
    
    UILabel *yjPicTit = [[UILabel alloc]init];
    yjPicTit.numberOfLines = 2;
    yjPicTit.textAlignment = NSTextAlignmentLeft;
    yjPicTit.font = [UIFont systemFontOfSize:14];
    yjPicTit.text = ZBLocalized(@"菜品原价", nil);
    [midGrayView addSubview:yjPicTit];
    [yjPicTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midGrayView.mas_left).offset(5);
        make.top.equalTo(midGrayView);
        make.height.equalTo(@(35));
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    self.yjPicLab = [[UILabel alloc]init];
    self.yjPicLab.numberOfLines = 2;
    self.yjPicLab.textAlignment = NSTextAlignmentLeft;
    self.yjPicLab.font = [UIFont systemFontOfSize:14];
    
    [midGrayView addSubview:self.yjPicLab];
    [self.yjPicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midGrayView.mas_left).offset(5);
        make.top.equalTo(yjPicTit.mas_bottom);
        make.height.equalTo(@(25));
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    
    
    UILabel *sjhdPicTit = [[UILabel alloc]init];
    sjhdPicTit.numberOfLines = 2;
    sjhdPicTit.textAlignment = NSTextAlignmentCenter;
    sjhdPicTit.font = [UIFont systemFontOfSize:14];
    sjhdPicTit.text = ZBLocalized(@"商家活动支出", nil);
    [midGrayView addSubview:sjhdPicTit];
    [sjhdPicTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(midGrayView);
        make.top.equalTo(midGrayView);
        make.height.equalTo(@(35));
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    self.sjhdPicLab = [[UILabel alloc]init];
    self.sjhdPicLab.numberOfLines = 2;
    self.sjhdPicLab.textAlignment = NSTextAlignmentCenter;
    self.sjhdPicLab.font = [UIFont systemFontOfSize:14];
    
    [midGrayView addSubview:self.sjhdPicLab];
    [self.sjhdPicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(midGrayView);
        make.top.equalTo(yjPicTit.mas_bottom);
        make.height.equalTo(@(25));
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    
    UILabel *ptfwfPicTit = [[UILabel alloc]init];
    ptfwfPicTit.numberOfLines = 2;
    ptfwfPicTit.textAlignment = NSTextAlignmentRight;
    ptfwfPicTit.font = [UIFont systemFontOfSize:14];
    ptfwfPicTit.text = ZBLocalized(@"配送费", nil);
    [midGrayView addSubview:ptfwfPicTit];
    [ptfwfPicTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(midGrayView.mas_right).offset(-5);;
        make.top.equalTo(midGrayView);
        make.height.equalTo(@(35));
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    self.ptfwfPicLab  = [[UILabel alloc]init];
    self.ptfwfPicLab.numberOfLines = 2;
    self.ptfwfPicLab.textAlignment = NSTextAlignmentRight;
    self.ptfwfPicLab.font = [UIFont systemFontOfSize:14];
    
    [midGrayView addSubview:self.ptfwfPicLab];
    [self.ptfwfPicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(midGrayView.mas_right).offset(-5);;
        make.top.equalTo(yjPicTit.mas_bottom);
        make.height.equalTo(@(25));
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    UILabel *chPicTit = [[UILabel alloc]init];
    chPicTit.numberOfLines = 2;
    chPicTit.textAlignment = NSTextAlignmentLeft;
    chPicTit.font = [UIFont systemFontOfSize:14];
    chPicTit.text = ZBLocalized(@"餐盒费用", nil);
    [midGrayView addSubview:chPicTit];
    [chPicTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midGrayView.mas_left).offset(5);
        make.top.equalTo(ws.yjPicLab.mas_bottom);
        make.height.equalTo(@(30));
        //make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    self.chPicLab = [[UILabel alloc]init];
    self.chPicLab.numberOfLines = 2;
    self.chPicLab.textAlignment = NSTextAlignmentLeft;
    self.chPicLab.font = [UIFont systemFontOfSize:14];
    
    [midGrayView addSubview:self.chPicLab];
    [self.chPicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midGrayView.mas_left).offset(5);
        make.top.equalTo(chPicTit.mas_bottom);
        make.height.equalTo(@(30));
        //make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    
    UIView *buttomline = [[UIView alloc]initWithFrame:CGRectMake(0, kHeadHeight - tableTitH - 10, SCREEN_WIDTH, 10)];
    buttomline.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
    [self.topView addSubview:buttomline];
    
    UIView *tableTitBackGroundView = [[UIView alloc]init];
    tableTitBackGroundView.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.topView addSubview:tableTitBackGroundView];
    [tableTitBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.topView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(buttomline.mas_bottom);
        make.height.equalTo(@(tableTitH));
    }];
    
    UILabel *dateOrderTit = [[UILabel alloc]init];
    dateOrderTit.font = [UIFont systemFontOfSize:14];
    dateOrderTit.text = ZBLocalized(@"商家名称&订单编号", nil);
    dateOrderTit.numberOfLines = 2;
    [tableTitBackGroundView addSubview:dateOrderTit];
    [dateOrderTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableTitBackGroundView);
        make.left.equalTo(tableTitBackGroundView).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH / 3 * 2  - 30));
    }];
    
//    UILabel *dateOrderCountTit = [[UILabel alloc]init];
//    dateOrderCountTit.font = [UIFont systemFontOfSize:14];
//    dateOrderCountTit.text = ZBLocalized(@"商家名称&订单编号", nil);
//    dateOrderCountTit.numberOfLines = 2;
//    [tableTitBackGroundView addSubview:dateOrderCountTit];
//    [dateOrderCountTit mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(tableTitBackGroundView);
//        make.centerX.equalTo(ws.view);
//        make.width.equalTo(@(SCREEN_WIDTH / 3  - 15));
//    }];
    
    UILabel *moneyOrderTit = [[UILabel alloc]init];
    moneyOrderTit.textAlignment = NSTextAlignmentRight;
    moneyOrderTit.font = [UIFont systemFontOfSize:14];
    moneyOrderTit.text = ZBLocalized(@"金额", nil);
    moneyOrderTit.numberOfLines = 2;
    [tableTitBackGroundView addSubview:moneyOrderTit];
    [moneyOrderTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableTitBackGroundView);
        make.right.equalTo(tableTitBackGroundView).offset (-10);
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
    }];
    
    topDatelab.text = self.dateStr ;
    toppiclab.text = self.datePicStr;
    self.orderPic.text = self.datePicStr;
    self.orderCount.text =self.orderCountStr ;
    self.stateLab.layer.borderColor = [UIColor colorWithHexString:BaseYellow].CGColor;
    self.stateLab.text =self.jzztStr;
    
    self.yjPicLab.text = self.goodsPicStr;
    self.sjhdPicLab.text =self.SJHDZCStr;
    self.ptfwfPicLab.text = self.PSFstr;
    self.chPicLab.text = self.boxStr;
}
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight , SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self createTopView];
    self.tableView.tableHeaderView = self.topView;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNetWork];
    }];
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreBills];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];
}
#pragma mark- UITabelViewDataSource/delegat
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrForGoodList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellForDateDetai *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil)
    {
        cell = [[CellForDateDetai alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    ModelForHis *mod = [[ModelForHis alloc]init];
    mod = [self.arrForGoodList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderName.text =[NSString stringWithFormat:@"%@#%@", mod.order.ordersShopName,mod.order.ordersNumDay];
    cell.orderPic.text = [NSString stringWithFormat:@"฿%@",mod.okpic];
    //cell.orderCount.text = [NSString stringWithFormat:@"#%@",mod.order.ordersNumDay];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryDetailOrderVC *his = [[HistoryDetailOrderVC alloc]init];
    ModelForHis *mod = [[ModelForHis alloc]init];
    mod = [self.arrForGoodList objectAtIndex:indexPath.row];
    his.modHis = mod;
    [self.navigationController pushViewController:his animated:YES];
}
-(void)setModHISdate:(ModelForHisDate *)modHISdate{
    self.datePicStr =[NSString stringWithFormat:@"฿%@",modHISdate.givepic] ;

    self.orderCountStr = [NSString stringWithFormat:@"%@%@%@",ZBLocalized(@"共", nil),modHISdate.orderallnum,ZBLocalized(@"笔", nil)];
    self.dateStr = modHISdate.cdate;
    if ([modHISdate.starts isEqualToString:@"2"]) {
        self.jzztStr = ZBLocalized(@"待交账", nil);
    }else{
        self.jzztStr = ZBLocalized(@"已交账", nil);
    }
    self.goodsPicStr =[NSString stringWithFormat:@"+฿%@",modHISdate.goodspic];
    self.SJHDZCStr = [NSString stringWithFormat:@"-฿%@",modHISdate.acpic];
    self.PSFstr = [NSString stringWithFormat:@"+฿%@",modHISdate.beepic];
    self.boxStr = [NSString stringWithFormat:@"+฿%@",modHISdate.boxpic];
    
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
