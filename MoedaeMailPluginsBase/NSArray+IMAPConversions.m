//
//  NSArray+IMAPConversions.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 04/29/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "NSArray+IMAPConversions.h"

@implementation NSArray (IMAPConversions)

/*
 
 */
-(NSArray*) asArrayOfIMAPSequenceStringsMaxSequence:(NSUInteger)maxSequence MaxLength:(NSUInteger)maxLength {
    NSMutableArray* sequenceStrings = [NSMutableArray new];
    
    if (self.count > 0) {
        NSMutableString* uidSequenceString = [NSMutableString stringWithCapacity: maxLength+1];
        UInt64 previousUID = 0;
        UInt64 currentUID  = 0;
        UInt64 nextUID = 0;
        
        currentUID = [(NSNumber*)self[0] unsignedLongValue];
        [uidSequenceString appendFormat: @"%llu",currentUID];
        
        if (self.count > 1) {
            BOOL inRange = NO;
            NSUInteger uidIndex = 1;
            NSInteger lastLineIndex = -1;
            
            for (uidIndex = 1; uidIndex < (self.count - 1); uidIndex++) {
                //
                previousUID = [(NSNumber*)self[uidIndex-1] unsignedLongValue];
                currentUID = [(NSNumber*)self[uidIndex] unsignedLongValue];
                nextUID = [(NSNumber*)self[uidIndex+1] unsignedLongValue];
                
                if (previousUID+1 == currentUID && currentUID+1 == nextUID) {
                    // in a range, do nothing
                    if (uidSequenceString.length == 0) {
                        // truncated range due to max..., restart
                        [uidSequenceString appendFormat: @"%llu",currentUID];
                    }
                    inRange = YES;
                } else if (previousUID+1 == currentUID && currentUID+1 != nextUID) {
                    // end of range
                    if (uidSequenceString.length == 0) {
                        [uidSequenceString appendFormat: @"%llu",currentUID];
                    } else {
                        [uidSequenceString appendFormat: @":%llu",currentUID];
                    }
                    inRange = NO;
                } else if (previousUID+1 != currentUID) {
                    // add a sequence or start new range
                    if (uidSequenceString.length == 0) {
                        [uidSequenceString appendFormat: @"%llu",currentUID];
                    } else {
                        [uidSequenceString appendFormat: @",%llu",currentUID];
                    }
                    inRange = NO;
                }
                
 
                if ((maxSequence && (uidIndex-lastLineIndex) >= maxSequence) || (maxLength && uidSequenceString.length >= maxLength)) {
                    if (inRange) {
                        [uidSequenceString appendFormat: @":%llu",currentUID];
                    }
                    [sequenceStrings addObject: uidSequenceString];
                    uidSequenceString = [NSMutableString stringWithCapacity: maxLength+1];
                    lastLineIndex = uidIndex;
                }
            }
            // finish up last one
            if (inRange) {
                if (uidSequenceString.length == 0) {
                    [uidSequenceString appendFormat: @"%llu",nextUID];
                } else {
                    [uidSequenceString appendFormat: @":%llu",nextUID];
                }
            } else {
                if (uidSequenceString.length == 0) {
                    [uidSequenceString appendFormat: @"%llu",nextUID];
                } else {
                    [uidSequenceString appendFormat: @",%llu",nextUID];
                }
            }
        }
        
        if (uidSequenceString.length > 0) {
            [sequenceStrings addObject: uidSequenceString];
        }
    }
    
    return [sequenceStrings copy];
}

@end
