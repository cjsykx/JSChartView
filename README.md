# JSChartView
利用类似TableView中DataSource数据源方法来高效绘制一张折线图。

主要使用dataSource方法为JSChartView.h中的


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

简书有介绍：http://www.jianshu.com/p/72476a813d74