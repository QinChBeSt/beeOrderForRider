//
//  CellForHistoryOrder.h
//  BeeOrderForRider
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelForHistory.h"
@interface CellForHistoryOrder : UITableViewCell
@property (nonatomic , strong)UILabel *orderDayNo;
@property (nonatomic , strong)UILabel *orderNumLab;
@property (nonatomic , strong)UILabel *orderDateLab;
@property (nonatomic , strong)UILabel *shopNameLab;
@property (nonatomic , strong)UILabel *riderStateLabel;
@property (nonatomic , strong)UILabel *userNameLab;
@property (nonatomic , strong)UILabel *userAddLab;
@property (nonatomic , strong)ModelForHistory *mod;
@end
