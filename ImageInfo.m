//
//  ImageInfo.m
//  Playhouse
//
//  Created by Emil Eriksson on 2006-09-16.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ImageInfo.h"


@implementation ImageInfo

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
	return NO;
}

+ (NSString *) webScriptNameForSelector:(SEL)aSelector
{
    if (aSelector == @selector(imageSize:))
		return @"imageSize";
	else
		return nil;
 }
 
 - (NSArray *)imageSize:(NSString *)url
 {
	NSLog(@"Entered imageSize: %@", url);
	NSArray *imageReps = [NSImageRep imageRepsWithContentsOfURL:[NSURL URLWithString:url]];
	NSLog(@"imagerep: %@", imageReps);
	NSImageRep *image = [imageReps lastObject];
	NSLog(@"image: %@",image);
	NSLog(@"Size: %ld,%ld",(long)[image pixelsWide],(long)[image pixelsHigh]);
	NSNumber *width = [NSNumber numberWithInt:[image pixelsWide]];
	NSNumber *height = [NSNumber numberWithInt:[image pixelsHigh]];
	//[image release];
	NSArray *result = [NSArray arrayWithObjects:width, height, nil];
	NSLog(@"%@",result);
	return result;
 }

@end
