//
//  Playhouse_AppDelegate.h
//  Playhouse
//
//  Created by Emil Eriksson on 2006-09-07.
//  Copyright __MyCompanyName__ 2006 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Playhouse_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

@end
