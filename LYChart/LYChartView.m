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

@interface LYChartView ()<CAAnimationDelegate>
@property (nonatomic, strong)CAShapeLayer *lineLayer;
@property (nonatomic, strong)UIBezierPath *lineBezierPath;
@property (nonatomic, assign)CGFloat    maxYValue;
@property (nonatomic, strong)CAGradientLayer *gradientLayer;
@property (nonatomic, strong)CAGradientLayer *fillGradientLayer;
@property (nonatomic, strong)CAShapeLayer    *fillShapeLayer;
@property (nonatomic, assign) CGRect drawRect;
@property (nonatomic, strong) NSMutableArray *realpointArray;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) PotView *currentPot;

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
        self.fillGradientLayer.hidden = YES;
        [self.layer addSublayer:self.lineLayer];
        [self.layer addSublayer:self.gradientLayer];
        
        
        
//        [self.layer addSublayer:self.fillGradientLayer];
//        [self.layer addSublayer:self.fillShapeLayer];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.drawRect = CGRectMake(YAxisLeftDistant, XAxisTopDistant, self.bounds.size.width -YAxisLeftDistant-YAxisRightDistant  , self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant);

}

- (NSMutableArray *)realpointArray {
    
    if (!_realpointArray) {
        _realpointArray = [NSMutableArray array];
    }
    return _realpointArray;
}


- (CAGradientLayer *)fillGradientLayer {
    if (!_fillGradientLayer) {
        
        _fillGradientLayer = [CAGradientLayer layer];
        _fillGradientLayer.frame = self.bounds;
        _fillGradientLayer.colors = @[(id)[UIColor lightGrayColor].CGColor,(id)[UIColor clearColor].CGColor];
        _fillGradientLayer.locations = @[@0.6];
        
    }
    return _fillGradientLayer;


}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[UIColor greenColor].CGColor,(id)[UIColor greenColor].CGColor];
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


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.showMask) {
        self.fillGradientLayer.hidden = NO;
    } else {
        self.fillGradientLayer.hidden = YES;
    }
   

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
    
    if (self.smoothCurve) {
        [self drawLineCurvese];
        return;
    }
     [self drawLine];
}

- (void)setSmoothCurve:(BOOL)smoothCurve {
    _smoothCurve = smoothCurve;
    
//    [self setNeedsDisplay];
//    if (self.smoothCurve) {
//        [self drawLineCurvese];
//        return;
//    }
//    [self drawLine];
    
}

- (void)setShowMask:(BOOL)showMask {
    _showMask =showMask;
    
    
    
}

