//
//  ResultListViewController.m
//  quickbite
//
//  Created by Sam Khawase on 27/05/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import "ResultListViewController.h"
#import "DataFetchService.h"
#import "LocationDetail.h"
#import "LocationDetailViewController.h"

static NSString *const cellId = @"LocationCell";

@interface ResultListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dataLoadingIndicator;

@property(strong, nonatomic) NSArray* jsonResults;
@property (strong, nonatomic) NSMutableArray* listOfLocations;
@property (strong, nonatomic) LocationDetail* selectedLocation;

- (void) loadDataInBackground;

@end

@implementation ResultListViewController

- (NSMutableArray *)listOfLocations{
    if (_listOfLocations == nil) {
        _listOfLocations = [[NSMutableArray alloc] init];
    }
    return _listOfLocations;
}

//- (LocationDetail *)selectedLocation{
//    if (nil == _selectedLocation) {
//        _selectedLocation = [[LocationDetail alloc] init];
//    }
//    return _selectedLocation;
//}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
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
    [self loadDataInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDataInBackground{
    
    [self.dataLoadingIndicator startAnimating];
    [self.dataLoadingIndicator setHidesWhenStopped:true];
    
    [DataFetchService getPlacesNearLocation:self.latitude
                                  longitude:self.longitude
                           withLocationType:@"pub"
                                  withBlock:^(NSData *data,NSURLResponse *response,NSError *error)
     {
         if (nil == error) {
             NSError* err;
             self.jsonResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
             
             [self.jsonResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop){
                 NSDictionary* currentLocationFromJson = (NSDictionary*)obj;
                 
                 LocationDetail* location = [[LocationDetail alloc]init];
                 location.place_id = [currentLocationFromJson objectForKey:@"place_id"];
                 location.osm_type = [currentLocationFromJson objectForKey:@"osm_type"];
                 location.osm_id = [currentLocationFromJson objectForKey:@"osm_id"];
                 location.latitude = [currentLocationFromJson objectForKey:@"lat"];
                 location.longitude = [currentLocationFromJson objectForKey:@"lon"];
                 location.display_name = [currentLocationFromJson objectForKey:@"display_name"];
                 location.class_type = [currentLocationFromJson objectForKey:@"class"];
                 location.type = [currentLocationFromJson objectForKey:@"type"];
                 location.importance = [currentLocationFromJson objectForKey:@"importance"];
                 location.icon = [currentLocationFromJson objectForKey:@"icon"];
                 
                 [self.listOfLocations addObject:location];
                 
             }];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [self.dataLoadingIndicator stopAnimating];
                 [self.locationTableView reloadData];
             });
             
         }
     }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToLocationDetail"] && self.selectedLocation != nil) {
        LocationDetailViewController* destination = (LocationDetailViewController*)segue.destinationViewController;
        destination.currentLocationDetails = self.selectedLocation;
    }
}

- (IBAction)navigateBack:(id)sender {
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TableViewDelegate and TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *thisCell = [self.locationTableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    LocationDetail* locationAtThisIndex = [self.listOfLocations objectAtIndex:indexPath.row];
    
    [thisCell.textLabel setText:locationAtThisIndex.display_name];
    [thisCell.textLabel setFont:[UIFont systemFontOfSize:12]];
    thisCell.textLabel.numberOfLines = 0;
    
    return thisCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listOfLocations count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedLocation = [self.listOfLocations objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SegueToLocationDetail" sender:self];
}

@end
