// **********************************************************************
//
// Copyright (c) 2003-2015 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#pragma once

[["cpp:header-ext:h", "objc:header-dir:objc"]]

#include <Ice/Connection.ice>

["objc:prefix:ICEBT"]
module IceBT
{

/**
 *
 * Provides access to the details of a Bluetooth connection.
 *
 **/
local class ConnectionInfo extends Ice::ConnectionInfo
{
    /** The local Bluetooth address. */
    string localAddress = "";

    /** The local RFCOMM channel. */
    int localChannel = -1;

    /** The remote Bluetooth address. */
    string remoteAddress = "";

    /** The remote RFCOMM channel. */
    int remoteChannel = -1;

    /** The UUID of the service being offered (in a server) or targeted (in a client). */
    string uuid = "";
};

};
