//
//  HomeVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/7.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "HomeVC.h"
#import "QCAnimateViewController.h"
#import "LoginVC.h"
#import "ZWMSegmentController.h"
#import "HomeOrderMissionVC.h"
#import <CoreLocation/CLLocationManager.h>

@interface HomeVC ()<UIGestureRecognizerDelegate>
/** tapGestureRec */
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRec;
/** panGestureRec */
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;
/** profileButton */
@property (nonatomic, weak) UIButton *profileButton;
/** hasClick */
@property (nonatomic, assign) BOOL hasClick;
/** vc */
@property (nonatomic, strong) QCAnimateViewController *vc;

@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UILabel *titleLabel ;
@property (nonatomic, strong) ZWMSegmentController *segmentVC;

@property (nonatomic , strong)NSString *WillGetOrderCountStr;
@property (nonatomic , strong)NSString *willPutOrderCountStr;
@property (nonatomic , strong)NSString *OrderCountStr;

@end

@implementation HomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self toLogin];
}
#pragma mark - 点击事件
-(void)toLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:UD_USERID];
    if (userID == nil ) {
        LoginVC *login = [[LoginVC alloc]init];
        [self.navigationController pushViewController:login animated:NO];
    }else{
        NSUserDefaults *defaults;
        defaults = [NSUserDefaults standardUserDefaults];
        NSString *userState  = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERState]];
        [self setWorkStateStr:userState];
        [self getNetWork];
    }
}
-(void )setWorkStateStr:(NSString *)str{
    if ([str isEqualToString:@"1"]) {
        self.titleLabel.text = ZBLocalized(@"开工", nil);
        
    }else if ([str isEqualToString:@"2"]){
        self.titleLabel.text = ZBLocalized(@"忙碌", nil);
        
    }else if ([str isEqualToString:@"3"]){
        self.titleLabel.text = ZBLocalized(@"收工", nil);
       
    }
}

-(void)getNetWork{
    self.OrderCountStr = @"0";
    self.WillGetOrderCountStr = @"0";
    self.willPutOrderCountStr = @"0";
//    [self getNetWorkForWillGet];
//    [self getNewWorkForWillPut];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [notiCenter addObserver:self selector:@selector(doingNotification:) name:@"DoingOrderCount" object:nil];
    
//    [notiCenter addObserver:self selector:@selector(finishNotification:) name:@"finishOrderCount" object:nil];
//    
//    [notiCenter addObserver:self selector:@selector(cleanNotification:) name:@"cleanOrderCount" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}- (void)doingNotification:(NSNotification *)noti
{
    
    // NSNotification 有三个属性，name, object, userInfo，其中最关键的object就是从第三个界面传来的数据。name就是通知事件的名字， userInfo一般是事件的信息。
    
    self.OrderCountStr = noti.object;
    
    [self.segmentVC enumerateBadges:@[ self.OrderCountStr,self.WillGetOrderCountStr,self.willPutOrderCountStr]];
    
}
- (void)finishNotification:(NSNotification *)noti
{
    
    // NSNotification 有三个属性，name, object, userInfo，其中最关键的object就是从第三个界面传来的数据。name就是通知事件的名字， userInfo一般是事件的信息。
    
    self.WillGetOrderCountStr = noti.object;
    [self.segmentVC enumerateBadges:@[ self.OrderCountStr,self.WillGetOrderCountStr,self.willPutOrderCountStr]];
    
}
- (void)cleanNotification:(NSNotification *)noti
{
    
    // NSNotification 有三个属性，name, object, userInfo，其中最关键的object就是从第三个界面传来的数据。name就是通知事件的名字， userInfo一般是事件的信息。
    
    self.willPutOrderCountStr = noti.object;
    [self.segmentVC enumerateBadges:@[ self.OrderCountStr,self.WillGetOrderCountStr,self.willPutOrderCountStr]];
    
}

// 第一界面中dealloc中移除监听的事件
- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

#pragma mark - ui
-(void)createNaviView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight )];
    self.naviView.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [self.view addSubview:self.naviView];
    
    __weak typeof(self) ws = self;
    UIImageView *backImg = [[UIImageView alloc]init];
    [backImg setImage:[UIImage imageNamed:@"icon_touxiang"]];
    [self.naviView addSubview:backImg];
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight + 5);
        make.left.equalTo(ws.naviView.mas_left).offset(20);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
    UIButton *backBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBTN addTarget:self action:@selector(profileCenter) forControlEvents:UIControlEventTouchUpInside];
    backBTN.backgroundColor = [UIColor clearColor];
    [self.naviView addSubview:backBTN];
    [backBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight);
        make.left.equalTo(ws.naviView.mas_left).offset(15);
        make.width.equalTo(@(45));
        make.height.equalTo(@(SafeAreaTopHeight - SafeAreaStatsBarHeight));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    //self.titleLabel.text = ZBLocalized(@"待处理", nil);
    self.titleLabel.textColor = [UIColor blackColor];
    [self.naviView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(backImg);
    }];
}
#pragma mark - ui
- (void)CreateSegment{
    
    HomeOrderMissionVC *doingOrder = [[HomeOrderMissionVC alloc] initWithType:@"4"];
    HomeOrderMissionVC *finshOrder = [[HomeOrderMissionVC alloc] initWithType:@"6"];
    HomeOrderMissionVC *CleanOrder = [[HomeOrderMissionVC alloc] initWithType:@"8"];
    
    
    NSArray *array = @[doingOrder,finshOrder,CleanOrder];

    
    self.segmentVC = [[ZWMSegmentController alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight , SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight ) titles:@[ZBLocalized(@"新任务", nil),ZBLocalized(@"待取货", nil),ZBLocalized(@"待送达", nil)]];
    self.segmentVC.segmentView.showSeparateLine = YES;
    self.segmentVC.segmentView.segmentTintColor = [UIColor blackColor];
    self.segmentVC.segmentView.separateColor = [UIColor whiteColor];
    self.segmentVC.segmentView.segmentNormalColor = [UIColor colorWithHexString:BaseTextGrayColor];
    self.segmentVC.segmentView.backgroundColor = [UIColor whiteColor];
    self.segmentVC.viewControllers = [array copy];
    
    
    self.segmentVC.segmentView.style=ZWMSegmentStyleFlush;
    
    [self addSegmentController:self.segmentVC];
    [self.segmentVC  setSelectedAtIndex:0];
    
    
}

