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

#pragma mark Init/dealloc/finalize methods
- (void)dealloc
{
	[self stopWatchingURLs];
	
	_delegate = nil;
	
	[_lastEvent release];
	[_watchedURLs release];
	[_excludedURLs release];
	
	[super dealloc];
}

- (void)finalize
{
	[self stopWatchingURLs];
	
	_delegate = nil;
	
	[super finalize];
}

- (id)init
{
	if ((self = [super init])) {
		_delegate = nil;
		_notificationLatency = CD_EVENTS_DEFAULT_NOTIFICATION_LATENCY;
		_isWatchingURLs = NO;
		_ignoreEventsFromSubDirectories = CD_EVENTS_DEFAULT_IGNORE_EVENT_FROM_SUB_DIRS;
		_lastEvent = nil;
		_watchedURLs = nil;
		_excludedURLs = nil;
	}
	
	return self;
}


#pragma mark NSCopying method
- (id)copyWithZone:(NSZone *)zone
{
	CDEvents *copy = [[CDEvents alloc] init];
	
	copy->_delegate = _delegate;
	copy->_notificationLatency = _notificationLatency;
	copy->_ignoreEventsFromSubDirectories = _ignoreEventsFromSubDirectories;
	copy->_lastEvent = [[self lastEvent] retain];
	copy->_isWatchingURLs = NO;
	copy->_watchedURLs = [[self watchedURLs] copyWithZone:zone];
	copy->_excludedURLs = [[self excludedURLs] copyWithZone:zone];
	
	return copy;
}



#pragma mark Misc methods
+ (NSUInteger)currentEventIdentifier
{
	return (NSUInteger)FSEventsGetCurrentEventId();
}


@end
