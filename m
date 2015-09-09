Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62032 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753238AbbIIItd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 04:49:33 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t898nGao006468
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2015 16:49:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs: convert: force convert to used mixed block group
Date: Wed, 9 Sep 2015 16:49:22 +0800
Message-ID: <1441788564-27382-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441788564-27382-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441788564-27382-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert has a bug that even we disable it from using mixed block, it
will still put data and metadata extent into the same chunk.

The bug can be reported by previous fsck patch.

Even without the bug, it's still high recommeneded to use mixed block
group, as unlike btrfs, ext* is not extent based from designed, so even
if we find a method to fix above bug, chunks will be quite scattered.

So force convert to use mixed block group right now.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 55 +++++++++++++++++++++++++++++++++----------------------
 ctree.h         |  2 +-
 extent-tree.c   | 15 ++++++++++++++-
 utils.h         | 16 ++++++++++++++--
 4 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 459b89a..a60f380 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1683,7 +1683,7 @@ static int create_subvol(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int init_btrfs(struct btrfs_root *root)
+static int init_btrfs(struct btrfs_root *root, u64 features)
 {
 	int ret;
 	struct btrfs_key location;
@@ -1693,7 +1693,7 @@ static int init_btrfs(struct btrfs_root *root)
 
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
-	ret = btrfs_make_block_groups(trans, root);
+	ret = btrfs_make_block_groups(trans, root, features);
 	if (ret)
 		goto err;
 	ret = btrfs_fix_block_accounting(trans, root);
@@ -2387,7 +2387,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 			ext2_free_block_range(ext2_fs, blocks[i],
 					blocks_per_node);
 	}
-	ret = init_btrfs(root);
+	ret = init_btrfs(root, features);
 	if (ret) {
 		fprintf(stderr, "unable to setup the root tree\n");
 		goto fail;
@@ -2861,15 +2861,15 @@ int main(int argc, char *argv[])
 	int packing = 1;
 	int noxattr = 0;
 	int datacsum = 1;
-	u32 nodesize = max_t(u32, sysconf(_SC_PAGESIZE),
-			BTRFS_MKFS_DEFAULT_NODE_SIZE);
+	u32 nodesize = sysconf(_SC_PAGESIZE);
 	int rollback = 0;
 	int copylabel = 0;
 	int usage_error = 0;
 	int progress = 1;
 	char *file;
 	char fslabel[BTRFS_LABEL_SIZE];
-	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 features = BTRFS_MKFS_DEFAULT_FEATURES |
+		       BTRFS_CONVERT_FORCE_FEATURES;
 
 	while(1) {
 		enum { GETOPT_VAL_NO_PROGRESS = 256 };
@@ -2937,22 +2937,6 @@ int main(int argc, char *argv[])
 					exit(1);
 				}
 				free(orig);
-				if (features & BTRFS_FEATURE_LIST_ALL) {
-					btrfs_list_all_fs_features(
-						~BTRFS_CONVERT_ALLOWED_FEATURES);
-					exit(0);
-				}
-				if (features & ~BTRFS_CONVERT_ALLOWED_FEATURES) {
-					char buf[64];
-
-					btrfs_parse_features_to_string(buf,
-						features & ~BTRFS_CONVERT_ALLOWED_FEATURES);
-					fprintf(stderr,
-						"ERROR: features not allowed for convert: %s\n",
-						buf);
-					exit(1);
-				}
-
 				break;
 				}
 			case GETOPT_VAL_NO_PROGRESS:
@@ -2964,6 +2948,12 @@ int main(int argc, char *argv[])
 				return c != GETOPT_VAL_HELP;
 		}
 	}
+	if (features & BTRFS_FEATURE_LIST_ALL) {
+		btrfs_list_all_fs_features(
+			~BTRFS_CONVERT_ALLOWED_FEATURES);
+		exit(0);
+	}
+
 	argc = argc - optind;
 	set_argv0(argv);
 	if (check_argc_exact(argc, 1)) {
@@ -2971,6 +2961,27 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (features & ~BTRFS_CONVERT_ALLOWED_FEATURES) {
+		char buf[64];
+
+		btrfs_parse_features_to_string(buf,
+			features & ~BTRFS_CONVERT_ALLOWED_FEATURES);
+		fprintf(stderr,
+			"ERROR: features not allowed for convert: %s\n",
+			buf);
+		exit(1);
+	}
+	if (!(features & BTRFS_CONVERT_FORCE_FEATURES)) {
+		char buf[64];
+
+		btrfs_parse_features_to_string(buf,
+				BTRFS_CONVERT_FORCE_FEATURES);
+		fprintf(stderr,
+			"ERROR: features %s must be enabled for convert\n",
+			buf);
+		exit(1);
+	}
+
 	if (rollback && (!datacsum || noxattr || !packing)) {
 		fprintf(stderr,
 			"Usage error: -d, -i, -n options do not apply to rollback\n");
diff --git a/ctree.h b/ctree.h
index bcad2b9..db39da7 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2269,7 +2269,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root);
+			    struct btrfs_root *root, u64 features);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr, u64 num,
 			     int alloc, int mark_free);
diff --git a/extent-tree.c b/extent-tree.c
index 0c8152a..6c0960d 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3373,7 +3373,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
  * before doing any block allocation.
  */
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root)
+			    struct btrfs_root *root, u64 features)
 {
 	u64 total_bytes;
 	u64 cur_start;
@@ -3406,7 +3406,20 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 			group_size &= ~(group_align - 1);
 			group_size = max_t(u64, group_size, 8 * 1024 * 1024);
 			group_size = min_t(u64, group_size, 32 * 1024 * 1024);
+		} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) {
+			/* mixed block group case */
+
+			if ((total_bytes - cur_start) * 4 < group_size * 5)
+				group_size = total_bytes - cur_start;
+			group_size = round_down(group_size, group_align);
+			group_type = BTRFS_BLOCK_GROUP_METADATA |
+				     BTRFS_BLOCK_GROUP_DATA;
+			group_size = min_t(u64, group_size,
+					   1ULL * 1024 * 1024 * 1024);
+			total_metadata += group_size;
+			total_data += group_size;
 		} else {
+			/* no mixed block group case, not used yet */
 			group_size &= ~(group_align - 1);
 			if (total_data >= total_metadata * 2) {
 				group_type = BTRFS_BLOCK_GROUP_METADATA;
diff --git a/utils.h b/utils.h
index 0eadaf1..7f1a128 100644
--- a/utils.h
+++ b/utils.h
@@ -31,7 +31,7 @@
 		| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
 /*
- * Avoid multi-device features (RAID56) and mixed block groups
+ * Avoid multi-device features (RAID56)
  */
 #define BTRFS_CONVERT_ALLOWED_FEATURES				\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF			\
@@ -41,7 +41,19 @@
 	| BTRFS_FEATURE_INCOMPAT_BIG_METADATA			\
 	| BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF			\
 	| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA		\
-	| BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	| BTRFS_FEATURE_INCOMPAT_NO_HOLES			\
+	| BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+
+/*
+ * Due to bugs in btrfs-convert, it will put data and metadata
+ * extents into the same chunk, even we disallow mixed block group.
+ *
+ * Also, ext* is not as extent based as btrfs, even if we find a method
+ * to fix above bug, it will cause chunks to be very scattered.
+ * So force mixed block group for now.
+ */
+#define BTRFS_CONVERT_FORCE_FEATURES				\
+	(BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
 
 #define BTRFS_FEATURE_LIST_ALL		(1ULL << 63)
 
-- 
2.5.1

