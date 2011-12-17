//
//  Photo.m
//  Saxophoto
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"

@implementation Photo
@synthesize imageURLString = _imageURLString;
@dynamic imageURL;
@synthesize thumbnailImageURLString = _thumbnailImageURLString;
@dynamic thumbnailImageURL;
@synthesize timestamp = _timestamp;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.imageURLString = [attributes valueForKeyPath:@"image_urls.original"];
    self.thumbnailImageURLString = [attributes valueForKeyPath:@"image_urls.thumbnail"];
    
    self.timestamp = [attributes valueForKey:@"timestamp"];
    
    return self;
}

- (NSURL *)imageURL {
    return [NSURL URLWithString:self.imageURLString];
}

- (NSURL *)thumbnailImageURL {
    return [NSURL URLWithString:self.thumbnailImageURLString];
}

@end
