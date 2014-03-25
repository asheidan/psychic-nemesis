//
//  main.m
//  Playhouse
//
//  Created by Emil Eriksson on 2006-09-07.
//  Copyright __MyCompanyName__ 2006. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSStringToIntTransformer.h"

int main(int argc, char *argv[])
{

	NSAutoreleasePool *pool;
	NSStringToIntTransformer *intTransfomer;
	
	pool = [[NSAutoreleasePool alloc] init];
	
	intTransfomer = [[[NSStringToIntTransformer alloc] init] autorelease];
	//intTransfomer = [[NSStringToIntTransformer alloc] init];

	[NSValueTransformer setValueTransformer:intTransfomer
                                forName:@"NSStringToIntTransformer"];

    return NSApplicationMain(argc,  (const char **) argv);
}
