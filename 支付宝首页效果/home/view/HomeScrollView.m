//
//  HomeScrollView.m
//  支付宝首页效果
//
//  Created by Dai on 16/4/7.
//  Copyright © 2016年 daishang. All rights reserved.
//

#import "HomeScrollView.h"
#import "HomeModel.h"
#import "ClickViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HomeScrollView ()

/**
 *  存储数据的数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/**
 *  存储每个单元button的数组
 */
@property (nonatomic, strong) NSMutableArray *buttonArr;
/**
 *  单元button
 */
@property (nonatomic, strong) UIButton *unitBtn;
/**
 *  空button
 */
@property (nonatomic, strong) UIButton *emptyBtn;
/**
 *  当前点击的button
 */
@property (nonatomic, strong) UIButton *currentBtn;
/**
 *  相对起始点
 */
@property (nonatomic, assign) CGPoint beganPoint;
/**
 *  记录行高
 */
@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation HomeScrollView

- (instancetype)initWithFrame:(CGRect)frame andWith:(NSMutableArray *)dataArr
{
    self = [super init];
    if (self)
    {
        self.buttonArr = [NSMutableArray array];
        self.emptyBtn  = [[UIButton alloc] init];
        self.dataArr   = [NSMutableArray array];
        self.dataArr   = dataArr;
        self.frame     = frame;
        [self createView];
    }
    return self;
}

//创建视图
- (void)createView
{
    self.backgroundColor = [UIColor whiteColor];
    //collectionView.contentSize小于collectionView.frame.size的时候，UICollectionView是不会滚动的，设置该属性即可。
    self.alwaysBounceVertical = YES;
    //创建单元view
    for (int i=0; i<self.dataArr.count; i++)
    {
        HomeModel *model = self.dataArr[i];
        self.unitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.unitBtn setImage:[UIImage imageNamed:model.imageName] forState:UIControlStateNormal];
        [self.unitBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
        self.unitBtn.tag = i;
        self.unitBtn.userInteractionEnabled = YES;
        //添加长按手势
        if (i < self.dataArr.count - 1)
        {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            
            [self.unitBtn addGestureRecognizer:longPress];
        }
        
        //创建标题label
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor lightGrayColor];
        titleLab.font = [UIFont systemFontOfSize:12];
        titleLab.text = model.titleStr;
        titleLab.tag  = i+100;
        [self.unitBtn addSubview:titleLab];

        [self addSubview:self.unitBtn];
        [self.buttonArr addObject:self.unitBtn];
        
    }
    //设置单元位置
    [self setNewView];
    //设置分割线
    [self setLineView];
    
}
//设置每个单元的位置
- (void)setNewView
{
    //设置每个单元view的宽高
    CGFloat itemW = WIDTH/4;
    CGFloat itemH = itemW*1.1;
    
    __weak typeof(self)weakSelf = self;
    //遍历单元view数组,设置每个单元view的位置
    [self.buttonArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = (UILabel *)[btn viewWithTag:idx+100];
        long rowIndex = idx/4;
        long columndex = idx%4;
        
        CGFloat x = itemW * columndex;
        CGFloat y = itemH * rowIndex;
        btn.frame = CGRectMake(x, y, itemW, itemH);
        lab.frame = CGRectMake(0, btn.bounds.size.height - 30, btn.bounds.size.width, 25);
        
        if (idx == weakSelf.buttonArr.count -1)
        {
            //设置scroll画布高度
            weakSelf.contentSize = CGSizeMake(0, btn.frame.size.height + btn.frame.origin.y);
            weakSelf.rowHeight = btn.frame.size.height + btn.frame.origin.y;
        }
    }];
    
}

//设置分割线
- (void)setLineView
{
    //设置列分割线
    for (int i=1; i < 4; i++)
    {
        UILabel *columnLab = [[UILabel alloc] initWithFrame:CGRectMake(self.unitBtn.frame.size.width*i, 0, 0.4, self.rowHeight)];
        columnLab.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:columnLab];
        [self bringSubviewToFront:columnLab];
    }
    //设置行分割线
    for (int i=0; i<self.buttonArr.count/4+1; i++)
    {
        UILabel *rowLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.unitBtn.frame.size.height*(i+1), WIDTH, 0.4)];
        rowLab.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:rowLab];
        [self bringSubviewToFront:rowLab];
    }
    
}
//点击button事件
- (void)press:(UIButton *)btn
{
    //使用block传值将点击的位置返回给controller
    self.clickButton(btn.tag);
}
//长按button事件
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    self.currentBtn = (UIButton *)longPress.view;
    CGPoint location = [longPress locationInView:self];
    
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        self.beganPoint = location;
        self.currentBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.currentBtn.backgroundColor = [UIColor grayColor];
        
        [self bringSubviewToFront:self.currentBtn];
        
        long index = [self.buttonArr indexOfObject:longPress.view];
        [self.buttonArr removeObject:self.currentBtn];
        [self.buttonArr insertObject:self.emptyBtn atIndex:index];
    }
    else if (longPress.state == UIGestureRecognizerStateEnded)
    {
        long index = [self.buttonArr indexOfObject:self.emptyBtn];
        
        [self.buttonArr removeObject:self.emptyBtn];
        [self.buttonArr insertObject:self.currentBtn atIndex:index];
        self.currentBtn.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.4 animations:^{
            
            [self setNewView];
        } completion:^(BOOL finished) {
            
            self.currentBtn.backgroundColor = [UIColor whiteColor];
            [self sendSubviewToBack:self.currentBtn];
        }];
    }
    //计算相对位移
    CGRect currentRcet = self.currentBtn.frame;
    currentRcet.origin.x += location.x - self.beganPoint.x;
    currentRcet.origin.y += location.y - self.beganPoint.y;
    self.currentBtn.frame = currentRcet;
    self.beganPoint = location;
    
    __weak typeof(self)weakSelf = self;
    [self.buttonArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (btn.tag == weakSelf.dataArr.count - 1)
        {
            return;
        }
        if (CGRectContainsPoint(btn.frame, location) && btn != longPress.view)
        {
            
            [weakSelf.buttonArr removeObject:weakSelf.emptyBtn];
            [weakSelf.buttonArr insertObject:weakSelf.emptyBtn atIndex:idx];
            
            *stop = YES;
            
            [UIView animateWithDuration:0.5 animations:^{
                //重新设置单元位置
                [weakSelf setNewView];
            }];
        }
    }];
}

@end
