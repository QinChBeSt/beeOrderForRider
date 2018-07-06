//
//  HistoryDetailOrderVC.m
//  BeeOrderForRider
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "HistoryDetailOrderVC.h"
#import "CellForHistoryDetailGoodsList.h"
#import "CellForHistoryLRtext.h"
@interface HistoryDetailOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)UIView *naviView;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)UIView *headView;
@property (nonatomic , strong)UILabel *shopNameLab;
@property (nonatomic , strong)UILabel *orderManeyLab;

@property (nonatomic , strong)UIView *footView;

@property (nonatomic , strong)NSMutableArray *arrForGoodList;
@property (nonatomic , strong)NSMutableArray *arrForHDlist;
@property (nonatomic , strong)NSString *hdzcStr;
@property (nonatomic , strong)NSString *psfStr;
@property (nonatomic , strong)NSString *jsjeStr;
@property (nonatomic , strong)NSString *ddbhStr;
@property (nonatomic , strong)NSString *ddhStr;
@property (nonatomic , strong)NSString *xdsjStr;
@property (nonatomic , strong)NSString *ddwcsjStr;
@property (nonatomic , strong)NSString *psfsStr;
@property (nonatomic , strong)NSString *shopName;
@property (nonatomic , strong)NSString *zjStr;
@property (nonatomic , strong)NSString *jsjgStr;
@end

