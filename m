Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755107AbdERDjN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:13 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 01/32] btrfs-progs: Remove deprecated leafsize usage
Date: Thu, 18 May 2017 11:38:26 +0800
Message-ID: <20170518033857.15002-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Leafsize is deprecated for a long time, and kernel has already updated
ctree.h to rename sb->leafsize to sb->__unused_leafsize.

This patch will remove normal users of leafsize:
1) Remove leafsize member from btrfs_root structure
   Now only root->nodesize and root->sectorisze.
   No longer root->leafsize.

2) Remove @leafsize parameter from btrfs_setup_root() function
   Since no root->leafsize, no need for @leafsize parameter.

The remaining user of leafsize will be:
1) btrfs inspect-internal dump-super
   Reformat the "leafsize" output to "leafsize (deprecated)" and
   use le32_to_cpu() to do the cast manually.

2) mkfs
   We still need to set sb->__unused_leafsize to nodesize.
   Do the manual cast too.

3) convert
   Same as mkfs, these two superblock setup should be merged later

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 chunk-recover.c           |  4 +---
 cmds-inspect-dump-super.c |  4 ++--
 convert/common.c          |  2 +-
 ctree.h                   | 18 +-----------------
 disk-io.c                 | 28 +++++++++++-----------------
 disk-io.h                 |  2 +-
 mkfs/common.c             |  2 +-
 7 files changed, 18 insertions(+), 42 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 0dc8a430..cf8b3184 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1450,7 +1450,6 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	struct extent_buffer *eb;
 	u32 sectorsize;
 	u32 nodesize;
-	u32 leafsize;
 	u32 stripesize;
 	int ret;
 
@@ -1482,11 +1481,10 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 		goto out_devices;
 
 	nodesize = btrfs_super_nodesize(disk_super);
-	leafsize = btrfs_super_leafsize(disk_super);
 	sectorsize = btrfs_super_sectorsize(disk_super);
 	stripesize = btrfs_super_stripesize(disk_super);
 
