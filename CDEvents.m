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
@synthesize sinceEventIdentifier			= _sinceEventIdentifier;
@synthesize ignoreEventsFromSubDirectories	= _ignoreEventsFromSubDirectories;
@synthesize lastEvent						= _lastEvent;
@synthesize watchedURLs						= _watchedURLs;
@synthesize excludedURLs					= _excludedURLs;


#pragma mark Event identifier class methods
+ (CDEventIdentifier)currentEventIdentifier
{
	return (NSUInteger)FSEventsGetCurrentEventId();
}


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

- (id)initWithURLs:(NSArray *)URLs delegate:(id<CDEventsDelegate>)delegate
{
	return [self initWithURLs:URLs
					 delegate:delegate
					onRunLoop:[NSRunLoop currentRunLoop]];
}

- (id)initWithURLs:(NSArray *)URLs
			delegate:(id<CDEventsDelegate>)delegate
		   onRunLoop:(NSRunLoop *)runLoop
{
	return [self initWithURLs:URLs
					 delegate:delegate
					onRunLoop:runLoop
		 sinceEventIdentifier:[CDEvents currentEventIdentifier]
		 notificationLantency:CD_EVENTS_DEFAULT_NOTIFICATION_LATENCY
	  ignoreEventsFromSubDirs:CD_EVENTS_DEFAULT_IGNORE_EVENT_FROM_SUB_DIRS
				  excludeURLs:nil];
}

- (id)initWithURLs:(NSArray *)URLs
		  delegate:(id<CDEventsDelegate>)delegate
		   onRunLoop:(NSRunLoop *)runLoop
sinceEventIdentifier:(CDEventIdentifier)sinceEventIdentifier
notificationLantency:(CFTimeInterval)notificationLatency
ignoreEventsFromSubDirs:(BOOL)ignoreEventsFromSubDirs
		 excludeURLs:(NSArray *)exludeURLs
{
	if (delegate == nil || URLs == nil || [URLs count] == 0) {
		[NSException raise:NSInvalidArgumentException
					format:@"Invalid arguments passed to CDEvents init-method."];
	}
	
	if ((self = [super init])) {
		_watchedURLs = [URLs copy];
		[self setExcludedURLs:exludeURLs];
		[self setDelegate:delegate];
		
		_sinceEventIdentifier = sinceEventIdentifier;
		
		_notificationLatency = notificationLatency;
		_ignoreEventsFromSubDirectories = ignoreEventsFromSubDirs;
		
		_lastEvent = nil;
		
		[self createEventsStream];
		
		FSEventStreamScheduleWithRunLoop(_eventStream,
										 [runLoop getCFRunLoop],
										 kCFRunLoopDefaultMode);
		if (!FSEventStreamStart(_eventStream)) {
			return nil;
		}
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


#pragma mark Private API:



@end
