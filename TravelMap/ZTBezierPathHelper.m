//
//  ZTLocationHelper.m
//  TravelMap
//
//  Created by Zacks Tsang  on 14-2-11.
//  Copyright (c) 2014年 www.aiysea.com. All rights reserved.
//

#import "ZTBezierPathHelper.h"

//angle of the auxiliaty point between start point and end point
#define ANGEL_OF_AUXILIARY_POINT 30

@implementation ZTBezierPathHelper



/**
 * p1 -> 起始点 CLLocationCoordinate2D
 *
 * p2 -> 结束点 CLLocationCoordinate2D
 *
 * isClockWise -> 是否顺时针方向 YES NO
 */
+(NSMutableArray *)bezierPath:(CLLocationCoordinate2D)p1 targetPoint:(CLLocationCoordinate2D)p2 clockwise:(BOOL)isClockWise{
    
    
    //get the auxiliary point
    CLLocationCoordinate2D auxiliaryPoint = [self fetchThirdPointByLocations:p1 withEndLocation:p2 withAngle:ANGEL_OF_AUXILIARY_POINT clockwise:isClockWise];
    
    float bezier1x;
    float bezier1y;
    float bezier2x;
    float bezier2y;
    
    NSMutableArray *targetPoints=[NSMutableArray arrayWithCapacity:3];
    
    float bezier_x,bezier_y;
    
    float t = 0;
    //t between 0.01 and 1
    while ( [targetPoints count]<=100 ) {
        
        //get the start point of a Bezier curve
        bezier1x = p1.longitude + ( auxiliaryPoint.longitude - p1.longitude ) * t;
        bezier1y = p1.latitude + ( auxiliaryPoint.latitude - p1.latitude ) * t;
        
        //get the end point of a Bezier curve
        bezier2x = auxiliaryPoint.longitude + ( p2.longitude - auxiliaryPoint.longitude ) * t;
        bezier2y = auxiliaryPoint.latitude + ( p2.latitude - auxiliaryPoint.latitude ) * t;
        
        //get the point of quadratic Bezier curve
        bezier_x = bezier1x + ( bezier2x - bezier1x ) * t;
        bezier_y  = bezier1y + ( bezier2y - bezier1y ) * t;
        
        CLLocation *bezierPoint=[[CLLocation alloc] initWithLatitude:bezier_y longitude:bezier_x];
        [targetPoints addObject:bezierPoint];
        
        t += 0.01f;
        
    }
    
    return targetPoints;
}


+(CLLocationCoordinate2D)fetchThirdPointByLocations:(CLLocationCoordinate2D)startLoc withEndLocation:(CLLocationCoordinate2D)endLoc withAngle:(float)angle  clockwise:(BOOL)isClockWise{
    
    CLLocationCoordinate2D target;
    
    //angle between the two points
    double btpAngle=0.0;

    btpAngle=atan2(fabs(startLoc.latitude-endLoc.latitude) , fabs(startLoc.longitude-endLoc.longitude))*180/M_PI;
    
    
    //center point
    CLLocationCoordinate2D center=CLLocationCoordinate2DMake((startLoc.latitude+endLoc.latitude)/2.0, (startLoc.longitude+endLoc.longitude)/2.0);
    
    //distance between the two points
    double distance=sqrtf((startLoc.latitude-endLoc.latitude)*(startLoc.latitude-endLoc.latitude)+(startLoc.longitude-endLoc.longitude)*(startLoc.longitude-endLoc.longitude));
    
    
    //distance taget point between and center point
    double adis=(distance/2.0)*tan(angle*M_PI/180);
    
    
    //target distance  longt and lat
    double longt=adis*cosf((90-btpAngle)*M_PI/180);
    
    double lat=adis*sinf((90-btpAngle)*M_PI/180);
    
    
    if (startLoc.longitude>endLoc.longitude) {
        isClockWise=!isClockWise;
    }
    
    //to get the right side of target
    if (isClockWise) {
        
        target.latitude=center.latitude+lat;
        target.longitude=center.longitude+longt;
    }else{
        
        target.latitude=center.latitude-lat;
        target.longitude=center.longitude-longt;
    }
    
    //avoid the target out of the map
    if (target.latitude>90) {
        target.latitude=90.0f;
    }else if (target.latitude<-90){
        target.latitude=-90.0f;
    }
    
    if (target.longitude>180) {
        target.longitude=target.longitude-360.0;
    }else if (target.longitude<-180){
        target.longitude=360.0f+target.longitude;
    }
    
    return target;
    
}


@end
