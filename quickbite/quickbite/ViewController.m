//
//  ViewController.m
//  quickbite
//
//  Created by Sam Khawase on 27/05/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DataFetchService.h"
#import "ResultListViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locationLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation* currentLocation;

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc]init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    // Set a movement threshold for new events.
    //self.locationManager.distanceFilter = 500; // meters
    [self.locationManager startUpdatingLocation];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.locationLoadingIndicator startAnimating];
    
    NSLog(@"%+.6f, %+.6f",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    
    //52.517070, 13.389109
    [DataFetchService getReverseGeoCodedLocation:@"52.517070"
                                       longitude:@"13.389109"
                                       withBlock:^(NSData *data,NSURLResponse *response,NSError *error)
    {
        NSError* err;
        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        //NSLog(@"Count: %d", [returnedDict count]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentLocationLabel setText:[returnedDict objectForKey:@"display_name"]];
            [self.currentLocationLabel setNeedsLayout];
            [self.locationLoadingIndicator stopAnimating];
            [self.locationLoadingIndicator setHidden:true];
        });
    }];
    //[self.currentLocationLabel setText:@"Berlin, DE"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)letsGoButton:(id)sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
    if ([segue.identifier isEqualToString:@"ResultListSegue"]) {
        // valid segue
        
        ResultListViewController* destination = (ResultListViewController*)segue.destinationViewController;
        destination.latitude = @"52.517070";
        destination.longitude = @"13.389109";
    }
}


#pragma LocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
 
    self.currentLocation = [locations lastObject];
    // If it's a relatively recent event, turn off updates to save power.
    
    NSDate* eventDate = self.currentLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              self.currentLocation.coordinate.latitude,
              self.currentLocation.coordinate.longitude);
        
//        [self.currentLocationLabel setText:[NSString stringWithFormat:@"%+.6f - %+.6f",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude]];
//        [self.currentLocationLabel setNeedsLayout];
        
        [self.locationManager stopUpdatingLocation];
    }
}


@end
