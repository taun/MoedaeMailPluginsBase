//
//  MMPMimeProxy.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 02/04/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Proxy Class for Message Mime Content to be passed to viewers.
 One way, Read-only
 
 */
@interface MMPMimeProxy : NSObject

@property (nonatomic, retain) NSString * bodyIndex;
@property (nonatomic, retain) NSString * charset;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * encoding;
@property (nonatomic, retain) NSString * extensions;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isAttachment;
@property (nonatomic, retain) NSNumber * isInline;
@property (nonatomic, retain) NSNumber * isLeaf;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * lines;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * md5;
@property (nonatomic, retain) NSString * mime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * octets;
@property (nonatomic, retain) NSString * subtype;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * subPartNumber;
@property (nonatomic, retain) NSOrderedSet *childNodes;
@property (nonatomic, retain) NSSet *parameters;
@property (nonatomic, retain) NSData * decoded;
@property (nonatomic, retain) NSString * encoded;
@property (nonatomic, retain) NSNumber * isDecoded;


@end
