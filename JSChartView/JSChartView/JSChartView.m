//
//  JSChartView.m
//  JSChartView
//
//  Created by Cjson on 15/7/30.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "JSChartView.h"
#import "NSString+Extension.h"

#define textFont [UIFont systemFontOfSize:10]
#define textDict   @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue"  size:10]} 

@interface JSChartView ()
/**
 *  是否已经画图
 */
@property (assign,nonatomic,getter=isDraw) BOOL darw;

/**
 *  最大值
 */
@property (assign,nonatomic) CGFloat maxVerticalValue;

/**
 *  水平宽度
 */
@property (assign,nonatomic) CGFloat horizontalItemWidth;
/**
 *  垂直宽度
 */
@property (assign,nonatomic) CGFloat verticalItemHeight;

/**
 *  y值 数组
 */
@property (nonatomic, strong) NSMutableArray *valueItemArray;

/**
 *  垂直文字(y)size
 */
@property (assign,nonatomic) CGSize verticalTextSize;

@property (nonatomic, retain) UIView *descriptionView;
@property (nonatomic, retain) UIView *slideLineView;

@end

@implementation JSChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if(self.isDraw) return;
    
    // 画线
    [self drawValueLine:rect];
    
    // 画x上的值
    [self drawHorizontalTitle:rect];
    
    // 画 边框 和 y上的值
    [self drawRectangleAndVerticalText:rect];

    _darw = YES;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
   self = [super initWithFrame:frame];
    
    if (self ) {

        // 默认线宽
        self.rectanglelineWidth = 1.0f;
        self.lineWidth = 1.0f;
        
        // 默认线颜色
        self.rectangleLineColor = [UIColor redColor];
        self.lineColor = [UIColor redColor];
        
        self.hideDescriptionViewWhenTouchesEnd = NO;
    }
    
    return self;
}

#pragma mark - custom method
/**
 *  draw data line
 */
- (void)drawValueLine:(CGRect)rect{
    
    if (!self.dataSource)  return;
    
    //数量
    if(![self.dataSource respondsToSelector:@selector(numberOfItemCountInchartView:)])
        return;
    
    NSInteger numberOfHorizontalItemCount = [self.dataSource numberOfItemCountInchartView:self];
    
    NSMutableArray *valueItems = [NSMutableArray array];
    
    for (int i = 0; i < numberOfHorizontalItemCount; i++){
        // 算出y值
        float value = [self.dataSource chartView:self valueAtIndex:i];
        
        [valueItems addObject:[NSNumber numberWithFloat:value]];
        
        // 得到最大值
        if (value >= _maxVerticalValue)  _maxVerticalValue = value;
    }
    
    // 返回大于或等于x的最小整数的double值
    _maxVerticalValue = ceilf(_maxVerticalValue);
    
    // 计算出 最大值的size
    _verticalTextSize = [[NSString stringWithFormat:@"%.2f", _maxVerticalValue] sizeWithFont:textFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.valueItemArray = valueItems;
    
    // 水平width
    _horizontalItemWidth = (rect.size.width - _verticalTextSize.width) / (numberOfHorizontalItemCount - 1);
    
    // 垂直width
    _verticalItemHeight = (rect.size.height - _verticalTextSize.height * 2) /  _maxVerticalValue;
    
    for (int i = 0; i < [valueItems count] - 1; i++){
        float value = [(NSNumber *)valueItems[i] floatValue];
        
        // 前一个位置
        CGPoint point = [self valuePoint:value atIndex:i];
        
        float nextValue = [(NSNumber *)valueItems[i + 1] floatValue];
        
        // 下一个位置
        CGPoint nextPoint = [self valuePoint:nextValue atIndex:i + 1];
        
        // 画图
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextMoveToPoint(context, point.x, point.y);
        CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
}

-(void)drawHorizontalTitle:(CGRect)rect{
    
    //draw horizontal title
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAtIndex:)]){
        for (int i = 0; i < [self.valueItemArray count]; i++){
        
            // 得到x轴上要画的值
            NSString *title = [self.dataSource chartView:self horizontalTitleAtIndex:i];
            
            if (title){
                float value = [(NSNumber *)[self.valueItemArray objectAtIndex:i] floatValue];
                
                CGPoint point = [self valuePoint:value atIndex:i];
                
                CGSize size = [title sizeWithFont:textFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                
                // 默认 中间
                HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
                
                if ([self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAlignmentAtIndex:)]){
                    alignment = [self.dataSource chartView:self horizontalTitleAlignmentAtIndex:i];
                }
                
                // 画的位置
                CGPoint darwPoint = CGPointZero;
                
                if (alignment == HorizontalTitleAlignmentLeft){
                    darwPoint = CGPointMake(point.x, rect.size.height - size.height);
                
                }
                else if (alignment == HorizontalTitleAlignmentCenter){
                    
                    darwPoint = CGPointMake(point.x - size.width * 0.5f, rect.size.height - size.height);
                    
                }
                else if (alignment == HorizontalTitleAlignmentRight){
                    darwPoint = CGPointMake(point.x - size.width, rect.size.height - size.height);
                   
                }
                
                
                [title drawAtPoint:darwPoint withAttributes:textDict];
            }
        }
    }

}

