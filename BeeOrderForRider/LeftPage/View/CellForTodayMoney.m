//
//  CellForTodayMoney.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/24.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForTodayMoney.h"

@implementation CellForTodayMoney
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:topLine];
    __weak typeof(self) ws = self;
    self.timeLab = [[UILabel alloc]init];
    self.timeLab.font = [UIFont systemFontOfSize:14];
    self.timeLab.text = @"16:27  送达";
    self.timeLab.textColor = [UIColor colorWithHexString:@"959595"];
    [self.contentView addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left).offset(30);
        make.height.equalTo(@(30));
        make.top.equalTo(topLine.mas_bottom);
    }];
    
    self.statsLab = [[UILabel alloc]init];
    self.statsLab.font = [UIFont systemFontOfSize:14];
    self.statsLab.text = @"已交账";
    self.statsLab.textColor = [UIColor colorWithHexString:@"959595"];
    [self.contentView addSubview:self.statsLab];
    [self.statsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30));
        make.top.equalTo(topLine.mas_bottom);
        make.right.equalTo(ws.contentView.mas_right).offset(-30);
    }];
    
    UIView *midLine = [[UIView alloc]init];
    midLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left).offset(25);
        make.centerX.equalTo(ws.contentView);
        make.top.equalTo(ws.timeLab.mas_bottom);
        make.height.equalTo(@(1));
    }];
    
    UIView *buttomView = [[UIView alloc]init];
    [self.contentView addSubview:buttomView];
    [buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midLine.mas_bottom);
        make.bottom.equalTo(ws.contentView);
        make.width.equalTo(ws.contentView);
        make.centerX.equalTo(ws.contentView);
    }];
    self.shopNameTit = [[UILabel alloc]init];
    self.shopNameTit.font = [UIFont systemFontOfSize:18];
    self.shopNameTit.text = ZBLocalized(@"商家名称", nil);
    self.shopNameTit.textColor = [UIColor colorWithHexString:@"4b4b4b"];
    [self.contentView addSubview:self.shopNameTit];
    [self.shopNameTit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midLine.mas_bottom).offset(10);
        make.bottom.equalTo(buttomView.mas_centerY).offset(0);
        make.left.equalTo(ws.timeLab);
    }];
    
    self.shopNameLab = [[UILabel alloc]init];
    self.shopNameLab.font = [UIFont systemFontOfSize:18];
    self.shopNameLab.text = @"KFC";
    self.shopNameLab.textColor = [UIColor colorWithHexString:@"4b4b4b"];
    [self.contentView addSubview:self.shopNameLab];
    [self.shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-10);
        make.top.equalTo(buttomView.mas_centerY).offset(0);
        make.left.equalTo(ws.timeLab);
    }];
    
    UILabel *picState = [[UILabel alloc]init];
    picState.text = ZBLocalized(@"(实收)", nil);
    picState.font = [UIFont systemFontOfSize:16];
    picState.textColor = [UIColor colorWithHexString:@"959595"];
    [self.contentView addSubview:picState];
    [picState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView.mas_right).offset(-30);
        make.centerY.equalTo(buttomView);
    }];
    
    self.priceLab = [[UILabel alloc]init];
    self.priceLab.text = @"￥23";
    self.priceLab.textColor = [UIColor redColor];
    self.priceLab.font = [UIFont systemFontOfSize:24];
    [self.contentView addSubview:self.priceLab];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buttomView);
        make.right.equalTo(picState.mas_left).offset(-2);
        
    }];
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
