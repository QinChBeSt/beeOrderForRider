//
//  CellForLeftPage.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForLeftPage.h"

@implementation CellForLeftPage

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
    self.img = [[UIImageView alloc]init];
    [self.contentView addSubview:self.img];
    [self.img  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left).offset(25);
        make.top.equalTo(ws.contentView.mas_top).offset(10);
        make.centerY.equalTo(ws.contentView);
        make.width.equalTo(ws.img.mas_height);
    }];
    
    self.Tlabel = [[UILabel alloc]init];
    self.Tlabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.Tlabel];
    [self.Tlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.img.mas_right).offset(20);
    }];
    
    UIView *line =[[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:BaseBackgroundGray];
    [ws.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.contentView);
        make.width.equalTo(ws.contentView);
        make.height.equalTo(@(0.5));
        make.centerX.equalTo(ws.contentView);
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
