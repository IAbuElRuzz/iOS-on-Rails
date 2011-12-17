//
//  SaxophotoAPIClient.m
//  Saxophoto
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SaxophotoAPIClient.h"

#import "AFJSONRequestOperation.h"

@implementation SaxophotoAPIClient

+ (SaxophotoAPIClient *)sharedClient {
    static SaxophotoAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[[SaxophotoAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:3000"]] autorelease];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
