//
//  CellForGoodsList.h
//  BeeOrderForRider
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelForOrderDetail.h"
@interface CellForGoodsList : UITableViewCell
@property (nonatomic , strong)UIImageView *bigImage;
@property (nonatomic , strong)UILabel *shopName;
@property (nonatomic , strong)UILabel *shopPic;
@property (nonatomic , strong)UILabel *shopCount;
@property (nonatomic , strong)ModelForOrderDetail *mod;
@end
