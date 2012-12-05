//
//  JBViewController.h
//  RSS Reader
//
//  Created by Lee Keyser-Allen on 12/4/12.
//  Copyright (c) 2012 Lee Keyser-Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBViewController : UIViewController {
    
    IBOutlet UIWebView *mapView;
    IBOutlet UITextField *countryName;
}

@property (nonatomic, retain) UIWebView *mapView;

@end
