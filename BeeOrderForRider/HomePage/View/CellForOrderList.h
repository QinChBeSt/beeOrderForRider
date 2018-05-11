//
//  CellForOrderList.h
//  BeeOrderForRider
//
//  Created by mac on 2018/5/10.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelForHistory.h"
typedef void (^blockChangeOrderState)(NSDictionary *);
typedef void (^blocktoMapView)(NSDictionary *);
@interface CellForOrderList : UITableViewCell
@property (nonatomic , copy)blockChangeOrderState blockChangeOrderState;
@property (nonatomic , copy)blocktoMapView blocktoMapView;
@property (nonatomic , strong)UILabel *orderNumLab;
@property (nonatomic , strong)UILabel *orderDateLab;
@property (nonatomic , strong)UILabel *shopNameLab;
@property (nonatomic , strong)UILabel *shopAddLab;
@property (nonatomic , strong)UILabel *userNameLab;
@property (nonatomic , strong)UILabel *userAddLab;
@property (nonatomic , strong)UIButton *leftButton;
@property (nonatomic , strong)UIButton *rightButton;
@property (nonatomic , strong)ModelForHistory *mod;
@property (nonatomic , strong)UIView *bottomLine;
@property (nonatomic , strong)NSString *orderTypeStr;
@property (nonatomic , strong)NSString *setUpdateOrderStr;
@property (nonatomic , strong)NSString *orderNumberStr;
@property (nonatomic , assign) CLLocation *LocCoordinate;
@property (nonatomic , strong)NSString *latStr;
@property (nonatomic , strong)NSString *longStr;
@property (nonatomic , strong)NSString *userLatStr;
@property (nonatomic , strong)NSString *userLongStr;

@property (nonatomic , strong)NSString *latLoc;
@property (nonatomic , strong)NSString *longLoc;
@property (nonatomic , strong)NSString *shopPhoneNum;

@end
