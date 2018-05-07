//
//  QCSegmentVC.m
//  BeeOrderForBusiness
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 QinChBeSt. All rights reserved.
//

#import "QCSegmentVC.h"
#define HEADBTN_TAG                 10000
#define Default_BottomLineColor     themeColor
#define Default_BottomLineHeight    2
#define Default_ButtonHeight        45
#define Default_BottomCount         2
#define Default_TitleColor          [UIColor whiteColor]
#define Default_HeadViewBackgroundColor  [UIColor blackColor]
#define Default_FontSize            16

///获取屏幕宽高
#define HK_Screen_Width         [[UIScreen mainScreen] bounds].size.width
#define HK_Screen_Height        [[UIScreen mainScreen] bounds].size.height

#define TEXT_BULE_LEVEL_1           [UIColor redColor]
@interface QCSegmentVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *headerView;
@property (nonatomic, strong) UIScrollView  *mainScrollView;
@property (nonatomic, strong) UIView        *lineView;
@property (nonatomic, assign) NSInteger     selectIndex;

@end

@implementation QCSegmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initSegment
{
    [self addButtonInScrollHeader:_titleArray];
    [self addContentViewScrollView:_subViewControllers];
}

/*!
 *  @brief  根据传入的title数组新建button显示在顶部scrollView上
 *
 *  @param titleArray  title数组
 */
- (void)addButtonInScrollHeader:(NSArray *)titleArray
{
    self.headerView.frame = CGRectMake(0, 0, HK_Screen_Width, self.buttonHeight);
    if (_segmentHeaderType == 0) {
        self.headerView.contentSize = CGSizeMake(self.buttonWidth * titleArray.count, self.buttonHeight);
    }
    else {
        self.headerView.contentSize = CGSizeMake(HK_Screen_Width, self.buttonHeight);
    }
    [self.view addSubview:self.headerView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        segmentBtn.frame = CGRectMake(self.buttonWidth * index, 0, self.buttonWidth, self.buttonHeight);
        [segmentBtn setTitle:titleArray[index] forState:UIControlStateNormal];
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        segmentBtn.tag = index + HEADBTN_TAG;
        [segmentBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [segmentBtn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:segmentBtn];
        if (index == 0) {
            segmentBtn.selected = YES;
            self.selectIndex = segmentBtn.tag;
        }
    }
    
    NSInteger lineWidth=80;
    NSInteger margin=(self.buttonWidth-lineWidth)/2;
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(margin, self.buttonHeight - self.bottomLineHeight, lineWidth, self.bottomLineHeight)];
    _lineView.backgroundColor = self.bottomLineColor;
    [self.headerView addSubview:_lineView];
}

/*!
 *  @brief  根据传入的viewController数组，将viewController的view添加到显示内容的scrollView
 *
 *  @param subViewControllers  viewController数组
 */
- (void)addContentViewScrollView:(NSArray *)subViewControllers
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.buttonHeight, HK_Screen_Width, HK_Screen_Height - self.buttonHeight)];
    _mainScrollView.contentSize = CGSizeMake(HK_Screen_Width * subViewControllers.count, HK_Screen_Height - self.buttonHeight);
    [_mainScrollView setScrollEnabled:YES];
    [_mainScrollView setPagingEnabled:YES];
    
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    
    [self.view addSubview:_mainScrollView];
    
    [subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
        viewController.view.frame = CGRectMake(idx * HK_Screen_Width, 0, HK_Screen_Width, _mainScrollView.frame.size.height);
        
        [_mainScrollView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }];
}

- (void)addParentController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

#pragma mark 点击按钮方法

- (void)btnClick:(UIButton *)button
{
    [_mainScrollView scrollRectToVisible:CGRectMake((button.tag - HEADBTN_TAG) *HK_Screen_Width, 0, HK_Screen_Width, _mainScrollView.frame.size.height) animated:YES];
    [self didSelectSegmentIndex:button.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenAction" object:nil];
}

/*!
 *  @brief  设置顶部选中button下方线条位置
 *
 *  @param index 第几个
 */
- (void)didSelectSegmentIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:self.selectIndex];
    btn.selected = NO;
    self.selectIndex = index;
    UIButton *currentSelectBtn = (UIButton *)[self.view viewWithTag:index];
    currentSelectBtn.selected = YES;
    
    CGRect rect = self.lineView.frame;
    
    NSInteger lineWidth=80;
    NSInteger margin=(self.buttonWidth-lineWidth)/2;
    
    rect.origin.x = (index - HEADBTN_TAG) * (HK_Screen_Width/_bottomCount)+margin;
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = rect;
    }];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenAction" object:nil];
    
    if (scrollView.contentOffset.x<=960) {
        if (scrollView == _mainScrollView) {
            float xx = scrollView.contentOffset.x * (_buttonWidth / HK_Screen_Width) - _buttonWidth;
            [_headerView scrollRectToVisible:CGRectMake(xx, 0, HK_Screen_Width, _headerView.frame.size.height) animated:YES];
            NSInteger currentIndex = scrollView.contentOffset.x / HK_Screen_Width;
            [self didSelectSegmentIndex:currentIndex + HEADBTN_TAG];
        }
    }else{
        [scrollView setScrollEnabled:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    float xx = scrollView.contentOffset.x * (_buttonWidth / HK_Screen_Width) - _buttonWidth;
    [_headerView scrollRectToVisible:CGRectMake(xx, 0, HK_Screen_Width, _headerView.frame.size.height) animated:YES];
    
    
}

#pragma mark - setter/getter
- (UIScrollView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIScrollView alloc] init];
        [_headerView setShowsVerticalScrollIndicator:NO];
        [_headerView setShowsHorizontalScrollIndicator:NO];
        _headerView.bounces = NO;
        _headerView.backgroundColor = self.headViewBackgroundColor;
    }
    return _headerView;
}

- (UIColor *)headViewBackgroundColor
{
    if (_headViewBackgroundColor == nil) {
        _headViewBackgroundColor = Default_HeadViewBackgroundColor;
    }
    return _headViewBackgroundColor;
}

- (UIColor *)titleColor
{
    if (_titleColor == nil) {
        _titleColor = Default_TitleColor;
    }
    return _titleColor;
}

- (UIColor *)titleSelectedColor
{
    if (_titleSelectedColor == nil) {
        _titleSelectedColor = Default_TitleColor;
    }
    return _titleSelectedColor;
}

- (CGFloat)fontSize
{
    if (_fontSize == 0) {
        _fontSize = Default_FontSize;
    }
    return _fontSize;
}

- (CGFloat)buttonWidth
{
    if (_buttonWidth == 0) {
        _buttonWidth = HK_Screen_Width / 4;
    }
    return _buttonWidth;
}

- (CGFloat)buttonHeight
{
    if (_buttonHeight == 0) {
        _buttonHeight = Default_ButtonHeight;
    }
    return _buttonHeight;
}

- (CGFloat)bottomLineHeight
{
    if (_bottomLineHeight == 0) {
        _bottomLineHeight = Default_BottomLineHeight;
    }
    return _bottomLineHeight;
}

- (CGFloat)bottomCount
{
    if (_bottomCount == 0) {
        _bottomCount = Default_BottomCount;
    }
    return _bottomCount;
}

- (UIColor *)bottomLineColor
{
    if (_bottomLineColor == nil) {
        _bottomLineColor = TEXT_BULE_LEVEL_1;
    }
    return _bottomLineColor;
}
@end
