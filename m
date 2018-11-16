Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAEFC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28A17208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28A17208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389423AbeKPSGG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:06:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:46218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSGG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:06:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D613ABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 07:54:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs-progs: Cleanup warning reported by -Wmissing-prototypes except free space tree
Date:   Fri, 16 Nov 2018 15:54:26 +0800
Message-Id: <20181116075426.4142-10-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-1-wqu@suse.com>
References: <20181116075426.4142-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The following missing prototypes will be fixed:
1)  btrfs.c::handle_special_globals()
2)  check/mode-lowmem.c::repair_ternary_lowmem()
3)  extent-tree.c::btrfs_search_overlap_extent()
    Above 3 can be fixed by making them static

4)  utils.c::btrfs_check_nodesize()
    Fixed by moving it to fsfeatures.c

5)  chunk-recover.c::btrfs_recover_chunk_tree()
6)  super-recover.c::btrfs_recover_superblocks()
    Fixed by moving the declaration from cmds-rescue.c to rescue.h

7)  utils-lib.c::arg_strtou64()
8)  utils-lib.c::lookup_path_rootid()
    Fixed by include "utils.h"

9)  free-space-tree.c::set_free_space_tree_thresholds()
    Fixed by deleting it, as there is no user.

10) free-space-tree.c::convert_free_space_to_bitmaps()
11) free-space-tree.c::convert_free_space_to_extents()
12) free-space-tree.c::__remove_from_free_space_tree()
13) free-space-tree.c::__add_to_free_space_tree()
14) free-space-tree.c::btrfs_create_tree()
    Fixed by making them static.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs.c             |  2 +-
 check/mode-lowmem.c |  6 ++---
 chunk-recover.c     |  1 +
 cmds-rescue.c       |  4 +--
 extent-tree.c       |  2 +-
 free-space-tree.c   | 59 ++++++++++++---------------------------------
 fsfeatures.c        | 22 +++++++++++++++++
 rescue.h            | 14 +++++++++++
 super-recover.c     |  1 +
 utils-lib.c         |  1 +
 utils.c             | 23 ------------------
 11 files changed, 60 insertions(+), 75 deletions(-)
 create mode 100644 rescue.h

diff --git a/btrfs.c b/btrfs.c
index 2d39f2ced3e8..78c468d2e050 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -210,7 +210,7 @@ static int handle_global_options(int argc, char **argv)
 	return shift;
 }
 
-void handle_special_globals(int shift, int argc, char **argv)
+static void handle_special_globals(int shift, int argc, char **argv)
 {
 	int has_help = 0;
 	int has_full = 0;
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 14bbc9ee6cb6..f56b5e8d45dc 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -953,9 +953,9 @@ out:
  * returns 0 means success.
  * returns not 0 means on error;
  */
-int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
-			  u64 index, char *name, int name_len, u8 filetype,
-			  int err)
+static int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
+				 u64 index, char *name, int name_len,
+				 u8 filetype, int err)
 {
 	struct btrfs_trans_handle *trans;
 	int stage = 0;
diff --git a/chunk-recover.c b/chunk-recover.c
index 1d30db51d8ed..1e554b8e8750 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -40,6 +40,7 @@
 #include "utils.h"
 #include "btrfsck.h"
 #include "commands.h"
+#include "rescue.h"
 
 struct recover_control {
 	int verbose;
diff --git a/cmds-rescue.c b/cmds-rescue.c
index 2bc50c0841ed..36e9e1277e40 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -26,15 +26,13 @@
 #include "commands.h"
 #include "utils.h"
 #include "help.h"
+#include "rescue.h"
 
 static const char * const rescue_cmd_group_usage[] = {
 	"btrfs rescue <command> [options] <path>",
 	NULL
 };
 
-int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
-int btrfs_recover_superblocks(const char *path, int verbose, int yes);
-
 static const char * const cmd_rescue_chunk_recover_usage[] = {
 	"btrfs rescue chunk-recover [options] <device>",
 	"Recover the chunk tree by scanning the devices one by one.",
diff --git a/extent-tree.c b/extent-tree.c
index cd98633992ac..8c9cdeff3b02 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3749,7 +3749,7 @@ static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
  * Return >0 for not found.
  * Return <0 for err
  */
-int btrfs_search_overlap_extent(struct btrfs_root *root,
+static int btrfs_search_overlap_extent(struct btrfs_root *root,
 				struct btrfs_path *path, u64 bytenr, u64 len)
 {
 	struct btrfs_key key;
diff --git a/free-space-tree.c b/free-space-tree.c
index 6641cdfa42ba..af141e6e611a 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -24,35 +24,6 @@
 #include "bitops.h"
 #include "internal.h"
 
-void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache,
-				    u64 sectorsize)
-{
-	u32 bitmap_range;
-	size_t bitmap_size;
-	u64 num_bitmaps, total_bitmap_size;
-
-	/*
-	 * We convert to bitmaps when the disk space required for using extents
-	 * exceeds that required for using bitmaps.
-	 */
-	bitmap_range = sectorsize * BTRFS_FREE_SPACE_BITMAP_BITS;
-	num_bitmaps = div_u64(cache->key.offset + bitmap_range - 1,
-			      bitmap_range);
-	bitmap_size = sizeof(struct btrfs_item) + BTRFS_FREE_SPACE_BITMAP_SIZE;
-	total_bitmap_size = num_bitmaps * bitmap_size;
-	cache->bitmap_high_thresh = div_u64(total_bitmap_size,
-					    sizeof(struct btrfs_item));
-
-	/*
-	 * We allow for a small buffer between the high threshold and low
-	 * threshold to avoid thrashing back and forth between the two formats.
-	 */
-	if (cache->bitmap_high_thresh > 100)
-		cache->bitmap_low_thresh = cache->bitmap_high_thresh - 100;
-	else
-		cache->bitmap_low_thresh = 0;
-}
-
 static struct btrfs_free_space_info *
 search_free_space_info(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info,
@@ -202,9 +173,9 @@ static void le_bitmap_set(unsigned long *map, unsigned int start, int len)
 	}
 }
 
-int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
-				  struct btrfs_block_group_cache *block_group,
-				  struct btrfs_path *path)
+static int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *block_group,
+				struct btrfs_path *path)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->free_space_root;
@@ -341,9 +312,9 @@ out:
 	return ret;
 }
 
