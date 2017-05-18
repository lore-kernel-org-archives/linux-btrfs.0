Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932137AbdERDjS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:18 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 03/32] btrfs-progs: Refactor block sizes users in disk-io.c
Date: Thu, 18 May 2017 11:38:28 +0800
Message-ID: <20170518033857.15002-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have cached block sizes in fs_info, there is no need to specify
these sizes in btrfs_setup_root() function.

And refactor all root->sector/node/stripesize users in disk-io.c.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 chunk-recover.c | 11 ++--------
 disk-io.c       | 64 ++++++++++++++++++++-------------------------------------
 disk-io.h       |  5 ++---
 3 files changed, 26 insertions(+), 54 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 1a880038..96b939a3 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1448,9 +1448,6 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_super_block *disk_super;
 	struct extent_buffer *eb;
-	u32 sectorsize;
-	u32 nodesize;
-	u32 stripesize;
 	int ret;
 
 	fs_info = btrfs_new_fs_info(1, BTRFS_SUPER_INFO_OFFSET);
@@ -1483,12 +1480,8 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	if (ret)
 		goto out_devices;
 
-	nodesize = btrfs_super_nodesize(disk_super);
-	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = btrfs_super_stripesize(disk_super);
-
-	btrfs_setup_root(nodesize, sectorsize, stripesize,
-		     fs_info->chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
+	btrfs_setup_root(fs_info->chunk_root, fs_info,
+			 BTRFS_CHUNK_TREE_OBJECTID);
 
 	ret = build_device_maps_by_chunk_records(rc, fs_info->chunk_root);
 	if (ret)
diff --git a/disk-io.c b/disk-io.c
index bfdac5ab..89e35c92 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -56,7 +56,7 @@ static int check_tree_block(struct btrfs_fs_info *fs_info,
 {
 
 	struct btrfs_fs_devices *fs_devices;
-	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 nodesize = fs_info->nodesize;
 	int ret = BTRFS_BAD_FSID;
 
 	if (buf->start != btrfs_header_bytenr(buf))
@@ -313,8 +313,8 @@ struct extent_buffer* read_tree_block_fs_info(
 	int ret;
 	struct extent_buffer *eb;
 	u64 best_transid = 0;
-	u32 sectorsize = btrfs_super_sectorsize(fs_info->super_copy);
-	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 sectorsize = fs_info->sectorsize;
+	u32 nodesize = fs_info->nodesize;
 	int mirror_num = 0;
 	int good_mirror = 0;
 	int num_copies;
@@ -476,15 +476,14 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 	return write_and_map_eb(root, eb);
 }
 
-void btrfs_setup_root(u32 nodesize, u32 sectorsize,
-			u32 stripesize, struct btrfs_root *root,
-			struct btrfs_fs_info *fs_info, u64 objectid)
+void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
+		      u64 objectid)
 {
 	root->node = NULL;
 	root->commit_root = NULL;
-	root->sectorsize = sectorsize;
-	root->nodesize = nodesize;
-	root->stripesize = stripesize;
+	root->sectorsize = fs_info->sectorsize;
+	root->nodesize = fs_info->nodesize;
+	root->stripesize = fs_info->stripesize;
 	root->ref_cows = 0;
 	root->track_dirty = 0;
 
@@ -630,14 +629,13 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 	u32 blocksize;
 	u64 generation;
 
-	btrfs_setup_root(tree_root->nodesize, tree_root->sectorsize,
-			 tree_root->stripesize, root, fs_info, objectid);
+	btrfs_setup_root(root, fs_info, objectid);
 	ret = btrfs_find_last_root(tree_root, objectid,
 				   &root->root_item, &root->root_key);
 	if (ret)
 		return ret;
 
-	blocksize = root->nodesize;
+	blocksize = fs_info->nodesize;
 	generation = btrfs_root_generation(&root->root_item);
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
@@ -663,10 +661,9 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 		return 0;
 	}
 
-	blocksize = tree_root->nodesize;
+	blocksize = fs_info->nodesize;
 
-	btrfs_setup_root(tree_root->nodesize, tree_root->sectorsize,
-			 tree_root->stripesize, log_root, fs_info,
+	btrfs_setup_root(log_root, fs_info,
 			 BTRFS_TREE_LOG_OBJECTID);
 
 	log_root->node = read_tree_block(tree_root, blocknr,
@@ -729,8 +726,7 @@ struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 		goto insert;
 	}
 
-	btrfs_setup_root(tree_root->nodesize, tree_root->sectorsize,
-			 tree_root->stripesize, root, fs_info,
+	btrfs_setup_root(root, fs_info,
 			 location->objectid);
 
 	path = btrfs_alloc_path();
@@ -758,7 +754,7 @@ out:
 		return ERR_PTR(ret);
 	}
 	generation = btrfs_root_generation(&root->root_item);
-	blocksize = root->nodesize;
+	blocksize = fs_info->nodesize;
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
 	if (!extent_buffer_uptodate(root->node)) {
@@ -996,21 +992,13 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	struct btrfs_root *root;
 	struct btrfs_key key;
-	u32 sectorsize;
-	u32 nodesize;
-	u32 stripesize;
 	u64 generation;
 	u32 blocksize;
 	int ret;
 
-	nodesize = btrfs_super_nodesize(sb);
-	sectorsize = btrfs_super_sectorsize(sb);
-	stripesize = btrfs_super_stripesize(sb);
-
 	root = fs_info->tree_root;
-	btrfs_setup_root(nodesize, sectorsize, stripesize,
-		     root, fs_info, BTRFS_ROOT_TREE_OBJECTID);
-	blocksize = root->nodesize;
+	btrfs_setup_root(root, fs_info, BTRFS_ROOT_TREE_OBJECTID);
+	blocksize = fs_info->nodesize;
 	generation = btrfs_super_generation(sb);
 
 	if (!root_tree_bytenr && !(flags & OPEN_CTREE_BACKUP_ROOT)) {
@@ -1188,31 +1176,22 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 					  u64 chunk_root_bytenr)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
-	u32 sectorsize;
-	u32 nodesize;
-	u32 blocksize;
-	u32 stripesize;
 	u64 generation;
 	int ret;
 
-	nodesize = btrfs_super_nodesize(sb);
-	sectorsize = btrfs_super_sectorsize(sb);
-	stripesize = btrfs_super_stripesize(sb);
-
-	btrfs_setup_root(nodesize, sectorsize, stripesize,
-		     fs_info->chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
+	btrfs_setup_root(fs_info->chunk_root, fs_info,
+			BTRFS_CHUNK_TREE_OBJECTID);
 
 	ret = btrfs_read_sys_array(fs_info->chunk_root);
 	if (ret)
 		return ret;
 
-	blocksize = fs_info->chunk_root->nodesize;
 	generation = btrfs_super_chunk_root_generation(sb);
 
 	if (chunk_root_bytenr && !IS_ALIGNED(chunk_root_bytenr,
-					    btrfs_super_sectorsize(sb))) {
+					    fs_info->sectorsize)) {
 		warning("chunk_root_bytenr %llu is unaligned to %u, ignore it",
-			chunk_root_bytenr, btrfs_super_sectorsize(sb));
+			chunk_root_bytenr, fs_info->sectorsize);
 		chunk_root_bytenr = 0;
 	}
 
@@ -1223,7 +1202,8 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 
 	fs_info->chunk_root->node = read_tree_block(fs_info->chunk_root,
 						    chunk_root_bytenr,
-						    blocksize, generation);
+						    fs_info->nodesize,
+						    generation);
 	if (!extent_buffer_uptodate(fs_info->chunk_root->node)) {
 		if (fs_info->ignore_chunk_tree_error) {
 			warning("cannot read chunk root, continue anyway");
diff --git a/disk-io.h b/disk-io.h
index 27dea40a..b4d02275 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -133,9 +133,8 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 struct extent_buffer* btrfs_find_create_tree_block(
 		struct btrfs_fs_info *fs_info, u64 bytenr, u32 blocksize);
 
-void btrfs_setup_root(u32 nodesize, u32 sectorsize,
-                        u32 stripesize, struct btrfs_root *root,
-                        struct btrfs_fs_info *fs_info, u64 objectid);
+void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
+		      u64 objectid);
 int clean_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root, struct extent_buffer *buf);
 
-- 
2.13.0



