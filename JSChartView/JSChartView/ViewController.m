//
//  ViewController.m
//  JSChartView
//
//  Created by Cjson on 15/7/30.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "ViewController.h"
#import "JSChartView.h"

#define ARC4RANDOM_MAX  0x100000000

@interface ViewController ()<JSChartViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *chartView;

@property (strong,nonatomic) JSChartView *jsChartView;


@property (nonatomic, strong) NSArray *values;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray array];
    
    // 30天
    for (int i = 0; i < 30; i++)
    {
        double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f);
        [array addObject:[NSNumber numberWithDouble:val + 1]];
    }
    self.values = array;

    
    [self createChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom method 

/**
 *  加载 图表
 */
-(void)createChartView{
    
    self.jsChartView = [[JSChartView alloc] initWithFrame:self.chartView.bounds];

    self.jsChartView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.jsChartView.rectangleLineColor = [UIColor grayColor];
    self.jsChartView.lineColor = [UIColor blueColor];
    self.jsChartView.dataSource = self;
    
    [self.chartView addSubview:self.jsChartView];

    
}

#pragma mark JSChartView datasource
-(NSInteger)numberOfItemCountInchartView:(JSChartView *)chartView{
    
    return self.values ? self.values.count : 0;

}

-(CGFloat)chartView:(JSChartView *)chartView valueAtIndex:(NSInteger)index{
    
    return [((NSNumber *)self.values[index]) floatValue];

}

- (NSString *)chartView:(JSChartView *)chartView horizontalTitleAtIndex:(NSInteger)index{
    
    return [NSString stringWithFormat:@"%lu",index + 1];
}



- (HorizontalTitleAlignment)chartView:(JSChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index{
    HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
    if (index == 0){
        alignment = HorizontalTitleAlignmentCenter;
    }
    else if (index == self.values.count - 1){
        alignment = HorizontalTitleAlignmentRight;
    }
    
    return alignment;
}

- (UIView *)chartView:(JSChartView *)chartView descriptionViewAtIndex:(NSInteger)index{
    NSString *description = [NSString stringWithFormat:@"日期=%ld\n病例=%.2f", (long)index,
                             [((NSNumber *)self.values[index]) floatValue]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chart_ description_bg"]];
    CGRect frame = imageView.frame;
    frame.size = CGSizeMake(80.0f, 40.0f);
    imageView.frame = frame;
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(.0f, .0f, imageView.frame.size.width, imageView.frame.size.height)];
    label.text = description;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10.0f];
    
    [imageView addSubview:label];
    
    return imageView;
}

@end
