//
//  CellForChooseLag.m
//  BeeOrderForRider
//
//  Created by mac on 2018/5/25.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "CellForChooseLag.h"

@implementation CellForChooseLag

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    
    self.img = [[UIImageView alloc]init];
    [self.contentView addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.and.height.equalTo(@(15));
    }];
    
    self.name = [[UILabel alloc]init];
    self.name.numberOfLines = 0;
    self.name.textColor = [UIColor colorWithHexString:BaseTextGrayColor];
    self.name.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.img.mas_left).offset(-10);
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
