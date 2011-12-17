//
//  PhotosViewController.m
//  Saxophoto
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhotosViewController.h"

#import "Photo.h"

#import "SaxophotoAPIClient.h"

#import "UIImageView+AFNetworking.h"

@implementation PhotosViewController
@synthesize photos = _photos;

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
    
    [[SaxophotoAPIClient sharedClient] getPath:@"/photos" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mutablePhotos = [NSMutableArray array];
        for (NSDictionary *attributes in [responseObject valueForKey:@"photos"]) {
            Photo *photo = [[[Photo alloc] initWithAttributes:attributes] autorelease];
            [mutablePhotos addObject:photo];
        }
        self.photos = mutablePhotos;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
}

#pragma mark - Actions

- (void)takePhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[[UIImagePickerController alloc] initWithRootViewController:nil] autorelease];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:^{
        NSLog(@"Complete");
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    
    [cell.imageView setImageWithURL:photo.imageURL placeholderImage:[UIImage imageNamed:@"placeholder-photo.png"]];
    cell.textLabel.text = photo.timestamp;
    
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSURLRequest *uploadRequest = [[SaxophotoAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"/photos" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"photo[image]" fileName:[[[NSDate date] description]  stringByAppendingPathExtension:@"jpg"] mimeType:@"image/jpeg"];
    }];
    AFHTTPRequestOperation *operation = [[SaxophotoAPIClient sharedClient] HTTPRequestOperationWithRequest:uploadRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    [[SaxophotoAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
