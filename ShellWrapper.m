//
//  ShellWrapper.m
//  Playhouse
//
//  Created by Emil Eriksson on 2006-09-16.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ShellWrapper.h"


@implementation ShellWrapper

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
	/*
	if(aSelector == @selector(executeCommand:))
		return NO;
	else
	*/
		return NO;
}
+ (NSString *) webScriptNameForSelector:(SEL)aSelector
{
    if (aSelector == @selector(executeCommand:))
		return @"executeCommand";
	else
		return nil;
 }


- (NSString *)executeCommand:(NSString *)command
{
	//NSLog(@"Entering executeCommand with: %@", command);
	NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];

/*
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"-l", @"-a", @"-t", nil];
    [task setArguments: arguments];
*/
    NSPipe *outPipe,*inPipe;
	
	inPipe = [NSPipe pipe];
	[task setStandardInput:inPipe];
	
	NSFileHandle *input;
	input = [inPipe fileHandleForWriting];
    //////////////////////////////////
	
	outPipe = [NSPipe pipe];
    [task setStandardOutput: outPipe];

    NSFileHandle *file;
    file = [outPipe fileHandleForReading];

    [task launch];
	//NSLog(@"Task is launched: %@", task);

	[input writeData:[NSData dataWithBytes:[command UTF8String] length:[command length]]];
	[input closeFile];
	//NSLog(@"Task input is closed: %@", task);

    NSData *data;
    data = [file readDataToEndOfFile];

    NSString *string;
    string = [[NSString alloc] initWithData: data
                               encoding: NSUTF8StringEncoding];
    //NSLog (@"woop!  got\n%@", string);
	[task terminate];
	[task waitUntilExit];
	/*
	if([task isRunning]){
		NSLog(@"Task is still running...");
	}
	else {
		NSLog(@"Task is terminated: %@", task);
	}
	*/

	[task autorelease];
	//[outPipe autorelease];
	//[inPipe release];
	//[data release];
	[string autorelease];
	//NSLog(@"This is what the task is: %@", task);
	
	return string;
}

@end
