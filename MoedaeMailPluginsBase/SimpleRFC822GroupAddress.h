//
//  SimpleRFC822GroupAddress.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 03/13/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleRFC822Address.h"

/*!
 We are going to consider the email address fields to always be a group.
 "TO:" if the list of addresses is a RFC group, then it will have a name,
 otherwise, there will be no name and it is just a list of addresses.
 
 -------------------
 Groups RFC
 -------------------
 
 When it is desirable to treat several mailboxes as a single unit
 (i.e., in a distribution list), the group construct can be used.  The
 group construct allows the sender to indicate a named group of
 recipients.  This is done by giving a display name for the group,
 followed by a colon, followed by a comma-separated list of any number
 of mailboxes (including zero and one), and ending with a semicolon.
 Because the list of mailboxes can be empty, using the group construct
 is also a simple way to communicate to recipients that the message
 was sent to one or more named sets of recipients, without actually
 providing the individual mailbox address for any of those recipients.
 
 group = display-name ":" [group-list] ";" [CFWS]
 
 group-list = mailbox-list / CFWS / obs-group-list
 
 
 Samples::
 
 * undisclosed-recipients:;
 
 * displayName: multiple email addresses ;
 
 *
 
 
 All new address parsing attempt and notes
 ----------------------------------------
 
 # assume string is already unfolded.
 # regex to determine if there is a group ,(*):(*);*  comma is optional
 # if group, get group name and range then pass to parse addresses (recurse).
 # if address, return address and get next.

 */
@interface SimpleRFC822GroupAddress : NSObject

@property(nonatomic,strong) NSString        *name;
@property(nonatomic,strong) NSSet           *addresses;

+(instancetype) newGroupNamed: (NSString *)name addresses:(NSSet *)list;
+(instancetype) newGroupNamed: (NSString*)name fromString: (NSString*) aList;

/* designated initializer */
-(instancetype) initWithName:(NSString *)name addresses:(NSSet *)list;

@end