- (void)setAnimation:(BOOL)animation {
    _animation = animation;

    
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
    
    CGFloat xcolum = (self.bounds.size.width - YAxisLeftDistant - YAxisRightDistant) / (self.xAxisArray.count -1);
    
    CGFloat statX = YAxisLeftDistant;
    
    for (int i = 0; i< self.xAxisArray.count; i++) {
        NSString *number = self.xAxisArray[i];
        [self.xAxisLineColor set];
        
    
//        CGContextMoveToPoint(context, statX + xcolum *i  , self.bounds.size.height - XAxisBottomDistant);
//        CGContextAddLineToPoint(context, statX+xcolum * i, XAxisTopDistant);
//        CGContextStrokePath(context);
        NSString *text = [NSString stringWithFormat:@"%@",number];
        
       
        [text drawAtPoint:CGPointMake(statX + xcolum *i- [text sizeWithAttributes:nil].width /2 , self.bounds.size.height - XAxisBottomDistant +1) withAttributes:nil];
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
    
    if (!self.lineBezierPath) {
          self.lineBezierPath = [UIBezierPath bezierPath];
    }
    
    [self.lineBezierPath removeAllPoints];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    [self.lineBezierPath moveToPoint:CGPointMake(YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant)];
    CGFloat xcolum = (self.bounds.size.width - YAxisLeftDistant - YAxisRightDistant)/(self.xAxisArray.count - 1) ;
    [self.realpointArray removeAllObjects];
    for (int i = 0; i < self.pointArray.count; i++) {
         NSInteger number  =[self.pointArray[i] integerValue];
        if (i == 0) {
            [self.lineBezierPath moveToPoint:CGPointMake((i) *xcolum + YAxisLeftDistant,  (1 - number/self.maxYValue) *(self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant) + XAxisTopDistant)];
        }
       
        [self.lineBezierPath addLineToPoint:CGPointMake((i) *xcolum + YAxisLeftDistant , (1 - number/self.maxYValue) *(self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant) + XAxisTopDistant)];
        
        @autoreleasepool {
            PotView *pot = [[PotView alloc] init];
            pot.frame = CGRectMake(0, 0, 10, 10);
            pot.layer.cornerRadius = 5;
            pot.point = number;
            pot.center = CGPointMake((i) *xcolum + YAxisLeftDistant , (1 - number/self.maxYValue) *(self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant) + XAxisTopDistant);
            pot.backgroundColor = [UIColor greenColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(potViewGes:)];
            [pot addGestureRecognizer:tap];
            [self addSubview:pot];
            
            [self.realpointArray addObject:pot];
            
        }
        
        
    }
    
    self.lineLayer.path = self.lineBezierPath.CGPath;
    self.lineLayer.strokeStart = 0 ;
    self.lineLayer.strokeEnd = 1;
    
    self.gradientLayer.mask = self.lineLayer;
    
    if (self.animation) {
        self.lineLayer.strokeEnd = 0;
         [self.lineLayer addAnimation:[self creatAnimation] forKey:@"path"];
    } else {
        self.lineLayer.strokeEnd = 1;
    }
   
    
    UIBezierPath *fillPath = [self.lineBezierPath copy];
    
    [fillPath addLineToPoint:CGPointMake((self.pointArray.count - 1)*xcolum + YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant )];
    [fillPath addLineToPoint:CGPointMake(YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant)];
    self.fillShapeLayer.path = fillPath.CGPath;
    
    self.fillGradientLayer.mask = self.fillShapeLayer;

}


- (CGFloat)getVerPoint:(NSNumber *)number {
    
    return  (1 - [number floatValue]/self.maxYValue) *(self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant) + XAxisTopDistant;
}
- (void)drawLineCurvese {
    
    if (!self.lineBezierPath) {
        self.lineBezierPath = [UIBezierPath bezierPath];
    }
    
    [self.lineBezierPath removeAllPoints];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    CGFloat xcolum = (self.bounds.size.width - YAxisLeftDistant - YAxisRightDistant)/(self.xAxisArray.count - 1) ;
    
    NSNumber *startNumber = [self.pointArray firstObject];
    
    CGPoint startPoint = CGPointMake(YAxisLeftDistant, [self getVerPoint:startNumber]);
    [self.lineBezierPath moveToPoint:startPoint];
    for (int i = 0; i < self.pointArray.count - 1; i++) {
    
        CGPoint startPoint = CGPointMake((i) *xcolum + YAxisLeftDistant, [self getVerPoint:self.pointArray[i]]);
        CGPoint endPoint =  CGPointMake((i + 1) *xcolum + YAxisLeftDistant, [self getVerPoint:self.pointArray[i +1]]);
    
        CGPoint controlPoint1 = CGPointMake((endPoint.x - startPoint.x)/2 +startPoint.x, startPoint.y);
        CGPoint controlPoint2 = CGPointMake((endPoint.x - startPoint.x)/2 +startPoint.x, endPoint.y);
        
        [self.lineBezierPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];

    }
    
    [self.realpointArray removeAllObjects];
    
    for (int i = 0; i < self.pointArray.count; i++) {
        
        NSInteger number = [[self.pointArray objectAtIndex:i] integerValue];
        @autoreleasepool {
            PotView *pot = [[PotView alloc] init];
            pot.frame = CGRectMake(0, 0, 10, 10);
            pot.layer.cornerRadius = 5;
            pot.point = number;
            pot.center = CGPointMake((i) *xcolum + YAxisLeftDistant , (1 - number/self.maxYValue) *(self.bounds.size.height - XAxisBottomDistant - XAxisTopDistant) + XAxisTopDistant);
            pot.backgroundColor = [UIColor redColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(potViewGes:)];
            [pot addGestureRecognizer:tap];
            pot.hidden = YES;
            [self addSubview:pot];
            
            
            [self.realpointArray addObject:pot];
            
        }
    }
    
    self.lineLayer.path = self.lineBezierPath.CGPath;
    self.lineLayer.strokeStart = 0 ;
    self.lineLayer.strokeEnd = 1;
    
    self.gradientLayer.mask = self.lineLayer;
    
    if (self.animation) {
        self.lineLayer.strokeEnd = 0;
        [self.lineLayer addAnimation:[self creatAnimation] forKey:@"path"];
    } else {
        self.lineLayer.strokeEnd = 1;
    }
    
    
    UIBezierPath *fillPath = [self.lineBezierPath copy];
    
    [fillPath addLineToPoint:CGPointMake((self.pointArray.count - 1)*xcolum + YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant )];
    [fillPath addLineToPoint:CGPointMake(YAxisLeftDistant, self.bounds.size.height - XAxisBottomDistant)];
    self.fillShapeLayer.path = fillPath.CGPath;
    
    self.fillGradientLayer.mask = self.fillShapeLayer;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  
    [self calucatorPoint:touches];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self calucatorPoint:touches];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    self.showLabel.hidden = YES;
    self.verticalLine.hidden = YES;
    self.currentPot.hidden = YES;
}
- (void)calucatorPoint :(NSSet<UITouch *> *)touches {
    CGPoint location = [[touches anyObject] locationInView:self];
    NSInteger index  = -1;
    if(CGRectContainsPoint(self.drawRect, location)){
        CGFloat value = MAXFLOAT;
        
        for (int i = 0 ; i < self.realpointArray.count; i ++ ) {
            PotView *pot  = self.realpointArray[i];
            if (value >  fabs(pot.center.x - location.x)) {
                value =  fabs(pot.center.x - location.x);
                index = i;
            }
            
        }
        
        
    } else {
        
        if(location.x>=CGRectGetMaxX(self.drawRect)){
            index = self.realpointArray.count -1;
        }else{
            index = 0;
        }
   
        
        
    }
    
    [self drawfingerView:index];
}




