#import "PlayController.h"
#import <WebKit/WebFrame.h>

@implementation PlayController

- (void)awakeFromNib
{
	NSLog(@"[PlayController awakeFromNib]");
	//NSLog(@"CoraDataContent: %@", [coreDataController selectionIndex]);
	
	[textView setFont:[NSFont fontWithName:@"Monaco" size:9.0]];
	
	renderWindows = [[NSMutableDictionary alloc] init];
	shellWrapper = [[ShellWrapper alloc ] init];
	imageInfo = [[ImageInfo alloc] init];

	NSError *error;
    //BOOL ok = [coreDataController fetchWithRequest:nil merge:NO error:&error];
	[coreDataController fetchWithRequest:nil merge:NO error:&error];
	
	[self showAllRenderWindows:self];
}

// Gets notified when the "body" changes
//- (void)textDidChange:(NSNotification *)aNotification
- (void)textDidEndEditing:(NSNotification *)aNotification
{
	//NSLog(@"textDidChange: %@", aNotification);
	NSEnumerator *enumerator = [[coreDataController selectedObjects] objectEnumerator];
	id object;
	while((object = [enumerator nextObject])) {
		//NSLog(@"Updating: %@", [object valueForKey:@"name"]);
		if([[object valueForKey:@"render"] boolValue]) {
			[(WebFrame *)([[[renderWindows objectForKey:[object objectID]] contentView] mainFrame]) loadHTMLString:[textView string] baseURL:NULL];
		}
	}
}

// Gets notified when x/y/width/height is changed
- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
	//NSLog(@"textDidEndEditing: %@", aNotification);
	NSEnumerator *enumerator = [[coreDataController selectedObjects] objectEnumerator];
	NSWindow *renderWindow;
	id object;
	while((object = [enumerator nextObject])) {
		renderWindow = [renderWindows objectForKey:[object objectID]];
		//NSLog(@"Updating: %@", [object valueForKey:@"name"]);
		if(renderWindow != nil) {
			[renderWindow setFrame:NSMakeRect(
										[[object valueForKey:@"posX"] floatValue],
										[[object valueForKey:@"posY"] floatValue],
										[[object valueForKey:@"width"] floatValue],
										[[object valueForKey:@"height"] floatValue])
							display:YES
							animate:NO];
		}
	}

}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	//NSLog(@"tableViewSelectionDidChange: %@", aNotification);
	if([editWindow isVisible]) {
		//NSLog(@"Editwindow is visible!");
		NSEnumerator *enumerator = [[coreDataController selectedObjects] objectEnumerator];
		NSWindow *renderWindow;
		id object;
		while((object = [enumerator nextObject])) {
			renderWindow = [renderWindows objectForKey:[object objectID]];
			//NSLog(@"Updating: %@", [object valueForKey:@"name"]);
			if(renderWindow != nil) {
				[renderWindow setMovableByWindowBackground:YES];
			}
		}
	}
}
- (void)tableViewSelectionIsChanging:(NSNotification*)aNotification
{
	NSLog(@"Beware, selection is changing");
	if([editWindow isVisible]) {
		//NSLog(@"Editwindow is visible!");
		NSEnumerator *enumerator = [[coreDataController selectedObjects] objectEnumerator];
		NSWindow *renderWindow;
		id object;
		while((object = [enumerator nextObject])) {
			renderWindow = [renderWindows objectForKey:[object objectID]];
			NSLog(@"Updating: %@", renderWindow);
			if(renderWindow != nil) {
				[renderWindow setMovableByWindowBackground:NO];

				//[[renderWindow contentView] setSelectedDOMRange:nil affinity:NSSelectionAffinityDownstream];
				//[renderWindow setSelectedDOMRange:nil affinity:nil];
			}
		}
	}
}

- (void)windowDidMove:(NSNotification *)aNotification
{
	//NSRect frame = [[aNotification object] frame];
	//NSLog(@"%d", (int)[[aNotification object] frame].origin.x);
	NSEnumerator *enumerator = [[renderWindows allKeysForObject:[aNotification object]] objectEnumerator];
    NSManagedObjectID *window;
	while(window = [enumerator nextObject]) {
		//NSLog(@"Window %@ was moved", [[[coreDataController managedObjectContext] objectWithID:windowName] valueForKey:@"name"]);
		[[[coreDataController managedObjectContext] objectWithID:window]
				setValue:[NSNumber numberWithInt:(int)[[aNotification object] frame].origin.x]
				forKey:@"posX"];
		[[[coreDataController managedObjectContext] objectWithID:window]
				setValue:[NSNumber numberWithInt:(int)[[aNotification object] frame].origin.y]
				forKey:@"posY"];
	}
	//[[aNotification object] 
}

