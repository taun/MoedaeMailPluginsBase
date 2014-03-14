//
//  SimpleRFC822GroupAddress.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 03/13/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "SimpleRFC822GroupAddress.h"
#import "NSObject+MBShorthand.h"

@implementation SimpleRFC822GroupAddress

+(instancetype) newGroupNamed:(NSString *)name fromString:(NSString *)aList {
    
    
    return nil;
}

+(instancetype) newGroupNamed:(NSString *)name addresses:(NSSet *)list {
    return [[SimpleRFC822GroupAddress alloc] initWithName: name addresses: list];
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


@end
