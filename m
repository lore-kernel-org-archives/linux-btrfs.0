Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50794 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbdAaPvR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 10:51:17 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: create a helper to create em for IO
Date: Tue, 31 Jan 2017 07:50:22 -0800
Message-Id: <1485877822-28919-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1485807952-17604-1-git-send-email-bo.li.liu@oracle.com>
References: <1485807952-17604-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have similar codes to create and insert extent mapping around IO path,
this merges them into a single helper.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: - undo the function declaration style change.
    - fix errors by checkpatch.pl
    
 fs/btrfs/inode.c | 189 ++++++++++++++++++++++---------------------------------
 1 file changed, 74 insertions(+), 115 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f2b281a..fab42df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -108,11 +108,11 @@ static noinline int cow_file_range(struct inode *inode,
 				   u64 start, u64 end, u64 delalloc_end,
 				   int *page_started, unsigned long *nr_written,
 				   int unlock, struct btrfs_dedupe_hash *hash);
-static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
-					   u64 len, u64 orig_start,
-					   u64 block_start, u64 block_len,
-					   u64 orig_block_len, u64 ram_bytes,
-					   int type);
+static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
+				       u64 orig_start, u64 block_start,
+				       u64 block_len, u64 orig_block_len,
+				       u64 ram_bytes, int compress_type,
+				       int type);
 
 static int btrfs_dirty_inode(struct inode *inode);
 
@@ -690,7 +690,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree;
 	int ret = 0;
 
