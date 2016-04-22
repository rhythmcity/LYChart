//
//  LYChartView.h
//  LYChart
//
//  Created by 李言 on 16/4/22.
//  Copyright © 2016年 李言. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYChartView : UIView
@property (nonatomic, strong)NSArray *pointArray;
@property (nonatomic, strong)NSArray<NSNumber *> *yAxisArray;
@property (nonatomic, strong)NSArray<NSNumber *> *xAxisArray;
@property (nonatomic, strong)UIColor *xAxisLineColor;
@property (nonatomic, strong)UIColor *yAxisLineColor;
@property (nonatomic, strong)UIColor *lineColor;
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, assign)CGFloat lineWidth;
@end
