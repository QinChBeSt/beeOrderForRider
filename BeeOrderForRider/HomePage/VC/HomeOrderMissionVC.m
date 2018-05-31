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
#import "OrderDetilVC.h"
#import "MapVC.h"

#define callLineHeight 40

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

@property (nonatomic , strong)UIImageView *noDataImg;
@property (nonatomic , strong)NSString *locationQX;

@property (nonatomic , strong)UIView *windowBackView;
@property (nonatomic , strong)UIView *callBackView;
@property (nonatomic , strong)NSString *shopPhone;
@property (nonatomic , strong)NSString *userPhone;
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
    if ([self.locationQX isEqualToString:@"no"]) {
        [self getLocation];
    }
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
                    self.noDataImg.hidden = NO;
                }else{
                    self.noDataImg.hidden = YES;
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
    self.noDataImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight - 45)];
    self.noDataImg.image = [UIImage imageNamed:@"bg_zanwandingdan"];
    self.noDataImg.hidden = YES;
    [self.view addSubview:self.noDataImg];
    
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
        NSLog(@"定位到经度long %lf,纬度lat %lf",coordinate.longitude,coordinate.latitude);
    
    }
    
    // 停止定位
    self.locationQX = @"yes";
    [manager stopUpdatingLocation];
    [self.tableView reloadData];
    
}
#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager locationServicesEnabled])
    {
        //  判断用户是否允许程序获取位置权限
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways)
        {
            //用户允许获取位置权限
        }else
        {
            self.locationQX = @"no";
            //用户拒绝开启用户权限
            [self alertToOpenLocation];
            
        }
        
    }
    else
    {
        self.locationQX = @"no";
        [self alertToOpenLocation];
    }
    
    NSLog(@"location Fail");
}
-(void)alertToOpenLocation{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ZBLocalized(@"允许定位提示", nil)  message:ZBLocalized(@"请在设置中打开定位,否则无法提供准确的距离信息", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:ZBLocalized(@"打开定位", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ZBLocalized(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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
    cell.blocktoMapView = ^(NSDictionary *dic) {
        MapVC *map = [[MapVC alloc]init];
        map.type = self.CountType;
        map.dic = dic;
       
        [self.navigationController pushViewController:map animated:YES];
    };
    cell.blockToCallUser = ^(NSDictionary *dic) {
        NSString *shopName = mod.shopname;
        [self createCallView:dic shopname:shopName];
    };
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH  tableView:self.tableView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetilVC *order = [[OrderDetilVC alloc]init];
    ModelForHistory *mod = [[ModelForHistory alloc]init];
    mod = [self.arrForHistory objectAtIndex:indexPath.row];
    order.mod = mod;
    [self.navigationController pushViewController:order animated:YES];
}
-(void)createwindowBackView{
    self.windowBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    self.windowBackView.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:self.windowBackView];
    
}
-(void)createCallView:(NSDictionary *)phoneDic shopname:(NSString *)shopName{
    [self createwindowBackView];
    __weak typeof(self) ws = self;
    self.callBackView = [[UIView alloc]init];
    self.callBackView.backgroundColor = [UIColor whiteColor];
    [self.windowBackView addSubview:self.callBackView];
    [self.callBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(ws.view).offset(-SafeAreaTopHeight / 2);
        make.width.equalTo(@(SCREEN_WIDTH * 0.7));
        make.height.equalTo(@(callLineHeight * 5 + 10));
    }];
    
    UILabel *shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.7,callLineHeight)];
    shopNameLab.text = shopName ;
    shopNameLab.textAlignment = NSTextAlignmentCenter;
    shopNameLab.font = [UIFont systemFontOfSize:14];
    [self.callBackView addSubview:shopNameLab];
    self.shopPhone = [NSString stringWithFormat:@"%@",phoneDic[@"shop"]];
    self.userPhone = [NSString stringWithFormat:@"%@",phoneDic[@"user"]];
    UIButton *shopCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCallBtn.frame = CGRectMake(0, callLineHeight, SCREEN_WIDTH * 0.7, callLineHeight);
    NSString  *shopText  = [NSString stringWithFormat:@"%@:%@",ZBLocalized(@"商家电话", nil),phoneDic[@"shop"]];
    
    [shopCallBtn addTarget:self action:@selector(callShop) forControlEvents:UIControlEventTouchUpInside];
    [shopCallBtn setTitle:shopText forState:UIControlStateNormal];
    [shopCallBtn setTitleColor:[UIColor colorWithHexString:@"#1E90FF"] forState:UIControlStateNormal];
    [self.callBackView addSubview:shopCallBtn];
   
    UIButton *userCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userCallBtn.frame = CGRectMake(0, callLineHeight * 2, SCREEN_WIDTH * 0.7, callLineHeight);
    NSString  *userText  = [NSString stringWithFormat:@"%@:%@",ZBLocalized(@"顾客电话", nil),phoneDic[@"user"]];
    
    [userCallBtn addTarget:self action:@selector(callUser) forControlEvents:UIControlEventTouchUpInside];
    [userCallBtn setTitle:userText forState:UIControlStateNormal];
    [userCallBtn setTitleColor:[UIColor colorWithHexString:@"#1E90FF"] forState:UIControlStateNormal];
    [self.callBackView addSubview:userCallBtn];
    
    UIButton *userMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userMsgBtn.frame = CGRectMake(0, callLineHeight * 3, SCREEN_WIDTH * 0.7, callLineHeight);
    [userMsgBtn addTarget:self action:@selector(MSGUser) forControlEvents:UIControlEventTouchUpInside];
    [userMsgBtn setTitle:ZBLocalized(@"发短信给顾客", nil)   forState:UIControlStateNormal];
    [userMsgBtn setTitleColor:[UIColor colorWithHexString:@"#1E90FF"] forState:UIControlStateNormal];
    [self.callBackView addSubview:userMsgBtn];
    
    UIButton *CleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CleanBtn.frame = CGRectMake(0, callLineHeight * 4, SCREEN_WIDTH * 0.7, callLineHeight + 10);
    [CleanBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [CleanBtn setTitle:ZBLocalized(@"退出", nil)   forState:UIControlStateNormal];
    [CleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.callBackView addSubview:CleanBtn];
}
-(void)exit{
    [self.windowBackView removeFromSuperview];
}
-(void)getNetworkForChangeOrderType: (NSDictionary *)str{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,updateOrderStateURL];
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    //请求的方式：POST
    [managers POST:url parameters:str progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSString *typeStr = str[@"flg"];
            if ([typeStr isEqualToString:@"6"]) {
                [MBManager showBriefAlert:ZBLocalized(@"接单成功,此订单为待取货状态，右滑查看", nil)];
            }
            else if ([typeStr isEqualToString:@"7"]) {
                [MBManager showBriefAlert:ZBLocalized(@"上报到店成功,此订单为待取货状态", nil)];
            }
            else if ([typeStr isEqualToString:@"8"]) {
                [MBManager showBriefAlert:ZBLocalized(@"取货成功,此订单为待送达状态，右滑查看", nil)];
            }else if ([typeStr isEqualToString:@"9"]){
                [MBManager showBriefAlert:ZBLocalized(@"确认送达,此订单已完成", nil)];
            }
            
            [self toSearchHistory];
        }else{
            [MBManager showBriefAlert:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)callShop{
    
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.shopPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)callUser{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.userPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)MSGUser{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"sms://%@",self.userPhone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
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
