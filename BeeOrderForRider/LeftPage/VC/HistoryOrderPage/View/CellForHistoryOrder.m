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
    self.orderNumLab.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    self.orderNumLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.orderNumLab];
    [self.orderNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView.mas_left).offset(20);
        make.height.equalTo(@(lineHeight));
    }];
    
    self.orderDateLab = [[UILabel alloc]init];
    self.orderDateLab.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
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
    

    
    UILabel *put = [[UILabel alloc]init];
    put.adjustsFontSizeToFitWidth = YES;
    put.text = ZBLocalized(@"送",nil);
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
    
    
    UIView *buttomLine = [[UIView alloc]initWithFrame:CGRectMake(0, lineHeight * 3, SCREEN_WIDTH, 10)];
    buttomLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:buttomLine];
}
-(void)setMod:(ModelForHistory *)mod{
    self.orderNumLab.text = [NSString stringWithFormat:@"%@%@",ZBLocalized(@"订单编号:", nil),mod.ordernum];
    self.orderDateLab.text = [NSString stringWithFormat:@"%@",mod.orderdatatime];
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
