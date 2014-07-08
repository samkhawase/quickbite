//
//  CacheService.m
//  quickbite
//
//  Created by Sam Khawase on 06/07/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import "CacheService.h"
#import "LocationDetail.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface CacheService()

@end

@implementation CacheService

+(CacheService *)sharedInstance{
    static CacheService *_sharedInstance = nil;
    static dispatch_once_t oncepPredicate;
    
    dispatch_once(&oncepPredicate, ^{
        _sharedInstance = [[CacheService init] alloc];
    });
    
    return _sharedInstance;
}

+ (NSMutableArray *)getAllLocationsForLatitude:(NSString *)latitude andLongitude:(NSString *)longitude{
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
//    NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"(firstname CONTAINS[cd] %@) OR (lastname CONTAINS[cd] %@)", _mySearchKey, _mySearchKey];

    NSRange majorRange = [latitude rangeOfString:@"."];
    NSString *latitudeMajorPart = [latitude substringToIndex:majorRange.location];
    
    NSRange minorRange =[longitude rangeOfString:@"."];
    NSString* longitudeMajorPart = [longitude substringToIndex:minorRange.location];
    
    NSPredicate *likePredicate = [NSPredicate predicateWithFormat:@"(latitude BEGINSWITH %@) AND (longitude BEGINSWITH %@)", latitudeMajorPart, longitudeMajorPart];

    NSLog(@"%@ - %@", latitudeMajorPart, longitudeMajorPart);
    
    [request setPredicate:likePredicate];
    
    NSError *fetchError;
    NSMutableArray *objects = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&fetchError]];

    // remove objects more than 2 KM away
    NSMutableIndexSet *indexedDelete = [NSMutableIndexSet indexSet];
    NSUInteger currentIdx = 0;
    
    for (LocationDetail* aLocationObject in objects) {
        
        CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:[aLocationObject.latitude floatValue]
                                                              longitude:[aLocationObject.longitude floatValue]];
        
        CLLocation *thatLocation = [[CLLocation alloc] initWithLatitude:[latitude floatValue]
                                                              longitude:[longitude floatValue]];
        
        CLLocationDistance distance = [thisLocation distanceFromLocation:thatLocation];
        
        if (distance > 2000) {
            NSLog(@"\t %f will be removed", distance);
            [indexedDelete addIndex:currentIdx];
        }
        currentIdx++;
    }
    
    [objects removeObjectsAtIndexes:indexedDelete];
    
//    NSLog(@"Objects found in cache: %d", objects.count);
    
    return objects;
}

+ (BOOL)saveLocationsInList:(NSArray *)fetchedLocations{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *saveMoc = [appDelegate managedObjectContext];
    
    [fetchedLocations enumerateObjectsUsingBlock:^(LocationDetail *loopLocation, NSUInteger idx, BOOL *stop){

        NSLog(@"%@ - %@", loopLocation.latitude, loopLocation.longitude);
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:saveMoc];
        [fetchRequest setEntity:entityDescription];
        
        NSPredicate *checkPredicate = [NSPredicate predicateWithFormat:@"(latitude BEGINSWITH %@) AND (longitude BEGINSWITH %@)",
                                       loopLocation.latitude, loopLocation.longitude];
        
        [fetchRequest setPredicate:checkPredicate];
        
        NSError * fetchError;
        NSArray *results = [saveMoc executeFetchRequest:fetchRequest error:&fetchError];
        
        if (results.count > 0) {
            // kalti, entity exists
            //*stop = YES;
            return;
        }
        
        NSManagedObject *locationInQuestion;
        locationInQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:saveMoc];
        
        // append the signs for the lat-longs
        if ([loopLocation.latitude intValue] > 0) {
            loopLocation.latitude = [NSString stringWithFormat:@"+%@", loopLocation.latitude];
        } else {
            loopLocation.latitude = [NSString stringWithFormat:@"-%@", loopLocation.latitude];
        }
        
        if ([loopLocation.longitude intValue] > 0) {
            loopLocation.longitude = [NSString stringWithFormat:@"+%@", loopLocation.longitude];
        } else {
            loopLocation.longitude = [NSString stringWithFormat:@"-%@", loopLocation.longitude];
        }
        
        [locationInQuestion setValue:loopLocation.osm_id forKey:@"osm_id"];
        [locationInQuestion setValue:loopLocation.latitude forKey:@"latitude"];
        [locationInQuestion setValue:loopLocation.longitude forKey:@"longitude"];
        [locationInQuestion setValue:loopLocation.display_name forKey:@"display_name"];
        [locationInQuestion setValue:loopLocation.type forKey:@"type"];
        [locationInQuestion setValue:loopLocation.place_id forKey:@"place_id"];
        [locationInQuestion setValue:loopLocation.osm_type forKey:@"osm_type"];
//        [locationInQuestion setValue:loopLocation.importance forKey:@"importance"];
//        [locationInQuestion setValue:loopLocation.icon forKey:@"icon"];

        NSError *saveError;
        NSLog(@"saved? %@",[saveMoc save:&saveError] ? @"YES" : @"NO");
        
    }];
    
    return YES;
}

/* No need for this, CLLocationDistance is better
+ (double) distanceBetweenLat1: (double)lat1
                      withLon1:(double) lon1
                       andLat2: (double) lat2
                      withLon2: (double) lon2
{
    
    double earthRadius = 6371;
    double dLat = (lat1 - lat2 * M_PI)/180;
    double dLon = (lon1 - lon2 * M_PI)/180;
    
    double sindLat = sin(dLat/2);
    double sindLon = sin(dLon/2);
    
    double a = pow(sindLat, 2) + pow(sindLon, 2) * cos(lat1 *M_PI/180) * cos(lat2 * M_PI / 180);
    
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    double dist = earthRadius * c;
    
    return dist;
}
*/

@end