@@ -778,46 +777,19 @@ static noinline void submit_compressed_extents(struct inode *inode,
 		 * here we're doing allocation and writeback of the
 		 * compressed pages
 		 */
-		btrfs_drop_extent_cache(inode, async_extent->start,
-					async_extent->start +
-					async_extent->ram_size - 1, 0);
-
-		em = alloc_extent_map();
-		if (!em) {
-			ret = -ENOMEM;
-			goto out_free_reserve;
-		}
-		em->start = async_extent->start;
-		em->len = async_extent->ram_size;
-		em->orig_start = em->start;
-		em->mod_start = em->start;
-		em->mod_len = em->len;
-
-		em->block_start = ins.objectid;
-		em->block_len = ins.offset;
-		em->orig_block_len = ins.offset;
-		em->ram_bytes = async_extent->ram_size;
-		em->bdev = fs_info->fs_devices->latest_bdev;
-		em->compress_type = async_extent->compress_type;
-		set_bit(EXTENT_FLAG_PINNED, &em->flags);
-		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
-		em->generation = -1;
-
-		while (1) {
-			write_lock(&em_tree->lock);
-			ret = add_extent_mapping(em_tree, em, 1);
-			write_unlock(&em_tree->lock);
-			if (ret != -EEXIST) {
-				free_extent_map(em);
-				break;
-			}
-			btrfs_drop_extent_cache(inode, async_extent->start,
-						async_extent->start +
-						async_extent->ram_size - 1, 0);
-		}
-
-		if (ret)
+		em = create_io_em(inode, async_extent->start,
+				  async_extent->ram_size, /* len */
+				  async_extent->start, /* orig_start */
+				  ins.objectid, /* block_start */
+				  ins.offset, /* block_len */
+				  ins.offset, /* orig_block_len */
+				  async_extent->ram_size, /* ram_bytes */
+				  async_extent->compress_type,
+				  BTRFS_ORDERED_COMPRESSED);
+		if (IS_ERR(em))
+			/* ret value is not necessary due to void function */
 			goto out_free_reserve;
+		free_extent_map(em);
 
 		ret = btrfs_add_ordered_extent_compress(inode,
 						async_extent->start,
@@ -952,7 +924,6 @@ static noinline int cow_file_range(struct inode *inode,
 	u64 blocksize = fs_info->sectorsize;
 	struct btrfs_key ins;
 	struct extent_map *em;
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;
 
 	if (btrfs_is_free_space_inode(inode)) {
@@ -1008,39 +979,18 @@ static noinline int cow_file_range(struct inode *inode,
 		if (ret < 0)
 			goto out_unlock;
 
-		em = alloc_extent_map();
-		if (!em) {
-			ret = -ENOMEM;
-			goto out_reserve;
-		}
-		em->start = start;
-		em->orig_start = em->start;
 		ram_size = ins.offset;
-		em->len = ins.offset;
-		em->mod_start = em->start;
-		em->mod_len = em->len;
-
-		em->block_start = ins.objectid;
-		em->block_len = ins.offset;
-		em->orig_block_len = ins.offset;
-		em->ram_bytes = ram_size;
-		em->bdev = fs_info->fs_devices->latest_bdev;
-		set_bit(EXTENT_FLAG_PINNED, &em->flags);
-		em->generation = -1;
-
-		while (1) {
-			write_lock(&em_tree->lock);
-			ret = add_extent_mapping(em_tree, em, 1);
-			write_unlock(&em_tree->lock);
-			if (ret != -EEXIST) {
-				free_extent_map(em);
-				break;
-			}
-			btrfs_drop_extent_cache(inode, start,
-						start + ram_size - 1, 0);
-		}
-		if (ret)
+		em = create_io_em(inode, start, ins.offset, /* len */
+				  start, /* orig_start */
+				  ins.objectid, /* block_start */
+				  ins.offset, /* block_len */
+				  ins.offset, /* orig_block_len */
+				  ram_size, /* ram_bytes */
+				  BTRFS_COMPRESS_NONE, /* compress_type */
+				  0 /* type */);
+		if (IS_ERR(em))
 			goto out_reserve;
+		free_extent_map(em);
 
 		cur_alloc_size = ins.offset;
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
@@ -1255,6 +1205,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key found_key;
+	struct extent_map *em;
 	u64 cow_start;
 	u64 cur_offset;
 	u64 extent_end;
@@ -1455,35 +1406,28 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		}
 
 		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
-			struct extent_map *em;
-			struct extent_map_tree *em_tree;
-			em_tree = &BTRFS_I(inode)->extent_tree;
-			em = alloc_extent_map();
-			BUG_ON(!em); /* -ENOMEM */
-			em->start = cur_offset;
-			em->orig_start = found_key.offset - extent_offset;
-			em->len = num_bytes;
-			em->block_len = num_bytes;
-			em->block_start = disk_bytenr;
-			em->orig_block_len = disk_num_bytes;
-			em->ram_bytes = ram_bytes;
-			em->bdev = fs_info->fs_devices->latest_bdev;
-			em->mod_start = em->start;
-			em->mod_len = em->len;
-			set_bit(EXTENT_FLAG_PINNED, &em->flags);
-			set_bit(EXTENT_FLAG_FILLING, &em->flags);
-			em->generation = -1;
-			while (1) {
-				write_lock(&em_tree->lock);
-				ret = add_extent_mapping(em_tree, em, 1);
-				write_unlock(&em_tree->lock);
-				if (ret != -EEXIST) {
-					free_extent_map(em);
-					break;
-				}
-				btrfs_drop_extent_cache(inode, em->start,
-						em->start + em->len - 1, 0);
+			u64 orig_start = found_key.offset - extent_offset;
+
+			em = create_io_em(inode, cur_offset, num_bytes,
+					  orig_start,
+					  disk_bytenr, /* block_start */
+					  num_bytes, /* block_len */
+					  disk_num_bytes, /* orig_block_len */
+					  ram_bytes, BTRFS_COMPRESS_NONE,
+					  BTRFS_ORDERED_PREALLOC);
+			if (IS_ERR(em)) {
+				if (!nolock && nocow)
+					btrfs_end_write_no_snapshoting(root);
+				if (nocow)
+					btrfs_dec_nocow_writers(fs_info,
+								disk_bytenr);
+				ret = PTR_ERR(em);
+				goto error;
 			}
+			free_extent_map(em);
+		}
+
+		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 			type = BTRFS_ORDERED_PREALLOC;
 		} else {
 			type = BTRFS_ORDERED_NOCOW;
@@ -7217,9 +7161,11 @@ static struct extent_map *btrfs_create_dio_extent(struct inode *inode,
 
 	down_read(&BTRFS_I(inode)->dio_sem);
 	if (type != BTRFS_ORDERED_NOCOW) {
-		em = create_pinned_em(inode, start, len, orig_start,
-				      block_start, block_len, orig_block_len,
-				      ram_bytes, type);
+		em = create_io_em(inode, start, len, orig_start,
+				  block_start, block_len, orig_block_len,
+				  ram_bytes,
+				  BTRFS_COMPRESS_NONE, /* compress_type */
+				  type);
 		if (IS_ERR(em))
 			goto out;
 	}
@@ -7563,17 +7509,23 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 	return ret;
 }
 
-static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
-					   u64 len, u64 orig_start,
-					   u64 block_start, u64 block_len,
-					   u64 orig_block_len, u64 ram_bytes,
-					   int type)
+/* The callers of this must take lock_extent() */
+static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
+				       u64 orig_start, u64 block_start,
+				       u64 block_len, u64 orig_block_len,
+				       u64 ram_bytes, int compress_type,
+				       int type)
 {
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
+	ASSERT(type == BTRFS_ORDERED_PREALLOC ||
+	       type == BTRFS_ORDERED_COMPRESSED ||
+	       type == BTRFS_ORDERED_NOCOW ||
+	       type == 0);
+
 	em_tree = &BTRFS_I(inode)->extent_tree;
 	em = alloc_extent_map();
 	if (!em)
@@ -7581,8 +7533,6 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 
 	em->start = start;
 	em->orig_start = orig_start;
-	em->mod_start = start;
-	em->mod_len = len;
 	em->len = len;
 	em->block_len = block_len;
 	em->block_start = block_start;
@@ -7593,6 +7543,10 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 	if (type == BTRFS_ORDERED_PREALLOC)
 		set_bit(EXTENT_FLAG_FILLING, &em->flags);
+	else if (type == BTRFS_ORDERED_COMPRESSED) {
+		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
+		em->compress_type = compress_type;
+	}
 
 	do {
 		btrfs_drop_extent_cache(inode, em->start,
@@ -7600,6 +7554,10 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 		write_lock(&em_tree->lock);
 		ret = add_extent_mapping(em_tree, em, 1);
 		write_unlock(&em_tree->lock);
+		/*
+		 * The caller has taken lock_extent(), who could race with us
+		 * to add em?
+		 */
 	} while (ret == -EEXIST);
 
 	if (ret) {
@@ -7607,6 +7565,7 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 		return ERR_PTR(ret);
 	}
 
+	/* em got 2 refs now, callers needs to do free_extent_map once. */
 	return em;
 }
 
-- 
2.5.5

