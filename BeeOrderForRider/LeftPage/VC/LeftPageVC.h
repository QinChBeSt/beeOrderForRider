//
//  LeftPageVC.h
//  BeeOrderForRider
//
//  Created by mac on 2018/5/7.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^blockCloceSide)(NSString *);
@interface LeftPageVC : UIViewController
@property (nonatomic , copy)blockCloceSide blockCloceSide;
@end
