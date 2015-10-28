//
//  DataFetchService.m
//  quickbite
//
//  Created by Sam Khawase on 27/05/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import "DataFetchService.h"

@interface DataFetchService()

@end

@implementation DataFetchService

+ (DataFetchService*)sharedInstance{
    
    static DataFetchService* _sharedInstance = nil;
    static dispatch_once_t oncepPredicate;
    
    dispatch_once(&oncepPredicate, ^{
        _sharedInstance = [[DataFetchService init] alloc];
    });
    
    return _sharedInstance;
}

+ (NSString *)getReverseGeoCodedLocation:(NSString *)lat
                               longitude:(NSString *)lon
                               withBlock:(void (^)(NSData *, NSURLResponse *, NSError *))returnedBlock{

    NSString* locationName = [[NSString alloc]init];
    
    // http://open.mapquestapi.com/nominatim/v1/reverse.php?format=json&lat=52.517070&lon=13.389109
    
    NSString* nominatimURL = [NSString stringWithFormat:@"http://open.mapquestapi.com/nominatim/v1/reverse.php?key=OpG77EV5jNGTWkTUNa2tvySro6eyCNcF&format=json&lat=%@&lon=%@", lat, lon];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:nominatimURL]
            completionHandler:returnedBlock] resume];
    
    return locationName;
    
}

+ (void)getPlacesNearLocation:(NSString *)latitude
                    longitude:(NSString *)longitude
             withLocationType:(NSString *)locationType
                    withBlock:(void (^)(NSData *, NSURLResponse *, NSError *))returnedBlock{


    int fetchLimit = 20;

 
    NSString* nominatimSearchUrlWithParams = [NSString stringWithFormat:@"http://open.mapquestapi.com/nominatim/v1/search.php?key=OpG77EV5jNGTWkTUNa2tvySro6eyCNcF&format=json&q=%@ near [%@, %@]&limit=%d",locationType,latitude, longitude,fetchLimit];

    NSString* urlstr = [nominatimSearchUrlWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *searchSession = [NSURLSession sharedSession];
    
    [[searchSession dataTaskWithURL:[NSURL URLWithString:urlstr] completionHandler:returnedBlock] resume];
    
 
    
}

/*
    http://open.mapquestapi.com/nominatim/v1/search.php?format=json&q=pub%20near%20[52.517070,%2013.389109]&limit=5

 ^(NSData *data,NSURLResponse *response,NSError *error){
    if (nil != error) { }
 }
 */

@end
