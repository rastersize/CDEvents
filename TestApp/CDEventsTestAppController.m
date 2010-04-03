//
//  CDEventsTestAppController.m
//  CDEvents
//
//  Created by Aron Cedercrantz on 03/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDEventsTestAppController.h"

#import <CDEvents/CDEvent.h>
#import <CDEvents/CDEvents.h>


@implementation CDEventsTestAppController

- (void)run
{
	NSArray *watchedURLs = [NSArray arrayWithObject:
							[NSURL URLWithString:NSHomeDirectory()]];
	NSArray *excludeURLs = [NSMutableArray arrayWithObject:
							[NSHomeDirectory() stringByAppendingPathComponent:@"Downloads"]];
	
	_events = [[CDEvents alloc] initWithURLs:watchedURLs
									delegate:self];
	[_events setExcludedURLs:excludeURLs];
	
	NSLog(@"-[CDEventsTestAppController init]:\n%@\n------\n%@",
		  _events,
		  [_events streamDescription]);
}

- (void)dealloc
{
	[_events setDelegate:nil];
	[_events release];
	
	[super dealloc];
}

- (void)URLWatcher:(CDEvents *)URLWatcher eventOccurred:(CDEvent *)event
{
	NSLog(@"URLWatcher: %@\nEvent: %@", URLWatcher, event);
}

@end
