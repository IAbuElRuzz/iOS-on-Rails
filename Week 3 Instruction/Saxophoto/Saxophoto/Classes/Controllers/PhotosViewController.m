//
//  PhotosViewController.m
//  Saxophoto
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhotosViewController.h"

@implementation PhotosViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) {
        return nil;
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Saxophoto", nil);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto:)] autorelease];
}

#pragma mark - Actions

- (void)takePhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[[UIImagePickerController alloc] initWithRootViewController:nil] autorelease];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:^{
        NSLog(@"Complete");
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
        
    return cell;
}

@end
