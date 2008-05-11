# **********************************************************************
#
# Copyright (c) 2003-2008 ZeroC, Inc. All rights reserved.
#
# This copy of Ice is licensed to you under the terms described in the
# ICE_LICENSE file included in this distribution.
#
# **********************************************************************

top_srcdir	= ..\..

TOOL		= $(top_srcdir)\bin\iceserviceinstall.exe

TARGETS         = $(TOOL)

OBJS            = ServiceInstaller.obj \
                  Install.obj

SRCS		= $(OBJS:.obj=.cpp)

!include $(top_srcdir)\config\Make.rules.mak

CPPFLAGS	= -I. $(CPPFLAGS) -DWIN32_LEAN_AND_MEAN

LINKWITH        = $(LIBS)
!if "$(CPP_COMPILER)" == "VC90" || "$(CPP_COMPILER)" == "VC90_EXPRESS"
LINKWITH	= /MANIFESTUAC:"level='requireAdministrator' uiAccess='false'" $(LINKWITH)
!else
EXTRA_MANIFEST  = security.manifest
!endif

!if "$(GENERATE_PDB)" == "yes"
PDBFLAGS       = /pdb:$(TOOL:.exe=.pdb)
!endif

!if "$(CPP_COMPILER)" == "BCC2007"
RES_FILE        = ,, IceServiceInstall.res
!else
RES_FILE        = IceServiceInstall.res
!endif

$(TOOL): $(OBJS) IceServiceInstall.res
	$(LINK) $(LD_EXEFLAGS) $(PDBFLAGS) $(OBJS) $(SETARGV) $(PREOUT)$@ $(PRELIBS)$(LINKWITH) $(RES_FILE)
	@if exist $@.manifest echo ^ ^ ^ Embedding manifest using $(MT) && \
	    $(MT) -nologo -manifest $@.manifest $(EXTRA_MANIFEST) -outputresource:$@;#1 && del /q $@.manifest

clean::
	del /q $(TOOL:.exe=.*)
	del /q IceServiceInstall.res

install:: all
	copy $(TOOL) $(install_bindir)

!if "$(OPTIMIZE)" != "yes"

!if "$(CPP_COMPILER)" == "BCC2007"

install:: all
	copy $(TOOL:.exe=.tds) $(install_bindir)

!else

install:: all
	copy $(TOOL:.exe=.pdb) $(install_bindir)

!endif

!endif


!include .depend

