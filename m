Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab3BLXYW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 18:24:22 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 9971EA52DB
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 00:24:21 +0100 (CET)
In-Reply-To: <20130212231526.GE12339@twin.jikos.cz>
References: <20130212231526.GE12339@twin.jikos.cz>
From: David Sterba <dsterba@suse.cz>
Date: Tue, 12 Feb 2013 18:44:35 +0100
Subject: [PATCH 20/21] btrfs-progs: don't link binaries to a dynamic library
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
Message-Id: <S1758958Ab3BLXYX/20130212232425Z+291@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)

Linking 'btrfs' and other binaries against the dynamic library makes it
tedious to use directly from the git repo. This is useful for testing
various fixes, but now it'd need to also set LD_LIBRARY_PATH or install
the library to a known path.

Add a target for static library and use it for linking, the dynamic
library is to be used by external users.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 6013fe2..84c39c0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,6 @@
 CC = gcc
 LN = ln
+AR = ar
 AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -DBTRFS_FLAT_INCLUDES -fPIC
 CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
@@ -26,7 +27,7 @@ bindir = $(prefix)/bin
 libdir = $(prefix)/lib
 incdir = $(prefix)/include/btrfs
 lib_LIBS = -luuid -lm -lz -L.
-LIBS = $(lib_LIBS) -lbtrfs
+LIBS = $(lib_LIBS) $(libs_static)
 
 ifeq ("$(origin V)", "command line")
   BUILD_VERBOSE = $(V)
@@ -57,7 +58,9 @@ STATIC_CFLAGS = $(CFLAGS) -ffunction-sections -fdata-sections
 STATIC_LDFLAGS = -static -Wl,--gc-sections
 STATIC_LIBS = $(LIBS) -lpthread
 
-libs = libbtrfs.so.0.1
+libs_shared = libbtrfs.so.0.1
+libs_static = libbtrfs.a
+libs = $(libs_shared) $(libs_static)
 lib_links = libbtrfs.so.0 libbtrfs.so
 headers = $(libbtrfs_headers)
 
@@ -88,10 +91,14 @@ static: version.h $(libs) btrfs.static
 version.h:
 	$(Q)bash version.sh
 
-$(libs): $(libbtrfs_objects) $(lib_links) send.h
+$(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(lib_LIBS) -shared -Wl,-soname,libbtrfs.so -o libbtrfs.so.0.1
 
+$(libs_static): $(libbtrfs_objects)
+	@echo "    [AR]     $@"
+	$(Q)$(AR) cru libbtrfs.a $(libbtrfs_objects)
+
 $(lib_links):
 	@echo "    [LN]     $@"
 	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so.0
@@ -199,7 +206,7 @@ clean :
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfs.static btrfsck \
 	      version.h \
-	      $(libs) libbtrfs.so libbtrfs.so.0 libbtrfs.so.0.1
+	      $(libs) libbtrfs.so libbtrfs.so.0 libbtrfs.so.0.1 libbtrfs.a
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
 install: $(libs) $(progs) install-man
-- 
1.8.0.2

