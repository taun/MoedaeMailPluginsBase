//
//  SimpleRFC822Address.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 11/1/11.
//  Copyright (c) 2011 MOEDAE LLC. All rights reserved.
//

#import "SimpleRFC822Address.h"
#import "NSString+IMAPConversions.h"
#import "NSObject+MBShorthand.h"

static NSRegularExpression *regexGroupEmails;
static NSRegularExpression *regexRfcComments;

@interface SimpleRFC822Address ()


@end


@implementation SimpleRFC822Address

/*!
 
 Sample group list text from RFC
 "A Group(Some people):Chris Jones <c@(Chris’s host.)public.example>, joe@example.org,John <jdoe@one.test> (my dear friend); (the end of the group)"
 "Pete(A nice \) chap) <pete(his account)@silly.test(his host)>"
 "Pete(A nice \) chap) <pete(his account)@silly.test(his host)>,A Group(Some people):Chris Jones <c@(Chris’s host.)public.example>, joe@example.org,John <jdoe@one.test> (my dear friend); (the end of the group)"
 
 Comment capture regex = "(\([^\(\)]*\))"
 Group capture regex = ":([^:;]*);"
 */
+(void)initialize {
    NSError *error=nil;
    regexGroupEmails = [[NSRegularExpression alloc] initWithPattern: @"([^,]*):([^:;]*);"
                                                            options: NSRegularExpressionCaseInsensitive
                                                              error: &error];
    if (error) {
        NSLog(@"regexGroupEmails NSRegularExpression Error: %@", error);
    }
    
    //    regexRfcComments = [[NSRegularExpression alloc] initWithPattern: @"(\\([^\\(\\)]*(?!\\\\)\\))"
    //                                                            options: NSRegularExpressionCaseInsensitive
    //                                                              error: &error];
    //    if (error) {
    //        NSLog(@"regexRfcComments NSRegularExpression Error: %@", error);
    //    }
}


+(instancetype) newFromString:(NSString *)emailString {
    return [[SimpleRFC822Address alloc] initWithString: emailString];
}
+(instancetype) newLeafAddressFromString:(NSString *)fullEmailString {
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
            
            name =  potentiallyEncodedWord;
            
            email = [[addressString substringWithRange: NSMakeRange(lastSpace.location+1, addressString.length-lastSpace.location-1)]
                     stringByTrimmingCharactersInSet: addressDelimiters];
        } else {
            // only have <mailbox@domain>
            email = [addressString stringByTrimmingCharactersInSet: addressDelimiters];
        }
    }
    
    return [SimpleRFC822Address newAddressName: name email: email];
}
+(instancetype) newAddressName:(NSString *)name email:(NSString *)email {
    return [[SimpleRFC822Address alloc] initWithName:name email:email];
}
+(instancetype) newAddressesGroupNamed: (NSString *)name addresses:(NSSet *)list {
    SimpleRFC822Address* newGroupAddress = [[[self class] alloc] initWithName: name email: nil];
    newGroupAddress.addresses = list;
    return newGroupAddress;
}
-(void) setName:(NSString *)potentiallyEncodedWord {
    NSString* name = [potentiallyEncodedWord mdcStringByDecodingRFC2047];
    
    if (![_name isEqualToString: name]) {
        _name = name;
    }
}
-(void) setEmail:(NSString *)email {
    if (_email != email) {
        _email = email;
        
        if (_email) {
            NSArray* parts = [email componentsSeparatedByString: @"@"];
            if ([parts count]==2) {
                _mailbox = parts[0];
                _domain = parts[1];
            }
        }
    }
}
-(void) setAddresses:(NSSet *)addresses {
    if (addresses != _addresses) {
        _addresses = addresses;
        if (_addresses.count > 0) {
            _isLeaf = NO;
        } else {
            _isLeaf = YES;
        }
    }
}
-(BOOL) showMe {
    return ([self.name isNonNilString] || ([self.email isNonNilString]) || (self.addresses.count > 0));
}
-(NSUInteger) count {
    return self.addresses.count;
}
/*!
 Group of Addresses ascii string to address object list
 
 String
 may or may not be a group ": ;"
 may or may not have Q or B encoded text
 may or may not have comments
 
 Need to
 1. remove all comments "(.*)"
 2. determine if there is a group and where "name:group;", extract name and recurse for addresses.
 3. separate addresses by "," and decode Q or B to UTF for each then convert to address object and add to array?
 
 
 
 @param anRfcGroupString ascii string in rfc 822 format
 
 @return SimpleRFC822Address
 */
