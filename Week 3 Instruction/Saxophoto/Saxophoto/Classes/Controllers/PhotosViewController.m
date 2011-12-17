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
@synthesize tableView = _tableView;
@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize photos = _photos;

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) {
        return nil;
    }
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 80.0f;
    
    return self;
}

- (void)dealloc {
    [_tableView release];
    [_mapView release];
    [_locationManager release];
    [_photos release];
    [super dealloc];
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    self.mapView = [[[MKMapView alloc] initWithFrame:self.view.bounds] autorelease];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    self.tableView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Saxophoto", nil);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto:)] autorelease];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[SaxophotoAPIClient sharedClient] getPath:@"/photos" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mutablePhotos = [NSMutableArray array];
        for (NSDictionary *attributes in [responseObject valueForKey:@"photos"]) {
            Photo *photo = [[[Photo alloc] initWithAttributes:attributes] autorelease];
            [mutablePhotos addObject:photo];
        }
        self.photos = mutablePhotos;
        [self.tableView reloadData];
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotations:self.photos];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    
    self.tableView.rowHeight = 100.0f;
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Actions

- (void)takePhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
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
    
    [cell.imageView setImageWithURL:photo.thumbnailImageURL placeholderImage:[UIImage imageNamed:@"placeholder-photo.png"]];
    cell.textLabel.text = photo.timestamp;
    
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"photo[lat]"];
    [mutableParameters setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"photo[lng]"];
    
    NSURLRequest *uploadRequest = [[SaxophotoAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"/photos" parameters:mutableParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"photo[image]" fileName:[[[NSDate date] description]  stringByAppendingPathExtension:@"jpg"] mimeType:@"image/jpeg"];
    }];
    AFHTTPRequestOperation *operation = [[SaxophotoAPIClient sharedClient] HTTPRequestOperationWithRequest:uploadRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        Photo *photo = [[[Photo alloc] initWithAttributes:responseObject] autorelease];
        [self.mapView addAnnotation:photo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    [[SaxophotoAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

@end
