//
//  SimpleRFC822Address.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 11/1/11.
//  Copyright (c) 2011 MOEDAE LLC. All rights reserved.
//

#import "SimpleRFC822Address.h"
#import "SimpleRFC822GroupAddress.h"
#import "NSString+IMAPConversions.h"
#import "NSObject+MBShorthand.h"


@implementation SimpleRFC822Address

+(instancetype) newAddressFromString:(NSString *)emailString {
    return [[SimpleRFC822Address alloc] initWithString: emailString];
}

+(instancetype) newAddressName:(NSString *)name email:(NSString *)email {
    return [[SimpleRFC822Address alloc] initWithName:name email:email];
}
-(instancetype) initWithString:(NSString *)fullEmailString {
    NSString* name;
    NSString* email;
    
    NSString* addressString = [fullEmailString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([addressString isNonNilString]) {
        NSMutableCharacterSet* addressDelimiters = [NSMutableCharacterSet characterSetWithCharactersInString: @"<>"];
        [addressDelimiters formUnionWithCharacterSet: [NSCharacterSet whitespaceCharacterSet]];
        
        NSMutableCharacterSet* nameDelimiters = [NSMutableCharacterSet characterSetWithCharactersInString: @"\""];
        [nameDelimiters formUnionWithCharacterSet: [NSCharacterSet whitespaceCharacterSet]];
        
        // Find space between name and address "first last <mailbox@domain>"
        NSRange lastSpace = [addressString rangeOfString: @" " options: NSBackwardsSearch];
        
        if (lastSpace.location != NSNotFound) {
            
            NSString* potentiallyEncodedWord = [[addressString substringWithRange: NSMakeRange(0, lastSpace.location)]
                                                stringByTrimmingCharactersInSet: nameDelimiters];
            
            NSString* potentiallyDecodedWord = [potentiallyEncodedWord mdcStringByDecodingRFC2047];
            
            name =  potentiallyDecodedWord;
            
            email = [[addressString substringWithRange: NSMakeRange(lastSpace.location+1, addressString.length-lastSpace.location-1)]
                                stringByTrimmingCharactersInSet: addressDelimiters];
        } else {
            // only have <mailbox@domain>
            email = [addressString stringByTrimmingCharactersInSet: addressDelimiters];
        }
    }
    
    return [[SimpleRFC822Address alloc] initWithName: name email: email];
}
/* designated initializer */
-(instancetype) initWithName:(NSString *)name email:(NSString *)email {
    self = [super init];
    
    if (self) {
        _name = name;
        _email = email;
        if (email) {
            NSArray* parts = [email componentsSeparatedByString: @"@"];
            if ([parts count]==2) {
                _mailbox = parts[0];
                _domain = parts[1];
            }
        }
    }
    
    return self;
}

-(id) init {
    self = [self initWithName: nil email: nil];
    
    return self;
}

-(NSString *) stringRFC822AddressFormat {
    NSString *rfc822Email = nil;
    if (self.name.length != 0) {
        rfc822Email = [NSString stringWithFormat: @"%@ <%@>", self.name, self.email];
    } else {
        rfc822Email = [NSString stringWithFormat: @"<%@>", self.email];
    }
    return rfc822Email;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"%@ Name: %@; E-Mail: %@; Mailbox: %@; Domain: %@;",
            [super description], _name, _email, _mailbox, _domain];
}
-(NSString*) debugDescription {
    return [NSString stringWithFormat:@"%@ Name: %@; E-Mail: %@; Mailbox: %@; Domain: %@;",
            [super description], _name, _email, _mailbox, _domain];
}

- (NSUInteger)hash {
    NSUInteger nameHash = [_name hash];
    nameHash += [_email hash];
//    NSString* fullAddress = [NSString stringWithFormat:@"%@ %@ %@ %@", _name, _email, _mailbox, _domain];
//    NSLog(@"Hash: %lu, Self: %@",nameHash,_email);
    return nameHash;
}

- (BOOL)isEqual:(id)other {
    BOOL equality = NO;
    
    if ([other isKindOfClass: [SimpleRFC822Address class]]) {
        SimpleRFC822Address *otherEmail = (SimpleRFC822Address*) other;
        if (otherEmail == self){
            equality = YES;
        } else {
            if ([self.name isNonNilString]) {
                // if self.name is non-nil then other.name should be non-nil and equal to be an equal object.
                equality = [self.name isEqualToString: otherEmail.name];
            } else if (![otherEmail.name isNonNilString]){
                // both == nil
                equality = YES; // chance at equality
            }
            
            if (equality && [self.email isEqualToString: otherEmail.email]
                && [self.mailbox isEqualToString: otherEmail.mailbox]
                && [self.domain isEqualToString: otherEmail.domain]) {
                equality = YES;
            } else {
                equality = NO;
            }
        }
    } else if ([other isKindOfClass:[SimpleRFC822GroupAddress class]]) {
        // comparing address to group
//        NSLog(@"Comparing group to address");
    }

//    NSLog(@"Self:%lu - %@",[self hash], self);
//    NSLog(@"Other:%lu - %@",[other hash], other);
//    NSLog(@"Result: %hhd", equality);

    return equality;
}
@end
