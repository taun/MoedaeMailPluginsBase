//
//  NSObject+TokenDispatch.h
//  MailBoxes
//
//  Created by Taun Chapman on 03/07/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TokenDispatch)

/*!
 Dispatch the passed string as a method call with the prefix assigned.
 A way for parsers to call actions based on a token string value. Just name the method to be performed,
 "prefixToken". If the object does not implement the prefixToken, the fallback method with no prefix added will be called.

 
 @param command  the token value as a string. Will be CamelCased. Non method safe characters will be removed such as spaces hyphens, ...
 @param prefix   the prefix. Will be prefixed to CapitaliseCamelCased token. Ex prefixedCommandCase
 @param fallback fallback method to be performed.
 */
-(void) performCleanedSelectorString: (NSString*)command prefixedBy: (NSString*) prefix fallbackSelector: (NSString*) fallback;
/*!
 Same as above but with argument
 
 @param command  automatically add ":" suffix to token.
 @param prefix   prefix to add to all token commands.
 @param fallback must have ":" at end of string for method to be found.
 @param object   argument
 */
-(void) performCleanedSelectorString: (NSString*)command prefixedBy: (NSString*) prefix fallbackSelector: (NSString*) fallback withObject: (id) object;
@end
