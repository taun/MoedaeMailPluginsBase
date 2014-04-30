//
//  NSArray+IMAPConversions.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 04/29/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (IMAPConversions)

/*!
 Receiver should be a sorted array of NSNumbers. NSNumbers will be transformed into an 
 array of strings where each string will be the most compact representation of the sequence of 
 numbers using the IMAP syntax for specifying a range ":". For example, the array 1,2,3,4,6,9,10,11
 -> "1:4,6,9:11" 
 
 @param maxSequence maximum total count of individual items defined by a string.
 @param maxLength   maximum length of characters of each string
 
 @return an array of string representing the transformed sequence in the same order as the receiver. Each string
 will be the lesser of maxLength characters or maxSequence total numbers represented.
 */
-(NSArray*) asArrayOfIMAPSequenceStringsMaxSequence: (NSUInteger) maxSequence MaxLength: (NSUInteger) maxLength;

@end
