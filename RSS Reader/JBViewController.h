//
//  JBViewController.h
//  RSS Reader
//
//  Created by Lee Keyser-Allen on 12/4/12.
//  Copyright (c) 2012 Lee Keyser-Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JBViewController : UIViewController <CLLocationManagerDelegate> {
    
    IBOutlet UIWebView *mapView;
    IBOutlet UITextField *countryName;
}

@property (nonatomic, retain) UIWebView *mapView;

@end