- (void)showRenderWindowForGadget:(NSManagedObject*)object
{
	NSWindow *renderWindow = [renderWindows objectForKey:[object objectID]];
	if(renderWindow == nil) {
		NSLog(@"Render: %@", [object valueForKey:@"name"]);
		
		// Creating a borderless window
		renderWindow =
			[[NSWindow alloc] initWithContentRect:NSMakeRect(	[[object valueForKey:@"posX"] floatValue],
																[[object valueForKey:@"posY"] floatValue],
																[[object valueForKey:@"width"] floatValue],
																[[object valueForKey:@"height"] floatValue])
								styleMask:NSBorderlessWindowMask
								backing:NSBackingStoreBuffered
								defer:NO];
		
		// Make the NSWindow transparent
		[renderWindow setOpaque: NO];
		[renderWindow setBackgroundColor:[NSColor clearColor]];
		
		// Add the WebView
		[renderWindow setContentView:[[WebView alloc] init]];
		// Make the WebView transparent
		[[renderWindow contentView] setDrawsBackground:NO];
		
		//NSLog(@"Body to render:\n%@",[object valueForKey:@"body"]);
		//NSLog(@"contentView class: %@", [[renderWindow contentView] class]);
		//NSLog(@"mainFrame class: %@", [[[renderWindow contentView] mainFrame] class]);
		
		[renderWindow setDelegate:self];
		[[renderWindow contentView] setFrameLoadDelegate:self];
		[[renderWindow contentView] setEditingDelegate:self];
		
		// Loading content
		//NSURL *url = [NSURL fileURLWithPath:[@"~/Library/Application Support/Playhouse/null.html" stringByExpandingTildeInPath] isDirectory:false];
		//NSLog(@"%@", url);
		[[[renderWindow contentView] mainFrame]
			loadHTMLString:[object valueForKey:@"body"]
			baseURL:nil];
		//[[[renderWindow contentView] mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/"]]];
		
		// Show window
		[renderWindow makeKeyAndOrderFront:self];
		[renderWindows setObject:renderWindow forKey:[object objectID]];
	}
}
- (void)hideRenderWindowForGadget:(NSManagedObject*)object
{
	NSWindow *renderWindow = [renderWindows objectForKey:[object objectID]];
	if(renderWindow != nil) {
		[renderWindow release];
		[renderWindows removeObjectForKey:[object objectID]];
	}
}

- (IBAction)showAllRenderWindows:(id)sender
{	
	NSEnumerator *enumerator = [[coreDataController arrangedObjects] objectEnumerator];
	
	id object;
	while((object = [enumerator nextObject])) {
		if([[object valueForKey:@"render"] boolValue]) {
			[self showRenderWindowForGadget:object];
		}
		// WTF?!
	}
}

- (IBAction)newGadget:(id)sender
{
	NSManagedObject *object = [coreDataController newObject];
	[self showRenderWindowForGadget:object];
	//NSLog(@"selectionIndex: %d", [coreDataController selectionIndex]);
	//NSError *error;
	//[[coreDataController managedObjectContext] save:&error];
	//[self showAllRenderWindows:sender];
}

- (IBAction)removeGadget:(id)sender
{
	NSEnumerator *enumerator = [[coreDataController selectedObjects] objectEnumerator];
	NSWindow *renderWindow;
	id object;
	while((object = [enumerator nextObject])) {
		//NSLog(@"Updating: %@", [object valueForKey:@"name"]);
		renderWindow = [renderWindows objectForKey:[object objectID]];
		if(renderWindow != nil) {
			[renderWindow release];
			[renderWindows removeObjectForKey:[object objectID]];
		}
	}

	[coreDataController remove:sender];
}

- (IBAction)showEditWindow:(id)sender
{
	[editWindow makeKeyAndOrderFront:sender];
	[self tableViewSelectionDidChange:[NSNotification notificationWithName:@"NSTableViewSelectionDidChangeNotification" object:NULL]];
}

- (void)webView:(WebView *)sender windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject
{
	//[windowScriptObject evaluateWebScript:@"document.write('digitalclock'); return true;"];
	//NSLog(@"WindowScriptingObject is available!!!");
	[windowScriptObject setValue:shellWrapper forKey:@"shellWrapper"];
	[windowScriptObject setValue:imageInfo forKey:@"imageInfo"];
}

/*
- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange toDOMRange:(DOMRange *)proposedRange affinity:(NSSelectionAffinity)selectionAffinity stillSelecting:(BOOL)flag
{
	NSLog(@"Yay!");
	return NO;
}

- (void)webViewDidChangeSelection:(NSNotification *)aNotification
{
	NSLog(@"Bajs: %@", [[aNotification object] className]);
	[[aNotification object] setSelectedDOMRange:nil affinity:NSSelectionAffinityDownstream];
}
*/
@end
