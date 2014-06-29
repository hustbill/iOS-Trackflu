//
//  LineChartViewController.m
//  TrackFlu
//
//  Created by hua zhang on 5/6/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "LineChartViewController.h"
#import "LineChartView.h"


@interface LineChartViewController ()

@end

@implementation LineChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Override point for customization after application launch.
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//Load the lineChart view,  set it as *the* view of this view controller
-(void)loadView{
   
    LineChartView *lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(100, 200, 300, 300)];
    
    
    NSMutableArray *pointArray = [[NSMutableArray alloc]init];    
    //Generate random points
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(50*0, 20)]];
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(50*1, 40)]];
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(50*2, 70)]];
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(50*3, 30)]];
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(50*4, 20)]];
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(50*5, 55)]];
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(50*6, 80)]];
    
    //Vertical axis
    NSMutableArray *vArr = [[NSMutableArray alloc]initWithCapacity:pointArray.count-1];
    for (int i=0; i<9; i++) {
        [vArr addObject:[NSString stringWithFormat:@"%d",i*10]];
    }
    
    //Horizontal axis
    NSMutableArray *hArr = [[NSMutableArray alloc]initWithCapacity:pointArray.count-1];
    
    [hArr addObject:@"05-6"];
    [hArr addObject:@"05-7"];
    [hArr addObject:@"05-8"];
    [hArr addObject:@"05-9"];
    [hArr addObject:@"05-10"];
    [hArr addObject:@"05-11"];
    
    [lineChartView setHDesc:hArr];
    [lineChartView setVDesc:vArr];
    [lineChartView setArray:pointArray];
    
    //set it as *the* view of this view controller
    self.view = lineChartView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
