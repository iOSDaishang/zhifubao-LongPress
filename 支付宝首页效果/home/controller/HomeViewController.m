//
//  HomeViewController.m
//  支付宝首页效果
//
//  Created by Dai on 16/4/7.
//  Copyright © 2016年 daishang. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeModel.h"
#import "ClickViewController.h"
#import "HomeScrollView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HomeViewController ()<HomeScrollViewDelegate>

/**
 *  存储数据的数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:14/255.0 green:168/255.0 blue:225/255.0 alpha:1.0];
    self.navigationItem.title = @"长按拖拽效果";
    //去除导航栏边线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.dataArr = [[NSMutableArray alloc] init];
    //设置数据
    [self setData];
    //创建视图
    [self createScrollView];
}
//模拟数据
- (void)setData
{
    NSArray *titleArr = @[@"淘宝",@"生活缴费",@"教育缴费",@"红包",@"物流",@"信用卡",@"转账",@"爱心捐赠",@"彩票",@"当面付",@"余额宝",@"AA付款",@"国际汇款",@"淘点点",@"淘宝电影",@"亲密付",@"故事行情",@"汇率换算",@"天猫",@"借贷宝",@"校园一卡通"];
    
    for (int i = 0; i < 21; i++)
    {
        HomeModel *model = [[HomeModel alloc] init];
        NSString *imageName = nil;
        if (i<10)
        {
            imageName = [NSString stringWithFormat:@"i0%d",i];
        }
        else
        {
            imageName = [NSString stringWithFormat:@"i%d",i];
        }
        model.imageName = imageName;
        model.titleStr  = titleArr[i];
        [self.dataArr addObject:model];
    }
    HomeModel *model = [[HomeModel alloc] init];
    model.imageName  = @"tf_home_more";
    model.titleStr   = nil;
    [self.dataArr addObject:model];
}
//创建scrollView
- (void)createScrollView
{
    HomeScrollView *homeScroll = [[HomeScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-65) andWith:self.dataArr];
    
    [self.view addSubview:homeScroll];
    //通过Block返回的值确定跳转界面
    homeScroll.clickButton = ^(NSInteger index)
    {
        ClickViewController *clickVC = [[ClickViewController alloc] init];
        clickVC.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        [self.navigationController pushViewController:clickVC animated:YES];
    };
}

@end
