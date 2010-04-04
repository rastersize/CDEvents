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


/**
 * The event identifier type.
 *
 * @since 1.0.0
 */
typedef NSUInteger CDEventIdentifier;

/**
 * The event stream event flags type.
 *
 * @since 1.0.1
 */
typedef NSUInteger CDEventFlags;


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
