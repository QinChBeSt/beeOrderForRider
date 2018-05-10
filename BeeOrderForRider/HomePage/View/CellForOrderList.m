//
//  CellForOrderList.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/10.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForOrderList.h"
#import <CoreLocation/CoreLocation.h>
#define lineHeight 50
@implementation CellForOrderList

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    __weak typeof(self) ws = self;
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:topLine];
    //订单编号
    self.orderNumLab = [[UILabel alloc]init];
    self.orderNumLab.textColor = [UIColor blackColor];
    self.orderNumLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.orderNumLab];
    [self.orderNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom);
        make.left.equalTo(ws.contentView.mas_left).offset(20);
        make.height.equalTo(@(lineHeight));
    }];
    
    //订单距离
    self.orderDateLab = [[UILabel alloc]init];
    self.orderDateLab.textColor = [UIColor blackColor];
    self.orderDateLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.orderDateLab];
    [self.orderDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom);
        make.right.equalTo(ws.contentView.mas_right).offset(-20);
        make.height.equalTo(@(lineHeight));
    }];
    
    UIView *topYellowLine = [[UIView alloc]initWithFrame:CGRectMake(0, lineHeight + 10, SCREEN_WIDTH / 4, 2)];
    topYellowLine.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [self.contentView addSubview:topYellowLine];
    UIView *topgrayLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, lineHeight + 10, SCREEN_WIDTH / 4 * 3, 2)];
    topgrayLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:topgrayLine];
    
    UILabel *get = [[UILabel alloc]init];
    get.adjustsFontSizeToFitWidth = YES;
    get.text = ZBLocalized(@"取",nil);
    get.textAlignment = NSTextAlignmentCenter;
    get.numberOfLines = 0;
    get.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    get.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    get.layer.cornerRadius=(lineHeight - 20)/ 2;
    get.clipsToBounds = YES;
    [self.contentView addSubview:get];
    [get mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.orderDateLab.mas_bottom).offset(10);
        make.height.equalTo(@(lineHeight - 20));
        make.left.equalTo(ws.orderNumLab);
        make.width.equalTo(@(lineHeight - 20));
    }];
    
    //商家名称
    self.shopNameLab = [[UILabel alloc]init];
    self.shopNameLab.font = [UIFont systemFontOfSize:14];
    self.shopNameLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.shopNameLab];
    [self.shopNameLab setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                      forAxis:UILayoutConstraintAxisHorizontal];
    [self.shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(get);
        make.height.equalTo(@(lineHeight));
        make.left.equalTo(get.mas_right).offset(20);
        
    }];
    
    
   
    
    
    //商家地理位置
    self.shopAddLab = [[UILabel alloc]init];
    self.shopAddLab.textAlignment = NSTextAlignmentLeft;
    self.shopAddLab.numberOfLines = 2;
    self.shopAddLab.font = [UIFont systemFontOfSize:14];
    self.shopAddLab.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    [self.contentView addSubview:self.shopAddLab];
    [self.shopAddLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(lineHeight-10));
        make.left.equalTo(ws.shopNameLab.mas_left);
        make.top.equalTo(ws.shopNameLab.mas_bottom);
        make.right.equalTo(ws.contentView.mas_right).offset(50);
    }];
    UIImageView *rightIcon = [[UIImageView alloc]init];
    [rightIcon setImage:[UIImage imageNamed:@"右箭头"]];
    [self.contentView addSubview:rightIcon];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.shopAddLab);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
        make.width.and.height.equalTo(@(20));
    }];
    
    UILabel *put = [[UILabel alloc]init];
    put.adjustsFontSizeToFitWidth = YES;
    put.textAlignment = NSTextAlignmentCenter;
    put.text = ZBLocalized(@"送",nil);
    put.numberOfLines = 0;
    put.textColor = [UIColor whiteColor];
    put.backgroundColor = [UIColor redColor];
    put.layer.cornerRadius=(lineHeight - 20)/ 2;
    put.clipsToBounds = YES;
    [self.contentView addSubview:put];
    [put mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.shopAddLab.mas_bottom).offset(10);
        make.height.equalTo(@(lineHeight - 20));
        make.left.equalTo(ws.orderNumLab);
        make.width.equalTo(@(lineHeight - 20));
    }];
    
    //用户地址
    self.userAddLab = [[UILabel alloc]init];
    self.userAddLab.textAlignment = NSTextAlignmentLeft;
    self.userAddLab.numberOfLines = 2;
    self.userAddLab.font = [UIFont systemFontOfSize:14];
    self.userAddLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.userAddLab];
    [self.userAddLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(put);
        make.height.equalTo(@(lineHeight));
        make.right.equalTo(ws.contentView.mas_right).offset(-20);
        make.left.equalTo(put.mas_right).offset(20);
    }];
    
    UIView *buttomGrayLine = [[UIView alloc]init];
    buttomGrayLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:buttomGrayLine];
    [buttomGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.contentView);
        make.width.equalTo(ws.contentView);
        make.height.equalTo(@(2));
        make.top.equalTo(ws.userAddLab.mas_bottom).offset(5);
    }];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [self.leftButton setTitle:ZBLocalized(@"联系商家", nil) forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.leftButton addTarget:self action:@selector(callShop) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.contentView.mas_centerX).offset(-SCREEN_WIDTH / 4);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        make.top.equalTo(buttomGrayLine.mas_bottom).offset(10);
        make.height.equalTo(@(40));
    }];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightButton addTarget:self action:@selector(changeOrderTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.contentView.mas_centerX).offset(SCREEN_WIDTH / 4);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        make.top.equalTo(buttomGrayLine.mas_bottom).offset(10);
        make.height.equalTo(@(40));
    }];
    
    self.bottomLine = [[UIView alloc]init];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:self.bottomLine];
    self.bottomLine.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView,0)
    .heightIs(0)
    .topSpaceToView(buttomGrayLine, 60);
    [self setupAutoHeightWithBottomView:self.bottomLine bottomMargin:0];
}
-(void)setMod:(ModelForHistory *)mod{
    self.orderNumLab.text = [NSString stringWithFormat:@"%@",mod.orderdaynum];//订单编号
    
    self.shopNameLab.text = mod.shopname;
    self.shopAddLab.text = mod.shopaddr;//商铺地点
    self.userAddLab.text = mod.uaddr;
    self.shopPhoneNum = mod.shopphone;
    self.orderTypeStr = mod.ordertype;
    self.orderNumberStr = mod.ordernum;
    [self setRightBtnTit];
    
    self.longStr = mod.shoplonng;
    self.latStr = mod.shoplat;
    [self getDissForShop];
}
-(void)setRightBtnTit{
    if ([self.orderTypeStr isEqualToString:@"5"]) {
        [self.rightButton setTitle:ZBLocalized(@"抢单", nil) forState:UIControlStateNormal];
        self.setUpdateOrderStr = @"6";
    }else if ([self.orderTypeStr isEqualToString:@"6"]){
        [self.rightButton setTitle:ZBLocalized(@"上报到店", nil) forState:UIControlStateNormal];
        self.setUpdateOrderStr = @"7";
    }
    else if ([self.orderTypeStr isEqualToString:@"7"]){
        [self.rightButton setTitle:ZBLocalized(@"确认取货", nil) forState:UIControlStateNormal];
        self.setUpdateOrderStr = @"8";
    }
    else if ([self.orderTypeStr isEqualToString:@"8"]){
        [self.rightButton setTitle:ZBLocalized(@"确认送达", nil) forState:UIControlStateNormal];
        self.setUpdateOrderStr = @"9";
    }
    
}

-(void)getDissForShop{
     CLLocation *getLocation = [[CLLocation alloc] initWithLatitude:[self.latLoc doubleValue] longitude:[self.longLoc doubleValue]];
    CLLocation *getShop = [[CLLocation alloc] initWithLatitude:[self.latStr doubleValue] longitude:[self.longStr doubleValue]];
    double distance = [getLocation distanceFromLocation:getShop];
    NSLog(@"当前位置距离 %lf M",distance );
    self.orderDateLab.text = [NSString stringWithFormat:@"%.2lfKm",distance / 1000];//距离
}
-(void)callShop{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.shopPhoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)changeOrderTypeAction{
    NSDictionary * dic2 = @{ @"flg":self.setUpdateOrderStr,@"ordernum":self.orderNumberStr};
    if (self.blockChangeOrderState) {
        self.blockChangeOrderState(dic2);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
