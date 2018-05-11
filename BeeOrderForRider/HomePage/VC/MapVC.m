//
//  MapVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
@interface MapVC ()<CLLocationManagerDelegate>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong) CLLocationManager *locationManager;
@property (nonatomic , strong)CLGeocoder *geo;
@property (nonatomic , strong)NSString *cityStr;
@property (nonatomic , strong)MKMapView *mapView;
@property (nonatomic , strong)NSString *latStr;
@property (nonatomic , strong)NSString *longStr;
@property (nonatomic , strong)NSString *typeStr;
@end

@implementation MapVC{
    MKMapView *mapView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //1. 创建位置管理器
    self.locationManager = [CLLocationManager new];
    //2>判断版本,如果大于iOS8需要进行授权 ,同时配置plist文件
    //用户使用时授权 大部分的应用应该使用此种授权方式
    // 判断可以使用宏定义(获取系统版本号)  / respondsToSelector
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //使用时授权
        [self.locationManager requestWhenInUseAuthorization];
        // 一直授权
        //[locationManager requestAlwaysAuthorization];
    }
    //3. 设置代理, 来获取数据
    self.locationManager.delegate = self;
    
    //4. 开始定位
    // 开始定位不要忘记停止定位  //[self.locationManager stopUpdatingLocation]
    
    [self.locationManager startUpdatingLocation];
    
    // 为了实现省电目的,对定位进行优化
    
    //5. 距离筛选器 (当用户发生一定位置的改变时, 再去调用代理方法, 以此实现省电)
    // 值: 多少米  譬如:设置10, 就代表用户位置发生10米以上的偏移时, 才去定位
    self.locationManager.distanceFilter = 5;
    
    //6. 设置精确度 (减少为卫星之间的计算, 以此实现省电)
    // 定位的方式: GPS 北斗 基站定位 WiFi 定位
    // iPhone打开定位: GPS 跟24颗卫星进行通讯
    //desired: 期望
    //Accurac: 精准度
    //extern const CLLocationAccuracy kCLLocationAccuracyBest;设备 使用电池供电时候，最高的精度
    //extern const CLLocationAccuracy kCLLocationAccuracyNearestTenMeters;精度10米
    //extern const CLLocationAccuracy kCLLocationAccuracyHundredMeters;精度100米
    //extern const CLLocationAccuracy kCLLocationAccuracyKilometer;精度1000米
    //extern const CLLocationAccuracy kCLLocationAccuracyThreeKilometers;精度3000米
    //kCLLocationAccuracyBestForNavigation   导航情况下最高精度，一般要有外接电源时才 能使用
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
}
# pragma mark -懒加载 创建CLGeocoder对象
-(CLGeocoder *)geo
{
    if (!_geo)
    {
        _geo = [[CLGeocoder alloc] init];
        
    }
    return  _geo;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviView];
    self.mapView =[[MKMapView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight)];
    
    self.mapView.mapType=MKMapTypeStandard;
    
    [self.view addSubview:self.mapView];
    
    UIButton *toMapView = [UIButton buttonWithType:UIButtonTypeCustom];
    [toMapView addTarget:self action:@selector(toMapAction) forControlEvents:UIControlEventTouchUpInside];
    toMapView.frame  = CGRectMake(50, SCREENH_HEIGHT - 100, 100, 80);
    toMapView.backgroundColor = [UIColor redColor];
    [self.mapView addSubview:toMapView];
    
    
}
-(void)toMapAction{
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.latStr floatValue], [self.longStr floatValue]);
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    
   
}
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
    titleLabel.text = ZBLocalized(@"导航", nil);
    titleLabel.textColor = [UIColor blackColor];
    [self.naviView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(backImg);
    }];
}
-(void)setType:(NSString *)type{
    self.typeStr = type;
    
}
-(void)setDic:(NSDictionary *)dic{
    if ([ self.typeStr isEqualToString:@"6"]) {
        self.latStr = dic[@"sLat"];
        self.longStr = dic[@"sLong"];
    }else if ([ self.typeStr isEqualToString:@"8"]) {
        self.latStr = dic[@"uLat"];
        self.longStr = dic[@"uLong"];
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
