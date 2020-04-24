//
//  MoedaeMailPluginsBaseTests.m
//  MoedaeMailPluginsTests
//
//  Created by Taun Chapman on 02/04/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+IMAPConversions.h"
#import "NSScanner+IMAPConversions.h"
#import "SimpleRFC822Address.h"

@interface MoedaeMailPluginsBaseTests : XCTestCase

@end

@implementation MoedaeMailPluginsBaseTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*!
 Sample test addresses from RFC
 
 From: "Joe Q. Public" <john.q.public@example.com>
 To: Mary Smith <mary@x.test>, jdoe@example.org, Who? <one@y.test>
 Cc: <boss@nil.test>, "Giant; \"Big\" Box" <sysservices@example.net>
 
 From: Pete <pete@silly.example>
 To: A Group:Ed Jones <c@a.test>,joe@where.test,John <jdoe@one.test>;
 Cc: Undisclosed recipients:;
 
 From: Pete(A nice \) chap) <pete(his account)@silly.test(his host)>
 To:A Group(Some people)
 :Chris Jones <c@(Chris’s host.)public.example>,
 joe@example.org,
 John <jdoe@one.test> (my dear friend); (the end of the group)
 Cc:(Empty list)(start)Hidden recipients  :(nobody(that I know))  ;
 
 
 
 */

#pragma mark - Single email tests
- (void)testEmailAddress1 {
    NSString* emailString = @"john.q.public@example.com";
    SimpleRFC822Address *newAddress = [SimpleRFC822Address newFromString: emailString];
    SimpleRFC822Address *correctAddress = [SimpleRFC822Address newAddressName: @"" email: @"john.q.public@example.com"];
    SimpleRFC822Address* correctGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: [NSSet setWithObject: correctAddress]];
    BOOL result = [correctGroup isEqual: newAddress];
    
    XCTAssertTrue(result, );
}

- (void)testEmailAddress4 {
    NSString* emailString = @"<john.q.public@example.com>";
    SimpleRFC822Address *newAddress = [SimpleRFC822Address newFromString: emailString];
    SimpleRFC822Address *correctAddress = [SimpleRFC822Address newAddressName: @"" email: @"john.q.public@example.com"];
    SimpleRFC822Address* correctGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: [NSSet setWithObject: correctAddress]];
    BOOL result = [correctGroup isEqual: newAddress];
    
    XCTAssertTrue(result, );
}

- (void)testEmailAddress2 {
    NSString* emailString = @"\"Joe Q. Public\" <john.q.public@example.com>";
    SimpleRFC822Address *newAddress = [SimpleRFC822Address newFromString: emailString];
    SimpleRFC822Address *correctAddress = [SimpleRFC822Address newAddressName: @"Joe Q. Public" email: @"john.q.public@example.com"];
    SimpleRFC822Address* correctGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: [NSSet setWithObject: correctAddress]];
    BOOL result = [correctGroup isEqual: newAddress];
    
    XCTAssertTrue(result, );
}

- (void)testEmailAddress3 {
    NSString* emailString = @"Joe Q. Public <john.q.public@example.com>";
    SimpleRFC822Address *newAddress = [SimpleRFC822Address newFromString: emailString];
    SimpleRFC822Address *correctAddress = [SimpleRFC822Address newAddressName: @"Joe Q. Public" email: @"john.q.public@example.com"];
    SimpleRFC822Address* correctGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: [NSSet setWithObject: correctAddress]];
    BOOL result = [correctGroup isEqual: newAddress];
    
    XCTAssertTrue(result, );
}

