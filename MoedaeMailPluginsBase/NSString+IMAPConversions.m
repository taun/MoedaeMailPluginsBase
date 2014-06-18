//
//  NSString+IMAPConversions.m
//  MailBoxes
//
//  Created by Taun Chapman on 11/1/11.
//  Copyright (c) 2011 MOEDAE LLC. All rights reserved.
//

#import <MoedaeMailPlugins/NSString+IMAPConversions.h>
#import "NSScanner+IMAPConversions.h"

#import <MoedaeMailPlugins/NSObject+MBShorthand.h>
#import <MoedaeMailPlugins/SimpleRFC822Address.h>

#include <time.h>
#include <xlocale.h>

@implementation NSString (IMAPConversions)


-(NSString *) mdcStringAsSelectorSafeCamelCase {
    NSString *normalized = [self capitalizedString];
    normalized = [normalized stringByReplacingOccurrencesOfString: @" " withString: @""];
    normalized = [normalized stringByReplacingOccurrencesOfString: @"-" withString: @""];
    normalized = [normalized stringByReplacingOccurrencesOfString: @"." withString: @""];
    normalized = [normalized stringByReplacingOccurrencesOfString: @"[" withString: @""];
    normalized = [normalized stringByReplacingOccurrencesOfString: @"]" withString: @""];
    normalized = [normalized stringByReplacingOccurrencesOfString: @"/" withString: @""];
    normalized = [normalized stringByReplacingOccurrencesOfString: @"\\" withString: @""];
    return normalized;
}

