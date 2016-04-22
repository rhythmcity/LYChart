//
//  LYChartView.m
//  LYChart
//
//  Created by 李言 on 16/4/22.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "LYChartView.h"
#import "PotView.h"

static CGFloat  const YAxisLeftDistant      = 30;
static CGFloat  const XAxisBottomDistant    = 20;
static CGFloat  const YAxisRightDistant     = 10;
static CGFloat  const XAxisTopDistant       = 10;
static CGFloat  const XAxisLineWidth        = 1;
static CGFloat  const yAxisLineWidth        = 1;

@interface LYChartView ()
@property (nonatomic, strong)CAShapeLayer *lineLayer;
@property (nonatomic, strong)UIBezierPath *lineBezierPath;
@property (nonatomic, assign)CGFloat    maxYValue;
@property (nonatomic, strong)CAGradientLayer *gradientLayer;
@property (nonatomic, strong)CAGradientLayer *fillGradientLayer;
@property (nonatomic, strong)CAShapeLayer    *fillShapeLayer;

@end
@implementation LYChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.lineLayer = [CAShapeLayer layer];
         self.lineLayer.fillColor = [UIColor clearColor].CGColor;
        self.xAxisLineColor = [UIColor lightGrayColor];
        self.yAxisLineColor = [UIColor lightGrayColor];
        [self.layer addSublayer:self.fillGradientLayer];
        self.fillGradientLayer.opacity = 0;
        [self.layer addSublayer:self.lineLayer];
        [self.layer addSublayer:self.gradientLayer];
        
//        [self.layer addSublayer:self.fillGradientLayer];
//        [self.layer addSublayer:self.fillShapeLayer];
    }
    
    return self;
}




- (CAGradientLayer *)fillGradientLayer {
    if (!_fillGradientLayer) {
        
        _fillGradientLayer = [CAGradientLayer layer];
        _fillGradientLayer.frame = self.bounds;
        _fillGradientLayer.colors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor clearColor].CGColor];
        _fillGradientLayer.locations = @[@0.6];
        
    }
    return _fillGradientLayer;


}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[UIColor greenColor].CGColor,(id)[UIColor redColor].CGColor];
        _gradientLayer.locations = @[@0.4];
        
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
    }

    return _gradientLayer;

}

- (CAShapeLayer *)fillShapeLayer {
    if (!_fillShapeLayer) {
        
        _fillShapeLayer = [CAShapeLayer layer];
        
        
    }
    
    return _fillShapeLayer;

}

- (void)layoutSubviews {
    
    [super layoutSubviews];


    

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.fillGradientLayer.opacity = 1;

}


- (CAAnimation *)creatAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 2;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    return animation;
}

- (void)setYAxisArray:(NSArray *)yAxisArray {
    _yAxisArray = yAxisArray;
    
    
  NSArray *array =  [_yAxisArray sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      
       return   [obj1 integerValue] > [obj2 integerValue];
      
   }];
    self.maxYValue = [[array lastObject] integerValue];
    [self setNeedsDisplay];
}

- (void)setXAxisArray:(NSArray *)xAxisArray {
    _xAxisArray = xAxisArray;
    [self setNeedsDisplay];
    
}
- (void)menu {


}




- (void)potViewGes:(UITapGestureRecognizer *)tap {

    PotView *pot = (PotView *)tap.view;
    [pot becomeFirstResponder];
    
    UIMenuController *menu  =  [UIMenuController sharedMenuController];
    
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld",pot.point] action:@selector(menu)];
    menu.menuItems = [NSArray arrayWithObjects:item, nil];
    [menu setTargetRect:pot.frame inView:pot.superview];
    menu.arrowDirection = UIMenuControllerArrowDefault;
    
    
    [menu setMenuVisible:YES animated:YES];
    

}

- (void)setPointArray:(NSArray *)pointArray {
    _pointArray = pointArray;
    
    [self setNeedsDisplay];
     [self drawLine];
    
   
}

- (void)setLineWidth:(CGFloat)lineWidth {

    _lineWidth = lineWidth;
    self.lineLayer.lineWidth = _lineWidth;

}
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.lineLayer.strokeColor = _lineColor.CGColor;

}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    
}

- (void)setXAxisLineColor:(UIColor *)xAxisLineColor {
    _xAxisLineColor = xAxisLineColor;
    [self setNeedsDisplay];
}

- (void)setYAxisLineColor:(UIColor *)yAxisLineColor {
    _yAxisLineColor = yAxisLineColor;
    [self setNeedsDisplay];
}

