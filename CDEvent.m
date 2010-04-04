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

#import "CDEvent.h"


@implementation CDEvent

#pragma mark Properties
@synthesize identifier	= _identifier;
@synthesize date		= _date;
@synthesize URL			= _URL;
@synthesize flags		= _flags;


#pragma mark Class object creators
+ (CDEvent *)eventWithIdentifier:(NSUInteger)identifier
							date:(NSDate *)date
							 URL:(NSURL *)URL
						   flags:(CDEventFlags)flags
{
	return [[[CDEvent alloc] initWithIdentifier:identifier
										   date:date
											URL:URL
										  flags:flags]
			autorelease];
}


#pragma mark Init/dealloc methods

- (void)dealloc
{
	[_date release];
	[_URL release];
	
	[super dealloc];
}

- (id)initWithIdentifier:(NSUInteger)identifier
					date:(NSDate *)date
					 URL:(NSURL *)URL
				   flags:(CDEventFlags)flags
{
	if ((self = [super init])) {
		_identifier	= identifier;
		_flags		= flags;
		_date		= [date retain];
		_URL		= [URL retain];
	}
	
	return self;
}


#pragma mark NSCoding methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:[self identifier]] forKey:@"identifier"];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:[self flags]] forKey:@"flags"];
	[aCoder encodeObject:[self date] forKey:@"date"];
	[aCoder encodeObject:[self URL] forKey:@"URL"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [self initWithIdentifier:[[aDecoder decodeObjectForKey:@"identifier"] unsignedIntegerValue]
							   date:[aDecoder decodeObjectForKey:@"date"]
								URL:[aDecoder decodeObjectForKey:@"URL"]
							  flags:[[aDecoder decodeObjectForKey:@"flags"] unsignedIntegerValue]];
	
	return self;
}

#pragma mark NSCopying methods

- (id)copyWithZone:(NSZone *)zone
{
	// We can do this since we are immutable.
	return [self retain];
}

#pragma mark Public API

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { identifier = %ld, URL = %@, flags = %ld, date = %@ }>",
			[self className],
			self,
			(unsigned long)[self identifier],
			[self URL],
			(unsigned long)[self flags],
			[self date]];
}

@end
