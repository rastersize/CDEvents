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

#import <CDEvents/CDEvent.h>

@protocol CDEventsDelegate;

#pragma mark -
#pragma mark CDEvents custom exceptions
extern NSString *const CDEventsEventStreamCreationFailureException;


#pragma mark -
#pragma mark Default values
/**
 * The default notificaion latency.
 *
 * @since 1.0.0
 */
#define CD_EVENTS_DEFAULT_NOTIFICATION_LATENCY			(NSTimeInterval)3.0

/**
 * The default value wheter events from sub directories should be ignored or not.
 *
 * @since 1.0.0
 */
#define CD_EVENTS_DEFAULT_IGNORE_EVENT_FROM_SUB_DIRS	NO


#pragma mark -
#pragma mark CDEvents interface
/**
 * An Objective-C wrapper for the <code>FSEvents</code> C API.
 *
 * @note Inpired by <code>SCEvents</code> class of the <code>SCEvents</code> project by Stuart Connolly.
 *
 * @see FSEvents.h in CoreServices
 *
 * @since 1.0.0
 */
@interface CDEvents : NSObject <NSCopying> {
@private
	id<CDEventsDelegate>		_delegate;
	
	FSEventStreamRef			_eventStream;
	CFTimeInterval				_notificationLatency;
	
	CDEventIdentifier			_sinceEventIdentifier;
	
	BOOL						_ignoreEventsFromSubDirectories;
	
	CDEvent						*_lastEvent;
	
	NSArray						*_watchedURLs;
	NSArray						*_excludedURLs;
}

#pragma mark Properties
/**
 * The delegate object the <code>CDEvents</code> object calls when it recieves an event.
 *
 * @param delegate Delegate for the events object. <code>nil</code> removed the delegate.
 * @return The events's delegate.
 *
 * @since 1.0.0
 */
@property (assign) id<CDEventsDelegate>		delegate;

/**
 * The (approximate) time intervall between notifications sent to the delegate.
 *
 * @return The time intervall between notifications.
 *
 * @since 1.0.0
 */
@property (readonly) CFTimeInterval			notificationLatency;

/**
 * The event identifier from which events will be supplied to the delegate.
 *
 * @return The event identifier from which events will be supplied to the delegate.
 *
 * @since 1.0.0
 */
@property (readonly) CDEventIdentifier		sinceEventIdentifier;

/**
 * Wheter events from sub-directories of the watched URLs should be ignored or not.
 *
 * @param flag Wheter events from sub-directories of the watched URLs shouled be ignored or not.
 * @return <code>YES</code> if events from sub-directories should be ignored, otherwise <code>NO</code>.
 *
 * @since 1.0.0
 */
@property (assign) BOOL						ignoreEventsFromSubDirectories;

/**
 * The last event that occured and thas has been delivered to the delegate.
 *
 * @return The last event that occured and thas has been delivered to the delegate.
 *
 * @since 1.0.0
 */
@property (retain) CDEvent					*lastEvent;

/**
 * The URLs that we watch for events.
 *
 * @return An array of <code>NSURL</code> object for the URLs which we watch for events.
 *
 * @since 1.0.0
 */
@property (readonly) NSArray				*watchedURLs;

/**
 * The URLs that we should ignore events from. 
 *
 * @return An array of <code>NSURL</code> object for the URLs which we want to ignore.
 * @discussion Events from concerning these URLs and there sub-directories will not be delivered to the delegate.
 *
 * @since 1.0.0
 */
@property (copy) NSArray					*excludedURLs;


#pragma mark Event identifier class methods
/**
 * The current event identifier.
 *
 * @return The current event identifier.
 *
 * @see FSEventsGetCurrentEventId(void)
 *
 * @since 1.0.0
 */
+ (CDEventIdentifier)currentEventIdentifier;

/**
 * The last event identifier for the given device that was returned before the given date and time
 *
 * @param URL The URL of the item the event identifier is sought for, used to find the device.
 * @param time The date and time.
 * @return The last event identifier for the given URL that was returned before the given time
 *
 * @see FSEventsGetLastEventIdForDeviceBeforeTime(dev_t, CFAbsoluteTime)
 *
 * @since 1.1.0
 */
+ (CDEventIdentifier)lastEventIdentifierForURL:(NSURL *)URL time:(NSDate *)time;


#pragma mark Init methods
/**
 * Returns an <code>CDEvents</code> object initialized with the given URLs to watch.
 *
 * @param URLs An array of URLs we want to watch.
 * @param delegate The delegate object the <code>CDEvents</code> object calls when it recieves an event.
 * @return An <code>CDEvents</code> object initialized with the given URLs to watch. 
 * @throws NSInvalidArgumentException if <em>URLs</em> is empty or points to <code>nil</code>.
 * @throws NSInvalidArgumentException if <em>delegate</em>is <code>nil</code>.
 *
 * @see startWatchingURLs:delegate:onRunLoop:
 * @see startWatchingURLs:delegate:onRunLoop:notificationLantency:ignoreEventsFromSubDirs:excludeURLs:
 * @see stopWatchingURLs
 *
 * @discussion Calls startWatchingURLs:onRunLoop:notificationLantency:ignoreEventsFromSubDirs:excludeURLs:
 * with <em>sinceEventIdentifier</em> with the current event identifier,
 * <em>notificationLatency</em> set to 3.0 seconds,
 * <em>ignoreEventsFromSubDirectories</em> set to <code>NO</code>
 * <em>excludedURLs</em> to no URLs and schedueled on the current run loop.
 *
 * @since 1.0.0
 */