-int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
-				  struct btrfs_block_group_cache *block_group,
-				  struct btrfs_path *path)
+static int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *block_group,
+				struct btrfs_path *path)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->free_space_root;
@@ -780,9 +751,9 @@ out:
 	return ret;
 }
 
-int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
-				  struct btrfs_block_group_cache *block_group,
-				  struct btrfs_path *path, u64 start, u64 size)
+static int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *block_group,
+				struct btrfs_path *path, u64 start, u64 size)
 {
 	struct btrfs_free_space_info *info;
 	u32 flags;
@@ -960,9 +931,9 @@ out:
 	return ret;
 }
 
-int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_block_group_cache *block_group,
-			     struct btrfs_path *path, u64 start, u64 size)
+static int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *block_group,
+				struct btrfs_path *path, u64 start, u64 size)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_free_space_info *info;
@@ -1420,9 +1391,9 @@ out:
 	return ret;
 }
 
-struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info,
-				     u64 objectid)
+static struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
+					    struct btrfs_fs_info *fs_info,
+					    u64 objectid)
 {
 	struct extent_buffer *leaf;
 	struct btrfs_root *tree_root = fs_info->tree_root;
diff --git a/fsfeatures.c b/fsfeatures.c
index 7d85d60f1277..201d0f576688 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -225,3 +225,25 @@ u32 get_running_kernel_version(void)
 	return version;
 }
 
+int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
+{
+	if (nodesize < sectorsize) {
+		error("illegal nodesize %u (smaller than %u)",
+				nodesize, sectorsize);
+		return -1;
+	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		error("illegal nodesize %u (larger than %u)",
+			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
+		return -1;
+	} else if (nodesize & (sectorsize - 1)) {
+		error("illegal nodesize %u (not aligned to %u)",
+			nodesize, sectorsize);
+		return -1;
+	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
+		   nodesize != sectorsize) {
+		error("illegal nodesize %u (not equal to %u for mixed block group)",
+			nodesize, sectorsize);
+		return -1;
+	}
+	return 0;
+}
diff --git a/rescue.h b/rescue.h
new file mode 100644
index 000000000000..c9f6e7b80b16
--- /dev/null
+++ b/rescue.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2018 SUSE.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+int btrfs_recover_superblocks(const char *path, int verbose, int yes);
+int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
diff --git a/super-recover.c b/super-recover.c
index 86b3df9867dc..a1af71786034 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -34,6 +34,7 @@
 #include "crc32c.h"
 #include "volumes.h"
 #include "commands.h"
+#include "rescue.h"
 
 struct btrfs_recover_superblock {
 	struct btrfs_fs_devices *fs_devices;
diff --git a/utils-lib.c b/utils-lib.c
index 044f93fc4446..5bb89f2f1a8d 100644
--- a/utils-lib.c
+++ b/utils-lib.c
@@ -1,4 +1,5 @@
 #include "kerncompat.h"
+#include "utils.h"
 #include <unistd.h>
 #include <stdlib.h>
 #include <limits.h>
diff --git a/utils.c b/utils.c
index b274f46fdd9d..a7e34b804551 100644
--- a/utils.c
+++ b/utils.c
@@ -2266,29 +2266,6 @@ int btrfs_tree_search2_ioctl_supported(int fd)
 	return ret;
 }
 
-int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
-{
-	if (nodesize < sectorsize) {
-		error("illegal nodesize %u (smaller than %u)",
-				nodesize, sectorsize);
-		return -1;
-	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		error("illegal nodesize %u (larger than %u)",
-			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
-		return -1;
-	} else if (nodesize & (sectorsize - 1)) {
-		error("illegal nodesize %u (not aligned to %u)",
-			nodesize, sectorsize);
-		return -1;
-	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
-		   nodesize != sectorsize) {
-		error("illegal nodesize %u (not equal to %u for mixed block group)",
-			nodesize, sectorsize);
-		return -1;
-	}
-	return 0;
-}
-
 /*
  * Copy a path argument from SRC to DEST and check the SRC length if it's at
  * most PATH_MAX and fits into DEST. DESTLEN is supposed to be exact size of
-- 
2.19.1

