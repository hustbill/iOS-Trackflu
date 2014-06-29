//
//  LineChartView.h
//  TrackFlu
//
//  Created by hua zhang on 5/6/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LineChartView : UIView

@property (assign) NSInteger hInterval;
@property (assign) NSInteger vInterval;

@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;


@property (nonatomic, strong) NSArray *array;


@end
