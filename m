Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26380 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932194AbcLZGae (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:34 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 9F7C041B4BD0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:48 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 19/19] btrfs-progs: fsck: Introduce offline scrub function
Date: Mon, 26 Dec 2016 14:29:39 +0800
Message-Id: <20161226062939.5841-20-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, btrfs check has a kernel scrub equivalent.
A new option, --scrub is added for "btrfs check".

If --scrub is given, btrfs check will just act like kernel scrub, to
check every copy of extent and do a report on corrupted data and if it's
recoverable.

The advantage compare to kernel scrub is:
1) No race
   Unlike kernel scrub, which is done in parallel, offline scrub is done
   by a single thread.
   Although it may be slower than kernel one, it's safer and no false
   alert.

2) Correctness
   Kernel has a known bug (fix submitted) which will recovery RAID5/6
   data but screw up P/Q, due to the hardness coding in kernel.
   While in btrfs-progs, no page, (almost) no memory size limit, we're
   can focus on the scrub, and make things easier.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-check.asciidoc |  7 ++++++
 cmds-check.c                       | 12 +++++++++-
 ctree.h                            |  3 +++
 scrub.c                            | 49 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index 633cbbf6..d421afa4 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -91,6 +91,13 @@ the entire free space cache. This option with 'v2' provides an alternative
 method of clearing the free space cache that doesn't require mounting the
 filesystem.
 
+--scrub::
+kernel scrub equivalent.
++
+Off-line scrub has better reconstruction check than kernel. Won't cause
+possible silent data corruption for RAID5
++
+NOTE: Repair is not supported yet.
 
 DANGEROUS OPTIONS
 -----------------
diff --git a/cmds-check.c b/cmds-check.c
index 1dba2985..3a16a1ff 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12588,6 +12588,7 @@ int cmd_check(int argc, char **argv)
 	int clear_space_cache = 0;
 	int qgroup_report = 0;
 	int qgroups_repaired = 0;
+	int scrub = 0;
 	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
 
 	while(1) {
@@ -12595,7 +12596,8 @@ int cmd_check(int argc, char **argv)
 		enum { GETOPT_VAL_REPAIR = 257, GETOPT_VAL_INIT_CSUM,
 			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
 			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE,
-			GETOPT_VAL_MODE, GETOPT_VAL_CLEAR_SPACE_CACHE };
+			GETOPT_VAL_MODE, GETOPT_VAL_CLEAR_SPACE_CACHE,
+			GETOPT_VAL_SCRUB };
 		static const struct option long_options[] = {
 			{ "super", required_argument, NULL, 's' },
 			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
@@ -12617,6 +12619,7 @@ int cmd_check(int argc, char **argv)
 				GETOPT_VAL_MODE },
 			{ "clear-space-cache", required_argument, NULL,
 				GETOPT_VAL_CLEAR_SPACE_CACHE},
+			{ "scrub", no_argument, NULL, GETOPT_VAL_SCRUB },
 			{ NULL, 0, NULL, 0}
 		};
 
@@ -12701,6 +12704,9 @@ int cmd_check(int argc, char **argv)
 				}
 				ctree_flags |= OPEN_CTREE_WRITES;
 				break;
+			case GETOPT_VAL_SCRUB:
+				scrub = 1;
+				break;
 		}
 	}
 
@@ -12755,6 +12761,10 @@ int cmd_check(int argc, char **argv)
 
 	global_info = info;
 	root = info->fs_root;
+	if (scrub) {
+		ret = btrfs_scrub(info, repair);
+		goto err_out;
+	}
 	if (clear_space_cache == 1) {
 		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE)) {
 			error(
diff --git a/ctree.h b/ctree.h
index fe7c077e..8f669ee7 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2803,4 +2803,7 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
 /* csum.c */
 int btrfs_read_one_data_csum(struct btrfs_fs_info *fs_info, u64 bytenr,
 			     void *csum_ret);
+
+/* scrub.c */
+int btrfs_scrub(struct btrfs_fs_info *fs_info, int repair);
 #endif
diff --git a/scrub.c b/scrub.c
index 8f122012..00662da0 100644
--- a/scrub.c
+++ b/scrub.c
@@ -953,3 +953,52 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+int btrfs_scrub(struct btrfs_fs_info *fs_info, int repair)
+{
+	struct btrfs_block_group_cache *bg_cache;
+	struct btrfs_scrub_progress scrub_ctx = {0};
+	int ret = 0;
+
+	/*
+	 * TODO: To support repair, which should not be quite hard
+	 */
+	if (repair) {
+		error("Read-write scrub is not supported yet");
+		return 1;
+	}
+
+	bg_cache = btrfs_lookup_first_block_group(fs_info, 0);
+	if (!bg_cache) {
+		error("no block group is found");
+		return -ENOENT;
+	}
+
+	while (1) {
+		ret = scrub_one_block_group(fs_info, &scrub_ctx, bg_cache);
+		if (ret < 0 && ret != -EIO)
+			break;
+
+		bg_cache = btrfs_lookup_first_block_group(fs_info,
+				bg_cache->key.objectid + bg_cache->key.offset);
+		if (!bg_cache)
+			break;
+	}
+
+	printf("Scrub result:\n");
+	printf("Tree bytes scrubbed: %llu\n", scrub_ctx.tree_bytes_scrubbed);
+	printf("Tree extents scrubbed: %llu\n", scrub_ctx.tree_extents_scrubbed);
+	printf("Data bytes scrubbed: %llu\n", scrub_ctx.data_bytes_scrubbed);
+	printf("Data extents scrubbed: %llu\n", scrub_ctx.data_extents_scrubbed);
+	printf("Data bytes without csum: %llu\n", scrub_ctx.csum_discards *
+			fs_info->tree_root->sectorsize);
+	printf("Read error: %llu\n", scrub_ctx.read_errors);
+	printf("Verify error: %llu\n", scrub_ctx.verify_errors);
+	printf("Csum error: %llu\n", scrub_ctx.csum_errors);
+	if (scrub_ctx.csum_errors || scrub_ctx.read_errors ||
+	    scrub_ctx.uncorrectable_errors || scrub_ctx.verify_errors)
+		ret = 1;
+	else
+		ret = 0;
+	return ret;
+}
-- 
2.11.0