- (id)initWithURLs:(NSArray *)URLs delegate:(id<CDEventsDelegate>)delegate;

/**
 * Returns an <code>CDEvents</code> object initialized with the given URLs to watch and schedules the watcher on the given run loop.
 *
 * @param URLs An array of URLs we want to watch.
 * @param delegate The delegate object the <code>CDEvents</code> object calls when it recieves an event.
 * @param The run loop which the which the watcher should be schedueled on.
 * @return An <code>CDEvents</code> object initialized with the given URLs to watch.
 * @throws NSInvalidArgumentException if <em>URLs</em> is empty or points to <code>nil</code>.
 * @throws NSInvalidArgumentException if <em>delegate</em>is <code>nil</code>.
 *
 * @see startWatchingURLs:
 * @see startWatchingURLs:onRunLoop:notificationLantency:ignoreEventsFromSubDirs:excludeURLs:
 * @see stopWatchingURLs
 *
 * @discussion Calls startWatchingURLs:onRunLoop:notificationLantency:ignoreEventsFromSubDirs:excludeURLs:
 * with <em>runLoop</em> set to the current run loop, <em>sinceEventIdentifier</em>
 * with the current event identifier, <em>notificationLatency</em> set to 3.0
 * seconds, <em>ignoreEventsFromSubDirectories</em> set to <code>NO</code>
 * <em>excludedURLs</em> to no URLs.
 *
 * @since 1.0.0
 */
- (id)initWithURLs:(NSArray *)URLs
			delegate:(id<CDEventsDelegate>)delegate
		  onRunLoop:(NSRunLoop *)runLoop;

/**
 * Returns an <code>CDEvents</code> object initialized with the given URLs to watch, URLs to exclude, wheter events from sub-directories are ignored or not and schedules the watcher on the given run loop.
 *
 * @param URLs An array of URLs we want to watch.
 * @param delegate The delegate object the <code>CDEvents</code> object calls when it recieves an event.
 * @param runLoop The run loop which the which the watcher should be schedueled on.
 * @param sinceEventIdentifier Events that have happened after the given event identifier will be supplied.
 * @param notificationLatency The (approximate) time intervall between notifications sent to the delegate.
 * @param ignoreEventsFromSubDirs Wheter events from sub-directories of the watched URLs should be ignored or not.
 * @param exludeURLs An array of URLs that we should ignore events from. Pass <code>nil</code> if none should be excluded.
 * @return An <code>CDEvents</code> object initialized with the given URLs to watch, URLs to exclude, wheter events from sub-directories are ignored or not and run on the given run loop.
 * @throws NSInvalidArgumentException if the parameter URLs is empty or points to <code>nil</code>.
 * @throws NSInvalidArgumentException if <em>delegate</em>is <code>nil</code>.
 *
 * @see startWatchingURLs:
 * @see startWatchingURLs:onRunLoop:
 * @see stopWatchingURLs
 * @see ignoreEventsFromSubDirectories
 * @see excludedURLs
 *
 * @discussion To ask for events "since now" pass the return value of
 * currentEventIdentifier as the parameter sinceEventIdentifier.
 *
 * @since 1.0.0
 */
- (id)initWithURLs:(NSArray *)URLs
			delegate:(id<CDEventsDelegate>)delegate
		   onRunLoop:(NSRunLoop *)runLoop
sinceEventIdentifier:(CDEventIdentifier)sinceEventIdentifier
notificationLantency:(CFTimeInterval)notificationLatency
ignoreEventsFromSubDirs:(BOOL)ignoreEventsFromSubDirs
		 excludeURLs:(NSArray *)exludeURLs;

#pragma mark Flush methods

/**
 * Flushes the event stream synchronously.
 *
 * Flushes the event stream synchronously by sending events that have already occurred but not yet delivered.
 *
 * @see flushAsynchronously
 *
 * @since 1.0.0
 */
- (void)flushSynchronously;

/**
 * Flushes the event stream asynchronously.
 *
 * Flushes the event stream asynchronously by sending events that have already occurred but not yet delivered.
 *
 * @see flushSynchronously
 *
 * @since 1.0.0
 */
- (void)flushAsynchronously;

#pragma mark Misc methods
/**
 * Returns a NSString containing the description of the current event stream.
 *
 * @return A NSString containing the description of the current event stream.
 *
 * @see FSEventStreamCopyDescription
 *
 * @discussion For debugging only.
 *
 * @since 1.0.0
 */
- (NSString *)streamDescription;

@end
