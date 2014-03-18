//
//  MoedaeMailPluginsBaseTests.m
//  MoedaeMailPluginsTests
//
//  Created by Taun Chapman on 02/04/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SimpleRFC822Address.h"
#import "SimpleRFC822GroupAddress.h"
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
    SimpleRFC822Address *newAddress = [SimpleRFC822Address newAddressFromString: emailString];
    SimpleRFC822Address *correctAddress = [SimpleRFC822Address newAddressName: @"" email: @"john.q.public@example.com"];
    BOOL result = [correctAddress isEqual: newAddress];
    
    XCTAssertTrue(result, );
}

- (void)testEmailAddress4 {
    NSString* emailString = @"<john.q.public@example.com>";
    SimpleRFC822Address *newAddress = [SimpleRFC822Address newAddressFromString: emailString];
    SimpleRFC822Address *correctAddress = [SimpleRFC822Address newAddressName: @"" email: @"john.q.public@example.com"];
    BOOL result = [correctAddress isEqual: newAddress];
    
    XCTAssertTrue(result, );
}

- (void)testEmailAddress2 {
    NSString* emailString = @"\"Joe Q. Public\" <john.q.public@example.com>";
    SimpleRFC822Address *newAddress = [SimpleRFC822Address newAddressFromString: emailString];
    SimpleRFC822Address *correctAddress = [SimpleRFC822Address newAddressName: @"Joe Q. Public" email: @"john.q.public@example.com"];
    BOOL result = [correctAddress isEqual: newAddress];
    
    XCTAssertTrue(result, );
}

- (void)testEmailAddress3 {
    NSString* emailString = @"Joe Q. Public <john.q.public@example.com>";
    SimpleRFC822Address *newAddress = [SimpleRFC822Address newAddressFromString: emailString];
    SimpleRFC822Address *correctAddress = [SimpleRFC822Address newAddressName: @"Joe Q. Public" email: @"john.q.public@example.com"];
    BOOL result = [correctAddress isEqual: newAddress];
    
    XCTAssertTrue(result, );
}

#pragma mark - Email list tests

#pragma mark - Single Group tests

- (void)testEmailGroup1 {
    NSString* emailString = @"A Group(Some people):Chris Jones <c@(Chris’s host.)public.example>, joe@example.org,John <jdoe@one.test> (my dear friend); (the end of the group)";
    NSString *decommentedString = [emailString mdcStringByRemovingRFCComments];
    SimpleRFC822GroupAddress *newGroup = [SimpleRFC822GroupAddress newGroupFromString: decommentedString];
    
    // Create the reference for testing
    SimpleRFC822Address* address1 = [SimpleRFC822Address newAddressName: @"Chris Jones" email: @"c@public.example"];
    SimpleRFC822Address* address2 = [SimpleRFC822Address newAddressName: nil email: @"joe@example.org"];
    SimpleRFC822Address* address3 = [SimpleRFC822Address newAddressName: @"John" email: @"jdoe@one.test"];
    NSSet* groupSet = [NSSet setWithObjects: address1, address2, address3, nil];
    SimpleRFC822GroupAddress* subGroup = [SimpleRFC822GroupAddress newGroupNamed: @"A Group" addresses: groupSet];
    SimpleRFC822GroupAddress* refGroup = [SimpleRFC822GroupAddress newGroupNamed: @"" addresses: [NSSet setWithObjects: subGroup, nil]];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}
- (void)testEmailGroup2 {
    NSString* emailString = @"Pete(A nice \\) chap) <pete(his account)@silly.test(his host)>";
    NSString *decommentedString = [emailString mdcStringByRemovingRFCComments];

    SimpleRFC822GroupAddress *newGroup = [SimpleRFC822GroupAddress newGroupFromString: decommentedString];

    // Create the reference for testing
    SimpleRFC822Address* address1 = [SimpleRFC822Address newAddressName: @"Pete" email: @"pete@silly.test"];
    NSSet* groupSet = [NSSet setWithObjects: address1, nil];

    SimpleRFC822GroupAddress* refGroup = [SimpleRFC822GroupAddress newGroupNamed: @"" addresses: groupSet];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}
- (void)testEmailGroup3 {
    NSString* emailString = @"Pete(A nice \\) chap) <pete(his account)@silly.test(his host)>,A Group(Some people):Chris Jones <c@(Chris’s host.)public.example>, joe@example.org,John <jdoe@one.test> (my dear friend); (the end of the group)";
    NSString *decommentedString = [emailString mdcStringByRemovingRFCComments];
    
    SimpleRFC822GroupAddress *newGroup = [SimpleRFC822GroupAddress newGroupFromString: decommentedString];
    
    // Create the reference for testing
    SimpleRFC822Address* address0 = [SimpleRFC822Address newAddressName: @"Pete" email: @"pete@silly.test"];
    
    SimpleRFC822Address* address1 = [SimpleRFC822Address newAddressName: @"Chris Jones" email: @"c@public.example"];
    SimpleRFC822Address* address2 = [SimpleRFC822Address newAddressName: nil email: @"joe@example.org"];
    SimpleRFC822Address* address3 = [SimpleRFC822Address newAddressName: @"John" email: @"jdoe@one.test"];
    NSSet* groupSet = [NSSet setWithObjects: address1, address2, address3, nil];
    SimpleRFC822GroupAddress* subGroup = [SimpleRFC822GroupAddress newGroupNamed: @"A Group" addresses: groupSet];
    
    SimpleRFC822GroupAddress* refGroup = [SimpleRFC822GroupAddress newGroupNamed: @"" addresses: [NSSet setWithObjects: address0, subGroup, nil]];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}

- (void)testEmailGroup4 {
    NSString* emailString = @"(Empty list)(start)Hidden recipients  :(nobody(that I know))  ;";
    NSString *decommentedString = [emailString mdcStringByRemovingRFCComments];
    
    SimpleRFC822GroupAddress *newGroup = [SimpleRFC822GroupAddress newGroupFromString: decommentedString];

    SimpleRFC822GroupAddress* subGroup = [SimpleRFC822GroupAddress newGroupNamed: @"Hidden recipients" addresses: [NSSet new]];
    
    SimpleRFC822GroupAddress* refGroup = [SimpleRFC822GroupAddress newGroupNamed: @"" addresses: [NSSet setWithObjects: subGroup, nil]];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}

- (void)testEmailGroup5 {
    NSString* emailString = @":;";
    NSString *decommentedString = [emailString mdcStringByRemovingRFCComments];
    
    SimpleRFC822GroupAddress *newGroup = [SimpleRFC822GroupAddress newGroupFromString: decommentedString];

    SimpleRFC822GroupAddress* subGroup = [SimpleRFC822GroupAddress newGroupNamed: nil addresses: [NSSet new]];
    
    SimpleRFC822GroupAddress* refGroup = [SimpleRFC822GroupAddress newGroupNamed: @"" addresses: [NSSet setWithObjects: subGroup, nil]];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}
#pragma mark - Embedded Group tests


@end
