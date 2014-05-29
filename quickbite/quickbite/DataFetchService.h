//
//  DataFetchService.h
//  quickbite
//
//  Created by Sam Khawase on 27/05/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetchService : NSObject

+ (DataFetchService*)sharedInstance;

+ (NSString*) getReverseGeoCodedLocation:(NSString*)lat
                               longitude:(NSString*)lon
                               withBlock:(void (^)(NSData*, NSURLResponse*, NSError*))returnedBlock;

+ (void) getPlacesNearLocation:(NSString*)latitude
                   longitude:(NSString*)longitude
            withLocationType:(NSString*)locationType
                   withBlock:(void (^)(NSData*, NSURLResponse*, NSError*))returnedBlock;




@end
