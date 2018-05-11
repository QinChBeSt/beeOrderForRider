//
//  CellForGoodsList.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForGoodsList.h"

@implementation CellForGoodsList
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
    self.bigImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bigImage];
    [self.bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.top.equalTo(ws.contentView.mas_top).offset(10);
        make.left.equalTo(ws.contentView.mas_left).offset(15);
        make.width.equalTo(ws.bigImage.mas_height);
    }];
    
    self.shopName = [[UILabel alloc]init];
    self.shopName.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.shopName];
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.bigImage.mas_top);
        make.bottom.equalTo(ws.bigImage.mas_centerY);
        make.left.equalTo(ws.bigImage.mas_right).offset(20);
    }];
    
    self.shopPic = [[UILabel alloc]init];
    self.shopPic.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.shopPic];
    [self.shopPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.bigImage.mas_top);
        make.bottom.equalTo(ws.bigImage.mas_centerY);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
    }];
    
    self.shopCount = [[UILabel alloc]init];
    self.shopCount.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.shopCount];
    [self.shopCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.bigImage.mas_bottom);
        make.top.equalTo(ws.bigImage.mas_centerY);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.contentView);
        make.height.equalTo(@(1));
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.bottom.equalTo(ws.contentView.mas_bottom);
    }];
    
    
}
-(void)setMod:(ModelForOrderDetail *)mod{
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:mod.ordersGoodsLog] placeholderImage:[UIImage imageNamed:@"xmfLogo"]];
    self.shopName.text = mod.ordersGoodsName;
    CGFloat Fpic = [mod.ordersGoodsPic floatValue];
    self.shopPic.text = [NSString stringWithFormat:@"%@%.2f",ZBLocalized(@"￥",nil),Fpic];
    self.shopCount.text = [NSString stringWithFormat:@"x %@",mod.ordersGoodsNum];
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
