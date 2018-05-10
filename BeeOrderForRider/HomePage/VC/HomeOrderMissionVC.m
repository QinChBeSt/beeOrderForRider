//
//  HomeOrderMissionVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/10.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "HomeOrderMissionVC.h"
#import "ModelForHistory.h"
#import "CellForOrderList.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeOrderMissionVC ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager * manger;

@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic,retain)NSString *CountType;
@property (nonatomic , strong)NSMutableArray *arrForHistory;
/**
 *   页数
 */
@property (nonatomic,assign) int pageIndex;
@property (nonatomic , strong)NSString *latLoc;
@property (nonatomic , strong)NSString *longLoc;
@end

@implementation HomeOrderMissionVC
-(NSMutableArray *)arrForHistory{
    if (_arrForHistory == nil) {
        _arrForHistory = [NSMutableArray array];
    }
    return _arrForHistory;
}
-(void)viewWillAppear:(BOOL)animated{
    [self toSearchHistory];
}
-(void)toSearchHistory{
    self.pageIndex = 1;
   
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        NSUserDefaults *defaults;
        defaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
        
      
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,GetOrderListURL];
        NSDictionary *parameters = @{@"flg":self.CountType,
                                     @"page":@"1",
                                     @"qsid":userId
                                     };
        
        //请求的方式：POST
        [self.arrForHistory removeAllObjects];
        [self.tableView.mj_header setHidden:NO];
        [MHNetWorkTask getWithURL:url withParameter:parameters withHttpHeader:nil withResponseType:ResponseTypeJSON withSuccess:^(id result) {
            NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSMutableArray *arr = result[@"value"];
                
               
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
-(void)loadMoreBills{
    self.pageIndex ++;
   
        NSUserDefaults *defaults;
        defaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
        
        NSString *page = [NSString stringWithFormat:@"%d",self.pageIndex];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,GetOrderListURL];
        NSDictionary *parameters = @{
                                     @"flg":self.CountType,
                                     @"page":page,
                                     @"qsid":userId
                                     };
        
        //请求的方式：POST
        
        [MHNetWorkTask getWithURL:url withParameter:parameters withHttpHeader:nil withResponseType:ResponseTypeJSON withSuccess:^(id result) {
            NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSMutableArray *arr = result[@"value"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self getLocation];
}
-(void)getLocation{
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    
    // 设置代理
    manager.delegate = self;
    
    // 距离过滤 设置多少米定位一次
    manager.distanceFilter = 1000;
    
    // 设置定位的精确度，误差不超过10米,定位越精确，越耗电
    manager.desiredAccuracy = 10;
    
    //2>调用 startUpdatingLocation方法进入定位
    [manager startUpdatingLocation];
    
    // ios8要定位，要请求定位的权限
    if ([[UIDevice  currentDevice].systemVersion doubleValue] >= 8.0) {
        [manager requestWhenInUseAuthorization];
    }
    
    
    //赋值
    self.manger = manager;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //    CLLocation 是一个位置对象
    for (CLLocation *loc in locations) {
        // 经纬度
       CLLocationCoordinate2D coordinate =  loc.coordinate;
        self.latLoc = [NSString stringWithFormat:@"%lf",coordinate.latitude];
        self.longLoc = [NSString stringWithFormat:@"%lf",coordinate.longitude];
        NSLog(@"定位到经度 %lf,纬度 %lf",coordinate.longitude,coordinate.latitude);
    
    }
    
    // 停止定位
    [manager stopUpdatingLocation];
    [self.tableView reloadData];
    
}
- (id)initWithType:(NSString *)type
{
    self = [super init];
    if (self)
    {
        if ([type isEqualToString:@"4"]) {
            
            _CountType = @"4";
            
        }else if([type isEqualToString:@"6"]){
            _CountType = @"6";
           
        }else{
            _CountType = @"8";
            
        }
    }
    return self;
}
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight - 45) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

    [self.view addSubview:self.tableView];
}
#pragma mark- UITabelViewDataSource/delegat
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrForHistory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idF = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    CellForOrderList *cell = [tableView dequeueReusableCellWithIdentifier:idF];
    if(cell == nil)
    {
        cell = [[CellForOrderList alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idF];
    }
    ModelForHistory *mod = [[ModelForHistory alloc]init];
    mod = [self.arrForHistory objectAtIndex:indexPath.row];
    cell.latLoc = self.latLoc;
    cell.longLoc = self.longLoc;
    cell.mod = mod;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.blockChangeOrderState = ^(NSDictionary *str) {
        [self getNetworkForChangeOrderType:str];
    };
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH  tableView:self.tableView];
}
-(void)getNetworkForChangeOrderType: (NSDictionary *)str{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,updateOrderStateURL];
   
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    //请求的方式：POST
    [managers POST:url parameters:str progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            [MBManager showBriefAlert:ZBLocalized(@"成功", nil)];
            [self toSearchHistory];
        }else{
            [MBManager showBriefAlert:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
