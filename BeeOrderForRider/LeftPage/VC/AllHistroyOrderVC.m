//
//  AllHistroyOrderVC.m
//  BeeOrderForBusiness
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "AllHistroyOrderVC.h"
#import "CellForHistory.h"
#import "HistoryDetailOrderVC.h"
#import "DateDeatilOrderVC.h"
#import "ModelForHisDate.h"
@interface AllHistroyOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *arrForHIsDate;

/**
 *   页数
 */
@property (nonatomic,assign) int pageIndex;
@end

@implementation AllHistroyOrderVC
#pragma mark - ui
-(NSMutableArray *)arrForHIsDate{
    if (_arrForHIsDate == nil) {
        _arrForHIsDate = [NSMutableArray array];
        
    }
    return _arrForHIsDate;
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


-(void)getnetwork{
    self.pageIndex = 1;
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
                   for (NSDictionary *dic in responseObject[@"value"]) {
                       ModelForHisDate *mod = [ModelForHisDate yy_modelWithDictionary:dic];
                       [self.arrForHIsDate addObject:mod];
                       
                   }
                   
               }else{
                   [MBManager showBriefAlert:responseObject[@"msg"]];
               }
              
               
               if (self.arrForHIsDate.count == 0) {
                   [self.tableView.mj_header endRefreshing];
                   [self.tableView.mj_footer endRefreshingWithNoMoreData];
                   [self.tableView reloadData];
                   
               }else{
                   
                   [self.tableView.mj_footer resetNoMoreData];
                   [self.tableView.mj_header endRefreshing];
                   [self.tableView reloadData];
               }
               //[self.tableView reloadData];
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
           }];
    
}
-(void)loadMoreBills{
    self.pageIndex ++;
    NSString *page = [NSString stringWithFormat:@"%d",self.pageIndex];
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *useriD = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,historyDaysOrderURL];
    NSDictionary *parameters = @{@"qsid":useriD,
                                 @"page":page
                                 };
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    [managers POST:url parameters:parameters progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
               if ([code isEqualToString:@"1"]) {
                   
                   NSMutableArray *arr = responseObject[@"value"];
                   if (arr.count == 0) {
                       [self.tableView.mj_footer endRefreshingWithNoMoreData];
                       return ;
                   }
                   for (NSDictionary *dic in responseObject[@"value"]) {
                       ModelForHisDate *mod = [ModelForHisDate yy_modelWithDictionary:dic];
                       [self.arrForHIsDate addObject:mod];
                       
                   }
                   
               }else{
                   [MBManager showBriefAlert:responseObject[@"msg"]];
               }
               self.arrForHIsDate=(NSMutableArray *)[[self.arrForHIsDate reverseObjectEnumerator] allObjects];
               if (self.arrForHIsDate.count == 0) {
                   [self.tableView.mj_footer endRefreshingWithNoMoreData];
               }else{
                   [self.tableView.mj_footer endRefreshing];
                   [self.tableView reloadData];
               }
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
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
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    [self.view addSubview:headView];
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topline.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [headView addSubview:topline];
    UILabel *headTit = [[UILabel alloc]init];
    headTit.text = ZBLocalized(@"历史账单", nil);
    [headView addSubview:headTit];
    [headTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topline.mas_bottom);
        make.bottom.equalTo(headView);
        make.left.equalTo(headView.mas_left).offset(15);
    }];
    UIView *buttomLie = [[UIView alloc]init];
    buttomLie.backgroundColor = [UIColor colorWithHexString:BaseTextBlack];
    [headView addSubview:buttomLie];
    [buttomLie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView);
        make.centerX.equalTo(headView);
        make.width.equalTo(headView);
        make.height.equalTo(@(0.5));
    }];
    
    self.tableView.tableHeaderView = headView;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getnetwork];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ModelForHisDate *Mod = [self.arrForHIsDate objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([Mod.starts isEqualToString:@"2"]) {
        cell.orderState.text = ZBLocalized(@"待交账", nil);
    }else{
        cell.orderState.text = ZBLocalized(@"已交账", nil);
    }
    cell.dateLab.text = Mod.cdate;
    cell.picLab.text = [NSString stringWithFormat:@"฿%.2f", [Mod.givepic floatValue]];;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DateDeatilOrderVC *dateDetaul = [[DateDeatilOrderVC alloc]init];
    ModelForHisDate *Mod = [self.arrForHIsDate objectAtIndex:indexPath.row];
    dateDetaul.modHISdate = Mod;
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
