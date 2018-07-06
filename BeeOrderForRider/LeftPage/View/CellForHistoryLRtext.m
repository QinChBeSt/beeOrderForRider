//
//  CellForHistoryLRtext.m
//  BeeOrderForRider
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForHistoryLRtext.h"

@implementation CellForHistoryLRtext
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.topLine = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 1)];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
    [self.contentView addSubview:self.topLine];
    __weak typeof(self) ws = self;
    self.leftText = [[UILabel alloc]init];
    self.leftText.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.leftText];
    [self.leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView).offset(10);
    }];
    
    self.rightText = [[UILabel alloc]init];
    self.rightText.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.rightText];
    [self.rightText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView).offset(-10);
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
