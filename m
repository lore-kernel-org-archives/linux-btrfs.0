Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14911 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932469AbcI3FFS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 01:05:18 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 1/4] btrfs-progs: rename raid6.c to raid56.c
Date: Fri, 30 Sep 2016 13:04:54 +0800
Message-Id: <20160930050457.22584-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This allows us to put raid5 codes into that file other than creating a
new raid5.c.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Split patch
---
 Makefile.in         | 2 +-
 disk-io.h           | 2 +-
 raid6.c => raid56.c | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename raid6.c => raid56.c (100%)

diff --git a/Makefile.in b/Makefile.in
index 20b740a..0ae2cd5 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -90,7 +90,7 @@ CHECKER_FLAGS := -include $(check_defs) -D__CHECKER__ \
 objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o kernel-lib/list_sort.o props.o \
+	  qgroup.o raid56.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
diff --git a/disk-io.h b/disk-io.h
index 1080fc1..440baa9 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -190,7 +190,7 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 int write_and_map_eb(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *eb);
 
-/* raid6.c */
+/* raid56.c */
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
 
 #endif
diff --git a/raid6.c b/raid56.c
similarity index 100%
rename from raid6.c
rename to raid56.c
-- 
2.10.0



