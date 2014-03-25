//
//  SimpleRFC822Address.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 11/1/11.
//  Copyright (c) 2011 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 We are going to consider the email address fields to always be a group.
 "TO:" if the list of addresses is a RFC group, then it will have a name,
 otherwise, there will be no name and it is just a list of addresses. All
 address strings are assumed to be decommented.
 
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
@interface SimpleRFC822Address : NSObject
/*!
 String passed to name is RFC2047 decoded mdcStringByDecodingRFC2047 before assignement to _name.
 Note, string is NOT decommented before assignment.
 */
@property (strong,nonatomic) NSString*        name;
/*!
 Used as indicator of "groupness".
 If there is an email, addresses is ignored.
 If there is a name and no email, it is an "rfc group".
 If there is no name and no email, it is just a list of addresses.
 Email string is NOT decommented before assignment.
 */
@property (strong,nonatomic) NSString*        email;
@property (strong,nonatomic) NSString*        mailbox;
@property (strong,nonatomic) NSString*        domain;
@property (assign) BOOL                       isLeaf;

@property(nonatomic,strong) NSSet*            addresses;
/*!
 Whether there is anything to show for this address.
 If there is a name, email or addresses > 0, then show.
 */
@property(readonly) BOOL                      showMe;
@property(readonly) NSUInteger                count;

#pragma message "Comments could be left in name and email and removed for mailbox,domain. Are comments EVER used anymore? Does this matter?"
/*!
 Assumes a properly formatted self contained email string from a parser/scanner or elsewhere.
 Passed string is decommented using mdcStringByRemovingRFCComments before parsing.
 
 @param emailString a valid RFC header string of emails.
 
 @return a SimpleRFC822Address
 */
+(instancetype) newFromString: (NSString*) anRfcGroupString;

+(instancetype) newLeafAddressFromString:(NSString *)fullEmailString;

+(instancetype) newAddressName: (NSString*) name email: (NSString*) email;

+(instancetype) newAddressesGroupNamed: (NSString *)name addresses:(NSSet *)list;

-(instancetype) initWithString: (NSString*)fullEmailString;
/*!
 Designated initializer
 
 @param name  NSString address description
 @param email NSString mail box @ domain
 
 @return A SimpleRFC822Address
 */
-(instancetype) initWithName:(NSString *)name email:(NSString *)email;
//-(instancetype) initWithName: (NSString*) name email: (NSString*) email;

/* designated initializer */
//-(instancetype) initWithName:(NSString *)name addresses:(NSSet *)list;
//-(instancetype) initWithGroupString: (NSString*) anRfcGroupString;

/*!
 Convert the address back to a NSString.
 
 @return a NSString always with <> around the mail box @ domain.
 */
-(NSString *) stringRFC822AddressFormat;
-(NSString *) stringRFC822LeafAddressFormat;
-(NSString *) stringSingleTopLevel;

@end
