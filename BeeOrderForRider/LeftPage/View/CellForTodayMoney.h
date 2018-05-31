//
//  CellForTodayMoney.h
//  BeeOrderForRider
//
//  Created by mac on 2018/5/24.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelForViewMoney.h"
@interface CellForTodayMoney : UITableViewCell
@property (nonatomic , strong)UILabel *timeLab;
@property(nonatomic , strong)UILabel *ddStatsLab;
@property (nonatomic , strong)UILabel *statsLab;
@property (nonatomic , strong)UILabel *shopNameTit;
@property (nonatomic , strong)UILabel *shopNameLab;
@property (nonatomic , strong)UILabel *priceLab;
@property (nonatomic , strong)ModelForViewMoney *Mod;
@end