-	btrfs_setup_root(nodesize, leafsize, sectorsize, stripesize,
+	btrfs_setup_root(nodesize, sectorsize, stripesize,
 		     fs_info->chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
 
 	ret = build_device_maps_by_chunk_records(rc, fs_info->chunk_root);
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 85307e33..98e0270a 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -397,8 +397,8 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_sectorsize(sb));
 	printf("nodesize\t\t%llu\n",
 	       (unsigned long long)btrfs_super_nodesize(sb));
-	printf("leafsize\t\t%llu\n",
-	       (unsigned long long)btrfs_super_leafsize(sb));
+	printf("leafsize (deprecated)\t\t%u\n",
+	       le32_to_cpu(sb->__unused_leafsize));
 	printf("stripesize\t\t%llu\n",
 	       (unsigned long long)btrfs_super_stripesize(sb));
 	printf("root_dir\t\t%llu\n",
diff --git a/convert/common.c b/convert/common.c
index 40bf32cf..5411864d 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -128,7 +128,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	 */
 	btrfs_set_super_bytes_used(super, 6 * cfg->nodesize);
 	btrfs_set_super_sectorsize(super, cfg->sectorsize);
-	btrfs_set_super_leafsize(super, cfg->nodesize);
+	super->__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_super_nodesize(super, cfg->nodesize);
 	btrfs_set_super_stripesize(super, cfg->stripesize);
 	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
diff --git a/ctree.h b/ctree.h
index 13cf3b00..c457a8dc 100644
--- a/ctree.h
+++ b/ctree.h
@@ -440,7 +440,7 @@ struct btrfs_super_block {
 	__le32 sectorsize;
 	__le32 nodesize;
 	/* Unused and must be equal to nodesize */
-	__le32 leafsize;
+	__le32 __unused_leafsize;
 	__le32 stripesize;
 	__le32 sys_chunk_array_size;
 	__le64 chunk_root_generation;
@@ -1168,9 +1168,6 @@ struct btrfs_root {
 	/* node allocations are done in nodesize units */
 	u32 nodesize;
 
-	/* Unused, equal to nodesize */
-	u32 leafsize;
-
 	/* leaf allocations are done in nodesize units */
 	u32 stripesize;
 
@@ -2159,8 +2156,6 @@ BTRFS_SETGET_STACK_FUNCS(super_sectorsize, struct btrfs_super_block,
 			 sectorsize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_nodesize, struct btrfs_super_block,
 			 nodesize, 32);
-BTRFS_SETGET_STACK_FUNCS(super_leafsize, struct btrfs_super_block,
-			 leafsize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_stripesize, struct btrfs_super_block,
 			 stripesize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_root_dir, struct btrfs_super_block,
@@ -2410,17 +2405,6 @@ static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
 	return btrfs_file_extent_ram_bytes(eb, fi);
 }
 
-/*
- * NOTE: Backward compatibility, do not use.
- * Replacement: read nodesize directly
- */
-__attribute__((deprecated))
-static inline u32 btrfs_level_size(struct btrfs_root *root, int level) {
-	if (level == 0)
-		return root->leafsize;
-	return root->nodesize;
-}
-
 #define btrfs_fs_incompat(fs_info, opt) \
 	__btrfs_fs_incompat((fs_info), BTRFS_FEATURE_INCOMPAT_##opt)
 
diff --git a/disk-io.c b/disk-io.c
index 6aa6d98a..838d5cd4 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -476,7 +476,7 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 	return write_and_map_eb(root, eb);
 }
 
-void btrfs_setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
+void btrfs_setup_root(u32 nodesize, u32 sectorsize,
 			u32 stripesize, struct btrfs_root *root,
 			struct btrfs_fs_info *fs_info, u64 objectid)
 {
@@ -484,7 +484,6 @@ void btrfs_setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->commit_root = NULL;
 	root->sectorsize = sectorsize;
 	root->nodesize = nodesize;
-	root->leafsize = leafsize;
 	root->stripesize = stripesize;
 	root->ref_cows = 0;
 	root->track_dirty = 0;
@@ -631,9 +630,8 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 	u32 blocksize;
 	u64 generation;
 
-	btrfs_setup_root(tree_root->nodesize, tree_root->leafsize,
-		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, objectid);
+	btrfs_setup_root(tree_root->nodesize, tree_root->sectorsize,
+			 tree_root->stripesize, root, fs_info, objectid);
 	ret = btrfs_find_last_root(tree_root, objectid,
 				   &root->root_item, &root->root_key);
 	if (ret)
@@ -667,9 +665,9 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 
 	blocksize = tree_root->nodesize;
 
-	btrfs_setup_root(tree_root->nodesize, tree_root->leafsize,
-		     tree_root->sectorsize, tree_root->stripesize,
-		     log_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
+	btrfs_setup_root(tree_root->nodesize, tree_root->sectorsize,
+			 tree_root->stripesize, log_root, fs_info,
+			 BTRFS_TREE_LOG_OBJECTID);
 
 	log_root->node = read_tree_block(tree_root, blocknr,
 				     blocksize,
@@ -731,9 +729,9 @@ struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 		goto insert;
 	}
 
-	btrfs_setup_root(tree_root->nodesize, tree_root->leafsize,
-		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, location->objectid);
+	btrfs_setup_root(tree_root->nodesize, tree_root->sectorsize,
+			 tree_root->stripesize, root, fs_info,
+			 location->objectid);
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -1000,19 +998,17 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	struct btrfs_key key;
 	u32 sectorsize;
 	u32 nodesize;
-	u32 leafsize;
 	u32 stripesize;
 	u64 generation;
 	u32 blocksize;
 	int ret;
 
 	nodesize = btrfs_super_nodesize(sb);
-	leafsize = btrfs_super_leafsize(sb);
 	sectorsize = btrfs_super_sectorsize(sb);
 	stripesize = btrfs_super_stripesize(sb);
 
 	root = fs_info->tree_root;
-	btrfs_setup_root(nodesize, leafsize, sectorsize, stripesize,
+	btrfs_setup_root(nodesize, sectorsize, stripesize,
 		     root, fs_info, BTRFS_ROOT_TREE_OBJECTID);
 	blocksize = root->nodesize;
 	generation = btrfs_super_generation(sb);
@@ -1194,18 +1190,16 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	u32 sectorsize;
 	u32 nodesize;
-	u32 leafsize;
 	u32 blocksize;
 	u32 stripesize;
 	u64 generation;
 	int ret;
 
 	nodesize = btrfs_super_nodesize(sb);
-	leafsize = btrfs_super_leafsize(sb);
 	sectorsize = btrfs_super_sectorsize(sb);
 	stripesize = btrfs_super_stripesize(sb);
 
-	btrfs_setup_root(nodesize, leafsize, sectorsize, stripesize,
+	btrfs_setup_root(nodesize, sectorsize, stripesize,
 		     fs_info->chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
 
 	ret = btrfs_read_sys_array(fs_info->chunk_root);
diff --git a/disk-io.h b/disk-io.h
index cd4fe929..27dea40a 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -133,7 +133,7 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 struct extent_buffer* btrfs_find_create_tree_block(
 		struct btrfs_fs_info *fs_info, u64 bytenr, u32 blocksize);
 
-void btrfs_setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
+void btrfs_setup_root(u32 nodesize, u32 sectorsize,
                         u32 stripesize, struct btrfs_root *root,
                         struct btrfs_fs_info *fs_info, u64 objectid);
 int clean_tree_block(struct btrfs_trans_handle *trans,
diff --git a/mkfs/common.c b/mkfs/common.c
index 1e8f26ea..e4785c58 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -108,7 +108,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_super_total_bytes(&super, num_bytes);
 	btrfs_set_super_bytes_used(&super, 6 * cfg->nodesize);
 	btrfs_set_super_sectorsize(&super, cfg->sectorsize);
-	btrfs_set_super_leafsize(&super, cfg->nodesize);
+	super.__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_super_nodesize(&super, cfg->nodesize);
 	btrfs_set_super_stripesize(&super, cfg->stripesize);
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
-- 
2.13.0



