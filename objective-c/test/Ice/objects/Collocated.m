// **********************************************************************
//
// Copyright (c) 2003-2015 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#import <objc/Ice.h>
#import <TestCommon.h>
#import <objects/TestI.h>

@interface CollocatedMyValueFactory : NSObject<ICEValueFactory>
@end

@implementation CollocatedMyValueFactory

// Note that the object factory must not autorelease the
// returned objects.
-(ICEObject*) create:(NSString*)type
{
    if([type isEqualToString:@"::Test::B"])
    {
        return  [[TestObjectsBI alloc] init];
    }
    else if([type isEqualToString:@"::Test::C"])
    {
        return [[TestObjectsCI alloc] init];
    }
    else if([type isEqualToString:@"::Test::D"])
    {
        return [[TestObjectsDI alloc] init];
    }
    else if([type isEqualToString:@"::Test::E"])
    {
        return [[TestObjectsEI alloc] init];
    }
    else if([type isEqualToString:@"::Test::F"])
    {
        return [[TestObjectsFI alloc] init];
    }
    else if([type isEqualToString:@"::Test::I"])
    {
        return [[TestObjectsI alloc] init];
    }
    else if([type isEqualToString:@"::Test::J"])
    {
        return [[TestObjectsJI alloc] init];
    }
    else if([type isEqualToString:@"::Test::H"])
    {
        return [[TestObjectsHI alloc] init];
    }
    else
    {
        test(NO);
    }
    return nil;
}
@end

@interface ClientMyObjectFactory : NSObject<ICEObjectFactory>
@end

@implementation ClientMyObjectFactory

-(ICEObject*) create:(NSString*)type
{
    return nil;
}

-(void) destroy
{
    // Nothing to do
}
@end

static int
run(id<ICECommunicator> communicator)
{
    id<ICEValueFactory> factory = ICE_AUTORELEASE([[CollocatedMyValueFactory alloc] init]);

    [communicator addValueFactory:factory sliceId:@"::Test::B"];
    [communicator addValueFactory:factory sliceId:@"::Test::C"];
    [communicator addValueFactory:factory sliceId:@"::Test::D"];
    [communicator addValueFactory:factory sliceId:@"::Test::E"];
    [communicator addValueFactory:factory sliceId:@"::Test::F"];
    [communicator addValueFactory:factory sliceId:@"::Test::I"];
    [communicator addValueFactory:factory sliceId:@"::Test::J"];
    [communicator addValueFactory:factory sliceId:@"::Test::H"];

    id<ICEObjectFactory> objectFactory = ICE_AUTORELEASE([[ClientMyObjectFactory alloc] init]);
    [communicator addObjectFactory:objectFactory sliceId:@"TestOF" ];

    [[communicator getProperties] setProperty:@"TestAdapter.Endpoints" value:@"default -p 12010"];
    id<ICEObjectAdapter> adapter = [communicator createObjectAdapter:@"TestAdapter"];
    TestObjectsInitialI* initial = [TestObjectsInitialI initial];
    [adapter add:initial identity:[communicator stringToIdentity:@"initial"]];

    ICEObject* uoet = ICE_AUTORELEASE([[UnexpectedObjectExceptionTestI alloc] init]);
    [adapter add:uoet identity:[communicator stringToIdentity:@"uoet"]];

    id<TestObjectsInitialPrx> objectsAllTests(id<ICECommunicator>, bool);
    objectsAllTests(communicator, NO);

    // We must call shutdown even in the collocated case for cyclic dependency cleanup
    [initial shutdown:nil];

    return EXIT_SUCCESS;
}

#if TARGET_OS_IPHONE
#  define main objectsCollocated
#endif

int
main(int argc, char* argv[])
{
    int status;
    @autoreleasepool
    {
        id<ICECommunicator> communicator = nil;
        @try
        {
            ICEInitializationData* initData = [ICEInitializationData initializationData];
            initData.properties = defaultServerProperties(&argc, argv);
#if TARGET_OS_IPHONE
            initData.prefixTable__ = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"TestObjects", @"::Test",
                                      nil];
#endif
            communicator = [ICEUtil createCommunicator:&argc argv:argv initData:initData];
            status = run(communicator);
        }
        @catch(ICEException* ex)
        {
            tprintf("%@\n", ex);
            status = EXIT_FAILURE;
        }

        if(communicator)
        {
            @try
            {
                [communicator destroy];
            }
            @catch(ICEException* ex)
            {
                tprintf("%@\n", ex);
                status = EXIT_FAILURE;
            }
        }
    }
    return status;
}
