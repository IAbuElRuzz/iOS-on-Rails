//
//  Department.h
//  Company Directory
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 Gowalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Department : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, retain) NSSet *employees;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)departmentsWithBlock:(void (^)(NSArray *departments))block;

@end
