//
//  Photo.h
//  Saxophoto
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Photo : NSObject <MKAnnotation>

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (readonly) CLLocation *location;

@property (nonatomic, copy) NSString *imageURLString;
@property (readonly) NSURL *imageURL;

@property (nonatomic, copy) NSString *thumbnailImageURLString;
@property (readonly) NSURL *thumbnailImageURL;

@property (nonatomic, copy) NSString *timestamp;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
