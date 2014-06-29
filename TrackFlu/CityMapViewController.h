//
//  CityMapViewController.h
//  TrackFlu
//
//  Created by hua zhang on 5/6/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#include "JFMapAnnotation.h"



/*
adding a pin to the map and batch adding a list of annoations to the map 
 from a file that is saved in the local directory.
 */



@interface CityMapViewController : UIViewController <MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)addCitiesToMap:(id)sender;
- (void)addGestureRecogniserToMapView;
- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer;
- (NSMutableArray *)parseJSONCities;

@end
