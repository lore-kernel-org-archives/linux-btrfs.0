Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33303 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbdC0VH3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 17:07:29 -0400
Received: by mail-wr0-f194.google.com with SMTP id 20so16921799wrx.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 14:07:27 -0700 (PDT)
From: slyich@gmail.com
To: David Sterba <dsterba@suse.cz>
Cc: Sergei Trofimovich <slyfox@gentoo.org>, linux-btrfs@vger.kernel.org,
        Mike Gilbert <floppym@gentoo.org>
Subject: [PATCH] btrfs-progs: fix missing __error symbol in libbtrfs.so.0
Date: Mon, 27 Mar 2017 22:07:20 +0100
Message-Id: <20170327210720.10775-1-slyich@gmail.com>
In-Reply-To: <20170327114740.GA4781@twin.jikos.cz>
References: <20170327114740.GA4781@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

The easiest way to reproduce the error is to try to build
btrfs-progs with
    $ make LDFLAGS=-Wl,--no-undefined

    btrfs-list.o: In function `lookup_ino_path':
    btrfs-list.c:(.text+0x7d2): undefined reference to `__error'

Noticed by Denis Descheneaux when snapper tool
stopped working after upgrade to btrfs-progs-4.10.

As soname didn't change in 4.9 -> 4.10 release
I assume it's just an object file omission
in library depends and not the API/ABI change
of the library error printing.

Cc: linux-btrfs@vger.kernel.org
Cc: Mike Gilbert <floppym@gentoo.org>
Reported-by: Denis Descheneaux
Bug: https://bugs.gentoo.org/show_bug.cgi?id=613890

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index fdc63c3a..35a8b47c 100644
--- a/Makefile
+++ b/Makefile
@@ -95,7 +95,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o raid56.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o messages.o
+	  fsfeatures.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
@@ -104,7 +104,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
 	       mkfs/common.o
 libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
-		   kernel-lib/crc32c.o \
+		   kernel-lib/crc32c.o messages.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-list.h \
 	       kernel-lib/crc32c.h kernel-lib/list.h kerncompat.h \
@@ -446,7 +446,7 @@ test-ioctl: ioctl-test ioctl-test-32 ioctl-test-64
 	$(Q)./ioctl-test-32 > ioctl-test-32.log
 	$(Q)./ioctl-test-64 > ioctl-test-64.log
 
-library-test: library-test.c messages.o $(libs_shared)
+library-test: library-test.c $(libs_shared)
 	@echo "    [TEST PREP]  $@"$(eval TMPD=$(shell mktemp -d))
 	$(Q)mkdir -p $(TMPD)/include/btrfs && \
 	cp $(libbtrfs_headers) $(TMPD)/include/btrfs && \
@@ -456,7 +456,7 @@ library-test: library-test.c messages.o $(libs_shared)
 	@echo "    [TEST CLEAN] $@"
 	$(Q)$(RM) -rf -- $(TMPD)
 
-library-test.static: library-test.c messages.static.o $(libs_static)
+library-test.static: library-test.c $(libs_static)
 	@echo "    [TEST PREP]  $@"$(eval TMPD=$(shell mktemp -d))
 	$(Q)mkdir -p $(TMPD)/include/btrfs && \
 	cp $(libbtrfs_headers) $(TMPD)/include/btrfs && \
-- 
2.12.1

