//
//  SimpleRFC822Address.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 11/1/11.
//  Copyright (c) 2011 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

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

-(instancetype) initWithName: (NSString*) name email: (NSString*) email;

-(NSString *) stringRFC822AddressFormat;

@end
