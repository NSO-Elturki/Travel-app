#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    [GMSServices provideAPIKey: @"AIzaSyAUfRrZ85KVSXe-dC2gqIFPJFYQgufo0cU"];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
