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
-(void)testLongAddressesStringNamesWithCommasToSet {
    NSString* emailString = @"\"Mike Lee\" <mlee@rdpartners.com>, <wilkins@umbi.umd.edu>, \"Clayton Cardin\" <clayton.cardin@verizon.net>, \"PaGeN\" <pagen@io.com>, \"David Wieger\" <davidmichaelw@hotmail.com>, \"Gary Seldon\" <garyseldon@earthlink.net>, \"Jeff Malmgren\" <coord@vul.bc.ca>, \"Mark Walker\" <mwalker@skyytek.com>, \"Nick Roberts\" <nroberts@cyberus.ca>, \"peter roper\" <roper@portofolio.com>, \"Pieter Botman\" <P.BOTMAN@IEEE.ORG>, <Puttyhead@aol.com>, \"rob seidenberg\" <robseidenberg@yahoo.com>, <apeters@bhsusa.com>, \"Jamie Demarest\" <Jamie_demarest@newton.mec.edu>, \"Charles Shoemaker\" <charles.shoemaker@tufts.edu>, \"Scott Todd\" <sasha@scottsasha.com>, \"Michael Fortman\" <mcfortman@yahoo.com>, \"Matt J and Lori B\" <maplerowfarm@yahoo.com>, \"terry plotkin\" <tplotkin@earthlink.net>, \"Bowen, Mike\" <mike.bowen@bmonb.com>, \"Mark Corsey\" <eclipsemc@earthlink.net>, \"rob botman\" <rob.botman@gmail.com>, \"Moran, Mark D\" <mdmoran@kpmg.ca>, \"Jeffrey Wood\" <jeff@agencynextdoor.com>, \"Glenn Ulmer\" <GUlmer@syscom-consulting.com>, \"Tim Friesen\" <tim.friesen@telusplanet.net>, \"David Finn\" <finner64@gmail.com>, <stephen.wiencke@bmo.com>, \"Bruton, Peter\" <bruton@NRCan.gc.ca>, \"Fielding, Craig\" <Craig.Fielding@cra-arc.gc.ca>, \"J. Invencio\" <bosgmasters@mac.com>, <canniff@canniff.net>, \"Dave Wilkins\" <wilkins@umbi.umd.edu>, \"B KIRBY\" <ber01906@berk.com>, \"Taun\" <taun@charcoalia.net>";
    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];

    // log the correct address to create the reference set code.
