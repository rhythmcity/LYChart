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
@property (nonatomic, assign) BOOL smoothCurvse;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    chartView = [[LYChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height )];
    chartView.animation = YES;
    chartView.showMask= YES;
    chartView.smoothCurve = YES;

    chartView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    chartView.xAxisArray =
    
    NSMutableArray *xArray = [NSMutableArray array];
    for (int i = 1; i<11; i++) {
        if (i == 1 || i == 10) {
              [xArray addObject:[NSString stringWithFormat:@"%d",i] ];
        } else {
             [xArray addObject:[NSString stringWithFormat:@""]];
            
        }
      
    }
    chartView.xAxisArray = [xArray copy];
  
//  @[@"1",@"2",@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@201,@2002,@2003,@2004,@2005,@2006,@2007,@2008,@2009,@2010,@2011,@2012,@2013,@2014,@2015,@2016,@2017];
    
    chartView.yAxisArray = @[@10,@20,@30,@40,@50,@60,@70,@80];
    
    chartView.pointArray = @[@10,@60,@30,@40,@20,@37,@9,@69,@55,@70];
    
    
    chartView.lineColor = [UIColor redColor];
    chartView.lineWidth = 2;
    [self.view addSubview:chartView];
    
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[chartView]-|" options:0 metrics:nil views:@{@"chartView" : chartView}]];
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[chartView]-|" options:0 metrics:nil views:@{@"chartView" : chartView}]];
    
    
    
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
