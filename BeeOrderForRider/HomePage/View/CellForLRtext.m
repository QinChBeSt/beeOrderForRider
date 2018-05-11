//
//  CellForLRtext.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForLRtext.h"

@implementation CellForLRtext

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
    self.leftLab.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    self.leftLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.leftLab];
    [self.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView.mas_left).offset(15);
    }];
    
    self.rightLab = [[UILabel alloc]init];
    self.rightLab.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    self.rightLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.rightLab];
    [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
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
