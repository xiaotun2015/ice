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
#include <Test.h>

DEFINE_TEST("server");

using namespace std;

//
// Server side is pure unicode
//
class MyObjectI : public Test::MyObject
{
public:

    virtual wstring widen(const string& msg, const Ice::Current&)
    {
        const Ice::Byte* cmsg = reinterpret_cast<const Ice::Byte*>(msg.c_str());

        if(!IceUtil::isLegalUTF8Sequence(cmsg, cmsg + msg.size()))
        {
            throw Test::BadEncodingException();
        }

        return IceUtil::stringToWstring(msg, IceUtil::getProcessStringConverter(),
                                        IceUtil::getProcessWstringConverter());
    }

    virtual string narrow(const wstring& wmsg, const Ice::Current&)
    {
        return IceUtil::wstringToString(wmsg, IceUtil::getProcessStringConverter(),
                                        IceUtil::getProcessWstringConverter());
    }

    virtual void shutdown(const Ice::Current& current)
    {
        current.adapter->getCommunicator()->shutdown();
    }
};

int
run(int, char**, const Ice::CommunicatorPtr& communicator)
{
    communicator->getProperties()->setProperty("TestAdapter.Endpoints", "default -p 12010:udp -p 12010");
    Ice::ObjectAdapterPtr adapter = communicator->createObjectAdapter("TestAdapter");
    adapter->add(ICE_MAKE_SHARED(MyObjectI), communicator->stringToIdentity("test"));
    adapter->activate();

    TEST_READY
    communicator->waitForShutdown();
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
        Ice::InitializationData initData;
        initData.properties = Ice::createProperties(argc, argv);
        communicator = Ice::initialize(argc, argv, initData);
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