#pragma mark - Email list tests
-(void)testLongAddressesStringNamesWithCommasToSet {
    NSString* emailString = @"\"John Q. Public\" <email@example.com>, <email@subdomain.example.edu>, \"Jim James\" <firstname.lastname@example2.com>, \"Prince\" <email7@example.com>, \"Wise Man\" <email5@example.com>, \"Hari Seldon\" <email6@example.com>, \"Mousey Mouse\" <example2@sub.example2.ca>, \"Given Last\" <email1@example.ca>, \"Quick Nick\" <example3@example2.ca>, \"Who who who\" <last3@EXAMPLE.COM>, \"My Robot\" <g.last@EXAMPLE.ORG>, <email3@example.com>, \"BIG BOY\" <example4@example3.com>, <email2@example.com>, \"Gail Surname\" <firstname_lastname@example.u.edu>, \"First2 Surname\" <firstname.lastname@example2.edu>, \"Who who\" <last@EXAMPLE.COM>, \"Strong Arm\" <abc@example2.com>, \"Givena S1 and Givenb S2\" <maplerowfarm@yahoo.com>, \"Public, Janet\" <firstname.lastname@example.com>, \"Mary Public\" <email@example.co.jp>, \"Rob Public\" <a.b@example1.com>, \"Mary, Public Q\" <email@example.ca>, \"Jeff Public\" <firstname+lastname@example.com>, \"Given Surname\" <email@example-one.com>, \"Given Surname\" <firstname.lastname@example.net>, \"Given Surname\" <lastname@example.com>, <firstname.lastname@example.com>, \"last, first1\" <example3@example3.ca>, \"Surname, Given\" <firstname.lastname@abc-def.example.ca>, \"G. Surname\" <email4@example.com>, <example2@example2.net>, \"Dave Public\" <email@subdomain.example.edu>, \"G Surname\" <email1@example1.ca>";
    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];

    // log the correct address to create the reference set code.
//    for (SimpleRFC822Address* address in newGroup.addresses) {
//        NSLog(@"[groupSet addObject: [SimpleRFC822Address newAddressName: @\"%@\" email: @\"%@\"]];",address.name, address.email);
//    }
//    
    NSMutableSet* groupSet = [NSMutableSet new];

    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Given Last" email: @"email1@example.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Surname, Given" email: @"firstname.lastname@abc-def.example.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"G Surname" email: @"email1@example1.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jeff Public" email: @"firstname+lastname@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Rob Public" email: @"a.b@example1.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mary Public" email: @"email@example.co.jp"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mary, Public Q" email: @"email@example.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"First2 Surname" email: @"firstname.lastname@example2.edu"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Givena S1 and Givenb S2" email: @"maplerowfarm@yahoo.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Dave Public" email: @"email@subdomain.example.edu"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jim James" email: @"firstname.lastname@example2.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Strong Arm" email: @"abc@example2.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"example2@example2.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Public, Janet" email: @"firstname.lastname@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mousey Mouse" email: @"example2@sub.example2.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Quick Nick" email: @"example3@example2.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"last, first1" email: @"example3@example3.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Given Surname" email: @"email@example-one.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"BIG BOY" email: @"example4@example3.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"My Robot" email: @"g.last@EXAMPLE.ORG"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Given Surname" email: @"firstname.lastname@example.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Who who" email: @"last@EXAMPLE.COM"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Who who who" email: @"last3@EXAMPLE.COM"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"firstname.lastname@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"email2@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"email3@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"email@subdomain.example.edu"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"G. Surname" email: @"email4@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Gail Surname" email: @"firstname_lastname@example.u.edu"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Wise Man" email: @"email5@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Given Surname" email: @"lastname@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Hari Seldon" email: @"email6@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"John Q. Public" email: @"email@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Prince" email: @"email7@example.com"]];
    
    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: groupSet];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}
-(void)testShorterLongAddressesStringNamesWithCommasToSet {
    NSString* emailString = @"\"Public, Janet\" <firstname.lastname@example.com>, \"Mary Public\" <email@example.co.jp>, \"Rob Public\" <a.b@example1.com>, \"Mary, Public Q\" <email@example.ca>, \"Jeff Public\" <firstname+lastname@example.com>, \"Given Surname\" <email@example-one.com>, \"Given Surname\" <firstname.lastname@example.net>, \"Given Surname\" <lastname@example.com>, <firstname.lastname@example.com>";
    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];
    
    // log the correct address to create the reference set code.
    //    for (SimpleRFC822Address* address in newGroup.addresses) {
    //        NSLog(@"[groupSet addObject: [SimpleRFC822Address newAddressName: @\"%@\" email: @\"%@\"]];",address.name, address.email);
    //    }
    //
    NSMutableSet* groupSet = [NSMutableSet new];
    
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jeff Public" email: @"firstname+lastname@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Rob Public" email: @"a.b@example1.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mary Public" email: @"email@example.co.jp"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mary, Public Q" email: @"email@example.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Public, Janet" email: @"firstname.lastname@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Given Surname" email: @"email@example-one.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Given Surname" email: @"firstname.lastname@example.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"firstname.lastname@example.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Given Surname" email: @"lastname@example.com"]];
    
    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: groupSet];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}

