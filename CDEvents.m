//
//  CDEvents.m
//  CDEvents
//
//  Created by Aron Cedercrantz on 03/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDEvents.h"


#pragma mark Private API
// Private API
@interface CDEvents ()

@end


#pragma mark -
#pragma mark Implementation
@implementation CDEvents

#pragma mark Properties
@synthesize delegate						= _delegate;
@synthesize notificationLatency				= _notificationLatency;
@synthesize isWatchingURLs					= _isWatchingURLs;
@synthesize ignoreEventsFromSubDirectories	= _ignoreEventsFromSubDirectories;
@synthesize lastEvent						= _lastEvent;
@synthesize watchedURLs						= _watchedURLs;
@synthesize excludedURLs					= _excludedURLs;

@end
