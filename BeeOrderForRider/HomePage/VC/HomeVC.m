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
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}
#pragma mark - ui
-(void)createNaviView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight )];
    self.naviView.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [self.view addSubview:self.naviView];
    
    __weak typeof(self) ws = self;
    UIImageView *backImg = [[UIImageView alloc]init];
    [backImg setImage:[UIImage imageNamed:@"icon_user_normal"]];
    [self.naviView addSubview:backImg];
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight + 5);
        make.left.equalTo(ws.naviView.mas_left).offset(15);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
    UIButton *backBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBTN addTarget:self action:@selector(profileCenter) forControlEvents:UIControlEventTouchUpInside];
    backBTN.backgroundColor = [UIColor clearColor];
    [self.naviView addSubview:backBTN];
    [backBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.naviView.mas_top).offset(SafeAreaStatsBarHeight);
        make.left.equalTo(ws.naviView.mas_left).offset(10);
        make.width.equalTo(@(40));
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
#pragma mark - 点击事件
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNaviView];
    if ([self.showLeft isEqualToString:@"1"]) {
        [self profileCenter];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tongzhi:) name:@"homePageType" object:nil];
    self.title = ZBLocalized(@"主页", nil);
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 屏幕边缘pan手势(优先级高于其他手势)
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(moveViewWithGesture:)];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
