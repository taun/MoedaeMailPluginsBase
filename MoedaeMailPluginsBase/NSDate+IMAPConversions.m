//
//  NSDate+IMAPConversions.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 03/14/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "NSDate+IMAPConversions.h"
#include <time.h>
#include <xlocale.h>

@implementation NSDate (IMAPConversions)

+(instancetype) newDateFromRFC3501FormatString:(NSString *)dateString {
    NSDate *            internalDate = nil;
    
    struct tm  sometime;
    const char *rfc3501DateFormat = "%e-%b-%Y %H:%M:%S %z";
    char* transformResult = (char*)strptime_l([dateString cStringUsingEncoding: NSUTF8StringEncoding], rfc3501DateFormat, &sometime, NULL);
    
    if (transformResult != NULL) {
        internalDate = [NSDate dateWithTimeIntervalSince1970: mktime(&sometime)];
    }
    return internalDate;
}

+(instancetype) newDateFromRFC822FormatString:(NSString *)dateString {
    
    NSDate *internalDate = nil;
    static NSDateFormatter *sRFC2822DateFormatter = nil;
    //NSDateFormatter *dateFormatter;
    NSLocale *enUSPOSIXLocale;
    
    static NSRegularExpression *sLocateRFC2822Date = nil;
    NSError *regexError;
    
    if (sRFC2822DateFormatter==nil) {
        sRFC2822DateFormatter = [[NSDateFormatter alloc] init];
        enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sRFC2822DateFormatter setLocale:enUSPOSIXLocale];
        [sRFC2822DateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
        
        sLocateRFC2822Date = [[NSRegularExpression alloc] initWithPattern: @"(\\d{1,2} \\w{3} \\d{4} \\d{2}:\\d{2}:\\d{2})\\s(.\\d{4})|(\\d{1,2} \\w{3} \\d{4} \\d{2}:\\d{2}:\\d{2})\\s?\"?(\\w{3})"
                                                                  options: 0
                                                                    error: &regexError];
    }
    if (self) {
        NSTextCheckingResult *dateFound = [sLocateRFC2822Date firstMatchInString: dateString
                                                                         options: 0
                                                                           range:NSMakeRange(0, [dateString length])];
        
        NSString *timeZoneString = nil;
        NSTimeZone *messageTimeZone = nil;
        NSRange dateRange;
        
        if ([dateFound numberOfRanges] >= 5) {
            // should be full plus two capture ranges
            // date should be @ 1
            // timezone should be at 2
            //DDLogVerbose(@"Ranges: %lu\n", [dateFound numberOfRanges]);
            //NSRange range0 = [dateFound rangeAtIndex: 0]; // full range of found expression
            NSRange range1 = [dateFound rangeAtIndex: 1];
            NSRange range2 = [dateFound rangeAtIndex: 2];
            NSRange range3 = [dateFound rangeAtIndex: 3];
            NSRange range4 = [dateFound rangeAtIndex: 4];
            
            if (range1.length >0 && range2.length > 0) {
                // first type
                timeZoneString = [dateString substringWithRange: range2];
                NSInteger timeZoneDecimal100Hours = [timeZoneString integerValue];
                messageTimeZone = [NSTimeZone timeZoneForSecondsFromGMT: timeZoneDecimal100Hours*60*60/100];
                dateRange = range1;
                
                //DDLogVerbose(@"%@\n",[stringWithRFC2822Date substringWithRange: [dateFound rangeAtIndex: 1]]);
                //DDLogVerbose(@"%@\n",[stringWithRFC2822Date substringWithRange: [dateFound rangeAtIndex: 2]]);
            } else if (range3.length >0 && range4.length > 0) {
                // 2nd type
                timeZoneString = [dateString substringWithRange: range4];
                messageTimeZone = [NSTimeZone timeZoneWithAbbreviation: timeZoneString];
                if (messageTimeZone==nil) {
                    // default to GMT
                    messageTimeZone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
                }
                dateRange = range3;
                //DDLogVerbose(@"%@\n",[stringWithRFC2822Date substringWithRange: [dateFound rangeAtIndex: 3]]);
                //DDLogVerbose(@"%@\n",[stringWithRFC2822Date substringWithRange: [dateFound rangeAtIndex: 4]]);
            }
            
            [sRFC2822DateFormatter setTimeZone: messageTimeZone];
            
            [sRFC2822DateFormatter getObjectValue: &internalDate
                                        forString: dateString
                                            range: &dateRange
                                            error: &regexError];
        }
        
    }
    
    return internalDate;
}

@end
