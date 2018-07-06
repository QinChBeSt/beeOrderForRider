//
//  CellForDateDetai.m
//  BeeOrderForRider
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForDateDetai.h"

@implementation CellForDateDetai
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
    self.orderName = [[UILabel alloc]init];
    self.orderName.font = [UIFont systemFontOfSize:14];
    self.orderName.numberOfLines = 2;
    [self.contentView addSubview:self.orderName];
    [self.orderName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH / 3 * 2 - 30));
    }];
    
//    self.orderCount = [[UILabel alloc]init];
//    self.orderCount.font = [UIFont systemFontOfSize:14];
//    self.orderCount.numberOfLines = 1;
//    self.orderCount.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:self.orderCount];
//    [self.orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(ws.contentView);
//        make.centerX.equalTo(ws.contentView);
//        make.width.equalTo(@(SCREEN_WIDTH / 3  - 15));
//    }];
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    rightIcon.image  = [UIImage imageNamed:@"右箭头"];
    [self.contentView addSubview:rightIcon];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView.mas_right).offset(-10);
        make.width.and.height.equalTo(@(15));
    }];
    
    self.orderPic = [[UILabel alloc]init];
    self.orderPic.textAlignment = NSTextAlignmentRight;
    self.orderPic.font = [UIFont systemFontOfSize:14];
    self.orderPic.textColor = [UIColor colorWithHexString:BaseGreen];
    self.orderPic.numberOfLines = 2;
    [self.contentView addSubview:self.orderPic];
    [self.orderPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(rightIcon.mas_left).offset (-10);
        make.width.equalTo(@(SCREEN_WIDTH / 3 - 15));
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
    
    self.orderName.text = @"2018-05-18 #7";
    self.orderPic.text = @"$12.11";
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
