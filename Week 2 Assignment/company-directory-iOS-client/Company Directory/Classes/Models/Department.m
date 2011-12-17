//
//  Department.m
//  Company Directory
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 Gowalla. All rights reserved.
//

#import "Department.h"
#import "Employee.h"

#import "AFJSONRequestOperation.h"

@implementation Department
@synthesize name = _name;
@synthesize employees = _employees;

- (void)dealloc {
    [_name release];
    [_employees release];
    [super dealloc];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = [attributes valueForKey:@"name"];
    
    NSMutableSet *mutableEmployees = [NSMutableSet set];
    for (NSDictionary *employeeAttributes in [attributes valueForKey:@"employees"]) {
        Employee *employee = [[[Employee alloc] initWithAttributes:employeeAttributes] autorelease];
        [mutableEmployees addObject:employee];
    }
    self.employees = mutableEmployees;
    
    return self;
}

- (void)setEmployees:(NSSet *)employees {
    [self willChangeValueForKey:@"employees"];
    [employees retain];
    [_employees release];
    _employees = employees;
    [self didChangeValueForKey:@"employees"];
    
    for (Employee *employee in self.employees) {
        employee.department = self;
    }
}

+ (void)departmentsWithBlock:(void (^)(NSArray *departments))block {
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/departments.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *mutableDepartments = [NSMutableArray array];
        for (NSDictionary *attributes in JSON) {
            Department *department = [[[Department alloc] initWithAttributes:attributes] autorelease];
            [mutableDepartments addObject:department];
        }
        
        if (block) {
            block(mutableDepartments);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }] start];
}


@end
