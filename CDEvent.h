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
 * @headerfile CDEvent.h CDEvents/CDEvent.h
 * A class that wraps the data from a FSEvents event callback.
 * 
 * A class that wraps the data from a FSEvents event callback. Inspired and
 * based upon the open source project SCEvents created by Stuart Connolly
 * http://stuconnolly.com/projects/code/
 */

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>


#pragma mark -
#pragma mark CDEvent types
/**
 * The event identifier type.
 *
 * @since 1.0.0
 */
typedef FSEventStreamEventId CDEventIdentifier;

/**
 * The event stream event flags type.
 *
 * @since 1.0.1
 */
typedef FSEventStreamEventFlags CDEventFlags;


#pragma mark -
#pragma mark CDEvent interface
/**
 * An Objective-C wrapper for a <code>FSEvents</code> event data.
 *
 * @note Inpired by <code>SCEvent</code> class of the <code>SCEvents</code> project by Stuart Connolly.
 * @note The class is immutable.
 *
 * @see FSEvents.h in CoreServices
 *
 * @since 1.0.0
 */
@interface CDEvent : NSObject <NSCoding, NSCopying> {
@private
	CDEventIdentifier			_identifier;
	NSDate						*_date;
	NSURL						*_URL;
	CDEventFlags				_flags;
}

#pragma mark Properties
/**
 * The event identifier.
 *
 * The event identifier as returned by <code>FSEvents</code>.
 *
 * @return The event identifier.
 *
 * @since 1.0.0
 */
@property (readonly) CDEventIdentifier			identifier;

/**
 * An approximate date and time the event occured.
 *
 * @return The approximate date and time the event occured.
 *
 * @since 1.0.0
 */
@property (readonly) NSDate						*date;

/**
 * The URL of the item which changed.
 *
 * @return The URL of the item which changed.
 *
 * @since 1.0.0
 */
@property (readonly) NSURL						*URL;

/**
 * The flags of the event.
 *
 * The flags of the event as returned by <code>FSEvents</code>.
 *
 * @return The flags of the event.
 *
 * @see FSEventStreamEventFlags
 *
 * @since 1.0.0
 */
@property (readonly) CDEventFlags				flags;

/**
 * Wheter there was some change in the directory at the specific path supplied in this event.
 *
 * @return <code>YES</code> if there was some change in the directory, otherwise <code>NO</code>
 *
 * @see kFSEventStreamEventFlagNone
 * @see flags
 * @see mustRescanSubDirectories
 * @see isUserDropped
 * @see isKernelDropped
 * @see isEventIdsWrapped
 * @see isHistoryDone
 * @see isRootChanged
 * @see didVolumeMount
 * @see didVolumeUnmount
 *
 * @since head
 */
@property (readonly) BOOL						isGenericChange;

/**
 * Wheter you must rescan the whole URL including its children.
 *
 * Wheter your application must rescan not just the URL given in the event, but
 * all its children, recursively. This can happen if there was a problem whereby
 * events were coalesced hierarchically. For example, an event in
 * <code>/Users/jsmith/Music</code> and an event in
 * <code>/Users/jsmith/Pictures</code> might be coalesced into an event with
 * this flag set and <i>URL</i><code>=/Users/jsmith</code>. If this flag is set
 * you may be able to get an idea of whether the bottleneck happened in the
 * kernel (less likely) or in your client (more likely) by checking if
 * flagUserDropped or flagKernelDropped returns <code>YES</code>.
 *
 * @return <code>YES</code> if you must rescan the whole directory including its children, otherwise <code>NO</code>
 *
 * @see kFSEventStreamEventFlagMustScanSubDirs
 * @see flags
 * @see isGenericChange
 * @see isUserDropped
 * @see isKernelDropped
 * @see isEventIdsWrapped
 * @see isHistoryDone
 * @see isRootChanged
 * @see didVolumeMount
 * @see didVolumeUnmount
 *
 * @since head
 */
@property (readonly) BOOL						mustRescanSubDirectories;

