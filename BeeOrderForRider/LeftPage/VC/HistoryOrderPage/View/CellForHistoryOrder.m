//
//  CellForHistoryOrder.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForHistoryOrder.h"
#define lineHeight 50
@implementation CellForHistoryOrder

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
    self.orderNumLab = [[UILabel alloc]init];
    self.orderNumLab.textColor = [UIColor blackColor];
    self.orderNumLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.orderNumLab];
    [self.orderNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView.mas_left).offset(20);
        make.height.equalTo(@(lineHeight));
    }];
    
    self.orderDateLab = [[UILabel alloc]init];
    self.orderDateLab.textColor = [UIColor blackColor];
    self.orderDateLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.orderDateLab];
    [self.orderDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView.mas_right).offset(-20);
        make.height.equalTo(@(lineHeight));
    }];
    
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
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    [rightIcon setImage:[UIImage imageNamed:@"右箭头"]];
    [self.contentView addSubview:rightIcon];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(get);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
        make.width.and.height.equalTo(@(20));
    }];
    
    self.riderStateLabel = [[UILabel alloc]init];
    self.riderStateLabel.textAlignment = NSTextAlignmentRight;
    self.riderStateLabel.numberOfLines = 2;
    self.riderStateLabel.font = [UIFont systemFontOfSize:14];
    self.riderStateLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.riderStateLabel];
    [self.riderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(get);
        make.height.equalTo(@(lineHeight));
        make.right.equalTo(rightIcon.mas_left).offset(-15);
        make.left.equalTo(ws.shopNameLab.mas_right).offset(20);
    }];
    
    UILabel *put = [[UILabel alloc]init];
    put.adjustsFontSizeToFitWidth = YES;
    put.text = ZBLocalized(@"送",nil);
    put.textAlignment = NSTextAlignmentCenter;
    put.numberOfLines = 0;
    put.textColor = [UIColor whiteColor];
    put.backgroundColor = [UIColor redColor];
    put.layer.cornerRadius=(lineHeight - 20)/ 2;
    put.clipsToBounds = YES;
    [self.contentView addSubview:put];
    [put mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(get.mas_bottom).offset(20);
        make.height.equalTo(@(lineHeight - 20));
        make.left.equalTo(ws.orderNumLab);
        make.width.equalTo(@(lineHeight - 20));
    }];
    
    self.userNameLab = [[UILabel alloc]init];
    self.userNameLab.font = [UIFont systemFontOfSize:14];
    self.userNameLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.userNameLab];
    [self.userNameLab setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                      forAxis:UILayoutConstraintAxisHorizontal];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(put);
        make.height.equalTo(@(lineHeight));
        make.left.equalTo(ws.shopNameLab);
    }];
    
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
        make.left.equalTo(ws.userNameLab.mas_right).offset(20);
    }];
    
    
    UIView *buttomLine = [[UIView alloc]initWithFrame:CGRectMake(0, lineHeight * 3, SCREEN_WIDTH, 10)];
    buttomLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:buttomLine];
}
-(void)setMod:(ModelForHistory *)mod{
    self.orderNumLab.text = [NSString stringWithFormat:@"%@%@",ZBLocalized(@"订单编号:", nil),mod.ordernum];
    self.orderDateLab.text = [NSString stringWithFormat:@"%@",mod.orderdatatime];
    self.shopNameLab.text = mod.shopname;
    [self setOrderStateStr:mod.ordertype];
    self.userNameLab.text = mod.uname;
    self.userAddLab.text = mod.uaddr;
}
-(void)setOrderStateStr:(NSString *)str{
    NSString *shopStrat = str;
    if ([shopStrat isEqualToString:@"2"]) {
        self.riderStateLabel.text = ZBLocalized(@"商家未接单", nil);
    }
    else if ([shopStrat isEqualToString:@"3"]){
        self.riderStateLabel.text = ZBLocalized(@"商家未接单", nil);
    }
    else if ([shopStrat isEqualToString:@"4"]){
        self.riderStateLabel.text = ZBLocalized(@"商家已接单", nil);
    }
    else if ([shopStrat isEqualToString:@"5"]){
        self.riderStateLabel.text = ZBLocalized(@"骑手未接单", nil);
    }
    else if ([shopStrat isEqualToString:@"6"]){
        self.riderStateLabel.text =ZBLocalized(@"骑手已接单", nil);
    }
    else if ([shopStrat isEqualToString:@"7"]){
        self.riderStateLabel.text = ZBLocalized(@"骑手到店", nil);
    }
    else if ([shopStrat isEqualToString:@"8"]){
        self.riderStateLabel.text = ZBLocalized(@"骑手拿到东西", nil);
    }
    else if ([shopStrat isEqualToString:@"9"]){
        self.riderStateLabel.text = ZBLocalized(@"订单完成", nil);
    }
    else if ([shopStrat isEqualToString:@"10"]){
        self.riderStateLabel.text = ZBLocalized(@"未评价", nil);
    }
    else if ([shopStrat isEqualToString:@"11"]){
        self.riderStateLabel.text = ZBLocalized(@"已评价", nil);
    }
    else if ([shopStrat isEqualToString:@"12"]){
        self.riderStateLabel.text = ZBLocalized(@"商家已取消", nil);
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
