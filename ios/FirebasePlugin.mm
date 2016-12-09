#import "FirebasePlugin.h"
#import "Firebase.h"

@implementation FirebasePlugin

// The plugin must call super dealloc.
- (void) dealloc {
  [super dealloc];
}

// The plugin must call super init.
- (id) init {
  self = [super init];
  if (!self) {
    return nil;
  }
  return self;
}

- (void) initializeWithManifest:(NSDictionary *)manifest appDelegate:(TeaLeafAppDelegate *)appDelegate {
  @try {
    [FIRApp configure];
    NSLog(@"{firebase} initDone");
  } @catch (NSException *exception) {
    NSLog(@"{firebase} Failed to initialize with exception: %@", exception);
  }
}

- (void) setUserData: (NSDictionary*) userData {
  NSLog(@"{firebase} inside setUserData function");
  @try {
    [userData enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
      NSString *prop = (NSString *) key;
      NSString *currValue = (NSString *) value;

      if ([prop isEqualToString:@"uid"]) {
        [FIRAnalytics setUserID:currValue];
      } else {
        [FIRAnalytics setUserPropertyString:currValue forName:prop];
      }
    }];
  } @catch (NSException *exception) {
    NSLog(@"{firebase} Exception on setting user property: %@", exception);
  } 
}

- (void) logEvent: (NSDictionary*) eventData {
  NSLog(@"{firebase} inside logEvent function");
  @try {
    NSString *eventName = [eventData valueForKey:@"eventName"];
    NSDictionary *evtParams = [eventData objectForKey:@"params"];

    if (!evtParams || [evtParams count] <= 0) {
      [FIRAnalytics logEventWithName:eventName];

      NSLog(@"{firebase} Delivered event '%@'", eventName);
    } else {
      [FIRAnalytics logEventWithName:eventName parameters:evtParams];

      NSLog(@"{firebase} Delivered event '%@' with %d params", eventName, (int)[evtParams count]);
    }
  } @catch (NSException *exception) {
    NSLog(@"{firebase} Exception while processing event: %@", exception);
  }
}

- (void) setScreen: (NSDictionary*) screenData {
  @try {
    [FIRAnalytics setScreenName: [screenData valueForKey:@"name"]];
  } @catch (NSException *exception) {
    NSLOG(@"{firebase} Exception on set screen: ", exception);
  }
}

@end
