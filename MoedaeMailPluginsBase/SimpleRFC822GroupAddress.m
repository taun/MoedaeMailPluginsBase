//
//  SimpleRFC822GroupAddress.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 03/13/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "SimpleRFC822GroupAddress.h"
#import "NSObject+MBShorthand.h"
#import "NSString+IMAPConversions.h"

static NSRegularExpression *regexGroupEmails;
static NSRegularExpression *regexRfcComments;


@implementation SimpleRFC822GroupAddress

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


//+(instancetype) newGroupNamed:(NSString *)name fromString:(NSString *)aList {
//    return nil;
//}

+(instancetype) newGroupNamed:(NSString *)name addresses:(NSSet *)list {
    return [[[self class] alloc] initWithName: name addresses: list];
}

+(instancetype) newGroupFromString:(NSString *)anRfcGroupString {
    return [[[self class] alloc] initWithGroupString: anRfcGroupString];
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
 
 @return SimpleRFC822GroupAddress
 */
-(instancetype) initWithGroupString:(NSString *)anRfcGroupString {

    // 1st Remove comments
    NSMutableSet* tempAddresses = [NSMutableSet new];
    NSString* tempName = @"";  // always empty for top level group

    
    NSMutableString* topLevelAddresses = [anRfcGroupString mutableCopy];

    NSArray* matches;
    matches = [regexGroupEmails matchesInString: anRfcGroupString options: 0 range: NSMakeRange(0, anRfcGroupString.length)];

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
            
            SimpleRFC822GroupAddress* newGroup = [SimpleRFC822GroupAddress newGroupNamed: groupName addresses: groupSet];
            
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
    
    return [[[self class] alloc] initWithName: tempName addresses: tempAddresses];
}

/* designated initializer */
-(instancetype) initWithName:(NSString *)name addresses:( NSSet *)list {
    self = [super init];
    
    if (self) {
        _name = name;
        _addresses = list;
     }
    
    return self;
}

-(id) init {
    self = [self initWithName: nil addresses: nil];
    
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"%@ Name: %@; Addresses: %@",
            [super description], _name, _addresses];
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
                    SimpleRFC822Address* rfcAddress = [SimpleRFC822Address newAddressFromString: addressString];//[addressString mdcSimpleRFC822Address];
                    if (rfcAddress) {
                        [addresses addObject: rfcAddress];
                    }
                }
            }
        }
    }
    
    return [addresses copy];
}

-(NSString *) stringRFC822AddressFormat {
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

- (NSUInteger)hash {
    NSUInteger nameHash = [_name hash];
    for (id address in _addresses) {
        nameHash += [[address name] hash];
    }
    //    NSString* fullAddress = [NSString stringWithFormat:@"%@ %@ %@ %@", _name, _email, _mailbox, _domain];
//    NSLog(@"Hash: %lu, Self: %@",nameHash, self);
    return nameHash;
}

- (BOOL)isEqual:(id)other {
    BOOL equality = NO;
    
    if ([other isKindOfClass: [SimpleRFC822GroupAddress class]]) {
        SimpleRFC822GroupAddress *otherEmail = (SimpleRFC822GroupAddress*) other;
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
            
            
            
            if (equality && [self.addresses isEqualToSet: otherEmail.addresses]) {
                equality = YES;
            } else {
                equality = NO;
            }
        }
    } else if ([other isKindOfClass:[SimpleRFC822Address class]]) {
        // comparing address to group
//        NSLog(@"Comparing address to group");
    }
//    NSLog(@"Self:%lu - %@",[self hash], self);
//    NSLog(@"Other:%lu - %@",[other hash], other);
//    NSLog(@"Result: %hhd", equality);
    
    return equality;
}


@end
