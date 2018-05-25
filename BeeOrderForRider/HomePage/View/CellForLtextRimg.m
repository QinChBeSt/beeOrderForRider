//
//  CellForLtextRimg.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForLtextRimg.h"

@implementation CellForLtextRimg

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
    self.leftLab = [[UILabel alloc]init];
    self.leftLab.font = [UIFont systemFontOfSize:16];
    self.leftLab.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    [self.contentView addSubview:self.leftLab];
    [self.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView.mas_left).offset(25);
    }];
    self.rightImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.rightImg];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView.mas_right).offset(-25);
        make.width.equalTo(@(20));
        make.height.equalTo(@(30));
        make.centerY.equalTo(ws.contentView);
    }];
    
    self.shuxian = [[UIView alloc]init];
    
     self.shuxian.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    self.shuxian.hidden = YES;
    [self.contentView addSubview: self.shuxian];
    [ self.shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.rightImg.mas_left).offset(-20) ;
        make.width.equalTo(@(1));
        make.centerY.equalTo(ws.contentView);
        make.top.equalTo(ws.contentView).offset(5);
    }];
    self.buttomLine = [[UIView alloc]init];
    self.buttomLine.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [self.contentView addSubview:self.buttomLine];
    [self.buttomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.contentView);
        make.bottom.equalTo(ws.contentView);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@(1));
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
