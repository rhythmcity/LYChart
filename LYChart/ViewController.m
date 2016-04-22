//
//  ViewController.m
//  LYChart
//
//  Created by 李言 on 16/4/22.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "ViewController.h"
#import "LYChartView.h"
@interface ViewController ()
{
    LYChartView *chartView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    chartView = [[LYChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    chartView.xAxisArray = @[@2001,@2002,@2003,@2004,@2005,@2006,@2007];
    
    chartView.yAxisArray = @[@10,@20,@30,@40,@50,@60,@70,@80];
    
    chartView.pointArray = @[@14,@35,@24,@30,@44,@67,@20];
    
    
    chartView.lineColor = [UIColor redColor];
    chartView.lineWidth = 2;
    [self.view addSubview:chartView];
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundColor:[UIColor redColor]];
//    
//    button.frame = CGRectMake(100, CGRectGetMaxY(chartView.frame)+10, 100, 100);
//    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];

}


//- (void)btnClick:(UIButton *)sender{
//
//    [chartView setNeedsLayout];
//}
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator  {
//
//    chartView.frame = self.view.bounds;
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
