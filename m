Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26681 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752554AbdFMJTt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:49 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 01/19] btrfs-progs: Refactor btrfs_map_block and its variants to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:17 +0800
Message-ID: <20170613091935.23277-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just to keep the 1st paramter the same as kernel.

We can also save a few lines since the parameter is shorter now.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c |  5 ++---
 btrfs-map-logical.c   |  5 ++---
 cmds-check.c          |  2 +-
 cmds-restore.c        |  4 ++--
 disk-io.c             | 16 +++++++---------
 extent-tree.c         | 10 +++++-----
 extent_io.c           |  8 ++++----
 volumes.c             | 16 +++++++++-------
 volumes.h             |  6 +++---
 9 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index f29f22d2..01bd1f2f 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -47,9 +47,8 @@ static int debug_corrupt_block(struct extent_buffer *eb,
 
 	length = blocksize;
 	while (1) {
-		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-				      eb->start, &length, &multi,
-				      mirror_num, NULL);
+		ret = btrfs_map_block(root->fs_info, READ, eb->start, &length,
+				      &multi, mirror_num, NULL);
 		if (ret) {
 			error("cannot map block %llu length %llu mirror %d: %d",
 					(unsigned long long)eb->start,
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index e88357fc..c56253cd 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -109,9 +109,8 @@ static int __print_mapping_info(struct btrfs_fs_info *fs_info, u64 logical,
 		int i;
 
 		cur_len = len - cur_offset;
-		ret = btrfs_map_block(&fs_info->mapping_tree, READ,
-				logical + cur_offset, &cur_len,
-				&multi, mirror_num, NULL);
+		ret = btrfs_map_block(fs_info, READ, logical + cur_offset,
+				      &cur_len, &multi, mirror_num, NULL);
 		if (ret) {
 			fprintf(info_file,
 				"Error: fails to map mirror%d logical %llu: %s\n",
diff --git a/cmds-check.c b/cmds-check.c
index c052f66e..60640bc8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6932,7 +6932,7 @@ static int check_cache_range(struct btrfs_root *root,
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
+		ret = btrfs_rmap_block(root->fs_info,
 				       cache->key.objectid, bytenr, 0,
 				       &logical, &nr, &stripe_len);
 		if (ret)
diff --git a/cmds-restore.c b/cmds-restore.c
index 06c88b26..9ee38c70 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -346,8 +346,8 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	}
 again:
 	length = size_left;
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-			      bytenr, &length, &multi, mirror_num, NULL);
+	ret = btrfs_map_block(root->fs_info, READ, bytenr, &length, &multi,
+			      mirror_num, NULL);
 	if (ret) {
 		error("cannot map block logical %llu length %llu: %d",
 				(unsigned long long)bytenr,
diff --git a/disk-io.c b/disk-io.c
index ec2f52af..32e2d267 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -203,8 +203,8 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 
 	eb = btrfs_find_tree_block(root, bytenr, blocksize);
 	if (!(eb && btrfs_buffer_uptodate(eb, parent_transid)) &&
-	    !btrfs_map_block(&root->fs_info->mapping_tree, READ,
-			     bytenr, &length, &multi, 0, NULL)) {
+	    !btrfs_map_block(root->fs_info, READ, bytenr, &length, &multi, 0,
+			     NULL)) {
 		device = multi->stripes[0].dev;
 		device->total_ios++;
 		blocksize = min(blocksize, (u32)SZ_64K);
@@ -262,9 +262,8 @@ int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirr
 
 		if (!info->on_restoring &&
 		    eb->start != BTRFS_SUPER_INFO_OFFSET) {
-			ret = btrfs_map_block(&info->mapping_tree, READ,
-					      eb->start + offset, &read_len, &multi,
-					      mirror, NULL);
+			ret = btrfs_map_block(info, READ, eb->start + offset,
+					      &read_len, &multi, mirror, NULL);
 			if (ret) {
 				printk("Couldn't map the block %Lu\n", eb->start + offset);
 				kfree(multi);
@@ -402,8 +401,7 @@ int read_extent_data(struct btrfs_root *root, char *data,
 	int ret = 0;
 	u64 max_len = *len;
 
-	ret = btrfs_map_block(&info->mapping_tree, READ, logical, len,
-			      &multi, mirror, NULL);
+	ret = btrfs_map_block(info, READ, logical, len, &multi, mirror, NULL);
 	if (ret) {
 		fprintf(stderr, "Couldn't map the block %llu\n",
 				logical + offset);
@@ -436,8 +434,8 @@ int write_and_map_eb(struct btrfs_root *root, struct extent_buffer *eb)
 
 	dev_nr = 0;
 	length = eb->len;
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
-			      eb->start, &length, &multi, 0, &raid_map);
+	ret = btrfs_map_block(root->fs_info, WRITE, eb->start, &length,
+			      &multi, 0, &raid_map);
 
 	if (raid_map) {
 		ret = write_raid56_with_parity(root->fs_info, eb, multi,
diff --git a/extent-tree.c b/extent-tree.c
index 43fa3b5f..f252c0ce 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -69,13 +69,13 @@ static int remove_sb_from_cache(struct btrfs_root *root,
 	u64 *logical;
 	int stripe_len;
 	int i, nr, ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_io_tree *free_space_cache;
 
-	free_space_cache = &root->fs_info->free_space_cache;
+	free_space_cache = &fs_info->free_space_cache;
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
-				       cache->key.objectid, bytenr, 0,
+		ret = btrfs_rmap_block(fs_info, cache->key.objectid, bytenr, 0,
 				       &logical, &nr, &stripe_len);
 		BUG_ON(ret);
 		while (nr--) {
@@ -3181,7 +3181,7 @@ static void account_super_bytes(struct btrfs_fs_info *fs_info,
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(&fs_info->mapping_tree,
+		ret = btrfs_rmap_block(fs_info,
 				       cache->key.objectid, bytenr,
 				       0, &logical, &nr, &stripe_len);
 		if (ret)
@@ -4180,7 +4180,7 @@ int exclude_super_stripes(struct btrfs_root *root,
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
+		ret = btrfs_rmap_block(root->fs_info,
 				       cache->key.objectid, bytenr,
 				       0, &logical, &nr, &stripe_len);
 		if (ret)
diff --git a/extent_io.c b/extent_io.c
index 26a67865..1c6c1425 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -698,8 +698,8 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 
 	while (bytes_left) {
 		read_len = bytes_left;
-		ret = btrfs_map_block(&info->mapping_tree, READ, offset,
-				      &read_len, &multi, mirror, NULL);
+		ret = btrfs_map_block(info, READ, offset, &read_len, &multi,
+				      mirror, NULL);
 		if (ret) {
 			fprintf(stderr, "Couldn't map the block %Lu\n",
 				offset);
@@ -752,8 +752,8 @@ int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 		this_len = bytes_left;
 		dev_nr = 0;
 
-		ret = btrfs_map_block(&info->mapping_tree, WRITE, offset,
-				      &this_len, &multi, mirror, &raid_map);
+		ret = btrfs_map_block(info, WRITE, offset, &this_len, &multi,
+				      mirror, &raid_map);
 		if (ret) {
 			fprintf(stderr, "Couldn't map the block %Lu\n",
 				offset);
diff --git a/volumes.c b/volumes.c
index 990300f4..1ff90f0c 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1284,10 +1284,11 @@ int btrfs_next_bg(struct btrfs_mapping_tree *map_tree, u64 *logical,
 	return -ENOENT;
 }
 
-int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
+int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len)
 {
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct cache_extent *ce;
 	struct map_lookup *map;
 	u64 *buf;
@@ -1379,20 +1380,21 @@ static void sort_parity_stripes(struct btrfs_multi_bio *bbio, u64 *raid_map)
 	}
 }
 
-int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
+int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_multi_bio **multi_ret, int mirror_num,
 		    u64 **raid_map_ret)
 {
-	return __btrfs_map_block(map_tree, rw, logical, length, NULL,
+	return __btrfs_map_block(fs_info, rw, logical, length, NULL,
 				 multi_ret, mirror_num, raid_map_ret);
 }
 
-int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
-		    u64 logical, u64 *length, u64 *type,
-		    struct btrfs_multi_bio **multi_ret, int mirror_num,
-		    u64 **raid_map_ret)
+int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
+		      u64 logical, u64 *length, u64 *type,
+		      struct btrfs_multi_bio **multi_ret, int mirror_num,
+		      u64 **raid_map_ret)
 {
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct cache_extent *ce;
 	struct map_lookup *map;
 	u64 offset;
diff --git a/volumes.h b/volumes.h
index fc0a775b..59e43161 100644
--- a/volumes.h
+++ b/volumes.h
@@ -179,11 +179,11 @@ static inline int check_crossing_stripes(struct btrfs_fs_info *fs_info,
 		(bg_offset + len - 1) / BTRFS_STRIPE_LEN);
 }
 
-int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
+int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		      u64 logical, u64 *length, u64 *type,
 		      struct btrfs_multi_bio **multi_ret, int mirror_num,
 		      u64 **raid_map);
-int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
+int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_multi_bio **multi_ret, int mirror_num,
 		    u64 **raid_map_ret);
@@ -201,7 +201,7 @@ static inline int btrfs_next_bg_system(struct btrfs_mapping_tree *map_tree,
 	return btrfs_next_bg(map_tree, logical, size,
 			BTRFS_BLOCK_GROUP_SYSTEM);
 }
-int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
+int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);
 int btrfs_read_sys_array(struct btrfs_root *root);
-- 
2.13.1



