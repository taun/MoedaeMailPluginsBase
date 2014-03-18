//
//  NSDate+IMAPConversions.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 03/14/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (IMAPConversions)

/*!
 RFC822 Header Format = Tue, 12 Feb 2008 09:36:17 -0500
 INTERNALDATE Format =  "26-Jul-2011 07:48:41 -0400"

 @param dateString a valid RFC822 date.
 
 @return a NSDate
*/
+(instancetype) newDateFromRFC3501FormatString: (NSString*) dateString;
/*!
 RFC822 Header Format = Tue, 12 Feb 2008 09:36:17 -0500
 RFC822 Header Format = Tue, 12 Feb 2008 09:36:17 "GMT"  obsolete

 @param dateString a valid RFC date.
 
 @return a NSDate
*/
+(instancetype) newDateFromRFC822FormatString: (NSString*) dateString;

@end
