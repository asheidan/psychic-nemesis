//
//  NSStringToIntTransformer.m
//  Playhouse
//
//  Created by Emil Eriksson on 2006-09-08.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "NSStringToIntTransformer.h"


@implementation NSStringToIntTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
	return [value stringValue];
}

- (id)reverseTransformedValue:(id)value
{	//NSString* myNSString = (NSString*)someCFString;
	NSString* myCastedValue = (NSString*)value;
	//NSLog(@"reverseTransformedValue: %@",[myCastedValue class]);
	return [NSNumber numberWithInt:[myCastedValue intValue]];
}

@end
