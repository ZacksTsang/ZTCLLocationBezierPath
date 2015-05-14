//
//  TravelMapController.m
//  TravelMap
//
//  Created by Zacks Tsang  on 14-2-10.
//  Copyright (c) 2014年 www.aiysea.com. All rights reserved.
//

#import "TravelMapController.h"
#import "PVAttractionAnnotation.h"
#import "PVAttractionAnnotationView.h"

#import "ZTBezierPathHelper.h"

#define Angle 180

@interface TravelMapController (){
    
    MKMapView *map;
    NSInteger pointsCount;
    MKPolyline *polyline;
    NSTimer *time;
    
    CLLocationCoordinate2D startLocation;
    CLLocationCoordinate2D endLocation;
    
    
    int stepCount;
    
    NSMutableArray *locations;
    
    NSMutableArray *bezierPaths;
}

@end

@implementation TravelMapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
    
    map=[[MKMapView alloc] initWithFrame:CGRectZero];
    map.frame=self.view.frame;
    map.mapType=MKMapTypeStandard;
    map.delegate=self;
    [self.view addSubview:map];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    locations = [NSMutableArray arrayWithObjects:[[CLLocation alloc] initWithLatitude:20.02556 longitude:119.0154],[[CLLocation alloc] initWithLatitude:22.72556 longitude:113.5154],[[CLLocation alloc] initWithLatitude:23.02556 longitude:113.5154],[[CLLocation alloc] initWithLatitude:12.254 longitude:110.0154], nil];
    
    pointsCount = 0;
    
    startLocation = CLLocationCoordinate2DMake(20.02556, 119.0154);
    endLocation= CLLocationCoordinate2DMake(22.72556, 113.5154);
   
    
    bezierPaths=[ZTBezierPathHelper bezierPath:startLocation targetPoint:endLocation clockwise:(stepCount%2==0?YES:NO) ];
    
    
    map.region = MKCoordinateRegionMakeWithDistance(startLocation, 1609.344f * 30, 1609.344f * 30);
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
         time=[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(addLocation) userInfo:nil repeats:YES];;
        
        
    });

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addLocation{
    pointsCount++;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    
    for(int i = 0; i < pointsCount; i++) {
        
        pointsToUse[i] = ((CLLocation *)[bezierPaths objectAtIndex:i]).coordinate;
    }
    
    
    polyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pointsToUse[pointsCount-1], 1609.344f * 10, 1609.344f * 10);
    
    region.span=MKCoordinateSpanMake(fabs(startLocation.latitude-endLocation.latitude), fabs(startLocation.longitude-endLocation.longitude));
    map.region=region;
    
    [map addOverlay:polyline];

    if (pointsCount>[bezierPaths count]-1) {
        [time invalidate];
        
        pointsCount=0;
        
        if (stepCount<[locations count]-2) {
            
            stepCount++;
            
            CLLocation *loc1=(CLLocation *)[locations objectAtIndex:stepCount];
            CLLocation *loc2=(CLLocation *)[locations objectAtIndex:stepCount+1];
            
            startLocation = loc1.coordinate;
            endLocation= loc2.coordinate;
            
            bezierPaths=[ZTBezierPathHelper bezierPath:startLocation targetPoint:endLocation clockwise:(stepCount%2==0?YES:NO) ];
            
            time=[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(addLocation) userInfo:nil repeats:YES];
            
        }
        
    }
}


#pragma mark - MKMapViewDelegate
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor greenColor];
        lineView.lineWidth=1;
        
        return lineView;
    }
    
    return nil;
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    PVAttractionAnnotationView *annotationView = [[PVAttractionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Attraction"];
    annotationView.canShowCallout = YES;
    return annotationView;
}


@end
