// #import <UIKit/UITabBarController.h>

// UITabBarController
// MobileTimerTabBarController
%hook MobileTimerTabBarController 

	- (void)setSelectedIndex:(NSInteger)arg1 {
		arg1 = 1;
		%orig(arg1);
	}

%end