//
//  NSScanner+IMAPConversions.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 03/07/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimpleRFC822Address.h"

@interface NSScanner (IMAPConversions)

/*!
 This only gets called if there was an "=" found.
 Location is the first "X" after the "=".
 Current location of string should be of form ="XY".
 
 Result
 
 * if XY is valid hex, returns XY as UInt8 with location after "=XY"
 * If X is valid and Y is invalid, returns X as UInt8 and location at Y
 * If X and Y are invalid, return 0 and location still at X
 
 */
-(UInt8) mdcScanQHexUnichar;

/*!
 Scan for an RFC 5322/2822 email address.
 Does not handle groups. Need to extract the email list from the group first.
 
 @return a SimpleRFC822Address and the index incremented appropriately.
 
 @discussion what discussion?
 
 -------------------
 Address Spec
 -------------------
 
 Normally, a mailbox is composed of two parts: (1) an optional display
 name that indicates the name of the recipient (which can be a person
 or a system) that could be displayed to the user of a mail
 application, and (2) an addr-spec address enclosed in angle brackets
 ("<" and ">").  There is an alternate simple form of a mailbox where
 the addr-spec address appears alone, without the recipient’s name or
 the angle brackets.  The Internet addr-spec address is described in
 section 3.4.1.
 
 Samples::
 
 * A Name <box@domain.org>, Name2 <box2@domain.net>, QEncodedName <box3@domain.com>, + tabs and returns
 
 * box@domain.org, box2@domain.org, + tabs and returns
 
 
 Notes
 ------
 
    Only known delimiter is comma ","
 
 */
-(SimpleRFC822Address*) mdcScanRfc822Address;

@end