-(instancetype) initWithString:(NSString *)anRfcGroupString {
    NSString* decommentedString = [anRfcGroupString mdcStringByRemovingRFCComments];

    
    NSMutableSet* tempAddresses = [NSMutableSet new];
    NSString* tempName = @"";  // always empty for top level group
    
    
    NSMutableString* topLevelAddresses = [decommentedString mutableCopy];
    
    NSArray* matches;
    matches = [regexGroupEmails matchesInString: topLevelAddresses options: 0 range: NSMakeRange(0, topLevelAddresses.length)];
    
    NSUInteger offset = 0; // offset compensation as groups are removed from topLevelAddresses string
    
    for (NSTextCheckingResult* tcr in matches) {
        // If no matches, no group just addresses to parse into an array
        // one match per group
        // 1st range is full group with name
        // 2nd range is group name, length == 0 if empty
        // 3rd range is group addresses, length == 0 if empty
        // trim strings and check length before assigning, make isNonNil trim?
        
        // Remove groups from topLevelAddresses
        // add group to address set
        
        NSTextCheckingResult* offsetTcr = [tcr resultByAdjustingRangesWithOffset: -offset];
        if ([offsetTcr numberOfRanges]==3) {
            // good
            NSRange groupFullRange = (NSRange)[offsetTcr rangeAtIndex:0];
            NSRange groupNameRange = (NSRange)[offsetTcr rangeAtIndex:1];
            NSRange groupListRange = (NSRange)[offsetTcr rangeAtIndex:2];
            
            NSString* groupName = [[topLevelAddresses substringWithRange: groupNameRange] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]; // may be empty
            NSString* groupList = [topLevelAddresses substringWithRange: groupListRange];
            NSSet* groupSet = [self addressesToSetForString: groupList];
            
            SimpleRFC822Address* newGroup = [SimpleRFC822Address newAddressesGroupNamed: groupName addresses: groupSet];
            
            if (newGroup) {
                [tempAddresses addObject: newGroup];
                [topLevelAddresses deleteCharactersInRange: groupFullRange];
                offset += groupFullRange.length;
            } else {
                // leave group in place if conversion fails for some reason.
            }
            
        } else {
            NSLog(@"%@,%@ Error - Should have 3 capture ranges. Only have: %lu",NSStringFromClass([self class]), NSStringFromSelector(_cmd),[offsetTcr numberOfRanges]);
        }
    }
    
    // Turn topLevelAddresses into set
    [tempAddresses unionSet: [self addressesToSetForString: topLevelAddresses]];
    
    SimpleRFC822Address* newAddress = [SimpleRFC822Address newAddressesGroupNamed: tempName addresses: tempAddresses];
    
    return newAddress;
}


