
// IBActiveThemes - mutable array - one instance of this exists over the lifetime of program
static NSMutableArray *IBActiveThemes;

// WBPreferencesPath - string - where winterboard prefs path is on all iOS devices
static NSString *WBPreferencesPath = @"/User/Library/Preferences/com.saurik.WinterBoard.plist";



/*
 * IBTheme - Interface - IconBundles theme
 * Desc - What do we need to know about an icon bundles theme?
 * Properties
 *     path - string - location of icons? or IconBundles folder? Continue reading
 *     // TODO: Understand precomposed icons
 *     iconsArePrecomposed - bool - true or false whether icons are precomposed or not.
 */
@interface IBTheme : NSObject

// path - string property - sets and gets
@property (nonatomic, strong, readonly) NSString *path;

// iconsArePrecomposed - boolean property - this allows or disallows 'fancy' effects to be added by iOS
@property (nonatomic, assign) BOOL iconsArePrecomposed;

// initWithPath - initialize IBTheme with a certain path
- (instancetype)initWithPath:(NSString *)path;

@end

// Implementationo of IBTheme
@implementation IBTheme

/* initWithPath - function
 * Params
 *     path - a path passed to the function that sets the member _path to the path passed in
 */
- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _path = path;
    }
    return self;
}

@end



// Constructor
%ctor {
    // settings - dictionary - initialized with path to winterboard preferences
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:WBPreferencesPath];

    // themes - array - get the list of themes on device from Winterboard preferences
    NSArray *themes = settings[@"Themes"];

    // if there are no themes, end now
    if (![themes count])
        return;

    // IBActiveThemes - mutable array - initialized with a capacity of 8 elements
    IBActiveThemes = [[NSMutableArray alloc] initWithCapacity:8];

    // For each theme that is in the array of themes...
    for (NSDictionary *theme in themes) {

        // active - number - number of active themes
        NSNumber *active = theme[@"Active"];

        // name - string - stores the name of all installed themes
        NSString *name = theme[@"Name"];

        // If the theme iterated over IS NOT ACTIVE or there is NO Name then continue?
        if (![active boolValue] || !name)
            continue;

        // pathChecks - unmutable array - holds 4 locations as to where theme names may be found
        // NOTE: Summerboard is no longer used in newest versions of iOS but this allows for legacy versions
        // on older devices where Winterboard isn't up to date.
        NSArray *pathChecks = @[
            [NSString stringWithFormat:@"/Library/Themes/%@.theme", name],
            [NSString stringWithFormat:@"/Library/Themes/%@", name],
            [NSString stringWithFormat:@"/User/Library/SummerBoard/Themes/%@", name],
            [NSString stringWithFormat:@"/User/Library/SummerBoard/Themes/%@.theme", name]
        ];

        // For each string path in the array called pathChecks...
        for (NSString *path in pathChecks) {

            // iconBundlesPath - string - append "IconBundles" to path (i.e.: /Library/Themes/Zanilla.theme/IconBundles)
            NSString *iconBundlesPath = [path stringByAppendingPathComponent:@"IconBundles"];

            // If the default file manager tells us that the IconBundles folder exists at the path previously specified...
            if ([[NSFileManager defaultManager] fileExistsAtPath:iconBundlesPath]) {

                // then... Make a new IBTheme instantiation with the iconBundlesPath specified
                // once again example may be (/Library/Themes/Zanilla.theme/IconBundles)
                IBTheme *theme = [[IBTheme alloc] initWithPath:iconBundlesPath];

                // plistPath - string - path that points to where Info.plist is located in the theme
                // (i.e. /Library/Themes/Zanilla.theme/Info.plist)
                NSString *plistPath = [path stringByAppendingPathComponent:@"Info.plist"];

                // themeOptions - dictionary - instantiate it with the contents of Info.plist from
                // the current theme we're looking at
                NSDictionary *themeOptions = [NSDictionary dictionaryWithContentsOfFile:plistPath];

                // If there is no "IB-MaskIcons" in the dictionary from Info.plist,
                // then the iconsArePrecomposed is True
                theme.iconsArePrecomposed = ![themeOptions[@"IB-MaskIcons"] boolValue];

                // Add the current theme to a list of active IconBundles themes - IBActiveThemes
                [IBActiveThemes addObject:theme];
            }
        }
    }
}




