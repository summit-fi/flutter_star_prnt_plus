#import "FlutterStarPrntPlugin.h"
#import <TargetConditionals.h>

#if !TARGET_OS_SIMULATOR
#if __has_include(<flutter_star_prnt_plus/flutter_star_prnt_plus-Swift.h>)
#import <flutter_star_prnt_plus/flutter_star_prnt_plus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_star_prnt_plus-Swift.h"
#endif
#endif

@implementation FlutterStarPrntPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
#if TARGET_OS_SIMULATOR
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_star_prnt"
            binaryMessenger:[registrar messenger]];
  FlutterStarPrntPlugin* instance = [[FlutterStarPrntPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
#else
  [SwiftFlutterStarPrntPlugin registerWithRegistrar:registrar];
#endif
}

#if TARGET_OS_SIMULATOR
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"portDiscovery" isEqualToString:call.method]) {
    result(@[]);
    return;
  }

  if ([@"checkStatus" isEqualToString:call.method] || [@"print" isEqualToString:call.method]) {
    result(@{
      @"offline": @YES,
      @"coverOpen": @NO,
      @"cutterError": @NO,
      @"receiptPaperEmpty": @NO,
      @"is_success": @NO,
      @"overTemp": @NO,
      @"error_message": @"Star printer plugin is not available on iOS simulator."
    });
    return;
  }

  result(FlutterMethodNotImplemented);
}
#endif
@end
