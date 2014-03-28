//
//  NSObject+MBShorthand.m
//  MailBoxes
//
//  Created by Taun Chapman on 12/2/11.
//  Copyright (c) 2011 MOEDAE LLC. All rights reserved.
//

#import <MoedaeMailPlugins/NSObject+MBShorthand.h>
#import <MoedaeMailPlugins/NSString+IMAPConversions.h>

@implementation NSObject (MBShorthand)

-(BOOL) isNonZeroArray {
    BOOL result = NO;
    if ([self isKindOfClass: [NSArray class]]) {
        if ([(NSArray*)self count]>0) {
            result = YES;
        }
    }
    return result;
}

-(BOOL) isNonNilString {
    BOOL result = NO;
    if ([self isKindOfClass: [NSString class]]) {
        NSString* shortest = [(NSString*)self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([shortest length]>0) {
            if (!([shortest caseInsensitiveCompare: @"NIL"] == NSOrderedSame) || !([shortest caseInsensitiveCompare: @"(null)"] == NSOrderedSame)) {
                result = YES;
            }
        }
    }
    return result;
}

@end