@interface UIImage (UIApplicationIconPrivate)
- (id)_applicationIconImageForFormat:(int)arg1 precomposed:(BOOL)arg2 scale:(float)arg3;
@end


/*
 * IBGetThemedIcon - static UIImage
 * Params
 *    displayIdentifier - string
 *    format - int - default is 0 if no other value is given
 *    scale - float - default is 0 is no other value is given
 */
static UIImage* IBGetThemedIcon(NSString *displayIdentifier, int format = 0, float scale = 0) {

    // If the number of active IconBundle themes is 0 then just return nil and exit function
    if ([IBActiveThemes count] == 0)
        return nil;

    // potentialFilenames - mutable array - init
    NSMutableArray *potentialFilenames = [[NSMutableArray alloc] init];

    // displayScale - CGFloat - is scale greater than 0? If not, get the scale
    CGFloat displayScale = (scale > 0 ? scale : [UIScreen mainScreen].scale);

    // As long as the displayScale is greater than 1.0 when iterating over it...
    /*
     * TODO: Is it necessary to loop over this? Why not say if. Otherwise wouldn't this
     *       try to add @2x when it comes back around to the same string...
     *       i.e.: com.name.id@3x.png@2x.png  ?
     */
    if (displayScale >= 1.0) {
        // filename - mutable string - init with displayIdentifier passed to function
        NSMutableString *filename = [NSMutableString stringWithString:displayIdentifier];

        // If the device is an ipad add "~ipad" to the filename string
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            [filename appendString:@"~ipad"];

        // If the displayScale == 2.0 add "@2x" to the end of the filename string
        if (displayScale == 2.0)
            [filename appendString:@"@2x"];

        // Otherwise if the displayScale == 3.0 add "@3x" to the end of the filename string
        else if (displayScale == 3.0)
            [filename appendString:@"@3x"];

        //
        [filename appendString:@".png"];
        [potentialFilenames addObject:filename];
        displayScale--;
    }

    for (IBTheme *theme in IBActiveThemes) {
        for (NSString *filename in potentialFilenames) {
            NSString *path = [theme.path stringByAppendingPathComponent:filename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *themedImage = [UIImage imageWithContentsOfFile:path];

                if (theme.iconsArePrecomposed) {
                    // format == 2 means homescreen icon
                    if (format != 2) {
                        // if not formatting for a homescreen icon, resize the image
                        // to the correct size (namely for Notification Center)
                        UIImage *tempImage = [themedImage _applicationIconImageForFormat:format precomposed:NO scale:scale];
                        UIGraphicsBeginImageContextWithOptions(tempImage.size, NO, 0.0);
                        [themedImage drawInRect:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height)];
                        themedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                    }
                }
                else {
                    themedImage = [themedImage _applicationIconImageForFormat:format precomposed:NO scale:scale];
                }

                return themedImage;
            }
        }
    }

    return nil;
}

%hook SBIconImageCrossfadeView

- (void)setMasksCorners:(BOOL)masks {
    // Prevent icons from being rounded on launch
    %orig(NO);
}

%end

%hook UIImage

+ (id)_applicationIconImageForBundleIdentifier:(id)bundleIdentifier roleIdentifier:(id)roleIdentifier format:(int)format scale:(float)scale {
    return IBGetThemedIcon(bundleIdentifier, format, scale) ?: %orig;
}

+ (id)_applicationIconImageForBundleIdentifier:(id)bundleIdentifier format:(int)format scale:(float)scale {
    return IBGetThemedIcon(bundleIdentifier, format, scale) ?: %orig;
}

%end

@interface SBIcon : NSObject
- (NSString *)applicationBundleID;
@end

@interface SBClockApplicationIconImageView : UIView
- (SBIcon *)icon;
@end

%hook SBClockApplicationIconImageView

- (id)contentsImage {
    // Quick hack for iOS 7 "live" clock icon
    if ([self respondsToSelector:@selector(icon)]) {
        SBIcon *sbIcon = [self icon];
        if (UIImage *icon = IBGetThemedIcon([sbIcon applicationBundleID]))
            return icon;
    }

    return %orig;
}

%end
