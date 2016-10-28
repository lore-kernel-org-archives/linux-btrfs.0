Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965908AbcJ1Cc3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:29 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 19/19] btrfs-progs: fsck: Introduce offline scrub function
Date: Fri, 28 Oct 2016 10:31:55 +0800
Message-Id: <20161028023155.27336-20-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, btrfs check has a kernel scrub equivalent.

And even more, it's has stronger csum check against reconstructed data
and existing data stripes.
It will avoid any possible silent data corruption in kernel scrub.

Now it only supports to do read-only check, but is already able to
provide info on the recoverability.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-check.asciidoc |  8 ++++++++
 check/check.h                      |  2 ++
 check/scrub.c                      | 41 ++++++++++++++++++++++++++++++++++++++
 cmds-check.c                       | 12 ++++++++++-
 4 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index a32e1c7..98681ff 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -78,6 +78,14 @@ respective superblock offset is within the device size
 This can be used to use a different starting point if some of the primary
 superblock is damaged.
 
+--scrub::
+kernel scrub equivalent.
++
+Off-line scrub has better reconstruction check than kernel. Won't cause
+possible silent data corruption for RAID5
++
+NOTE: Support for RAID6 recover is not fully implemented yet.
+
 DANGEROUS OPTIONS
 -----------------
 
diff --git a/check/check.h b/check/check.h
index 61d1cac..7c14716 100644
--- a/check/check.h
+++ b/check/check.h
@@ -19,3 +19,5 @@
 /* check/csum.c */
 int btrfs_read_one_data_csum(struct btrfs_fs_info *fs_info, u64 bytenr,
 			     void *csum_ret);
+/* check/scrub.c */
+int scrub_btrfs(struct btrfs_fs_info *fs_info);
diff --git a/check/scrub.c b/check/scrub.c
index bce599f..013f060 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -881,3 +881,44 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+int scrub_btrfs(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_group_cache *bg_cache;
+	struct btrfs_scrub_progress scrub_ctx = {0};
+	int ret = 0;
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
diff --git a/cmds-check.c b/cmds-check.c
index 670ccd1..a081e82 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -41,6 +41,7 @@
 #include "rbtree-utils.h"
 #include "backref.h"
 #include "ulist.h"
+#include "check.h"
 
 enum task_position {
 	TASK_EXTENTS,
@@ -11252,6 +11253,7 @@ int cmd_check(int argc, char **argv)
 	int readonly = 0;
 	int qgroup_report = 0;
 	int qgroups_repaired = 0;
+	int scrub = 0;
 	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
 
 	while(1) {
@@ -11259,7 +11261,7 @@ int cmd_check(int argc, char **argv)
 		enum { GETOPT_VAL_REPAIR = 257, GETOPT_VAL_INIT_CSUM,
 			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
 			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE,
-			GETOPT_VAL_MODE };
+			GETOPT_VAL_MODE, GETOPT_VAL_SCRUB };
 		static const struct option long_options[] = {
 			{ "super", required_argument, NULL, 's' },
 			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
@@ -11279,6 +11281,7 @@ int cmd_check(int argc, char **argv)
 			{ "progress", no_argument, NULL, 'p' },
 			{ "mode", required_argument, NULL,
 				GETOPT_VAL_MODE },
+			{ "scrub", no_argument, NULL, GETOPT_VAL_SCRUB },
 			{ NULL, 0, NULL, 0}
 		};
 
@@ -11350,6 +11353,9 @@ int cmd_check(int argc, char **argv)
 					exit(1);
 				}
 				break;
+			case GETOPT_VAL_SCRUB:
+				scrub = 1;
+				break;
 		}
 	}
 
@@ -11402,6 +11408,10 @@ int cmd_check(int argc, char **argv)
 	global_info = info;
 	root = info->fs_root;
 
+	if (scrub) {
+		ret = scrub_btrfs(info);
+		goto err_out;
+	}
 	/*
 	 * repair mode will force us to commit transaction which
 	 * will make us fail to load log tree when mounting.
-- 
2.10.1



