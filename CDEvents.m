//
//  CDEvents.m
//  CDEvents
//
//  Created by Aron Cedercrantz on 03/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDEvents.h"

#import "CDEventsDelegate.h"

#pragma mark CDEvents custom exceptions
NSString *const CDEventsEventStreamCreationFailureException = @"CDEventsEventStreamCreationFailureException";

#pragma -
#pragma mark Default values
const CDEventsEventStreamCreationFlags kCDEventsDefaultEventStreamFlags =
	(kFSEventStreamCreateFlagUseCFTypes |
	 kFSEventStreamCreateFlagWatchRoot);

const CDEventIdentifier kCDEventsSinceEventNow = kFSEventStreamEventIdSinceNow;


#pragma mark -
#pragma mark Private API
// Private API
@interface CDEvents ()

@property (strong, readwrite) CDEvent *lastEvent;
@property (strong, readwrite) NSArray *watchedURLs;

// The FSEvents callback function
static void CDEventsCallback(
	ConstFSEventStreamRef streamRef,
	void *callbackCtxInfo,
	size_t numEvents,
	void *eventPaths,
	const FSEventStreamEventFlags eventFlags[],
	const FSEventStreamEventId eventIds[]);

// Creates and initiates the event stream.
- (void)createEventStream;
// Disposes of the event stream.
- (void)disposeEventStream;

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
	[self disposeEventStream];
	
	_delegate = nil;
	
	
}

- (void)finalize
{
	[self disposeEventStream];
	
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
		 sinceEventIdentifier:kCDEventsSinceEventNow
		 notificationLantency:CD_EVENTS_DEFAULT_NOTIFICATION_LATENCY
	  ignoreEventsFromSubDirs:CD_EVENTS_DEFAULT_IGNORE_EVENT_FROM_SUB_DIRS
				  excludeURLs:nil
		  streamCreationFlags:kCDEventsDefaultEventStreamFlags];
}

- (id)initWithURLs:(NSArray *)URLs
		  delegate:(id<CDEventsDelegate>)delegate
		   onRunLoop:(NSRunLoop *)runLoop
sinceEventIdentifier:(CDEventIdentifier)sinceEventIdentifier
notificationLantency:(CFTimeInterval)notificationLatency
ignoreEventsFromSubDirs:(BOOL)ignoreEventsFromSubDirs
		 excludeURLs:(NSArray *)exludeURLs
 streamCreationFlags:(CDEventsEventStreamCreationFlags)streamCreationFlags
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
		_eventStreamCreationFlags = streamCreationFlags;
		
		_notificationLatency = notificationLatency;
		_ignoreEventsFromSubDirectories = ignoreEventsFromSubDirs;
		
		_lastEvent = nil;
		
		[self createEventStream];
		
		FSEventStreamScheduleWithRunLoop(_eventStream,
										 [runLoop getCFRunLoop],
										 kCFRunLoopDefaultMode);
		if (!FSEventStreamStart(_eventStream)) {
			[NSException raise:CDEventsEventStreamCreationFailureException
						format:@"Failed to create event stream."];
		}
	}
	
	return self;
}


#pragma mark NSCopying method
- (id)copyWithZone:(NSZone *)zone
{
	CDEvents *copy = [[CDEvents alloc] initWithURLs:[self watchedURLs]
										   delegate:[self delegate]
										  onRunLoop:[NSRunLoop currentRunLoop]
							   sinceEventIdentifier:[self sinceEventIdentifier]
							   notificationLantency:[self notificationLatency]
							ignoreEventsFromSubDirs:[self ignoreEventsFromSubDirectories]
										excludeURLs:[self excludedURLs]
								streamCreationFlags:_eventStreamCreationFlags];
	
	return copy;
}


#pragma mark Flush methods
- (void)flushSynchronously
{
	FSEventStreamFlushSync(_eventStream);
}

- (void)flushAsynchronously
{
	FSEventStreamFlushAsync(_eventStream);
}


#pragma mark Misc methods
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { watchedURLs = %@ }>",
			[self className],
			self,
			[self watchedURLs]];
}

- (NSString *)streamDescription
{
	CFStringRef streamDescriptionCF = FSEventStreamCopyDescription(_eventStream);
	NSString *returnString = [[NSString alloc] initWithString:(__bridge NSString *)streamDescriptionCF];
	CFRelease(streamDescriptionCF);
	
	return returnString;
}


#pragma mark Private API:
- (void)createEventStream
{
	FSEventStreamContext callbackCtx;
	callbackCtx.version			= 0;
	callbackCtx.info			= (__bridge void *)self;
	callbackCtx.retain			= NULL;
	callbackCtx.release			= NULL;
	callbackCtx.copyDescription	= NULL;
	
	NSMutableArray *watchedPaths = [NSMutableArray arrayWithCapacity:[[self watchedURLs] count]];
	for (NSURL *URL in [self watchedURLs]) {
		[watchedPaths addObject:[URL path]];
	}
	
	_eventStream = FSEventStreamCreate(kCFAllocatorDefault,
									   &CDEventsCallback,
									   &callbackCtx,
									   (__bridge CFArrayRef)watchedPaths,
									   (FSEventStreamEventId)[self sinceEventIdentifier],
									   [self notificationLatency],
									   _eventStreamCreationFlags);
}

- (void)disposeEventStream
{
	if (!(_eventStream)) {
		return;
	}
	
	FSEventStreamStop(_eventStream);
	FSEventStreamInvalidate(_eventStream);
	FSEventStreamRelease(_eventStream);
	_eventStream = NULL;
}

static void CDEventsCallback(
	ConstFSEventStreamRef streamRef,
	void *callbackCtxInfo,
	size_t numEvents,
	void *eventPaths,
	const FSEventStreamEventFlags eventFlags[],
	const FSEventStreamEventId eventIds[])
{
	CDEvents *watcher = (__bridge CDEvents *)callbackCtxInfo;
	
	NSArray *watchedURLs		= [watcher watchedURLs];
	NSArray *excludedURLs		= [watcher excludedURLs];
	NSArray *eventPathsArray	= (__bridge NSArray *)eventPaths;
	BOOL shouldIgnore = NO;
	
	for (NSUInteger i = 0; i < numEvents; ++i) {
		shouldIgnore = NO;
		
		NSString *eventPath = [[eventPathsArray objectAtIndex:i]
							   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL *eventURL		= [NSURL URLWithString:eventPath];
		// We do this hackery to ensure that the eventPath string doesn't
		// contain any trailing slash.
		eventPath			= [eventURL path];
		
		if ([watcher ignoreEventsFromSubDirectories]) {
			shouldIgnore = YES;
			for (NSURL *URL in watchedURLs) {
				if ([[URL path] isEqualToString:eventPath]) {
					shouldIgnore = NO;
					break;
				}
			}
		} else if (excludedURLs != nil) {
			for (NSURL *URL in excludedURLs) {
				if ([eventPath hasPrefix:[URL path]]) {
					shouldIgnore = YES;
					break;
				}
			}
		}
		
		if (!shouldIgnore) {
			CDEvent *event = [[CDEvent alloc] initWithIdentifier:eventIds[i]
												   date:[NSDate date]
													URL:eventURL
												  flags:eventFlags[i]];
			
			if ([(id)[watcher delegate] conformsToProtocol:@protocol(CDEventsDelegate)]) {
				[[watcher delegate] URLWatcher:watcher eventOccurred:event];
			}
			
			// Last event?
			if (i == (numEvents - 1)) {
				[watcher setLastEvent:event];
			}
			
		}
	}
	
	
}

@end
