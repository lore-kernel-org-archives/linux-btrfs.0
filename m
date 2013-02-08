Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:48397 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638Ab3BHXXU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 18:23:20 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id C0DD140C023
	for <linux-btrfs@vger.kernel.org>; Sat,  9 Feb 2013 00:23:18 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH] Btrfs-progs: add static compile target
Date: Sat,  9 Feb 2013 00:19:29 +0100
Message-Id: <1360365569-18996-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes, when you least expect it, a static binary is what you need to
rescue your data... Or just get a good enough handle on things to make
it work again ;)

"make static" is a gift to you, dear user with filesystem problems!

Anyway, on a more serious note, changed the cflags and ldflags so that
we create a smaller binary, 1.1MB stripped on my 64 bit system
(2.7MB with debug data)

Signed-off-by: Ian Kumlien <pomac@demius.net>
---

This is v2 of the patch, David Sterba raised some questions on IRC
and quite correctly pointed out severe problems with the old patch.

The old patch depended on you doing make static from a clean state,
any objects compiled dynamically would ruin the resulting binary.

This version separates all objects and the resulting binary ;)

 .gitignore |  2 ++
 Makefile   | 26 +++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 0e560d5..230dfbd 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,8 +1,10 @@
 *.o
+*.static.o
 .*.o.d
 version.h
 man/*.gz
 btrfs
+btrfs.static
 btrfs-debug-tree
 btrfs-map-logical
 btrfs-show
diff --git a/Makefile b/Makefile
index d9a05f8..d40a9b4 100644
--- a/Makefile
+++ b/Makefile
@@ -40,6 +40,16 @@ progs = btrfsctl mkfs.btrfs btrfs-show btrfs-vol btrfs \
 	btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfstune
 
+# Create all the static targets
+static_objects = $(patsubst %.o, %.static.o, $(objects))
+static_cmds_objects = $(patsubst %.o, %.static.o, $(cmds_objects))
+static_progs = $(patsubst %.o, %.static.o, $(progs))
+
+# Define static compilation flags
+STATIC_CFLAGS = $(CFLAGS) -static -ffunction-sections -fdata-sections
+STATIC_LDFLAGS = -Wl,--gc-sections
+STATIC_LIBS = $(LIBS) -lpthread
+
 # make C=1 to enable sparse
 ifdef C
 	check = sparse $(CHECKFLAGS)
@@ -52,9 +62,18 @@ endif
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
 
+%.static.o: %.c
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
 
 all: version.h $(progs) manpages
 
+#
+# NOTE: For static compiles, you need to have all the required libs 
+# 	static equivalent available
+#
+static: version.h btrfs.static
+
 version.h:
 	$(Q)bash version.sh
 
@@ -63,6 +82,11 @@ btrfs: $(objects) btrfs.o help.o $(cmds_objects)
 	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
+btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objects)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
+		$(static_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
+
 calc-size: $(objects) calc-size.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
@@ -135,7 +159,7 @@ install-man:
 
 clean :
 	@echo "Cleaning"
-	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image \
+	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs.static \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
-- 
1.8.1.2

