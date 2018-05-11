//
//  OrderDetilVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "OrderDetilVC.h"
#import "CellForLRtext.h"
#import "CellForGoodsList.h"
#import "CellForLtextRimg.h"
#import "ModelForOrderDetail.h"
@interface OrderDetilVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *arrForOrderDetail;
@property (nonatomic , strong)NSString *shopNameStr;
@property (nonatomic , strong)NSString *imgUrlStr;
@property (nonatomic , strong)NSString *goodsNameStr;
@property (nonatomic , strong)NSString *goodsPicStr;
@property (nonatomic , strong)NSString *goodsCountStr;
@property (nonatomic , strong)NSString *orderYhStr;
@property (nonatomic , strong)NSString *orderPsStr;
@property (nonatomic , strong)NSString *orderAllpicStr;
@property (nonatomic , strong)NSString *orderUserPhoneStr;
@property (nonatomic , strong)NSString *orderUserAddStr;
@property (nonatomic , strong)NSString *orderUserOrderNumStr;
@property (nonatomic , strong)NSString *orderUserTimeStr;
@property (nonatomic , strong)NSString *callUserTel;
@property (nonatomic , strong)NSString *callShopTel;
@end

@implementation OrderDetilVC
-(NSMutableArray *)arrForOrderDetail{
    if (_arrForOrderDetail == nil) {
        _arrForOrderDetail = [NSMutableArray array];
    }
    return _arrForOrderDetail;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;// 屏幕左侧边缘响应
    [self.view addGestureRecognizer:leftEdgeGesture];
    [self createNaviView];
    [self createTableView];
}
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    if (panGes.state == UIGestureRecognizerStateEnded) {
        [self back];
    }
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
    titleLabel.text = ZBLocalized(@"订单详情", nil);
    titleLabel.textColor = [UIColor blackColor];
    [self.naviView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(backImg);
    }];
}
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.01f)];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.contentInset = UIEdgeInsetsMake(0,0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
#pragma mark- UITabelViewDataSource/delegat
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.arrForOrderDetail.count + 4;
    }else if (section == 2){
        return 4;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CellForLtextRimg *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLtextRimg alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            
            cell.leftLab.text = self.shopNameStr;
            cell.rightImg.image = [UIImage imageNamed:@"电话"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
   else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CellForLtextRimg *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLtextRimg alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.buttomLine.backgroundColor = [UIColor clearColor];
            cell.leftLab.text = ZBLocalized(@"—— 商品详情 ——",nil);
            [cell.leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.contentView);
                make.centerY.equalTo(cell.contentView);
            }];
           
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == self.arrForOrderDetail.count + 1){
            //优惠金额
            CellForLRtext *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLRtext alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.buttomLine.backgroundColor = [UIColor whiteColor];
            cell.leftLab.text = ZBLocalized(@"优惠金额", nil);
            cell.rightLab.text = self.orderYhStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == self.arrForOrderDetail.count + 2){
            //配送费
            CellForLRtext *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLRtext alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.leftLab.text = ZBLocalized(@"配送费", nil);
            cell.rightLab.text = self.orderPsStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == self.arrForOrderDetail.count + 3){
            //小计
            CellForLRtext *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLRtext alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.buttomLine.backgroundColor = [UIColor whiteColor];
            cell.rightLab.text = self.orderAllpicStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            //详情
            CellForGoodsList *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForGoodsList alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            ModelForOrderDetail *modOrder = [[ModelForOrderDetail alloc]init];
            modOrder = [self.arrForOrderDetail objectAtIndex:indexPath.row - 1];
            cell.mod = modOrder;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
   
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            CellForLtextRimg *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLtextRimg alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            
            cell.leftLab.text = self.orderUserPhoneStr;
            cell.rightImg.image = [UIImage imageNamed:@"电话"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 1) {
            CellForLtextRimg *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLtextRimg alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.leftLab.font = [UIFont systemFontOfSize:14];
            cell.leftLab.text = self.orderUserAddStr;
            cell.leftLab.numberOfLines = 2;
            [cell.leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView.mas_left).offset(15);
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 2) {
            CellForLtextRimg *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLtextRimg alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
           
            cell.leftLab.font = [UIFont systemFontOfSize:14];
            cell.leftLab.text = self.orderUserOrderNumStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else if (indexPath.row == 3) {
            CellForLtextRimg *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CellForLtextRimg alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            
            cell.leftLab.text = self.orderUserTimeStr;
            cell.leftLab.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    CellForLtextRimg *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
                if(cell == nil)
                {
                    cell = [[CellForLtextRimg alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
                }
                cell.leftLab.text = self.shopNameStr;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 50;
        }
        else if (indexPath.row == self.arrForOrderDetail.count + 1){
            return 40;
        }
        else if (indexPath.row == self.arrForOrderDetail.count + 2){
            return 40;
        }
        else if (indexPath.row == self.arrForOrderDetail.count + 3){
            return 50;
        }else{
            return 100;
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 50;
        }
        else {
            return 40;
        }
        
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self callShop];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self callUser];
        }
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setMod:(ModelForHistory *)mod
{
    self.callShopTel = mod.shopphone;
    self.callUserTel = mod.uphone;
    self.shopNameStr = mod.shopname;
    CGFloat yhF = [mod.orderyhpic floatValue];
    self.orderYhStr = [NSString stringWithFormat:@"%.2f",yhF];
    
    CGFloat psF = [mod.orderpspic floatValue];
    self.orderPsStr = [NSString stringWithFormat:@"%.2f",psF];
   
    CGFloat allF = [mod.orderallpic floatValue];
    allF = allF - yhF + psF;
    if (allF <= 0) {
        allF = 0.01;
    }
    self.orderAllpicStr = [NSString stringWithFormat:@"%@:%.2f",ZBLocalized(@"小计", nil),allF];
  
    self.orderUserPhoneStr = [NSString stringWithFormat:@"%@  %@",mod.uname,mod.uphone];
    self.orderUserAddStr = [NSString stringWithFormat:@"%@：%@",ZBLocalized(@"配送地址",nil),mod.uaddr];
    self.orderUserTimeStr = [NSString stringWithFormat:@"%@：%@",ZBLocalized(@"订单时间",nil),mod.orderdatatime];
    self.orderUserOrderNumStr = [NSString stringWithFormat:@"%@：%@",ZBLocalized(@"订单号码",nil),mod.ordernum];
    
    NSMutableArray *arr = mod.ordersContexts;
    for (NSMutableDictionary *dic in arr) {
        ModelForOrderDetail *modOrder = [ModelForOrderDetail yy_modelWithDictionary:dic];
        [self.arrForOrderDetail addObject:modOrder];
    }
   
}
-(void)callShop
{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.callShopTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)callUser{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.callUserTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