- (void)drawXAxis:(CGContextRef)context {
    
    
    CGContextSetLineWidth(context, XAxisLineWidth);
    
    [self.xAxisLineColor set];
    
    CGContextMoveToPoint(context, YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant);
    CGContextAddLineToPoint(context, self.bounds.size.width- YAxisRightDistant , self.bounds.size.height - XAxisBottomDistant);
    CGContextStrokePath(context);

    CGFloat xcolum = (self.bounds.size.width - YAxisLeftDistant - YAxisRightDistant)/self.xAxisArray.count;
    
    CGFloat statX = YAxisLeftDistant;
    
    for (NSNumber *number in self.xAxisArray) {
        [self.xAxisLineColor set];
        CGContextMoveToPoint(context, statX + xcolum , self.bounds.size.height - XAxisBottomDistant);
        CGContextAddLineToPoint(context, statX+xcolum, XAxisTopDistant);
        CGContextStrokePath(context);
       
        
        NSString *text = [NSString stringWithFormat:@"%ld",number.integerValue];
        [text drawAtPoint:CGPointMake(statX + xcolum-20 , self.bounds.size.height - XAxisBottomDistant +1) withAttributes:nil];
        statX  = statX +xcolum;
    }
}

- (void)drawYAxis:(CGContextRef)context {
    
    
    CGContextSetLineWidth(context, yAxisLineWidth);
    
    [self.yAxisLineColor set];
    
    CGContextMoveToPoint(context, YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant);
    CGContextAddLineToPoint(context, YAxisLeftDistant, XAxisTopDistant);
    CGContextStrokePath(context);
    
    CGFloat ycolum = (self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant)/self.yAxisArray.count;
    
    CGFloat statY = self.bounds.size.height - XAxisBottomDistant;


    for (NSNumber *number in self.yAxisArray) {
        [self.yAxisLineColor set];
        CGContextMoveToPoint(context,  YAxisLeftDistant , statY - ycolum);
        CGContextAddLineToPoint(context, self.bounds.size.width - YAxisRightDistant, statY - ycolum);
        CGContextStrokePath(context);

        NSString *text = [NSString stringWithFormat:@"%ld",number.integerValue];
        [text drawAtPoint:CGPointMake(YAxisLeftDistant - [text sizeWithAttributes:nil].width-1,   statY - ycolum +1) withAttributes:nil];
        statY  = statY - ycolum;
    }


}


- (void)drawLine {
    self.lineBezierPath = [UIBezierPath bezierPath];
    
    
    [self.lineBezierPath moveToPoint:CGPointMake(YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant)];
    CGFloat xcolum = (self.bounds.size.width - YAxisLeftDistant - YAxisRightDistant)/self.xAxisArray.count;
    for (int i = 0; i < self.pointArray.count; i++) {
        NSInteger number  =[self.pointArray[i] integerValue];
        [self.lineBezierPath addLineToPoint:CGPointMake((i+1) *xcolum + YAxisLeftDistant , (1 - number/self.maxYValue) *(self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant) + XAxisTopDistant)];
        @autoreleasepool {
            PotView *pot = [[PotView alloc] init];
            pot.frame = CGRectMake(0, 0, 10, 10);
            pot.layer.cornerRadius = 5;
            pot.point = number;
            pot.center = CGPointMake((i+1) *xcolum + YAxisLeftDistant , (1 - number/self.maxYValue) *(self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant) + XAxisTopDistant);
            pot.backgroundColor = [UIColor greenColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(potViewGes:)];
            [pot addGestureRecognizer:tap];
            [self addSubview:pot];
            
        }
        
        
    }
    
    self.lineLayer.path = self.lineBezierPath.CGPath;
    self.lineLayer.strokeStart = 0 ;
    self.lineLayer.strokeEnd = 0;
    
    self.gradientLayer.mask = self.lineLayer;
    [self.lineLayer addAnimation:[self creatAnimation] forKey:@"path"];
    
    UIBezierPath *fillPath = [self.lineBezierPath copy];
    
    [fillPath addLineToPoint:CGPointMake(self.pointArray.count*xcolum + YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant )];
    
    self.fillShapeLayer.path = fillPath.CGPath;
    
    self.fillGradientLayer.mask = self.fillShapeLayer;

}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawXAxis:context];
    [self drawYAxis:context];
   
    

    

}


@end
