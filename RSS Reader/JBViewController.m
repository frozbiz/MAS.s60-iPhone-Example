//
//  JBViewController.m
//  RSS Reader
//
//  Created by Lee Keyser-Allen on 12/4/12.
//  Copyright (c) 2012 Lee Keyser-Allen. All rights reserved.
//

#import "JBViewController.h"

@interface JBViewController ()

@end

@implementation JBViewController

@synthesize mapView;

- (void)centerMapWithLat:(double)lat andLon:(double)lon andZoom:(unsigned)zoomLevel
{
    NSString *urlAddress = [NSString stringWithFormat:@"http://maps.stamen.com/watercolor/embed#%u/%f/%f", zoomLevel, lat, lon];

    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];

    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [mapView loadRequest:requestObj];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self centerMapWithLat:42.358449 andLon:-71.09122 andZoom:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
