Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38181 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3LQCZY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 21:25:24 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBH2PNYW009901
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 02:25:23 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBH2PMEQ026521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 02:25:23 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBH2PMdB007425
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 02:25:22 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs-progs: don't replicate the stripe_len defines
Date: Tue, 17 Dec 2013 10:33:34 +0800
Message-Id: <1387247616-1574-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

a clean up patch, the BTRFS_STRIPE_LEN is been duplicated across
btrfs-progs, the kernel defines it in volume.h so do the same
for progs.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: commit update
---
 btrfs-convert.c | 19 +++++++++----------
 chunk-recover.c |  1 -
 cmds-chunk.c    |  1 -
 volumes.h       |  2 ++
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index ae10eed..65fe707 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -43,7 +43,6 @@
 #include <ext2fs/ext2_ext_attr.h>
 
 #define INO_OFFSET (BTRFS_FIRST_FREE_OBJECTID - EXT2_ROOT_INO)
-#define STRIPE_LEN (64 * 1024)
 #define EXT2_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
 
 /*
@@ -134,11 +133,11 @@ static int cache_free_extents(struct btrfs_root *root, ext2_filsys ext2_fs)
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		bytenr &= ~((u64)STRIPE_LEN - 1);
+		bytenr &= ~((u64)BTRFS_STRIPE_LEN - 1);
 		if (bytenr >= blocksize * ext2_fs->super->s_blocks_count)
 			break;
 		clear_extent_dirty(&root->fs_info->free_space_cache, bytenr,
-				   bytenr + STRIPE_LEN - 1, 0);
+				   bytenr + BTRFS_STRIPE_LEN - 1, 0);
 	}
 
 	clear_extent_dirty(&root->fs_info->free_space_cache,
@@ -207,9 +206,9 @@ static int intersect_with_sb(u64 bytenr, u64 num_bytes)
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		offset = btrfs_sb_offset(i);
-		offset &= ~((u64)STRIPE_LEN - 1);
+		offset &= ~((u64)BTRFS_STRIPE_LEN - 1);
 
-		if (bytenr < offset + STRIPE_LEN &&
+		if (bytenr < offset + BTRFS_STRIPE_LEN &&
 		    bytenr + num_bytes > offset)
 			return 1;
 	}
@@ -450,8 +449,8 @@ static int block_iterate_proc(ext2_filsys ext2_fs,
 		}
 
 		if (sb_region) {
-			bytenr += STRIPE_LEN - 1;
-			bytenr &= ~((u64)STRIPE_LEN - 1);
+			bytenr += BTRFS_STRIPE_LEN - 1;
+			bytenr &= ~((u64)BTRFS_STRIPE_LEN - 1);
 		} else {
 			cache = btrfs_lookup_block_group(root->fs_info, bytenr);
 			BUG_ON(!cache);
@@ -1523,7 +1522,7 @@ static int create_chunk_mapping(struct btrfs_trans_handle *trans,
 		btrfs_set_stack_chunk_length(&chunk, cache->key.offset);
 		btrfs_set_stack_chunk_owner(&chunk,
 					    extent_root->root_key.objectid);
-		btrfs_set_stack_chunk_stripe_len(&chunk, STRIPE_LEN);
+		btrfs_set_stack_chunk_stripe_len(&chunk, BTRFS_STRIPE_LEN);
 		btrfs_set_stack_chunk_type(&chunk, cache->flags);
 		btrfs_set_stack_chunk_io_align(&chunk, device->io_align);
 		btrfs_set_stack_chunk_io_width(&chunk, device->io_width);
@@ -2098,10 +2097,10 @@ static int cleanup_sys_chunk(struct btrfs_root *fs_root,
 	}
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		offset = btrfs_sb_offset(i);
-		offset &= ~((u64)STRIPE_LEN - 1);
+		offset &= ~((u64)BTRFS_STRIPE_LEN - 1);
 
 		ret = relocate_extents_range(fs_root, ext2_root,
-					     offset, offset + STRIPE_LEN);
+					     offset, offset + BTRFS_STRIPE_LEN);
 		if (ret)
 			goto fail;
 	}
diff --git a/chunk-recover.c b/chunk-recover.c
index bcde39e..b072ba6 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -41,7 +41,6 @@
 #include "btrfsck.h"
 #include "commands.h"
 
-#define BTRFS_STRIPE_LEN			(64 * 1024)
 #define BTRFS_NUM_MIRRORS			2
 
 struct recover_control {
diff --git a/cmds-chunk.c b/cmds-chunk.c
index 4d7fce0..348229c 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -42,7 +42,6 @@
 #include "commands.h"
 
 #define BTRFS_CHUNK_TREE_REBUILD_ABORTED	-7500
-#define BTRFS_STRIPE_LEN			(64 * 1024)
 #define BTRFS_NUM_MIRRORS			2
 
 struct recover_control {
diff --git a/volumes.h b/volumes.h
index 2802cb0..b1ff3d0 100644
--- a/volumes.h
+++ b/volumes.h
@@ -19,6 +19,8 @@
 #ifndef __BTRFS_VOLUMES_
 #define __BTRFS_VOLUMES_
 
+#define BTRFS_STRIPE_LEN	(64 * 1024)
+
 struct btrfs_device {
 	struct list_head dev_list;
 	struct btrfs_root *dev_root;
-- 
1.8.1.164.g2d0029e

