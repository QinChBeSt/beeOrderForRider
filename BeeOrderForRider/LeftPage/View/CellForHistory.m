//
//  CellForHistory.m
//  BeeOrderForRider
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForHistory.h"

@implementation CellForHistory
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
    self.dateLab = [[UILabel alloc]init];
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    self.dateLab.font = [UIFont systemFontOfSize:13];
    NSString *nowDate = [fmt stringFromDate:now];
    self.dateLab.text = [self pp_formatDateWithArrYMDToMD:nowDate];
    [self.contentView addSubview:self.dateLab];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView.mas_left).offset(15);
    }];
    
    self.orderState = [[UILabel alloc]init];
    self.orderState.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.orderState];
    [self.orderState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.dateLab.mas_right).offset(5);
    }];
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    rightIcon.image  = [UIImage imageNamed:@"右箭头"];
    [self.contentView addSubview:rightIcon];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
        make.width.and.height.equalTo(@(15));
    }];
    
    self.picLab = [[UILabel alloc]init];
    self.picLab.textColor = [UIColor blackColor];
    self.picLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.picLab];
    [self.picLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(rightIcon.mas_left).offset(-5);
    }];
    
    UIImageView *buttom = [[UIImageView alloc]init];
    buttom.backgroundColor = [UIColor colorWithHexString:BaseTextBlack];
    [self.contentView addSubview:buttom];
    [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.contentView);
        make.bottom.equalTo(ws.contentView);
        make.height.equalTo(@(0.5));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    self.orderState.textColor = [UIColor colorWithHexString:BaseYellow];
    self.orderState.text = ZBLocalized(@"待交账", nil);
    self.picLab.text = @"123.45";
}

- (NSString *)pp_formatDateWithArrYMDToMD:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSInteger year = [array[0] integerValue];
    NSInteger month = [array[1] integerValue];
    NSInteger day = [array[2] integerValue];
    
    return [NSString stringWithFormat:@"%lu.%lu.%lu",(long)year,(long)month, (long)day];
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