/**
 *  draw rectangle
 */
- (void)drawRectangleAndVerticalText:(CGRect)rect{
    rect.origin.x = _verticalTextSize.width;
    rect.origin.y = _verticalTextSize.height;
    rect.size.width -= _verticalTextSize.width;
    rect.size.height -= (_verticalTextSize.height * 2);
    
    // 画边框
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(currentContext, path);
    [[UIColor clearColor] setFill];
    [[UIColor clearColor] setStroke];
    CGContextSetStrokeColorWithColor(currentContext, self.rectangleLineColor.CGColor);
    CGContextSetLineWidth(currentContext, self.rectanglelineWidth);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
    
    //画线
    [self.rectangleLineColor setFill];
    CGContextSetLineWidth(currentContext, self.rectanglelineWidth);
    float itemHeight = rect.size.height / 5;
    for (int i = 1; i <= 5; i++)
    {
        if (i != 5)
        {
            CGContextMoveToPoint(currentContext, rect.origin.x, rect.size.height - itemHeight * i + _verticalTextSize.height);
            CGContextAddLineToPoint(currentContext,
                                    rect.size.width + _verticalTextSize.width,
                                    rect.size.height - itemHeight * i +_verticalTextSize.height);
            CGContextClosePath(currentContext);
            CGContextStrokePath(currentContext);
        }
        
        NSString *text = [NSString stringWithFormat:@"%.2f", (i + 1) * (_maxVerticalValue / 6)];
        
        [text drawAtPoint:CGPointMake(.0f,
                                      rect.size.height - itemHeight * i + _verticalTextSize.height - _verticalTextSize.height * 0.5f)
                 withAttributes:textDict];
        
    }
}
/**
 *  每个点上的位置
 */
- (CGPoint)valuePoint:(float)value atIndex:(int)index
{
    CGPoint retPoint = CGPointZero;
    
    retPoint.x = index * _horizontalItemWidth + _verticalTextSize.width;
    
    retPoint.y = self.frame.size.height - _verticalTextSize.height - value * _verticalItemHeight;
    
    return retPoint;
}

- (void)descriptionViewPointWithTouches:(NSSet *)touches{
    CGSize size = self.frame.size;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    if (location.x >= 0 && location.x <= size.width && location.y >= 0 && location.y <= size.height)
    {
        int intValue = location.x / _horizontalItemWidth ;
        float remainder = location.x - intValue * _horizontalItemWidth;
        
        int index = intValue + (remainder >= _horizontalItemWidth * 0.5f ? 1 : 0)  - 1;
        if (index < self.valueItemArray.count)
        {
            float value = [(NSNumber *)self.valueItemArray[index] floatValue];
            CGPoint point = [self valuePoint:value atIndex:index];
            
            if ([self.dataSource respondsToSelector:@selector(chartView:descriptionViewAtIndex:)])
            {
                UIView *descriptionView = [self.dataSource chartView:self descriptionViewAtIndex:index];
                CGRect frame = descriptionView.frame;
                if (point.x + frame.size.width > size.width){
                    frame.origin.x = point.x - frame.size.width;
                }
                else{
                    frame.origin.x = point.x;
                }
                
                if (frame.size.height + point.y > size.height){
                    frame.origin.y = point.y - frame.size.height;
                }
                else{
                    frame.origin.y = point.y;
                }
                
                descriptionView.frame = frame;
                
                if (self.descriptionView)  [self.descriptionView removeFromSuperview];
                
                if (!self.slideLineView){
                    //slide line view
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(.0f,
                                                                                _verticalTextSize.height,
                                                                                1.0f,
                                                                                self.frame.size.height - _verticalTextSize.height * 2)];
                    lineView.backgroundColor = [UIColor redColor];
                    lineView.hidden = YES;
                    self.slideLineView = lineView;
                    [self addSubview:self.slideLineView];
                }
                
                //draw line
                CGRect slideLineViewFrame = self.slideLineView.frame;
                
                slideLineViewFrame.origin.x = point.x ;
                self.slideLineView.frame = slideLineViewFrame;
                self.slideLineView.hidden = NO;
                
                [self addSubview:descriptionView];
                self.descriptionView = descriptionView;
                
                //delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:didMovedToIndex:)]){
                    [self.delegate chartView:self didMovedToIndex:index];
                }
            }
        }
    }
}


#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.valueItemArray || !self.valueItemArray.count || !self.dataSource) return;
    
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.descriptionView && self.hideDescriptionViewWhenTouchesEnd)   [self.descriptionView removeFromSuperview];
}

@end