-(NSString*) mdcStringFromBase64WithCharset: (NSStringEncoding) encodingCharset {
    
    NSData* decodedData = [[NSData alloc] initWithBase64EncodedString: self options: NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString* decodedString = [[NSString alloc] initWithData: decodedData encoding: encodingCharset];
    
    return decodedString;
}

-(NSString*) mdcStringByDecodingRFC2047 {
    NSString* returnString;

    NSError *error=nil;
    NSRegularExpression* regexEncodingFields = [[NSRegularExpression alloc] initWithPattern: @"=\\?([A-Z0-9\\-]+)\\?(?:(?:[bB]\\?([+/0-9A-Za-z]*=*))|(?:[qQ]\\?([a-zA-Z0-9.,_!=/\\*\\+\\-@]*)))\\?="
                                                               options: NSRegularExpressionCaseInsensitive
                                                                 error: &error];
    if (error) {
        NSLog(@"Encoding Fields Error: %@", error);
    }
    
//    NSRegularExpression* regexQSpaces = [[NSRegularExpression alloc] initWithPattern: @"=([0-9a-zA-Z][0-9a-zA-Z]?)|(_)"
//                                                        options: NSRegularExpressionCaseInsensitive
//                                                          error: &error];
//    if (error) {
//        NSLog(@"Q Spaces Error: %@", error);
//    }
    
    NSArray* matches;
    
    matches = [regexEncodingFields matchesInString: self options: 0 range: NSMakeRange(0, self.length)];
    
    NSInteger charsetRangeIndex = 1;
    NSInteger bCodeRangeIndex = 2;
    NSInteger qCodeRangeIndex = 3;
    // rangge length 0 means not found
    
    
    if (matches.count==0) {
        returnString = [self copy];
    } else {
        
        NSString* charsetString;
        NSMutableString* decodedString = [NSMutableString new];
        
        NSRange lastCaptureRange = NSMakeRange(0, 0);
        NSRange currentCaptureRange;
        
        for (NSTextCheckingResult* tcr in matches) {
            
            // Append the ascii string before the capture encoded word.
            // 0 aaaaaaaaa =?lastCaptureRange?= bbbbbbbbbbb =?currentCaptureRange?= cccccccc
            currentCaptureRange = (NSRange)[tcr rangeAtIndex:0];
            NSUInteger prefixLocation = lastCaptureRange.location + lastCaptureRange.length;
            NSUInteger prefixLength = currentCaptureRange.location - prefixLocation;
            NSRange prefixRange = NSMakeRange(prefixLocation, prefixLength);
            
            NSString* intraCaptureString = [self substringWithRange: prefixRange];
            NSString* noWhitespaceString = [intraCaptureString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            
            // if the intraCapture text is whitespace, skip, do not append.
            [decodedString appendString: noWhitespaceString];
            
            lastCaptureRange = (NSRange)[tcr rangeAtIndex:0];
            
            if ([tcr rangeAtIndex: charsetRangeIndex].length != 0) {
                charsetString = [[self substringWithRange: [tcr rangeAtIndex: charsetRangeIndex]] uppercaseString];
            }
            
            NSRange encodedRange;
            NSNumber* encodingNumber = [charsetString mdcNumberFromIANACharset];
            
            int encoding = [encodingNumber intValue]; //TODO: handle charset not found.
            if ([tcr rangeAtIndex: bCodeRangeIndex].length != 0) {
                // b encoded
                encodedRange = [tcr rangeAtIndex: bCodeRangeIndex];
                if (encodedRange.length !=0) {
                    //                    NSString* encodedString = [(NSString*)anObject substringWithRange: encodedRange];
                    //                    const char* encodedCString
                    //                    [decodedString appendString: encodedString];
                    NSString* encodedString = [self substringWithRange: encodedRange];
                    NSString* decodedFragment = [encodedString mdcStringFromBase64WithCharset: encoding];
                    if (!decodedFragment && (encoding != NSASCIIStringEncoding)) {
                        // designated encoding failed, fallback to ascii
                        decodedFragment = [encodedString mdcStringFromBase64WithCharset: NSASCIIStringEncoding];
                    }
                    if (!decodedFragment) {
                        // couldn't convert so fall back to just using the raw string
                        decodedFragment = encodedString;
                    }
                    [decodedString appendString: decodedFragment];
                }
            } else if ([tcr rangeAtIndex: qCodeRangeIndex].length != 0) {
                // q encoded
                encodedRange = [tcr rangeAtIndex: qCodeRangeIndex];
                if (encodedRange.length !=0) {
                    NSString* encodedString = [self substringWithRange: encodedRange];
                    const char* encodedCString = [encodedString cStringUsingEncoding: NSASCIIStringEncoding];
                    NSString* cString = [NSString stringWithCString: encodedCString encoding: encoding];
                    // search and replace "=XX" and "_"
                    NSString *decodedFragment = [cString mdcStringFromQEncodedAsciiHexInCharset: encoding];
                    if (!decodedFragment) {
                        // fall back to raw string
                        decodedFragment = cString;
                    }
                     [decodedString appendString: decodedFragment];
                }
            } else {
                // unknown encoding?? assert?
            }
        }
        // append remaining suffix ascii string if it exists
        NSUInteger suffixLocation = lastCaptureRange.location + lastCaptureRange.length;
        NSUInteger suffixLength = self.length - suffixLocation;
        NSRange suffixRange = NSMakeRange(suffixLocation, suffixLength);
        [decodedString appendString: [[self substringWithRange:suffixRange] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
        
        returnString = [decodedString copy];
    }
    
    return returnString;
}

-(NSString*) mdcStringByRemovingRFCComments {
    
    NSMutableString *decommentedString = [[NSMutableString alloc] initWithCapacity: self.length];
    
    NSString* previousChar = nil;
    NSString* ppreviousChar = nil;
    NSInteger commentLevel = 0;
    
    for (NSUInteger i=0; i < self.length; i++) {
        //
        NSString* currentChar = [self substringWithRange: NSMakeRange(i, 1)];
        
        if ([currentChar isEqualToString: @"("] && ![previousChar isEqualToString: @"\\"]) {
            commentLevel++;
        }
        if (commentLevel && [previousChar isEqualToString: @")"] && ![ppreviousChar isEqualToString: @"\\"]) {
            commentLevel--;
        }
        
        if (commentLevel == 0) {
            [decommentedString appendString: currentChar];
        }
        
        ppreviousChar = previousChar;
        previousChar = currentChar;
    }
    return [decommentedString copy];
}

-(NSArray*) mdcArrayFromCommaSeparatedTokens {
    
    NSMutableArray *emailTokens = [[NSMutableArray alloc] initWithCapacity: 4];
    NSString* currentToken;
    
    NSUInteger tokenStart = 0;

    BOOL inName = NO;
    
    for (NSUInteger i=0; i < self.length; i++) {
        //
        NSString* currentChar = [self substringWithRange: NSMakeRange(i, 1)];
        
        if ([currentChar isEqualToString: @"\""]) {
            inName = !inName;
        } else if (!inName && [currentChar isEqualToString: @","]) {
            currentToken = [self substringWithRange: NSMakeRange(tokenStart, i-tokenStart)];
            tokenStart = i+1;
            [emailTokens addObject: currentToken];
        }
    }
    if (self.length > tokenStart) {
        currentToken = [self substringWithRange: NSMakeRange(tokenStart, self.length - tokenStart)];
        [emailTokens addObject: currentToken];
    }
    return [emailTokens copy];
}


-(NSString*) mdcStringFromQEncodedAsciiHexInCharset: (NSStringEncoding) encodingCharset {
    // Change to use NSScanner
    
    // define regex above
    // find matches here
    // create empty new mutable string
    // replace matches with dehexed or spaced and append to new string
    // append intermediate range to string
    // return new string
    NSMutableString* decodedMutableString = [[NSMutableString alloc] initWithCapacity: self.length];
    
    //NSCharacterSet *replaceableCharacters = [NSCharacterSet characterSetWithCharactersInString:@"=_"];
    NSScanner* scanner = [NSScanner scannerWithString: self];
    
    NSString* currentCharacter;
    
    while (![scanner isAtEnd]) {
        currentCharacter = [scanner.string substringWithRange: NSMakeRange(scanner.scanLocation, 1)];
        if ([currentCharacter isEqualToString: @"="] || [currentCharacter isEqualToString: @"_"]) {
            if ([currentCharacter isEqualToString: @"_" ]) {
                // found underscore
                [decodedMutableString appendString: @" "];
                [scanner setScanLocation: ++(scanner.scanLocation)];
            } else if ([currentCharacter isEqualToString: @"=" ] && (scanner.string.length - scanner.scanLocation > 2)) {
                // found "=" and need to get next 2 char hex value
                [scanner setScanLocation: ++(scanner.scanLocation)]; // skip "="
                
                // Need to manually get next two characters to convert to hex.
                UInt8 hexCode = [scanner mdcScanQHexUnichar];
                
                if (hexCode!=0) {
                    // valid hex code found
                    char utf8Chars[5];
                    NSUInteger unicodeIndex = 0;
                    utf8Chars[unicodeIndex] = hexCode;
                    if ((encodingCharset == NSUTF8StringEncoding) && (hexCode > 0x7f) && (scanner.string.length - scanner.scanLocation > 2)) {
                        // Need to handle 2 to 4 encoded bytes
                        // decode byte count
                        // RFC 3269 UTF-8 definition
                        // Char. number range  |        UTF-8 octet sequence
                        // (hexadecimal)    |              (binary)
                        // --------------------+---------------------------------------------
                        // 0000 0000-0000 007F | 0xxxxxxx
                        // 0000 0080-0000 07FF | 110xxxxx 10xxxxxx
                        // 0000 0800-0000 FFFF | 1110xxxx 10xxxxxx 10xxxxxx
                        // 0001 0000-0010 FFFF | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
                        
                        // 2bytes 110xxxxx = C0, 111xxxxx = E0, 00011111 = 1F
                        // 3bytes 1110xxxx = E0, 1111xxxx = F0, 00001111 = 0F, 00111111 = 3F, 10000000 = 0x80
                        // 4bytes 11110xxx = F0, 11111xxx = F8, 00000111 = 07, 00111111 = 3F, 00111111 = 3F
                        
                        if ((hexCode & 0xE0) == 0xC0) {
                            // 2 bytes, additional 3 chars
                            currentCharacter = [scanner.string substringWithRange: NSMakeRange(scanner.scanLocation, 1)];
                            if ([currentCharacter isEqualToString: @"="]) {
                                // get second byte
                                [scanner setScanLocation: ++(scanner.scanLocation)]; // skip "="
                                hexCode = [scanner mdcScanQHexUnichar];
                                if ((hexCode & 0xC0) == 0x80) {
                                    // next byte is of correct 10xxxxxx form
                                    utf8Chars[++unicodeIndex] = hexCode;
                                }
                            }
                        } else if (((hexCode & 0xF0) == 0xE0) && (scanner.string.length - scanner.scanLocation > 5)) {
                            // 3 bytes, additional 6 chars
                            currentCharacter = [scanner.string substringWithRange: NSMakeRange(scanner.scanLocation, 1)];
                            if ([currentCharacter isEqualToString: @"="]) {
                                // get second byte
                                [scanner setScanLocation: ++(scanner.scanLocation)]; // skip "="
                                hexCode = [scanner mdcScanQHexUnichar];
                                if ((hexCode & 0xC0) == 0x80) {
                                    // next byte is of correct 10xxxxxx form
                                    utf8Chars[++unicodeIndex] = hexCode;
                                    currentCharacter = [scanner.string substringWithRange: NSMakeRange(scanner.scanLocation, 1)];
                                    if ([currentCharacter isEqualToString: @"="]) {
                                        // get second byte
                                        [scanner setScanLocation: ++(scanner.scanLocation)]; // skip "="
                                        hexCode = [scanner mdcScanQHexUnichar];
                                        if ((hexCode & 0xC0) == 0x80) {
                                            // next byte is of correct 10xxxxxx form
                                            utf8Chars[++unicodeIndex] = hexCode;
                                        }
                                    }
                                }
                            }
                        } else if (((hexCode & 0xF8) == 0xF0) && (scanner.string.length - scanner.scanLocation > 8)) {
                            // 4 bytes, additional 9 chars
                            currentCharacter = [scanner.string substringWithRange: NSMakeRange(scanner.scanLocation, 1)];
                            if ([currentCharacter isEqualToString: @"="]) {
                                // get second byte
                                [scanner setScanLocation: ++(scanner.scanLocation)]; // skip "="
                                hexCode = [scanner mdcScanQHexUnichar];
                                if ((hexCode & 0xC0) == 0x80) {
                                    // next byte is of correct 10xxxxxx form
                                    utf8Chars[++unicodeIndex] = hexCode;
                                    currentCharacter = [scanner.string substringWithRange: NSMakeRange(scanner.scanLocation, 1)];
                                    if ([currentCharacter isEqualToString: @"="]) {
                                        // get second byte
                                        [scanner setScanLocation: ++(scanner.scanLocation)]; // skip "="
                                        hexCode = [scanner mdcScanQHexUnichar];
                                        if ((hexCode & 0xC0) == 0x80) {
                                            // next byte is of correct 10xxxxxx form
                                            utf8Chars[++unicodeIndex] = hexCode;
                                            currentCharacter = [scanner.string substringWithRange: NSMakeRange(scanner.scanLocation, 1)];
                                            if ([currentCharacter isEqualToString: @"="]) {
                                                // get second byte
                                                [scanner setScanLocation: ++(scanner.scanLocation)]; // skip "="
                                                hexCode = [scanner mdcScanQHexUnichar];
                                                if ((hexCode & 0xC0) == 0x80) {
                                                    // next byte is of correct 10xxxxxx form
                                                    utf8Chars[++unicodeIndex] = hexCode;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            // bad value skip
                        }
                        utf8Chars[++unicodeIndex] = 0; // null terminate
                        NSString* newString = @(utf8Chars);
                        if (newString) {
                            [decodedMutableString appendString: newString];
                        }
                    } else {
                        // not UTF-8 > 7F
                        utf8Chars[++unicodeIndex] = 0; // null terminate
                        NSString* newString = [NSString stringWithCString: utf8Chars encoding: encodingCharset];
                        if (newString) {
                            [decodedMutableString appendString: newString];
                        }
                    }
                } else {
                    // no valid code found
                    // was not two hexadecimal digits
                    if (scanner.scanLocation < scanner.string.length) {
                        [decodedMutableString appendFormat:@"=%c", [scanner.string characterAtIndex: scanner.scanLocation]];
                        [scanner setScanLocation: ++(scanner.scanLocation)]; // skip "="
                    }
                }
            }
        } else {
            if (currentCharacter) {
                [decodedMutableString appendString: currentCharacter];
            }
            [scanner setScanLocation: ++(scanner.scanLocation)];
        }
        
    }
    
     return [decodedMutableString copy];
}

-(NSString*) mdcStringDeQuotedPrintableFromCharset: (NSStringEncoding) encodingCharset {
    NSString* dequotedPrintable;
    
    
    dequotedPrintable = [self mdcStringFromQEncodedAsciiHexInCharset: encodingCharset];
    
    NSString* softReturn = @"=\r\n";
    if ([dequotedPrintable rangeOfString: softReturn].location == NSNotFound) {
        // =\r\n not found
        softReturn = @"=\n";
        if ([dequotedPrintable rangeOfString: softReturn].location == NSNotFound) {
            // no soft returns found
            softReturn = nil;
        }
    }
    
    if (softReturn) {
        NSString* unfoldedString = [dequotedPrintable stringByReplacingOccurrencesOfString: softReturn withString: @""];
        dequotedPrintable = unfoldedString;
    }
    // Replace all lines ending with "=\r\n" meaning soft return with nothing.
    
    return dequotedPrintable;
}

-(NSNumber*) mdcNumberFromIANACharset {
    NSNumber* nsDomainCharset;
    
    NSDictionary* mdcCharsetMap = @{@"US-ASCII": @(NSASCIIStringEncoding),
                                    @"CSASCII": @(NSASCIIStringEncoding),
                                    @"CP367": @(NSASCIIStringEncoding),
                                    @"IBM367": @(NSASCIIStringEncoding),
                                    @"US": @(NSASCIIStringEncoding),
                                    @"ISO646-US": @(NSASCIIStringEncoding),
                                    @"ISO_646.IRV:1991": @(NSASCIIStringEncoding),
                                    @"ANSI_X3.4-1986": @(NSASCIIStringEncoding),
                                    @"ANSI_X3.4-1968": @(NSASCIIStringEncoding),
                                    @"SO-IR-6": @(NSASCIIStringEncoding),
                                    
                                    @"US-ASCII2": @(NSNonLossyASCIIStringEncoding),
                                    @"UTF-8": @(NSUTF8StringEncoding),
                                    @"CSUTF8": @(NSUTF8StringEncoding),
                                    @"UTF-16": @(NSUnicodeStringEncoding),
                                    @"UTF-32": @(NSUTF32StringEncoding),
                                    
                                    @"ISO-8859-1": @(NSISOLatin1StringEncoding),
                                    @"ISO_8859-1": @(NSISOLatin1StringEncoding),
                                    @"LATIN1": @(NSISOLatin1StringEncoding),
                                    @"L1": @(NSISOLatin1StringEncoding),
                                    @"IBM819": @(NSISOLatin1StringEncoding),
                                    @"CP819": @(NSISOLatin1StringEncoding),
                                    @"CSISOLATIN1": @(NSISOLatin1StringEncoding),
                                    
                                    @"CP1250":@(NSWindowsCP1250StringEncoding),
                                    @"WINDOWS-1250":@(NSWindowsCP1250StringEncoding),
                                    @"CSWINDOWS1250":@(NSWindowsCP1250StringEncoding),
                                    
                                    @"KOI8-R": @(NSWindowsCP1251StringEncoding),
                                    @"CP1251":@(NSWindowsCP1251StringEncoding),
                                    @"WINDOWS-1251":@(NSWindowsCP1251StringEncoding),
                                    @"CSWINDOWS1251":@(NSWindowsCP1251StringEncoding),
                                    
                                    @"CP1252":@(NSWindowsCP1252StringEncoding),
                                    @"WINDOWS-1252":@(NSWindowsCP1252StringEncoding),
                                    @"CSWINDOWS1252":@(NSWindowsCP1252StringEncoding),
                                    
                                    @"CP1253":@(NSWindowsCP1253StringEncoding),
                                    @"WINDOWS-1253":@(NSWindowsCP1253StringEncoding),
                                    @"CSWINDOWS1253":@(NSWindowsCP1253StringEncoding),
                                    
                                    @"CP1254":@(NSWindowsCP1254StringEncoding),
                                    @"WINDOWS-1254":@(NSWindowsCP1254StringEncoding),
                                    @"CSWINDOWS1254":@(NSWindowsCP1254StringEncoding),
                                    
                                    @"ISO-2022": @(NSISO2022JPStringEncoding),
                                    @"CSISO2022JP": @(NSISO2022JPStringEncoding),
                                    
                                    };
    
    // should be a string
    NSString* upperCaseMimeCharset = [self uppercaseString];
    nsDomainCharset = [mdcCharsetMap objectForKey: upperCaseMimeCharset];
    if (!nsDomainCharset) {
        // default to ASCII
        nsDomainCharset = @(NSASCIIStringEncoding);
    }
    
    return nsDomainCharset;
}

-(NSString*) mdcCompressWitespace {
    NSString* result;
    
    
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [self componentsSeparatedByCharactersInSet: whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate: noEmptyStrings];
    result = [filteredArray componentsJoinedByString:@" "];
    return result;
}

@end
