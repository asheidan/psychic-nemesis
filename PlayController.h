/* PlayController */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebView.h>
#import "ShellWrapper.h"
#import "ImageInfo.h"

@interface PlayController : NSObject <NSWindowDelegate>
{
    IBOutlet NSArrayController *coreDataController;
    IBOutlet NSWindow *editWindow;
	IBOutlet NSTextView *textView;
	NSMutableDictionary *renderWindows;
	ShellWrapper *shellWrapper;
	ImageInfo *imageInfo;
}
- (IBAction)showAllRenderWindows:(id)sender;
- (IBAction)showEditWindow:(id)sender;

- (IBAction)newGadget:(id)sender;
- (IBAction)removeGadget:(id)sender;

//- (void)textDidChange:(NSNotification *)aNotification;
//- (void)controlTextDidEndEditing:(NSNotification *)aNotification;

@end
