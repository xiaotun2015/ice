// **********************************************************************
//
// Copyright (c) 2003-2015 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#include <Ice/Ice.h>
#include <TestCommon.h>
#include <TestI.h>

DEFINE_TEST("server")

using namespace std;
using namespace Test;

int
run(int, char**, const Ice::CommunicatorPtr& communicator)
{
    communicator->getProperties()->setProperty("TestAdapter.Endpoints", "default -p 12010");
    Ice::ObjectAdapterPtr adapter = communicator->createObjectAdapter("TestAdapter");
    Ice::ObjectPtr d = ICE_MAKE_SHARED(DI);
    adapter->add(d, communicator->stringToIdentity("d"));
    adapter->addFacet(d, communicator->stringToIdentity("d"), "facetABCD");
    Ice::ObjectPtr f = ICE_MAKE_SHARED(FI);
    adapter->addFacet(f, communicator->stringToIdentity("d"), "facetEF");
    Ice::ObjectPtr h = ICE_MAKE_SHARED(HI, communicator);
    adapter->addFacet(h, communicator->stringToIdentity("d"), "facetGH");

    GPrxPtr allTests(const Ice::CommunicatorPtr&);
    allTests(communicator);

    return EXIT_SUCCESS;
}

int
main(int argc, char* argv[])
{
#ifdef ICE_STATIC_LIBS
    Ice::registerIceSSL();
#endif
    int status;
    Ice::CommunicatorPtr communicator;

    try
    {
        communicator = ICE_COMMUNICATOR_HOLDER_RELEASE(Ice::initialize(argc, argv));
        status = run(argc, argv, communicator);
    }
    catch(const Ice::Exception& ex)
    {
        cerr << ex << endl;
        status = EXIT_FAILURE;
    }

    if(communicator)
    {
        try
        {
            communicator->destroy();
        }
        catch(const Ice::Exception& ex)
        {
            cerr << ex << endl;
            status = EXIT_FAILURE;
        }
    }

    return status;
}
