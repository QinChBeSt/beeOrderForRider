//
//  HLAlertViewNoMassageBlock.h
//  BeeOrderForRider
//
//  Created by 钱程 on 2018/7/20.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    AlertBlockCauseButtonClick1 = 0,
    AlertBlockSureButtonClick1
} AlertBlockButtonClickIndex1;
@interface HLAlertViewNoMassageBlock : UIView

@property(nonatomic, copy) void (^buttonBlock) (NSInteger index);

- (instancetype)initWithTittle:(NSString *)tittle message:(NSString *)message block:(void (^) (NSInteger index))block;

- (void)show;
@end
