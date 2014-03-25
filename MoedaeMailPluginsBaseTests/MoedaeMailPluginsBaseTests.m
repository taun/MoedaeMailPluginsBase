//
//  MoedaeMailPluginsBaseTests.m
//  MoedaeMailPluginsTests
//
//  Created by Taun Chapman on 02/04/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SimpleRFC822Address.h"
#import "NSString+IMAPConversions.h"
#import "NSScanner+IMAPConversions.h"

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


@end