/*
 "'Trisha Tuttle'" <tbtut@aol.com>,	<dbasarab13@gmail.com>, <chamberlain51@comcast.net>,	<hjm041370@gmail.com>,	<adembrak@yahoo.com>, <wendy.dembrak@gmail.com>,	<jamesmckay@verizon.net>, <patrick.a.olivares@gmail.com>,	<jsarr@phoenixmanagement.com>, <marta@gigamyte.com>,	<todd@intelligentprofit.com>,	<mike_stagnaro@yahoo.com>, <theowells@gmail.com>,	<lescraig@hotmail.com>,	<barbycraig@hotmail.com>, <btuttle@teksystems.com>,	<the5mcqs@gmail.com>,	<ajbaci4@yahoo.com>, <arjetbaci@yahoo.com>,	<taun@charcoalia.net>,	<mmckay00@juno.com>, <myrna@charcoalia.net>
 */
//-(void)testLongAddressesStringNamesWithCommasAndTabsToSet {
//    NSString* addresses = [NSString stringWithFormat: @"\"'Trisha Tuttle'\" <tbtut@aol.com>,	<dbasarab13@gmail.com>, <chamberlain51@comcast.net>,	<hjm041370@gmail.com>,	<adembrak@yahoo.com>, <wendy.dembrak@gmail.com>,	<jamesmckay@verizon.net>, <patrick.a.olivares@gmail.com>,	<jsarr@phoenixmanagement.com>, <marta@gigamyte.com>,	<todd@intelligentprofit.com>,	<mike_stagnaro@yahoo.com>, <theowells@gmail.com>,	<lescraig@hotmail.com>,	<barbycraig@hotmail.com>, <btuttle@teksystems.com>,	<the5mcqs@gmail.com>,	<ajbaci4@yahoo.com>, <arjetbaci@yahoo.com>,	<taun@charcoalia.net>,	<mmckay00@juno.com>, <myrna@charcoalia.net>"];
//    NSSet* simpleAddressSet = [self reverseTranformAddresses: addresses];
//    NSString* reference = [self transformAddressesToString: simpleAddressSet];
//    NSSet* simpleAddressSet2 = [self reverseTranformAddresses: reference];
//    BOOL success = [simpleAddressSet2 isEqualToSet: simpleAddressSet];
//    XCTAssertTrue(success, @"%@ & %@ Should be equal.", addresses, reference);
//}



#pragma mark - Single Group tests

- (void)testEmailGroup1 {
    NSString* emailString = @"A Group(Some people):Chris Jones <c@(Chris’s host.)public.example>, joe@example.org,John <jdoe@one.test> (my dear friend); (the end of the group)";

    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];
    
    // Create the reference for testing
    SimpleRFC822Address* address1 = [SimpleRFC822Address newAddressName: @"Chris Jones" email: @"c@public.example"];
    SimpleRFC822Address* address2 = [SimpleRFC822Address newAddressName: nil email: @"joe@example.org"];
    SimpleRFC822Address* address3 = [SimpleRFC822Address newAddressName: @"John" email: @"jdoe@one.test"];
    NSSet* groupSet = [NSSet setWithObjects: address1, address2, address3, nil];
    SimpleRFC822Address* subGroup = [SimpleRFC822Address newAddressesGroupNamed: @"A Group" addresses: groupSet];
    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: [NSSet setWithObjects: subGroup, nil]];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}
- (void)testEmailGroup2 {
    NSString* emailString = @"Pete(A nice \\) chap) <pete(his account)@silly.test(his host)>";

    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];

    // Create the reference for testing
    SimpleRFC822Address* address1 = [SimpleRFC822Address newAddressName: @"Pete" email: @"pete@silly.test"];
    NSSet* groupSet = [NSSet setWithObjects: address1, nil];

    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: groupSet];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}
