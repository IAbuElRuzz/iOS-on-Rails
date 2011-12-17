//
//  EmployeeListViewController.h
//  Company Directory
//
//  Created by Mattt Thompson on 11/12/05.
//  Copyright (c) 2011年 CabForward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentsListViewController : UITableViewController

@property (nonatomic, retain) NSArray *departments;
@property (nonatomic, retain) NSDictionary *employeesKeyedByDepartment;

@end
