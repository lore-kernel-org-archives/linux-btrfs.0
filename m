Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31602 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdINKLs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 06:11:48 -0400
Subject: [PATCH 1/2] btrfs-progs: build: generate all dependency files
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Date: Thu, 14 Sep 2017 19:10:46 +0900
Message-ID: <150538384653.24503.41288304442819820.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're missing several dependency files like:

$ diff -u <(find -name '*.o'|cut -d. -f2|sort) <(find -name '*.o.d'|cut -d. -f2|sort)
--- /proc/self/fd/11    2017-09-14 18:17:44.460564620 +0900
+++ /proc/self/fd/12    2017-09-14 18:17:44.460564620 +0900
@@ -3,7 +3,6 @@
 /btrfs-corrupt-block
 /btrfs-debug-tree
 /btrfs-find-root
-/btrfs-list
 /btrfs-map-logical
 /btrfs-select-super
 /btrfstune
@@ -29,11 +28,6 @@
 /cmds-scrub
 /cmds-send
 /cmds-subvolume
-/convert/common
-/convert/main
-/convert/source-ext2
-/convert/source-fs
-/convert/source-reiserfs
 /ctree
 /dir-item
 /disk-io
<snip>

This is due to moving things out of objects and cmds_objects variables. Such
missing dependency files cause mis-building of some source files (try touch
utils.h; make mkfs/main.o).

This patch introduce a new variable "all_objects" to keep all the objects and
use the variable to generate proper dependency file building rules.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index a114eca..c00dff6 100644
--- a/Makefile
+++ b/Makefile
@@ -121,6 +121,9 @@ libbtrfs_headers = send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-l
 convert_objects = convert/main.o convert/common.o convert/source-fs.o \
 		  convert/source-ext2.o convert/source-reiserfs.o
 mkfs_objects = mkfs/main.o mkfs/common.o
+image_objects = image/main.o
+all_objects = $(objects) $(cmds_objects) $(libbtrfs_objects) $(convert_objects) \
+	      $(mkfs_objects) $(image_objects)
 
 TESTS = fsck-tests.sh convert-tests.sh
 
@@ -591,5 +594,5 @@ uninstall:
 	cd $(DESTDIR)$(bindir); $(RM) -f -- btrfsck fsck.btrfs $(progs_install)
 
 ifneq ($(MAKECMDGOALS),clean)
--include $(objects:.o=.o.d) $(cmds_objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
+-include $(all_objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
 endif

