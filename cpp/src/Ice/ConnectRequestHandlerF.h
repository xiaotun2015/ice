// **********************************************************************
//
// Copyright (c) 2003-2015 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef ICE_CONNECT_REQUEST_HANDLER_F_H
#define ICE_CONNECT_REQUEST_HANDLER_F_H

#include <IceUtil/Shared.h>
#include <Ice/Handle.h>

namespace IceInternal
{

class ConnectRequestHandler;
#ifdef ICE_CPP11_MAPPING
typedef ::std::shared_ptr<ConnectRequestHandler> ConnectRequestHandlerPtr;
#else
ICE_API IceUtil::Shared* upCast(ConnectRequestHandler*);
typedef IceInternal::Handle<ConnectRequestHandler> ConnectRequestHandlerPtr;
#endif

}

#endif
