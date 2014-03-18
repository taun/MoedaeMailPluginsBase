//
//  SimpleRFC822Address.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 11/1/11.
//  Copyright (c) 2011 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 All address strings are assumed to be decommented.
 */
@interface SimpleRFC822Address : NSObject

@property (strong) NSString* name;
@property (strong) NSString* email;
@property (strong) NSString* mailbox;
@property (strong) NSString* domain;

/*!
 Assumes a properly formatted self contained email string from a scanner or elsewhere.
 
 @param emailString a valid RFC email.
 
 @return a SimpleRFC822Address
 */
+(instancetype) newAddressFromString: (NSString*) emailString;

+(instancetype) newAddressName: (NSString*) name email: (NSString*) email;

-(instancetype) initWithString: (NSString*)fullEmailString;
/*!
 Designated initializer
 
 @param name  NSString address description
 @param email NSString mail box @ domain
 
 @return A SimpleRFC822Address
 */
-(instancetype) initWithName: (NSString*) name email: (NSString*) email;
/*!
 Convert the address back to a NSString.
 
 @return a NSString always with <> around the mail box @ domain.
 */
-(NSString *) stringRFC822AddressFormat;

@end
