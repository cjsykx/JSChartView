//
//  JSChartView.h
//  JSChartView
//
//  Created by Cjson on 15/7/30.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSChartView;
typedef enum HorizontalTitleAlignment{
    
    HorizontalTitleAlignmentLeft = 0,
    HorizontalTitleAlignmentCenter = 1,
    HorizontalTitleAlignmentRight = 2
    
}HorizontalTitleAlignment;


// --------------------- 数据源方法 -------------------------

@protocol JSChartViewDataSource <NSObject>

@required
/**
 *  总用有多少行
 *
 *  @param chartView JSChartView
 *
 *  @return 返回多少行 （x 数量）
 */
-(NSInteger)numberOfItemCountInchartView:(JSChartView *)chartView;

/**
 *
 *
 *  @param chartView JSChartView
 *  @param index     x多少
 *
 *  @return 返回 每一行的值 （y 值）
 */
-(CGFloat)chartView:(JSChartView *)chartView valueAtIndex:(NSInteger )index;

@optional
/**
 *  描述视图
 */
- (UIView *)chartView:(JSChartView *)chartView descriptionViewAtIndex:(NSInteger)index;

/**
 *  x轴上的值
 */
- (NSString *)chartView:(JSChartView *)chartView horizontalTitleAtIndex:(NSInteger)index;

/**
 *  每一行的文字排列位置
 *
 */
- (HorizontalTitleAlignment)chartView:(JSChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index;

@end

// --------------------- 代理方法 -------------------------
@protocol JSChartViewDelegate <NSObject>
@optional
/**
 *   当手指 点击  移动到相应的index上的时候  (暂时不用)
 */
- (void)chartView:(JSChartView *)chartView didMovedToIndex:(NSInteger)index;

@end





@interface JSChartView : UIView

/**
 *  水平的排序
 */
@property (nonatomic,assign) HorizontalTitleAlignment horizontalTitleAlignment;


/**
 *  正方形边框颜色  (默认 黑色)
 */
@property (nonatomic, retain) UIColor *rectangleLineColor;

/**
 *  正方形边框宽度  (默认 1.0f)
 */
@property (nonatomic, assign) float rectanglelineWidth;

/**
 *  画线颜色  (默认 黑色)
 */
@property (nonatomic, retain) UIColor *lineColor;

/**
 *  画线宽度  (默认 1.0f)
 */
@property (nonatomic, assign) float lineWidth;

/**
 *  当手势结束时候 隐藏 描述框
 */
@property (nonatomic, assign) BOOL hideDescriptionViewWhenTouchesEnd;

@property (weak,nonatomic) id<JSChartViewDataSource>dataSource;
@property (weak,nonatomic) id<JSChartViewDelegate>delegate;

@end