- (void)testEmailGroup3 {
    NSString* emailString = @"Pete(A nice \\) chap) <pete(his account)@silly.test(his host)>,A Group(Some people):Chris Jones <c@(Chris’s host.)public.example>, joe@example.org,John <jdoe@one.test> (my dear friend); (the end of the group)";
    
    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];
    
    // Create the reference for testing
    SimpleRFC822Address* address0 = [SimpleRFC822Address newAddressName: @"Pete" email: @"pete@silly.test"];
    
    SimpleRFC822Address* address1 = [SimpleRFC822Address newAddressName: @"Chris Jones" email: @"c@public.example"];
    SimpleRFC822Address* address2 = [SimpleRFC822Address newAddressName: nil email: @"joe@example.org"];
    SimpleRFC822Address* address3 = [SimpleRFC822Address newAddressName: @"John" email: @"jdoe@one.test"];
    NSSet* groupSet = [NSSet setWithObjects: address1, address2, address3, nil];
    SimpleRFC822Address* subGroup = [SimpleRFC822Address newAddressesGroupNamed: @"A Group" addresses: groupSet];
    
    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: [NSSet setWithObjects: address0, subGroup, nil]];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}

- (void)testEmailGroup4 {
    NSString* emailString = @"(Empty list)(start)Hidden recipients  :(nobody(that I know))  ;";
    
    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];

    SimpleRFC822Address* subGroup = [SimpleRFC822Address newAddressesGroupNamed: @"Hidden recipients" addresses: [NSSet new]];
    
    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: [NSSet setWithObjects: subGroup, nil]];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}

- (void)testEmailGroup5 {
    NSString* emailString = @":;";
    
    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];

    SimpleRFC822Address* subGroup = [SimpleRFC822Address newAddressesGroupNamed: nil addresses: [NSSet new]];
    
    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: [NSSet setWithObjects: subGroup, nil]];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}

//
//

- (void)testEmailGroup6 {
    NSString* emailString = @"Pete(A nice \\) chap) <pete(his account)@silly.test(his host)>,=?UTF-8?B?VEFVTiBDSEFQTUFO?= <taun@charcoalia.net>,=?UTF-8?Q?The_general-purpose_Squ?= =?UTF-8?Q?eak_developers_list=C2=A0=C2=A0=C2=A0=C2=A0?= <squeak-dev@lists.squeakfoundation.org>";
    
    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];
    
    // Create the reference for testing
    SimpleRFC822Address* address1 = [SimpleRFC822Address newAddressName: @"Pete" email: @"pete@silly.test"];
    SimpleRFC822Address* address2 = [SimpleRFC822Address newAddressName: @"=?UTF-8?B?VEFVTiBDSEFQTUFO?=" email: @"taun@charcoalia.net"];
    SimpleRFC822Address* address3 = [SimpleRFC822Address newAddressName: @"The general-purpose Squeak developers list    " email: @"squeak-dev@lists.squeakfoundation.org"];
    NSSet* groupSet = [NSSet setWithObjects: address1, address2, address3, nil];
    
    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: groupSet];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}

#pragma mark - Embedded Group tests

- (void) testCompressWhitespace1 {
    NSString* stringWithWhitespace = @"Hi John,\n\
    \n\
    \n\
    \n\
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna =\n\
    \n\
    aliqua.\n\
    \n\
    \n\
    \n\
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo =\n\
    \n\
consequat. \n\
    \n\
https://tools.ietf.org/html/rfc3501\n\
    \n\
    \n\
    \n\
    Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. =\n\
    Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\
    \n\
    \n\
    \n\
    \n\
";
    
    NSString* compressed = [stringWithWhitespace mdcCompressWitespace];
    NSLog(@"%@", compressed);
    NSString* refString = @"Hi John, Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna = aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo = consequat. https://tools.ietf.org/html/rfc3501 Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. = Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    
    BOOL result = [compressed isEqualToString: refString];
    
    XCTAssertTrue(result, );
}
@end
