//
//  NSString+IMAPConversions.h
//  MailBoxes
//
//  Created by Taun Chapman on 11/1/11.
//  Copyright (c) 2011 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimpleRFC822Address;

@interface NSString (IMAPConversions)


/*!
 Capitalizes the string then removes non-characters.
 commands like READ-ONLY become ReadOnly

 
 @return CamelCase string
 */
-(NSString*) mdcStringAsSelectorSafeCamelCase;

-(NSString*) mdcStringFromBase64WithCharset: (int) encodingCharset;


/*!
 Transforms string with RFC 2047 encoded words to UTF8 string.
 See RFC2047 for more details on the encoding.
 Use transformedValue: to transform an encoded string to decoded.
 
 Handles single line Q and B encoding in ascii string.
 
 @anAsciiEncodedString a one line string with potential Q or B encoding.
 
 @return a decoded utf8 NSString
 */
-(NSString*) mdcStringByDecodingRFC2047;

-(NSString*) mdcStringByRemovingRFCComments;

-(NSString*) mdcStringDeQuotedPrintableFromCharset: (int) encodingCharset;


/*!
 A string with hex octet encoding of the form "=XX" and returns a string
 with the "=XX" replaced by the character represented by the "XX" hex encoding of the character set.
 
 @return a decoded NSString
 */
-(NSString*) mdcStringFromQEncodedAsciiHexInCharset: (int) encodingCharset;

/*!
 Transforms from IANA charset strings representing a character set to an NSNumber representing an NS domain character set.
 Converts charset string to uppercase.
 
 @return default value of NSASCIIStringEncoding if charset is not found.
 */
-(NSNumber*) mdcNumberFromIANACharset;

@end