//    for (SimpleRFC822Address* address in newGroup.addresses) {
//        NSLog(@"[groupSet addObject: [SimpleRFC822Address newAddressName: @\"%@\" email: @\"%@\"]];",address.name, address.email);
//    }
//    
    NSMutableSet* groupSet = [NSMutableSet new];

    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mark Walker" email: @"mwalker@skyytek.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Fielding, Craig" email: @"Craig.Fielding@cra-arc.gc.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"B KIRBY" email: @"ber01906@berk.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jeffrey Wood" email: @"jeff@agencynextdoor.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"rob botman" email: @"rob.botman@gmail.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"terry plotkin" email: @"tplotkin@earthlink.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mark Corsey" email: @"eclipsemc@earthlink.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Moran, Mark D" email: @"mdmoran@kpmg.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Charles Shoemaker" email: @"charles.shoemaker@tufts.edu"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Matt J and Lori B" email: @"maplerowfarm@yahoo.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Dave Wilkins" email: @"wilkins@umbi.umd.edu"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Clayton Cardin" email: @"clayton.cardin@verizon.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Michael Fortman" email: @"mcfortman@yahoo.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"canniff@canniff.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Bowen, Mike" email: @"mike.bowen@bmonb.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jeff Malmgren" email: @"coord@vul.bc.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Nick Roberts" email: @"nroberts@cyberus.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Bruton, Peter" email: @"bruton@NRCan.gc.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Glenn Ulmer" email: @"GUlmer@syscom-consulting.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"rob seidenberg" email: @"robseidenberg@yahoo.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Pieter Botman" email: @"P.BOTMAN@IEEE.ORG"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Tim Friesen" email: @"tim.friesen@telusplanet.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Scott Todd" email: @"sasha@scottsasha.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"peter roper" email: @"roper@portofolio.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"stephen.wiencke@bmo.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"apeters@bhsusa.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"Puttyhead@aol.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"wilkins@umbi.umd.edu"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"J. Invencio" email: @"bosgmasters@mac.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jamie Demarest" email: @"Jamie_demarest@newton.mec.edu"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"David Wieger" email: @"davidmichaelw@hotmail.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"David Finn" email: @"finner64@gmail.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Gary Seldon" email: @"garyseldon@earthlink.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mike Lee" email: @"mlee@rdpartners.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"PaGeN" email: @"pagen@io.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Taun" email: @"taun@charcoalia.net"]];
    
    SimpleRFC822Address* refGroup = [SimpleRFC822Address newAddressesGroupNamed: @"" addresses: groupSet];
    
    BOOL result = [newGroup isEqual: refGroup];
    
    XCTAssertTrue(result, );
}
-(void)testShorterLongAddressesStringNamesWithCommasToSet {
    NSString* emailString = @"\"Bowen, Mike\" <mike.bowen@bmonb.com>, \"Mark Corsey\" <eclipsemc@earthlink.net>, \"rob botman\" <rob.botman@gmail.com>, \"Moran, Mark D\" <mdmoran@kpmg.ca>, \"Jeffrey Wood\" <jeff@agencynextdoor.com>, \"Glenn Ulmer\" <GUlmer@syscom-consulting.com>, \"Tim Friesen\" <tim.friesen@telusplanet.net>, \"David Finn\" <finner64@gmail.com>, <stephen.wiencke@bmo.com>";
    SimpleRFC822Address *newGroup = [SimpleRFC822Address newFromString: emailString];
    
    // log the correct address to create the reference set code.
    //    for (SimpleRFC822Address* address in newGroup.addresses) {
    //        NSLog(@"[groupSet addObject: [SimpleRFC822Address newAddressName: @\"%@\" email: @\"%@\"]];",address.name, address.email);
    //    }
    //
    NSMutableSet* groupSet = [NSMutableSet new];
    
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mark Walker" email: @"mwalker@skyytek.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Fielding, Craig" email: @"Craig.Fielding@cra-arc.gc.ca"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"B KIRBY" email: @"ber01906@berk.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jeffrey Wood" email: @"jeff@agencynextdoor.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"rob botman" email: @"rob.botman@gmail.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"terry plotkin" email: @"tplotkin@earthlink.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mark Corsey" email: @"eclipsemc@earthlink.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Moran, Mark D" email: @"mdmoran@kpmg.ca"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Charles Shoemaker" email: @"charles.shoemaker@tufts.edu"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Matt J and Lori B" email: @"maplerowfarm@yahoo.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Dave Wilkins" email: @"wilkins@umbi.umd.edu"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Clayton Cardin" email: @"clayton.cardin@verizon.net"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Michael Fortman" email: @"mcfortman@yahoo.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"canniff@canniff.net"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Bowen, Mike" email: @"mike.bowen@bmonb.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jeff Malmgren" email: @"coord@vul.bc.ca"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Nick Roberts" email: @"nroberts@cyberus.ca"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Bruton, Peter" email: @"bruton@NRCan.gc.ca"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Glenn Ulmer" email: @"GUlmer@syscom-consulting.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"rob seidenberg" email: @"robseidenberg@yahoo.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Pieter Botman" email: @"P.BOTMAN@IEEE.ORG"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Tim Friesen" email: @"tim.friesen@telusplanet.net"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Scott Todd" email: @"sasha@scottsasha.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"peter roper" email: @"roper@portofolio.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"stephen.wiencke@bmo.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"apeters@bhsusa.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"Puttyhead@aol.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: nil email: @"wilkins@umbi.umd.edu"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"J. Invencio" email: @"bosgmasters@mac.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Jamie Demarest" email: @"Jamie_demarest@newton.mec.edu"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"David Wieger" email: @"davidmichaelw@hotmail.com"]];
    [groupSet addObject: [SimpleRFC822Address newAddressName: @"David Finn" email: @"finner64@gmail.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Gary Seldon" email: @"garyseldon@earthlink.net"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Mike Lee" email: @"mlee@rdpartners.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"PaGeN" email: @"pagen@io.com"]];
//    [groupSet addObject: [SimpleRFC822Address newAddressName: @"Taun" email: @"taun@charcoalia.net"]];
    
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
    NSString* stringWithWhitespace = @"Hi Taun,\n\
    \n\
    \n\
    \n\
    Dorothy Parshall invited you to like Friends Committee on National =\n\
    \n\
    Legislation.\n\
    \n\
    \n\
    \n\
    If you like Friends Committee on National Legislation follow the link =\n\
    \n\
below:\n\
    \n\
https://www.facebook.com/n/?pages%2Fx%2Fadd_fan%2F&id=3D121721071090&ori=\n\
    \n\
    =3Dpage_invite&ext=3D1399643458&hash=3DAeRUgPtcxhxqd8GL&aref=3D96131958&me=\n\
    \n\
    dium=3Demail&mid=3D9af4d70G60bba639G5badb76G4cGb509&bcode=3D1.1397051458.A=\n\
    \n\
    bm6rlw3Ckv03zUz&n_m=3Dtaun%40charcoalia.net\n\
    \n\
    \n\
    \n\
    To view Friends Committee on National Legislation follow the link below:\n\
    \n\
https://www.facebook.com/quakerlobby\n\
    \n\
    \n\
    \n\
    Thanks,\n\
    \n\
    The Facebook Team\n\
";
    
    NSString* compressed = [stringWithWhitespace mdcCompressWitespace];
    NSString* refString = @"Hi Taun, Dorothy Parshall invited you to like Friends Committee on National = Legislation. If you like Friends Committee on National Legislation follow the link = below: https://www.facebook.com/n/?pages%2Fx%2Fadd_fan%2F&id=3D121721071090&ori= =3Dpage_invite&ext=3D1399643458&hash=3DAeRUgPtcxhxqd8GL&aref=3D96131958&me= dium=3Demail&mid=3D9af4d70G60bba639G5badb76G4cGb509&bcode=3D1.1397051458.A= bm6rlw3Ckv03zUz&n_m=3Dtaun%40charcoalia.net To view Friends Committee on National Legislation follow the link below: https://www.facebook.com/quakerlobby Thanks, The Facebook Team";
    
    BOOL result = [compressed isEqualToString: refString];
    
    XCTAssertTrue(result, );
}
@end
