//
//  CellForPSDZ.m
//  BeeOrderForRider
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForPSDZ.h"

@implementation CellForPSDZ
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
    self.TIT = [[UILabel alloc]init];
    self.TIT.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    self.TIT.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.TIT];
    [self.TIT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView.mas_left).offset(25);
    }];
      
    self.SUB = [[UILabel alloc]init];
    self.SUB.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    self.SUB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.SUB];
    [self.SUB mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.TIT.mas_right).offset(10);
        make.right.equalTo(ws.contentView.mas_right).offset(-10);
        make.top.equalTo(ws.contentView).offset(10);
    }];
    
    self.buttomLine = [[UIView alloc]init];
    self.buttomLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.buttomLine];
    [self.buttomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.contentView);
        make.bottom.equalTo(ws.SUB).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@(0.5));
    }];
    [self setupAutoHeightWithBottomView:self.buttomLine bottomMargin:0];
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
