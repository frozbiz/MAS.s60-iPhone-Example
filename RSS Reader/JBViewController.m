//
//  JBViewController.m
//  RSS Reader
//
//  Created by Lee Keyser-Allen on 12/4/12.
//  Copyright (c) 2012 Lee Keyser-Allen. All rights reserved.
//

#import "JBViewController.h"
#import <Foundation/NSJSONSerialization.h>

@interface JBViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDictionary *countryNameByISOCode;
@property (nonatomic, strong) NSDictionary *pathByCountryName;

@end

@implementation JBViewController

@synthesize mapView;
@synthesize locationManager = _locationManager;
@synthesize countryNameByISOCode = _countryNameByISOCode;
@synthesize pathByCountryName = _pathByCountryName;

- (void) buildDictionaries
{
    if (!_pathByCountryName) {
        NSError * __autoreleasing error;
        NSURL *pathURL = [[NSBundle mainBundle] URLForResource:@"gv_country_paths" withExtension:@"json"];
        NSInputStream *paths = [NSInputStream inputStreamWithURL:pathURL];
        [paths open];
        _pathByCountryName = [NSJSONSerialization JSONObjectWithStream:paths options:0 error:&error];
    }

    if (!_countryNameByISOCode) {
        NSError * __autoreleasing error;
        NSURL *pathURL = [[NSBundle mainBundle] URLForResource:@"code_country" withExtension:@"json"];
        NSInputStream *countries = [NSInputStream inputStreamWithURL:pathURL];
        [countries open];
        _countryNameByISOCode = [NSJSONSerialization JSONObjectWithStream:countries options:0 error:&error];
    }
}

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

- (void)createLocationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 1000.0f; // we don't need to be any more accurate than 1km
        _locationManager.purpose = @"This may be used to obtain your reverse geocoded address";
    }
}

- (void)findLocationAndUpdateMap
{
    [self startUpdatingCurrentLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self centerMapWithLat:42.358449 andLon:-71.09122 andZoom:1];
    
    [self findLocationAndUpdateMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _locationManager.delegate = nil;
    _locationManager = nil;
}

- (void)dealloc
{
    _locationManager.delegate = nil;
}

#pragma mark - CLGeocoder
- (void) findCountryForLocation:(CLLocation*)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@, location:%@", error, location);
            return;
        }

        // Get the first placemark. In some exceptional circumstances, you can recieve
        // more than one placemark but since we just want the country, we can assume that we
        // can get that from the first one.
        if (placemarks.count > 0 && !countryName.isEditing && ![countryName.text length]) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            NSString *countryCode = [placemark ISOcountryCode];
            [self buildDictionaries];
            NSString *countryString = [_countryNameByISOCode objectForKey:countryCode];
            
            countryName.text = countryString;
            // Also make our map track
            [self centerMapWithLat:location.coordinate.latitude andLon:location.coordinate.longitude andZoom:6];
        }
            
    }];

}


#pragma mark - CLLocationManagerDelegate

- (void)startUpdatingCurrentLocation
{
    // if location services are restricted do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        return;
    }
    
    // if locationManager does not currently exist, create it
    [self createLocationManager];

    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingCurrentLocation
{
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self findCountryForLocation:newLocation];
    
    // after recieving a location, stop updating
    [self stopUpdatingCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    // stop updating
    [self stopUpdatingCurrentLocation];

    // That's it, I could do something more clever here, but it's likely that it'll fail again
    // so for now, we'll just call it quits.
}




@end
