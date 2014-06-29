//
//  JFMapAnnotation.h
//  TrackFlu
//
//  Created by hua zhang on 5/6/14.
//  Copyright (c) 2014 WSUV. All rights reserved.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JFMapAnnotation : NSObject <MKAnnotation>{
    
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
