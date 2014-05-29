//
//  LocationDetail.h
//  quickbite
//
//  Created by Sam Khawase on 29/05/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//
/*
{
    "place_id": "1599833",
    "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright",
    "osm_type": "node",
    "osm_id": "336384880",
    "boundingbox": [
                    52.5213073,
                    52.5214073,
                    13.3856315,
                    13.3857315
                    ],
    "lat": "52.5213573",
    "lon": "13.3856815",
    "display_name": "Die Berliner Republik, 8, Schiffbauerdamm, Mitte, Berlin, 10117, Germany, European Union",
    "class": "amenity",
    "type": "pub",
    "importance": 0.201,
    "icon": "http://open.mapquestapi.com/nominatim/v1/images/mapicons/food_pub.p.20.png"
}
*/

#import <Foundation/Foundation.h>

@interface LocationDetail : NSObject

@property (strong, nonatomic) NSString* place_id;
@property (strong, nonatomic) NSString* osm_type;
@property (strong, nonatomic) NSString* osm_id;
@property (strong, nonatomic) NSMutableArray* boundingBox;
@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) NSString* display_name;
@property (strong, nonatomic) NSString* class;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* importance;
@property (strong, nonatomic) NSString* icon;

@end