-(NSSet*) addressesToSetForString: (NSString*) addressesString {
    NSMutableSet* addresses = [NSMutableSet new];
    
    if ([addressesString isKindOfClass: [NSString class]]) {
        NSString* noTabs = [addressesString stringByReplacingOccurrencesOfString: @"\t" withString: @"  "];
        NSString* noSingleQuote = [noTabs stringByReplacingOccurrencesOfString: @"'" withString: @""];
        NSString* trimmedAddressString = [noSingleQuote stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([trimmedAddressString isNonNilString]) {
            NSArray* addressesArray = [trimmedAddressString componentsSeparatedByString: @","];
            
            //            NSMutableArray* fixedAddressesArray = [NSMutableArray new];
            //            for (NSString* address in addressesArray) {
            //                // put back the ">" removed by using the componentsSeparatedByString method with ">, "
            //                trimmedAddressString = [address stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //                if ([trimmedAddressString isNonNilString]) {
            //                    [fixedAddressesArray addObject: [NSString stringWithFormat: @"%@>", address]];
            //                }
            //            }
            
            for (NSString* addressString in addressesArray) {
                if ([addressString isNonNilString]) {
                    SimpleRFC822Address* rfcAddress = [SimpleRFC822Address newLeafAddressFromString: addressString];//[addressString mdcSimpleRFC822Address];
                    if (rfcAddress) {
                        [addresses addObject: rfcAddress];
                    }
                }
            }
        }
    }
    
    return [addresses copy];
}

/* designated initializer */
-(instancetype) initWithName:(NSString *)name email:(NSString *)email{
    self = [super init];
    
    if (self) {
        [self setName: name];
        [self setEmail: email];
        _isLeaf = YES;
     }
    
    return self;
}

-(id) init {
    self = [self initWithName: nil email: nil];
    
    return self;
}

/*!
 String representation of addresses.
 If the address has no name, no email, and an addresses set, then assume it is a top level list of addresses.
 If there is a name, no email and an addresses set, then assumes it is a group.
 If there is an email and no addresses set, then it is a leaf address.
 If there is a name, email and addresses set, then something went wrong.
 
 @return NSString formatted as RFC2822 email addresses
 */
-(NSString *) stringRFC822AddressFormat {
    NSString* rfcString;
    
    if (!_email) {
        // a group, may have no addresses if an empty group
        rfcString = [self stringRFC822GroupAddressFormat];
    } else {
        rfcString = [self stringRFC822LeafAddressFormat];
    }
    return rfcString;
}
-(NSString*) stringRFC822GroupAddressFormat {
    NSUInteger roughCapacity = self.name.length + 2 + self.addresses.count*12;
    
    NSMutableString *rfc822Group = [NSMutableString stringWithCapacity: roughCapacity]; // default return value
    
    NSString* startDelimiter;
    NSString* endDelimiter;
    NSString* name = self.name;
    
    if ([self.name isNonNilString]) {
        // RFC group
        startDelimiter = @" :";
        endDelimiter = @"; ";
        
    } else {
        startDelimiter = @" ";
        endDelimiter = @" ";
        name = @"";
    }
    
    [rfc822Group appendFormat: @"%@%@", name, startDelimiter];
    
    for (SimpleRFC822Address* address in self.addresses) {
        // this will recurse if address is a groupAddress
        NSString *addressString = [address stringRFC822AddressFormat];
        if (addressString) {
            [rfc822Group appendString: addressString];
        }
    }
    
    [rfc822Group appendString: endDelimiter];
    
    return rfc822Group;
}
-(NSString*) stringRFC822LeafAddressFormat {
    NSString *rfc822Email = nil;
    if (self.name.length != 0) {
        rfc822Email = [NSString stringWithFormat: @"%@ <%@>", self.name, self.email];
    } else {
        rfc822Email = [NSString stringWithFormat: @"<%@>", self.email];
    }
    return rfc822Email;
}
-(NSString*) stringSingleTopLevel {
    NSString* simpleString;
    
    if ([self.email isNonNilString]) {
        // single leaf address. Normally wouldn't happen from UI
        simpleString = [self stringRFC822LeafAddressFormat];
    } else if ([self.name isNonNilString]) {
        // RFC group address since there is no email.
        simpleString = [NSString stringWithFormat: @"Group: %@", self.name];
    } else if (self.addresses.count > 0) {
        // top level list of address, pick one to display
        for (SimpleRFC822Address* address in self.addresses) {
            simpleString = [address stringSingleTopLevel];
            if ([simpleString isNonNilString]) {
                // found one
                break;
            }
        }
    }

    return simpleString;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"%@ Name: %@; E-Mail: %@; Mailbox: %@; Domain: %@; Addresses: %@",
            [super description], self.name, _email, _mailbox, _domain, _addresses];
}

- (id)copyWithZone:(NSZone *)zone{
    SimpleRFC822Address* newAddress = [SimpleRFC822Address new];
    newAddress.name = [self.name copy];
    newAddress.email = [self.email copy];
    newAddress.addresses = [self.addresses copy];
    
    return newAddress;
}

- (NSUInteger)hash {
    NSUInteger nameHash = [self.name hash];
    if (_email) {
        nameHash += [_email hash];
    }
    for (id address in _addresses) {
        nameHash += [[address email] hash];
    }
    //    NSString* fullAddress = [NSString stringWithFormat:@"%@ %@ %@ %@", _name, _email, _mailbox, _domain];
    //    NSLog(@"Hash: %lu, Self: %@",nameHash, self);
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
            
            if (equality && [self.email isNonNilString]) {
                equality = [self.email isEqualToString: otherEmail.email];
            } else if (![otherEmail.email isNonNilString]) {
                equality = YES;
            }
            
            if (equality && ((self.addresses.count > 0) || (otherEmail.addresses.count > 0))) {
                // using above test separate from below just to improve readability.
                if ((self.addresses.count == otherEmail.addresses.count) && [self.addresses isEqualToSet: otherEmail.addresses]) {
                    equality = YES;
                } else {
                    equality = NO;
                }
            }
        }
    }
    
//    NSLog(@"Self:%lu - %@",[self hash], self);
//    NSLog(@"Other:%lu - %@",[other hash], other);
//    NSLog(@"Result: %hhd", equality);

    return equality;
}


@end
