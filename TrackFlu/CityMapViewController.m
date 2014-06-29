//
//  CityMapViewController.m
//  TrackFlu
//
//  Created by hua zhang on 5/6/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "CityMapViewController.h"

#import "AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "AFHTTPSessionManager.h"

static NSString * const BaseURLString = @"https://bend.encs.vancouver.wsu.edu/~billyzhang/trackflu/";


@interface MyPlace : NSObject  <MKAnnotation>
@property (assign, nonatomic)CLLocationCoordinate2D coordinate;
@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coord;

@end

@implementation MyPlace

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    self = [super self];
    if (self) {
        _coordinate = coord;
        _title = @"title";
        _subtitle = @"subtitle";
        
    }
    return self;
}

@end


@interface CityMapViewController ()

@end

@implementation CityMapViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CLLocationCoordinate2D fluArea ;
    fluArea.latitude = 37.879825;
    fluArea.longitude = -122.287130;

    
    MKCoordinateRegion region;
    region.center = fluArea;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    
    self.mapView.region = region;
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    MyPlace *myFluArea = [[MyPlace alloc] initWithCoordinate:fluArea];
    myFluArea.title = @"BERKELEY's flu area";
    myFluArea.subtitle =@"ALAMEDA county";
    [self.mapView addAnnotation:myFluArea];

    [self addGestureRecogniserToMapView];
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
/*
 Add a Gesture Recogniser that determines when the user has pressed the map for more than 0.5 seconds
 When that action is detected, call a function to add a pin at that location
 */
- (void)addGestureRecogniserToMapView{
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5; //
    [self.mapView addGestureRecognizer:lpgr];
    
}

/*
 Called from LongPress Gesture Recogniser, convert Screen X+Y to Longitude and Latitude then add a standard Pin at that Location.
 The pin has its Title and SubTitle set to Placeholder text, you can modify this as you wish, a good idea would be to run a Geocoding block and put the street address in the SubTitle.
 */
- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    JFMapAnnotation *toAdd = [[JFMapAnnotation alloc]init];
    
    toAdd.coordinate = touchMapCoordinate;
    toAdd.subtitle = @"Subtitle";
    toAdd.title = @"Title";
    
    [self.mapView addAnnotation:toAdd];
    
}

/*
 On the background thread, retrieve the Array of Annotations from the JSON from the next function.
 On the main thread, add the annotations to the map.
 */
- (IBAction)addCitiesToMap:(id)sender{
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    // 1
    NSString *string = [NSString stringWithFormat:@"%@trackflu.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        /*
         Convert raw JSON to Objective-C Foundation Objects
         Iterate over each returned object and create a JFMapAnnotationObject from it
         Add each new Annotation to an Array and then return it.
         */
        NSArray *json  = (NSArray *)responseObject;
        self.title = @"Flu Map";
        for (JFMapAnnotation *record in json) {
            
            JFMapAnnotation *temp = [[JFMapAnnotation alloc]init];
            [temp setTitle:[record valueForKey:@"City"]];
            [temp setSubtitle:[record valueForKey:@"County"]];
            [temp setCoordinate:CLLocationCoordinate2DMake([[record valueForKey:@"Latitude"]floatValue], [[record valueForKey:@"Longitude"]floatValue])];
            [retval addObject:temp];
            
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.mapView addAnnotations:retval];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}


@end
