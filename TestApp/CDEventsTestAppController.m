/**
 * CDEvents
 *
 * Copyright (c) 2010-2013 Aron Cedercrantz
 * http://github.com/rastersize/CDEvents/
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#import "CDEventsTestAppController.h"

#import <CDEvents/CDEvent.h>
#import <CDEvents/CDEvents.h>


#define CD_EVENTS_TEST_APP_USE_BLOCKS_API				1


@implementation CDEventsTestAppController

- (void)run
{	
	NSArray *watchedURLs = [NSArray arrayWithObject:
							[NSURL URLWithString:[NSHomeDirectory()
							 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	NSArray *excludeURLs = [NSMutableArray arrayWithObject:
							[NSURL URLWithString:[[NSHomeDirectory() stringByAppendingPathComponent:@"Downloads"]
									stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
    CDEventsEventStreamCreationFlags creationFlags = kCDEventsDefaultEventStreamFlags;

    if (floor(NSAppKitVersionNumber) >= NSAppKitVersionNumber10_6) {
        creationFlags |= kFSEventStreamCreateFlagIgnoreSelf;
    }
    if (floor(NSAppKitVersionNumber) >= NSAppKitVersionNumber10_7) {
        creationFlags |= kFSEventStreamCreateFlagFileEvents;
    }

#if CD_EVENTS_TEST_APP_USE_BLOCKS_API
	_events = [[CDEvents alloc] initWithURLs:watchedURLs
									   block:^(CDEvents *watcher, CDEvent *event){ NSLog(@"[Block] URLWatcher: %@\nEvent: %@", watcher, event); }
								   onRunLoop:[NSRunLoop currentRunLoop]
						sinceEventIdentifier:kCDEventsSinceEventNow
						notificationLantency:CD_EVENTS_DEFAULT_NOTIFICATION_LATENCY
					 ignoreEventsFromSubDirs:CD_EVENTS_DEFAULT_IGNORE_EVENT_FROM_SUB_DIRS
								 excludeURLs:excludeURLs
						 streamCreationFlags:creationFlags];
#else
	_events = [[CDEvents alloc] initWithURLs:watchedURLs
									delegate:self
								   onRunLoop:[NSRunLoop currentRunLoop]
						sinceEventIdentifier:kCDEventsSinceEventNow
						notificationLantency:CD_EVENTS_DEFAULT_NOTIFICATION_LATENCY
					 ignoreEventsFromSubDirs:CD_EVENTS_DEFAULT_IGNORE_EVENT_FROM_SUB_DIRS
								 excludeURLs:excludeURLs
						 streamCreationFlags:creationFlags];
	//[_events setIgnoreEventsFromSubDirectories:YES];
#endif
	
	NSLog(@"-[CDEventsTestAppController run]:\n%@\n------\n%@",
		  _events,
		  [_events streamDescription]);
}

- (void)dealloc
{
	[_events setDelegate:nil];
	[_events release];
	
	[super dealloc];
}

- (void)URLWatcher:(CDEvents *)urlWatcher eventOccurred:(CDEvent *)event
{
	NSLog(@"[Delegate] URLWatcher: %@\nEvent: %@", urlWatcher, event);
}

@end