-(void)getNetWorkForWillGet{
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,GetOrderListURL];
    NSDictionary *parameters = @{@"flg":@"6",
                                 @"page":@"1",
                                 @"qsid":userId
                                 };
    [MHNetWorkTask getWithURL:url withParameter:parameters withHttpHeader:nil withResponseType:ResponseTypeJSON withSuccess:^(id result) {
        NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
        if ([code isEqualToString:@"1"]) {
             NSMutableArray *arr = result[@"value"];
            if (arr.count >5) {
                self.WillGetOrderCountStr = @"5+";
            }else{
                self.WillGetOrderCountStr = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];
                
            }
           [self.segmentVC enumerateBadges:@[self.OrderCountStr,self.WillGetOrderCountStr,self.willPutOrderCountStr]];
        }else{
            
        }
    } withFail:^(NSError *error) {
        
    }];
}
-(void)getNewWorkForWillPut{
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [NSString stringWithFormat:@"%@",[defaults objectForKey:UD_USERID]];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,GetOrderListURL];
    NSDictionary *parameters = @{@"flg":@"8",
                                 @"page":@"1",
                                 @"qsid":userId
                                 };
    [MHNetWorkTask getWithURL:url withParameter:parameters withHttpHeader:nil withResponseType:ResponseTypeJSON withSuccess:^(id result) {
        NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *arr = result[@"value"];
            if (arr.count >5) {
                self.willPutOrderCountStr = @"5+";
            }else{
                self.willPutOrderCountStr = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];
                
            }
            [self.segmentVC enumerateBadges:@[self.OrderCountStr,self.WillGetOrderCountStr,self.willPutOrderCountStr]];
        }else{
            
        }
    } withFail:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNaviView];
    [self CreateSegment];
    
  
    if ([self.showLeft isEqualToString:@"1"]) {
        [self profileCenter];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tongzhi:) name:@"homePageType" object:nil];
    self.title = ZBLocalized(@"主页", nil);
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 屏幕边缘pan手势(优先级高于其他手势)
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;// 屏幕左侧边缘响应
    [self.view addGestureRecognizer:leftEdgeGesture];
    leftEdgeGesture.delegate = self;
    
    
}
-(void)tongzhi:(NSNotification *)type {
    NSDictionary *dict = type.object;
    NSLog(@"%@",dict);
    self.titleLabel.text = dict[@"name"];

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL result = NO;
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    if (panGes.state == UIGestureRecognizerStateEnded) {
        if ([self.childViewControllers containsObject:self.vc]) return;
        [self profileCenter];
    }
}
- (void)profileCenter {
    // 防止重复点击
    if (self.hasClick) return;
    self.hasClick = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hasClick = NO;
    });
    
    // 展示个人中心
    QCAnimateViewController *vc = [[QCAnimateViewController alloc] init];
    self.vc = vc;
    vc.showLeft = self.showLeft;
    self.showLeft = @"";
    vc.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
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
