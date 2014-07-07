//
//  LocationDetailViewController.m
//  quickbite
//
//  Created by Sam Khawase on 29/05/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import "LocationDetailViewController.h"
#import <MapKit/MapKit.h>

@interface LocationDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationId;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *extraInfo;
@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;

@end

@implementation LocationDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.locationId setText:self.currentLocationDetails.place_id];
//    [self.description setText:self.currentLocationDetails.class_type];
    [self.address setText:self.currentLocationDetails.display_name];
    [self.type setText:self.currentLocationDetails.type];
    
    // replace with distance from me
    [self.extraInfo setText:[NSString stringWithFormat:@"latitude: %@ longitude: %@",self.currentLocationDetails.latitude, self.currentLocationDetails.longitude]];
    
    // show the mapview
    
    CLLocationCoordinate2D thisLocation = CLLocationCoordinate2DMake([self.currentLocationDetails.latitude doubleValue], [self.currentLocationDetails.longitude doubleValue]);

    MKPointAnnotation* point = [[MKPointAnnotation alloc] init];
    point.coordinate = thisLocation;
    point.title = self.currentLocationDetails.display_name;
    
    [self.locationMapView addAnnotation:point];
    
    MKCoordinateRegion adjustedRegion = [self.locationMapView regionThatFits:MKCoordinateRegionMakeWithDistance(thisLocation, 800, 800)];
    
    adjustedRegion.span.longitudeDelta = 0.005;
    adjustedRegion.span.latitudeDelta = 0.005;
    
    [self.locationMapView setCenterCoordinate:thisLocation];
    [self.locationMapView setRegion:adjustedRegion animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
