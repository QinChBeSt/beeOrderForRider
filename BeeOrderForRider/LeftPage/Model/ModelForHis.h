//
//  ModelForHis.h
//  BeeOrderForRider
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelForHisorder.h"

@interface ModelForHis : NSObject
@property (nonatomic , strong)ModelForHisorder *order;
@property (nonatomic , strong)NSMutableArray *prdergoods;
@property (nonatomic , strong)NSMutableArray *orderYhxEntities;
@property (nonatomic , strong)NSString *goodspic;
@property (nonatomic , strong)NSString *okpic;
@end