- (void)drawfingerView:(NSInteger)index {
    self.currentPot.hidden = YES;
    if (index >= 0) {
        
        if (!self.verticalLine) {
            self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, XAxisTopDistant, 0.5, self.drawRect.size.height)];
            self.verticalLine.backgroundColor = [UIColor yellowColor];
            [self addSubview:self.verticalLine];
        }
        if (!self.showLabel) {
            self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            self.showLabel.backgroundColor = [UIColor blueColor] ;
            self.showLabel.alpha = 0.5;
            [self addSubview:self.showLabel];
        }
        
     
        
        self.showLabel.hidden = NO;
        self.verticalLine.hidden = NO;
        
        PotView *pot = [self.realpointArray objectAtIndex:index];
        pot.hidden = NO;
        self.currentPot = pot;
        
        [self bringSubviewToFront:self.currentPot];
        self.verticalLine.frame = CGRectMake(pot.center.x- 0.25, XAxisTopDistant, 0.5, self.drawRect.size.height);
        self.showLabel.text = [NSString stringWithFormat:@"%ld",pot.point];
        
        if (self.currentPot.center.x > self.drawRect.size.width / 2) {
             self.showLabel.center = CGPointMake(self.verticalLine.center.x -  50, 50);
        } else {
             self.showLabel.center = CGPointMake(self.verticalLine.center.x + 50, 50);
        }
       
        
    }else {
        self.showLabel.hidden = YES;
        self.verticalLine.hidden = YES;
    }
    
    
    
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawXAxis:context];
    [self drawYAxis:context];
}


@end
