//
//  CacheService.h
//  quickbite
//
//  Created by Sam Khawase on 06/07/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocationDetail;

@interface CacheService : NSObject

+ (CacheService *) sharedInstance;

+ (NSMutableArray*) getAllLocationsForLatitude:(NSString*) latitude
                            andLongitude:(NSString*) longitude;

+ (NSArray*) saveLocationsInList:(NSArray*) fetchedLocations;


@end
