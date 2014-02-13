//
//  MoedaeMailPluginsBase.h
//  MoedaeMailPluginsBase
//
//  Created by Taun Chapman on 02/04/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

@class MMPMimeProxy;

/*
 5.1.  Syntax of the Content-Type Header Field
 In the Augmented BNF notation of RFC 822, a Content-Type header field value is defined as follows:
 content := "Content-Type" ":" type "/" subtype *(";" parameter) ; Matching of media type and subtype is ALWAYS case-insensitive.
 type := discrete-type / composite-type
 discrete-type := "text" / "image" / "audio" / "video" / "application" / extension-token
 composite-type := "message" / "multipart" / extension-token
 extension-token := ietf-token / x-token
 ietf-token := <An extension token defined by a standards-track RFC and registered with IANA.>
 x-token := <The two characters "X-" or "x-" followed, with no intervening white space, by any token>
 subtype := extension-token / iana-token
 iana-token := <A publicly-defined extension token. Tokens of this form must be registered with IANA as specified in RFC 2048.>
 parameter := attribute "=" value
 attribute := token ; Matching of attributes ; is ALWAYS case-insensitive.
 value := token / quoted-string
 token := 1*<any (US-ASCII) CHAR except SPACE, CTLs, or tspecials>
 tspecials := Freed & Borenstein "(" / ")" / "<" / ">" / "@" / "," / ";" / ":" / "\" / <"> "/" / "[" / "]" / "?" / "=" ; Must be in quoted-string, ; to use within parameter values
 
 http://www.iana.org/assignments/imap-keywords/imap-keywords.xhtml#imap-keywords-1
 
 http://www.iana.org/assignments/media-types/media-types.xhtml
 
 
 Summary:
 
 Types:
 
    discrete-type := "text" / "image" / "audio" / "video" / "application" / extension-token
 
    composite-type := "message" / "multipart" / extension-token
 

 subtype := extension-token / iana-token
 
 
 */
@interface MMPBaseMimeView : NSView

@property (nonatomic,strong) MMPMimeProxy       *node;
@property (nonatomic,strong) NSDictionary       *options;
@property (nonatomic,strong) NSDictionary       *attributes;
@property (nonatomic,strong) NSView             *mimeView;
@property (nonatomic,readonly) BOOL             wantsRichTextPresentation;

/*
 content := "Content-Type" ":" type "/" subtype *(";" parameter) ; Matching of media type and subtype is ALWAYS case-insensitive.
 set of handled contentTypes as NSString* with Type/Subtype case-insensitive
 Note these strings may also be used in the user interface.
 Possibly may use infoPlist.strings
 
 Some plugins may handle more than one subtype such as the IMAGE type.
 
 Ignoring ";" parameter
 */
+(NSSet*) contentTypes;


- (unsigned)interfaceVersion;

/* designated initializer */
-(instancetype) initWithFrame:(NSRect)frameRect node: (MMPMimeProxy*)node options: (NSDictionary*) options attributes: (NSDictionary*) attributes;

/* abstract, probably should be made private */
-(void) createSubviews;

-(void) removeSubviews;

@end
