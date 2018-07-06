//
//  CellForHistoryDetailGoodsList.m
//  BeeOrderForRider
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForHistoryDetailGoodsList.h"

@implementation CellForHistoryDetailGoodsList
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
    self.goodsPic = [[UILabel alloc]init];
    self.goodsPic.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.goodsPic];
    [self.goodsPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView).offset(-10);
    }];
    [self.goodsPic setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                  forAxis:UILayoutConstraintAxisHorizontal];
    
    self.goodsCount = [[UILabel alloc]init];
    self.goodsCount.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.goodsCount];
    [self.goodsCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.goodsPic.mas_left).offset(-20);
    }];
    
    UIView *leftIcon = [[UIView alloc]init];
    leftIcon.backgroundColor = [UIColor blackColor];
    leftIcon.layer.cornerRadius=5;
    leftIcon.clipsToBounds = YES;
    [self.contentView addSubview:leftIcon];
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView).offset(10);
        make.width.and.height.equalTo(@(10));
    }];
    
    self.goodsName = [[UILabel alloc]init];
    self.goodsName.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.goodsName];
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(leftIcon.mas_right).offset(10);
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
