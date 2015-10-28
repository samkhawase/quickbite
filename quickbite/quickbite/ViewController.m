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

//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc]init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.locationLoadingIndicator startAnimating];
    

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
        destination.latitude = [NSString stringWithFormat:@"%+.6f",self.currentLocation.coordinate.latitude];
        destination.longitude = [NSString stringWithFormat:@"%+.6f",self.currentLocation.coordinate.longitude];

    }
}


#pragma LocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
 
    self.currentLocation = [locations lastObject];
    // If it's a relatively recent event, turn off updates to save power.
    
    NSDate* eventDate = self.currentLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    // If the event is recent, do something with it.
    if (fabs(howRecent) < 15.0) {
        
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              self.currentLocation.coordinate.latitude,
              self.currentLocation.coordinate.longitude);
        
        __block NSString *savedGeocodedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLocation"];
        
        dispatch_queue_t bgQueue = dispatch_queue_create("bgQueue", NULL);
        
        dispatch_async(bgQueue, ^{
            if (0 != self.currentLocation.coordinate.latitude && 0 != self.currentLocation.coordinate.longitude) {
                
                dispatch_semaphore_t waitingSem = dispatch_semaphore_create(0);
                
                [DataFetchService getReverseGeoCodedLocation:[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude]
                                                   longitude:[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude]
                                                   withBlock:^(NSData *data,NSURLResponse *response,NSError *error)
                 {
                     NSError* err;
                     NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
                     
                     NSString *locationNameFromSpace = [returnedDict objectForKey:@"display_name"];
                     
                     if (nil == savedGeocodedName || ![savedGeocodedName isEqualToString:locationNameFromSpace]) {
                         savedGeocodedName = locationNameFromSpace;
                         [[NSUserDefaults standardUserDefaults] setObject:self.currentLocationLabel.text forKey:@"CurrentLocation"];
                     }
                     
                     // end the wait
                     dispatch_semaphore_signal(waitingSem);
                     
                     //NSLog(@"Count: %d", [returnedDict count]);
                     //NSLog(@"Running on main thread? %@", [[NSThread currentThread] isMainThread] ? @"YES" : @"NO");
                 }];
                
                dispatch_semaphore_wait(waitingSem, DISPATCH_TIME_FOREVER);
            }
            // this is executed either right away or after the semaphore signal
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.currentLocationLabel setBackgroundColor:[UIColor yellowColor]];
                [self.currentLocationLabel setText:savedGeocodedName];
                [self.currentLocationLabel setFont:[UIFont systemFontOfSize:12]];
                [self.currentLocationLabel setNeedsLayout];
                [self.locationLoadingIndicator stopAnimating];
                [self.locationLoadingIndicator setHidden:true];
            });
        });
        
        [self.locationManager stopUpdatingLocation];
    }
}


@end
