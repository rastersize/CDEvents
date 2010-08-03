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


@implementation CDEventsTestAppController

- (void)run
{
	NSArray *watchedURLs = [NSArray arrayWithObject:
							[NSURL URLWithString:[NSHomeDirectory()
							 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	NSArray *excludeURLs = [NSMutableArray arrayWithObject:
							[[NSHomeDirectory() stringByAppendingPathComponent:@"Downloads"]
							 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	_events = [[CDEvents alloc] initWithURLs:watchedURLs
									delegate:self];
	[_events setExcludedURLs:excludeURLs];
	
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
	NSLog(@"URLWatcher: %@\nEvent: %@", URLWatcher, event);
}

@end
