Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838Ab3BLXY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 18:24:57 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id E8E44A52F4
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 00:24:56 +0100 (CET)
In-Reply-To: <20130212231526.GE12339@twin.jikos.cz>
References: <20130212231526.GE12339@twin.jikos.cz>
From: David Sterba <dsterba@suse.cz>
Date: Tue, 12 Feb 2013 17:39:44 +0100
Subject: [PATCH 13/21] btrfs-progs: build btrsfck to keep compatibility
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
Message-Id: <S1759037Ab3BLXY6/20130212232458Z+1442@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)

The command 'btrfsck' is commonly used and we should build it by
default.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 039f0dc..7a679d0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,5 @@
 CC = gcc
+LN = ln
 AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
@@ -35,7 +36,7 @@ endif
 
 MAKEOPTS = --no-print-directory Q=$(Q)
 
-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol \
+progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfs-restore btrfstune btrfs-show-super
 
@@ -110,6 +111,11 @@ btrfs-show: $(objects) btrfs-show.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
 
+# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
+btrfsck: btrfs
+	@echo "    [LN]     $@"
+	$(Q)$(LN) -f btrfs btrfsck
+
 mkfs.btrfs: $(objects) mkfs.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -lblkid
@@ -171,7 +177,7 @@ install-man:
 clean :
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
-	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test btrfs.static \
+	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test btrfs.static btrfsck \
 	      version.h
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
-- 
1.8.0.2

