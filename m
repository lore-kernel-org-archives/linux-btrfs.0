Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from msa104.auone-net.jp ([61.117.18.164]:42704 "EHLO
	msa104.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab3GFImg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Jul 2013 04:42:36 -0400
Received: from ppp.dion.ne.jp (ZR168023.ppp.dion.ne.jp [222.14.168.23])
	by msa104.auone-net.jp (au one net msa) with ESMTP id 1679715C03A
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Jul 2013 17:22:31 +0900 (JST)
Date: Sat, 6 Jul 2013 17:22:31 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Fix automatic prerequisite generation
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <20130706082232.1679715C03A@msa104.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some files don't compile because of insufficient prerequisite.

$ make btrfs
...
    [CC]     btrfs.o
btrfs.c:24:21: fatal error: version.h: No such file or directory
 #include "version.h"
                     ^
compilation terminated.
make: *** [btrfs.o] Error 1

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 Makefile | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index da7438e..02b8a4c 100644
--- a/Makefile
+++ b/Makefile
@@ -76,22 +76,25 @@ else
 	check = true
 endif
 
+%.d: %.c
+	$(Q)$(CC) -MM -MG -MF $@ -MT $(@:.d=.o) -MT $(@:.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
+
 .c.o:
 	$(Q)$(check) $<
 	@echo "    [CC]     $@"
-	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+	$(Q)$(CC) $(AM_CFLAGS) $(CFLAGS) -c $<
 
 %.static.o: %.c
 	@echo "    [CC]     $@"
-	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
+	$(Q)$(CC) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
 
-all: version.h $(progs) manpages
+all: $(progs) manpages
 
 #
 # NOTE: For static compiles, you need to have all the required libs
 # 	static equivalent available
 #
-static: version.h btrfs.static mkfs.btrfs.static btrfs-find-root.static
+static: btrfs.static mkfs.btrfs.static btrfs-find-root.static
 
 version.h:
 	@echo "    [SH]     $@"
@@ -121,13 +124,13 @@ $(lib_links):
 # For static variants, use an extra $(subst) to get rid of the ".static"
 # from the target name before translating to list of libs
 
-btrfs-%.static: version.h $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects)
+btrfs-%.static: $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(STATIC_CFLAGS) -o $@ $@.o $(static_objects) \
 		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS) \
 		$($(subst -,_,$(subst .static,,$@)-libs))
 
-btrfs-%: version.h $(objects) $(libs) btrfs-%.o
+btrfs-%: $(objects) $(libs) btrfs-%.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
 
@@ -183,7 +186,7 @@ install-man:
 
 clean :
 	@echo "Cleaning"
-	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
+	$(Q)rm -f $(progs) cscope.out *.o *.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
 	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
 	      version.h \
@@ -199,4 +202,6 @@ install: $(libs) $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
 	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
 
--include .*.d
+ifneq ($(MAKECMDGOALS),clean)
+-include $(objects:.o=.d) $(cmd-objects:.o=.d) $(subst .btrfs,, $(filter-out btrfsck.d, $(progs:=.d)))
+endif
-- 
1.8.3.2

