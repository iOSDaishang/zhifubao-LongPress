//
//  HomeScrollView.h
//  支付宝首页效果
//
//  Created by Dai on 16/4/7.
//  Copyright © 2016年 daishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeScrollViewDelegate <NSObject>



@end

@interface HomeScrollView : UIScrollView

@property (nonatomic, copy) void (^clickButton)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame andWith:(NSMutableArray *)dataArr;
@end