/**
 * Provides some information as to what might have caused the need to rescan the URL including its children.
 *
 * @return <code>YES</code> if mustRescanSubDirectories returns <code>YES</code> and the cause were in userland, otherwise <code>NO</code>
 *
 * @see kFSEventStreamEventFlagUserDropped
 * @see flags
 * @see isGenericChange
 * @see mustRescanSubDirectories
 * @see isKernelDropped
 * @see isEventIdsWrapped
 * @see isHistoryDone
 * @see isRootChanged
 * @see didVolumeMount
 * @see didVolumeUnmount
 *
 * @since head
 */
@property (readonly) BOOL						isUserDropped;

/**
 * Provides some information as to what might have caused the need to rescan the URL including its children.
 *
 * @return <code>YES</code> if mustRescanSubDirectories returns <code>YES</code> and the cause were in kernelspace, otherwise <code>NO</code>
 *
 * @see kFSEventStreamEventFlagKernelDropped
 * @see flags
 * @see isGenericChange
 * @see mustRescanSubDirectories
 * @see isUserDropped
 * @see isEventIdsWrapped
 * @see isHistoryDone
 * @see isRootChanged
 * @see didVolumeMount
 * @see didVolumeUnmount
 *
 * @since head
 */
@property (readonly) BOOL						isKernelDropped;

/**
 * Wheter the 64-bit event identifier counter has wrapped around.
 *
 * Wheter the 64-bit event identifier counter has wrapped around. As a result,
 * previously-issued event identifiers are no longer valid arguments for the
 * sinceEventIdentifier parameter of the CDEvents init methods.
 *
 * @return <code>YES</code> if the 64-bit event identifier counter has wrapped around, otherwise <code>NO</code>
 *
 * @see kFSEventStreamEventFlagEventIdsWrapped
 * @see flags
 * @see isGenericChange
 * @see mustRescanSubDirectories
 * @see isUserDropped
 * @see isKernelDropped
 * @see isHistoryDone
 * @see isRootChanged
 * @see didVolumeMount
 * @see didVolumeUnmount
 *
 * @since head
 */
@property (readonly) BOOL						isEventIdentifiersWrapped;

/**
 * Denotes a sentinel event sent to mark the end of the "historical" events sent.
 *
 * Denotes a sentinel event sent to mark the end of the "historical" events sent
 * as a result of specifying a <i>sinceEventIdentifier</i> argument other than
 * kCDEventsSinceEventNow with the CDEvents init methods.
 *
 * @return <code>YES</code> if if the event is sent to mark the end of the "historical" events sent, otherwise <code>NO</code>
 *
 * @see kFSEventStreamEventFlagHistoryDone
 * @see flags
 * @see isGenericChange
 * @see mustRescanSubDirectories
 * @see isUserDropped
 * @see isKernelDropped
 * @see isEventIdsWrapped
 * @see isRootChanged
 * @see didVolumeMount
 * @see didVolumeUnmount
 * @see kCDEventsSinceEventNow
 * @see CDEvents
 *
 * @since head
 */
@property (readonly) BOOL						isHistoryDone;

#pragma mark Class object creators

/**
 * Returns an <code>CDEvent</code> created with the given identifier, date, URL and flags.
 *
 * @param identifier The identifier of the the event.
 * @param date The date when the event occured.
 * @param URL The URL of the item the event concerns.
 * @param flags The flags of the event.
 * @return An <code>CDEvent</code> created with the given identifier, date, URL and flags.
 *
 * @see FSEventStreamEventFlags
 * @see initWithIdentifier:date:URL:flags:
 *
 * @since 1.0.0
 */
+ (CDEvent *)eventWithIdentifier:(NSUInteger)identifier
							date:(NSDate *)date
							 URL:(NSURL *)URL
						   flags:(CDEventFlags)flags;

#pragma mark Init methods
/**
 * Returns an <code>CDEvent</code> object initialized with the given identifier, date, URL and flags.
 *
 * @param identifier The identifier of the the event.
 * @param date The date when the event occured.
 * @param URL The URL of the item the event concerns.
 * @param flags The flags of the event.
 * @return An <code>CDEvent</code> object initialized with the given identifier, date, URL and flags.
 * @see FSEventStreamEventFlags
 * @see eventWithIdentifier:date:URL:flags:
 *
 * @since 1.0.0
 */
- (id)initWithIdentifier:(NSUInteger)identifier
					date:(NSDate *)date
					 URL:(NSURL *)URL
				   flags:(CDEventFlags)flags;

@end
