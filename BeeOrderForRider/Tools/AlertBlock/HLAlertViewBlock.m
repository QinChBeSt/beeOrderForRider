//
//  HLAlertViewBlock.m
//  HLAlertView
//
//  Created by 郝靓 on 2018/6/5.
//  Copyright © 2018年 郝靓. All rights reserved.
//

#import "HLAlertViewBlock.h"
#import "UIView+HLExtension.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HLAlertViewBlock()

/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;

/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;

/** message */
@property (nonatomic,copy)   NSString *message;

/** 确认按钮 */
@property (nonatomic,copy)   UIButton *sureButton;

@end


@implementation HLAlertViewBlock

- (instancetype)initWithTittle:(NSString *)tittle message:(NSString *)message block:(void (^)(NSInteger))block{
    if (self = [super init]) {
        self.title = tittle;
        self.message = message;
        self.buttonBlock = block;
        [self sutUpView];
    }
    return self;
}

- (void)sutUpView{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.85];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 80, 180);
    self.contentView.center = self.center;
    self.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
    self.contentView.layer.cornerRadius = 6;
    [self addSubview:self.contentView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 50)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    [self.contentView addSubview:titleLabel];
    
    // message
    UILabel *messageLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.contentView.width, 50)];
    messageLable.font = [UIFont boldSystemFontOfSize:50];
    messageLable.textAlignment = NSTextAlignmentCenter;
    messageLable.textColor = [UIColor redColor];
    messageLable.text = self.message;
    [self.contentView addSubview:messageLable];
    
    
    // 取消按钮
    UIButton * causeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    causeBtn.frame = CGRectMake(0, self.contentView.height - 60, self.contentView.width/2, 60);
    causeBtn.backgroundColor = [UIColor whiteColor];
    [causeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [causeBtn setTitle:ZBLocalized(@"取消", nil) forState:UIControlStateNormal];
    [causeBtn addTarget:self action:@selector(causeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:causeBtn];
    
    // 确认按钮
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(causeBtn.width, causeBtn.y, causeBtn.width, 60);
    sureButton.backgroundColor = [UIColor colorWithHexString:BaseYellow];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitle:ZBLocalized(@"确定", nil) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(processSure:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:sureButton];
    
}

- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}


- (void)processSure:(UIButton *)sender{
    if (self.buttonBlock) {
        self.buttonBlock(AlertBlockSureButtonClick);
    }
    [self dismiss];
}

- (void)causeBtn:(UIButton *)sender{
    if (self.buttonBlock) {
        self.buttonBlock(AlertBlockCauseButtonClick);
    }
    [self dismiss];
}

#pragma mark - 移除此弹窗
/** 移除此弹窗 */
- (void)dismiss{
    [self removeFromSuperview];
}
@end
