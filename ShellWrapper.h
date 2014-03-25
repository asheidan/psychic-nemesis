//
//  ShellWrapper.h
//  Playhouse
//
//  Created by Emil Eriksson on 2006-09-16.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ShellWrapper : NSObject {

}

- (NSString *)executeCommand:(NSString *)command;

@end
