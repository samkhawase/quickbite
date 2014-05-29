//
//  ResultListViewController.h
//  quickbite
//
//  Created by Sam Khawase on 27/05/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSString* longitude;
@property(strong, nonatomic) NSString* latitude;

@end
