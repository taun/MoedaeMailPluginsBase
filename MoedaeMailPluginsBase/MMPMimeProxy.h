//
//  MMPMimeProxy.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 02/04/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleRFC822Address.h"
#import <CoreData/CoreData.h>

/*!
 Proxy Class for Message Mime Content to be passed to viewers.
 One way, Read-only
 
 */
@interface MMPMimeProxy : NSObject

@property (nonatomic, strong) NSManagedObjectID * objectID;
@property (nonatomic, strong) NSString * bodyIndex;
@property (nonatomic, strong) NSString * charset;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * encoding;
@property (nonatomic, strong) NSString * extensions;
@property (nonatomic, strong) NSString * filename;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSNumber * isAttachment;
@property (nonatomic, strong) NSNumber * isInline;
@property (nonatomic, strong) NSNumber * isLeaf;
@property (nonatomic, strong) NSString * language;
@property (nonatomic, strong) NSNumber * lines;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * md5;
@property (nonatomic, strong) NSString * mime;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * octets;
@property (nonatomic, strong) NSString * subtype;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSNumber * subPartNumber;
@property (nonatomic, strong) NSOrderedSet *childNodes;
@property (nonatomic, strong) NSSet *parameters;
@property (nonatomic, strong) NSData * decoded;
@property (nonatomic, strong) NSString * encoded;
@property (nonatomic, strong) NSNumber * isDecoded;

@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) SimpleRFC822Address *addressesBcc;
@property (nonatomic, retain) SimpleRFC822Address *addressesCc;
@property (nonatomic, retain) SimpleRFC822Address *addressesTo;
@property (nonatomic, retain) SimpleRFC822Address *addressFrom;
@property (nonatomic, retain) SimpleRFC822Address *addressReplyTo;
@property (nonatomic, retain) SimpleRFC822Address *addressSender;


@end
