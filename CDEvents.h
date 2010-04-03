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

/**
 * @headerfile CDEvents.h CDEvents/CDEvents.h
 * A class that wraps the <code>FSEvents</code> C API.
 * 
 * A class that wraps the <code>FSEvents</code> C API. Inspired and based
 * upon the open source project SCEvents created by Stuart Connolly
 * http://stuconnolly.com/projects/code/
 */

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

@class CDEvent;
@protocol CDEventsDelegate;

/**
 * An Objective-C wrapper for the <code>FSEvents</code> C API.
 *
 * @since 1.0.0
 * @note Inpired by <code>SCEvents</code> class of the <code>SCEvents</code> project by Stuart Connolly.
 * @note The class is immutable.
 * @see FSEvents.h in CoreServices
 */
@interface CDEvents : NSObject {
@private
	id<CDEventsDelegate>		_delegate;
	
	FSEventStreamRef			_eventStream;
	CFTimeInterval				_notificationLatency;
	
	BOOL						_isWatchingURLs;
	BOOL						_ignoreEventsFromSubDirectories;
	
	CDEvent						*_lastEvent;
	
	NSMutableArray				*_watchedURLs;
	NSMutableArray				*_excludedURLs;
}

#pragma mark Properties
/**
 * The delegate object the <code>CDEvents</code> object calls when it recieves an event.
 *
 * @param delegate Delegate for the events object. <code>nil</code> removed the delegate.
 * @return The events's delegate.
 */
@property (assign) id<CDEventsDelegate>		delegate;

/**
 * The time intervall of which the delegate is notified of by events.
 *
 * @return The time intervall between notifications.
 */
@property (readonly) CFTimeInterval			notificationLatency;

/**
 * Wheter we are watching the given URLs or not.
 *
 * @return <code>YES</code> if we are currently wathing the given URLs, otherwise <code>NO</code>.
 */
@property (readonly) BOOL					isWatchingURLs;

/**
 * Wheter events from sub-directories of the watched URLs should be ignored or not.
 *
 * @param flag Wheter events from sub-directories of the watched URLs shouled be ignored or not.
 * @return <code>YES</code> if events from sub-directories should be ignored, otherwise <code>NO</code>.
 */
@property (assign) BOOL						ignoreEventsFromSubDirectories;

/**
 * The last event that occured and thas has been delivered to the delegate.
 *
 * @return The last event that occured and thas has been delivered to the delegate.
 */
@property (readonly) CDEvent				*lastEvent;

/**
 * The URLs that we watch for events.
 *
 * @return An array of <code>NSURL</code> object for the URLs which we watch for events.
 */
@property (readonly) NSArray				*watchedURLs;

/**
 * The URLs that we should ignore events for. 
 *
 * @return A mutable array of <code>NSURL</code> object for the URLs which we want to ignore.
 * @discussion Events from these URLs will not be delivered to the delegate.
 */
@property (copy) NSMutableArray				*excludedURLs;


#pragma mark Init methods



@end
