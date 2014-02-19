//
//  ZTLocationHelper.h
//  TravelMap
//
//  Created by Zacks Tsang  on 14-2-11.
//  Copyright (c) 2014年 www.aiysea.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZTBezierPathHelper : NSObject


+(NSMutableArray *)bezierPath:(CLLocationCoordinate2D)p1 targetPoint:(CLLocationCoordinate2D)p2 clockwise:(BOOL)isClockWise;


@end
