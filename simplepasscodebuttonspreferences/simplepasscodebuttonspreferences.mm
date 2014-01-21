#import <Preferences/PSListController.h>

@interface simplepasscodebuttonspreferencesListController: PSListController {
}
@end

@implementation simplepasscodebuttonspreferencesListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"simplepasscodebuttonspreferences" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
