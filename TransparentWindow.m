#import "TransparentWindow.h"

@implementation TransparentWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned long)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	if(self = [super initWithContentRect:contentRect
					styleMask:NSBorderlessWindowMask
					backing:NSBackingStoreBuffered defer:flag]) {
		[self setOpaque:NO];
		[self setBackgroundColor:[NSColor clearColor]];
	}
	return self;
}

@end
