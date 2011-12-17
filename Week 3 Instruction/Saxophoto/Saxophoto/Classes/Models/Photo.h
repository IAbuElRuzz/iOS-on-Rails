//
//  Photo.h
//  Saxophoto
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, copy) NSString *imageURLString;
@property (readonly) NSURL *imageURL;

@property (nonatomic, copy) NSString *timestamp;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
