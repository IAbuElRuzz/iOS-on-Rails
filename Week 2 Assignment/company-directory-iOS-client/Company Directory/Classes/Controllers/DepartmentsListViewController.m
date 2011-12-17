//
//  EmployeeListViewController.m
//  Company Directory
//
//  Created by Mattt Thompson on 11/12/05.
//  Copyright (c) 2011年 CabForward. All rights reserved.
//

#import "DepartmentsListViewController.h"
#import "EmployeeViewController.h"
#import "NewEmployeeViewController.h"

#import "Department.h"
#import "Employee.h"

@implementation DepartmentsListViewController
@synthesize departments = _departments;
@synthesize employeesKeyedByDepartment = _employeesKeyedByDepartment;

- (void)dealloc {
    [_departments release];
    [_employeesKeyedByDepartment release];
    [super dealloc];
}

- (void)setDepartments:(NSArray *)departments {
    [self willChangeValueForKey:@"departments"];
    [_departments autorelease];
    _departments = [departments retain];
    [self didChangeValueForKey:@"departments"];
    
    NSMutableDictionary *mutableKeyedEmployees = [NSMutableDictionary dictionary];
    for (Department *department in self.departments) {
        [mutableKeyedEmployees setObject:[department.employees allObjects] forKey:department.name];
    }
    self.employeesKeyedByDepartment = mutableKeyedEmployees;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Company Directory", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEmployee:)];
    
    [Department departmentsWithBlock:^(NSArray *departments) {
        self.departments = departments;
        [self.tableView reloadData];
    }];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.tableView indexPathForSelectedRow]) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

#pragma mark - Actions

- (void)addEmployee:(id)sender {
    NewEmployeeViewController *viewController = [[[NewEmployeeViewController alloc] initWithNibName:@"NewEmployeeViewController" bundle:nil] autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    [self.navigationController presentModalViewController:navigationController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.departments count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Department *department = [self.departments objectAtIndex:section];
    return [[self.employeesKeyedByDepartment objectForKey:department.name] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Department *department = [self.departments objectAtIndex:indexPath.section];
    Employee *employee = [[self.employeesKeyedByDepartment objectForKey:department.name] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = employee.name;
    cell.detailTextLabel.text = employee.jobTitle;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Department *department = [self.departments objectAtIndex:section];
    return department.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Department *department = [self.departments objectAtIndex:indexPath.section];
    Employee *employee = [[self.employeesKeyedByDepartment objectForKey:department.name] objectAtIndex:indexPath.row];
    EmployeeViewController *viewController = [[[EmployeeViewController alloc] initWithEmployee:employee] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
