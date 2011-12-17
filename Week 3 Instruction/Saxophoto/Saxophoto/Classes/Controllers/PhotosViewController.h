//
//  PhotosViewController.h
//  Saxophoto
//
//  Created by Mattt Thompson on 11/12/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PhotosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) NSArray *photos;

@end
