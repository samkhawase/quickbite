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

+ (NSArray*) getAllLocationsForLatitude:(NSString*) latitude
                            andLongitude:(NSString*) longitude;

+ (BOOL) saveLocationsInList:(NSArray*) fetchedLocations;


@end
