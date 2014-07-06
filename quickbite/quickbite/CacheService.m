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

+ (NSArray *)getAllLocationsForLatitude:(NSString *)latitude andLongitude:(NSString *)longitude{
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(latitude = %@, longitude= %@)", latitude, longitude];
    [request setPredicate:pred];
    
    NSError *fetchError;
    NSArray *objects = [context executeFetchRequest:request error:&fetchError];
    
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop){
        NSLog(@"%@", [obj class]);
    }];
    
    return objects;
}

+ (BOOL)saveLocationsInList:(NSArray *)fetchedLocations{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *saveMoc = [appDelegate managedObjectContext];
    
    [fetchedLocations enumerateObjectsUsingBlock:^(LocationDetail *loopLocation, NSUInteger idx, BOOL *stop){

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:saveMoc];
        [fetchRequest setEntity:entityDescription];
        
        NSPredicate *checkPredicate = [NSPredicate predicateWithFormat:@"(latitude = %@) AND (longitude = %@)", loopLocation.latitude, loopLocation.longitude];
        [fetchRequest setPredicate:checkPredicate];
        
        NSError * fetchError;
        NSArray *results = [saveMoc executeFetchRequest:fetchRequest error:&fetchError];
        
        if (results.count > 0) {
            // kalti, entity exists
            *stop = YES;
        }
        
        NSManagedObject *locationInQuestion;
        
        [locationInQuestion setValue:loopLocation.osm_id forKey:@"osm_id"];
        [locationInQuestion setValue:loopLocation.latitude forKey:@"latitude"];
        [locationInQuestion setValue:loopLocation.longitude forKey:@"longitude"];

        NSError *saveError;
        NSLog(@"saved? %@",[saveMoc save:&saveError] ? @"YES" : @"NO");
        
    }];
    
    return YES;
}


@end
