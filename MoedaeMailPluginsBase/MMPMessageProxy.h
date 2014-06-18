//
//  MMPMessageProxy.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 05/22/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBoxProxy.h"
#import "SimpleRFC822Address.h"

/*!
 Currently unused and should remove.
 Added mime message/rfc822 header information to MMPMimeProxy instead.
 */
@interface MMPMessageProxy : NSObject

@property (nonatomic, retain) NSDate * dateReceived;
@property (nonatomic, retain) NSDate * dateSent;
@property (nonatomic, retain) NSString * encoding;
@property (nonatomic, retain) NSNumber * hasAttachment;
@property (nonatomic, retain) NSNumber * isAnsweredFlag;
@property (nonatomic, retain) NSNumber * isDeletedFlag;
@property (nonatomic, retain) NSNumber * isDraftFlag;
@property (nonatomic, retain) NSNumber * isFlaggedFlag;
@property (nonatomic, retain) NSNumber * isFullyCached;
@property (nonatomic, retain) NSNumber * isRecentFlag;
@property (nonatomic, retain) NSNumber * isSeenFlag;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSNumber * rfc2822Size;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * xSpamFlag;
@property (nonatomic, retain) NSString * returnPath;
@property (nonatomic, retain) NSNumber * xSpamScore;
@property (nonatomic, retain) NSString * xSpamLevel;
@property (nonatomic, retain) NSString * xSpamStatus;
@property (nonatomic, retain) SimpleRFC822Address *addressesBcc;
@property (nonatomic, retain) SimpleRFC822Address *addressesCc;
@property (nonatomic, retain) SimpleRFC822Address *addressesTo;
@property (nonatomic, retain) SimpleRFC822Address *addressFrom;
@property (nonatomic, retain) SimpleRFC822Address *addressReplyTo;
@property (nonatomic, retain) SimpleRFC822Address *addressSender;
@property (nonatomic, retain) NSSet *attachments;
@property (nonatomic, retain) NSOrderedSet *childNodes;
@property (nonatomic, retain) NSSet *flags;
//@property (nonatomic, retain) MBLabel *labels;
@property (nonatomic, retain) MBoxProxy *mbox;
@property (nonatomic, retain) NSSet *notes;
//@property (nonatomic, retain) MBRFC2822 *rfc2822;

@end
