//
//  NSObject+TokenDispatch.m
//  MailBoxes
//
//  Created by Taun Chapman on 03/07/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "NSObject+TokenDispatch.h"
#import <MoedaeMailPlugins/NSObject+MBShorthand.h>
#import <MoedaeMailPlugins/NSString+IMAPConversions.h>

@implementation NSObject (TokenDispatch)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

-(void) performCleanedSelectorString: (NSString*)command prefixedBy: (NSString*) prefix fallbackSelector: (NSString*) fallback {
    if (!prefix) {
        prefix = @"";
    }

    if ([command isNonNilString]) {
        NSString* codeMethod = [NSString stringWithFormat:@"%@%@",prefix,[command mdcStringAsSelectorSafeCamelCase]];
        
        
        if ([self respondsToSelector: NSSelectorFromString(codeMethod)]) {
            
            [self performSelector: NSSelectorFromString(codeMethod)];
            
        } else  if ([fallback isNonNilString] && [self respondsToSelector: NSSelectorFromString(fallback)]) {
            
            [self performSelector: NSSelectorFromString(fallback)];
        }
    }
}

-(void) performCleanedSelectorString: (NSString*)command prefixedBy: (NSString*) prefix fallbackSelector: (NSString*) fallback withObject: (id) object {
    if (!prefix) {
        prefix = @"";
    }
    
    if ([command isNonNilString]) {
        NSString* codeMethod = [NSString stringWithFormat:@"%@%@:",prefix,[command mdcStringAsSelectorSafeCamelCase]];
        
        
        if ([self respondsToSelector: NSSelectorFromString(codeMethod)]) {
            
            [self performSelector: NSSelectorFromString(codeMethod) withObject: object];
            
        } else  if ([fallback isNonNilString] && [self respondsToSelector: NSSelectorFromString(fallback)]) {
            
            [self performSelector: NSSelectorFromString(fallback) withObject: object];
        }
    }
}

#pragma clang diagnostic pop


@end
