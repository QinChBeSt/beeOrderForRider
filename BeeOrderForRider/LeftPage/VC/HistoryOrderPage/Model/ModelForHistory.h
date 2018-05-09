//
//  ModelForHistory.h
//  BeeOrderForRider
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelForOrderDetail.h"
@interface ModelForHistory : NSObject
@property (nonatomic , strong)NSString *orderdaynum;
@property (nonatomic , strong)NSString *ordernum;
@property (nonatomic , strong)NSString *orderdatatime;
@property (nonatomic , strong)NSString *orderbz;
@property (nonatomic , strong)NSString *ordertype;
@property (nonatomic , strong)NSString *orderpspic;
@property (nonatomic , strong)NSString *orderyhpic;
@property (nonatomic , strong)NSString *orderallpic;
@property (nonatomic , strong)NSString *shopname;
@property (nonatomic , strong)NSString *shopaddr;
@property (nonatomic , strong)NSString *shopphone;
@property (nonatomic , strong)NSString *shoplat;
@property (nonatomic , strong)NSString *shoplonng;
@property (nonatomic , strong)NSString *uname;
@property (nonatomic , strong)NSString *uphone;
@property (nonatomic , strong)NSString *ulat;
@property (nonatomic , strong)NSString *ulonng;
@property (nonatomic , strong)NSString *uaddr;
@property (nonatomic , strong)NSMutableArray *ordersContexts;
@end