@implementation HistoryDetailOrderVC
-(NSMutableArray *)arrForHDlist{
    if (_arrForHDlist == nil) {
        _arrForHDlist = [NSMutableArray array];
    }
    return _arrForHDlist;
}
-(NSMutableArray *)arrForGoodList{
    if (_arrForGoodList == nil) {
        _arrForGoodList = [NSMutableArray array];
    }
    return _arrForGoodList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviView];
    [self createTableView];

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

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatHeadView{
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.view addSubview:self.headView];
    self.shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    self.shopNameLab.font = [UIFont systemFontOfSize:20];
    self.shopNameLab.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:self.shopNameLab];
   
    self.orderManeyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 35)];
    self.orderManeyLab.font = [UIFont systemFontOfSize:22];
    self.orderManeyLab.textColor = [UIColor colorWithHexString:BaseGreen];
    self.orderManeyLab.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:self.orderManeyLab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
    [self.headView addSubview:line];
    
    __weak typeof(self) ws = self;
    UIImageView *shopTitIcon = [[UIImageView alloc]init];
    shopTitIcon.image = [UIImage imageNamed:@"shopBeforIcon"];
    [self.headView addSubview:shopTitIcon];
    [shopTitIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.headView.mas_left).offset(10);
        make.top.equalTo(line.mas_bottom).offset(5);
        make.bottom.equalTo(ws.headView).offset(-5);
        make.width.equalTo(@(25));
    }];
    
    UILabel *shop = [[UILabel alloc]init];
    shop.text = ZBLocalized(@"商品", nil);
    [self.headView addSubview:shop];
    [shop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shopTitIcon);
        make.left.equalTo(shopTitIcon.mas_right).offset(5);
    }];
    
    self.shopNameLab.text = self.shopName;
    self.orderManeyLab.text = self.jsjeStr;
}
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREENH_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self creatHeadView];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:self.tableView];
}
#pragma mark- UITabelViewDataSource/delegat
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.arrForGoodList.count + 1;
    }
    else if (section == 1){
        return self.arrForHDlist.count;
    }
    else if (section == 2){
        return 8;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 2) {
            return 10;
        }
        else if (indexPath.row > 2){
            return 25;
        }else{
            return 30;
        }
    }else{
        return 30;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row < self.arrForGoodList.count) {
            CellForHistoryDetailGoodsList *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if(cell == nil)
            {
                cell = [[CellForHistoryDetailGoodsList alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            
            cell.goodsName.text = [NSString stringWithFormat:@"%@",self.arrForGoodList[indexPath.row][@"ordersGoodsName"]];
            cell.goodsPic.text = [NSString stringWithFormat:@"฿%@",self.arrForGoodList[indexPath.row][@"ordersGoodsPic"]];
            cell.goodsCount.text = [NSString stringWithFormat:@"X%@",self.arrForGoodList[indexPath.row][@"ordersGoodsNum"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == self.arrForGoodList.count){
            CellForHistoryLRtext *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellText"];
            if(cell == nil)
            {
                cell = [[CellForHistoryLRtext alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellText"];
            }
            
            cell.leftText.text = ZBLocalized(@"活动支出", nil);
            cell.rightText.text = self.hdzcStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }
    else if (indexPath.section == 1){
        
            CellForHistoryLRtext *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellText"];
            if(cell == nil)
            {
                cell = [[CellForHistoryLRtext alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellText"];
            }
        cell.topLine.hidden = YES;
        cell.leftText.textColor = [UIColor colorWithHexString:@"9C9C9C"];
        cell.rightText.textColor = [UIColor colorWithHexString:@"9C9C9C"];
        NSString *yhNAME = [self.arrForHDlist objectAtIndex:indexPath.row][@"yhxTit"];
        NSString *yhPIC = [self.arrForHDlist objectAtIndex:indexPath.row][@"yhxPic"];
        cell.leftText.text = yhNAME;
        cell.rightText.text = [NSString stringWithFormat:@"-฿%@",yhPIC];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
   
    }
    else if (indexPath.section == 2){

        if (indexPath.row == 0) {
            CellForHistoryLRtext *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellText"];
            if(cell == nil)
            {
                cell = [[CellForHistoryLRtext alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellText"];
            }

            cell.leftText.text = ZBLocalized(@"用户支付配送费金额", nil);
            cell.rightText.text = self.psfStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 1) {
            CellForHistoryLRtext *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellText"];
            if(cell == nil)
            {
                cell = [[CellForHistoryLRtext alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellText"];
            }

            cell.leftText.text = ZBLocalized(@"结算金额", nil);
            cell.rightText.text = self.jsjeStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellUITableViewCellNONE"];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellNONE"];
            }
            cell.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else  {
            CellForHistoryLRtext *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellText"];
            if(cell == nil)
            {
                cell = [[CellForHistoryLRtext alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellText"];
            }
            cell.topLine.hidden = YES;
            cell.leftText.textColor = [UIColor colorWithHexString:@"9C9C9C"];
            cell.rightText.textColor = [UIColor colorWithHexString:@"9C9C9C"];
            if (indexPath.row == 3) {
                cell.leftText.text = ZBLocalized(@"订单编号", nil);
                cell.rightText.text = self.ddbhStr;
            }
            else if (indexPath.row == 4) {
                cell.leftText.text = ZBLocalized(@"订单号", nil);
                cell.rightText.text = self.ddhStr;
            }
            else if (indexPath.row == 5) {
                cell.leftText.text = ZBLocalized(@"下单时间", nil);
                cell.rightText.text = self.xdsjStr;
            }
            else if (indexPath.row == 6) {
                cell.leftText.text = ZBLocalized(@"订单完成时间", nil);
                cell.rightText.text = self.ddwcsjStr;
            }
            else if (indexPath.row == 7) {
                cell.leftText.text = ZBLocalized(@"配送方式", nil);
                cell.rightText.text = self.psfsStr;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }

    return nil;
    
}

-(void)setModHis:(ModelForHis *)modHis{
    self.arrForGoodList =  modHis.prdergoods;
    self.shopName =[NSString stringWithFormat:@"%@",modHis.order.ordersShopName];
    self.hdzcStr = [NSString stringWithFormat:@"-฿%@",modHis.order.ordersSubtractPic];
    self.ddbhStr = [NSString stringWithFormat:@"#%@",modHis.order.ordersNumDay];
    self.ddhStr = [NSString stringWithFormat:@"%@",modHis.order.ordersNum];
    
    if ([modHis.order.ordersOkDate isEqual:[NSNull null]]|| modHis.order.ordersOkDate == nil)
        
    {
        
        self.ddwcsjStr = @"";
        
    }else{
        self.ddwcsjStr = [NSString stringWithFormat:@"%@ %@",modHis.order.ordersOkDate,modHis.order.ordersOkTime];
    }
    

    self.xdsjStr = [NSString stringWithFormat:@"%@ %@",modHis.order.ordersCdata,modHis.order.ordersCtime];
    
    if ([modHis.order.ordersPs isEqualToString:@"2"]) {
        self.psfsStr = [NSString stringWithFormat:@"%@",ZBLocalized(@"BeeOrder配送", nil)];
    }else{
        self.psfsStr = [NSString stringWithFormat:@"%@",ZBLocalized(@"商家配送", nil)];
    }
    self.psfStr = [NSString stringWithFormat:@"+฿%@",modHis.order.ordersPsPic];
    
    self.zjStr = [NSString stringWithFormat:@"฿%@",modHis.goodspic];;
    self.jsjeStr = [NSString stringWithFormat:@"฿%@",modHis.okpic];
    
    self.arrForHDlist = modHis.orderYhxEntities;
    
    [self.tableView reloadData];
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
