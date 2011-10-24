/**
 * CDEvents
 *
 * Copyright (c) 2010 Aron Cedercrantz
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


bool systemVersionIsAtLeast(SInt32 major, SInt32 minor)
{
    static SInt32 versionMajor = 0, versionMinor = 0;

    if (versionMajor == 0) {
        Gestalt(gestaltSystemVersionMajor, &versionMajor);
    }

    if (versionMinor == 0) {
        Gestalt(gestaltSystemVersionMinor, &versionMinor);
    }

    return ((versionMajor > major) ||
            ((versionMajor == major) && (versionMinor >= minor)));
}


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

    if (systemVersionIsAtLeast(10,6)) {
        creationFlags |= kFSEventStreamCreateFlagIgnoreSelf;
    }

    if (systemVersionIsAtLeast(10,7)) {
        creationFlags |= kFSEventStreamCreateFlagFileEvents;
    }

	_events = [[CDEvents alloc] initWithURLs:watchedURLs
									delegate:self
								   onRunLoop:[NSRunLoop currentRunLoop]
						sinceEventIdentifier:kCDEventsSinceEventNow
						notificationLantency:CD_EVENTS_DEFAULT_NOTIFICATION_LATENCY
					 ignoreEventsFromSubDirs:CD_EVENTS_DEFAULT_IGNORE_EVENT_FROM_SUB_DIRS
								 excludeURLs:excludeURLs
						 streamCreationFlags:creationFlags];
	//[_events setIgnoreEventsFromSubDirectories:YES];
	
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

- (void)URLWatcher:(CDEvents *)URLWatcher eventOccurred:(CDEvent *)event
{
	NSLog(@"[Delegate] URLWatcher: %@\nEvent: %@", URLWatcher, event);
}

@end
