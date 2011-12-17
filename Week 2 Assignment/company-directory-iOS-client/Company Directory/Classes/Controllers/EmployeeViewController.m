//
//  EmployeeViewController.m
//  Company Directory
//
//  Created by Mattt Thompson on 11/12/07.
//  Copyright (c) 2011年 Gowalla. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "EmployeeViewController.h"

#import "Employee.h"

#import "UIImageView+AFNetworking.h"

enum {
    NameRowIndex        = 0,
    JobTitleRowIndex    = 1,
    BirthdayRowIndex    = 2,
    SalaryRowIndex      = 3,
} EmployeeViewControllerRowIndexes;

@interface EmployeeViewController ()
@property (readwrite, nonatomic, retain) Employee *employee;

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation EmployeeViewController
@synthesize employee = _employee;

- (id)initWithEmployee:(Employee *)employee {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) {
        return nil;
    }
    
    self.employee = employee;
    
    return self;
}

- (void)dealloc {
    [_employee release];
    [super dealloc];
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 80.0f)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    UIImageView *avatarImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 50.0f, 50.0f)] autorelease];
    [avatarImageView setImageWithURL:[NSURL URLWithString:@"http://localhost:3000/placeholder.gif"]];
    avatarImageView.layer.cornerRadius = 5.0f;
    avatarImageView.layer.masksToBounds = YES;
    [tableHeaderView addSubview:avatarImageView];
    
    UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70.0f, 5.0f, 240.0f, 20.0f)] autorelease];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.text = self.employee.name;
    [tableHeaderView addSubview:nameLabel];
    
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.employee.name;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case NameRowIndex:
            cell.textLabel.text = NSLocalizedString(@"Name", nil);
            cell.detailTextLabel.text = self.employee.name;
            break;
        case JobTitleRowIndex:
            cell.textLabel.text = NSLocalizedString(@"Job Title", nil);
            cell.detailTextLabel.text = self.employee.jobTitle;
            break;
        case BirthdayRowIndex:
            cell.textLabel.text = NSLocalizedString(@"Birthday", nil);
            cell.detailTextLabel.text = [self.employee formattedBirthdayString];
            break;
        case SalaryRowIndex:
            cell.textLabel.text = NSLocalizedString(@"Salary", nil);
            cell.detailTextLabel.text = [self.employee formattedSalaryString];
            break;
        default:
            break;
    }
}

@end
