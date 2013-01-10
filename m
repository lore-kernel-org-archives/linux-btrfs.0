Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57131 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab3AJMsJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 07:48:09 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0ACm7qr022117
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 20:48:07 +0800
Message-ID: <50EEB8AD.9020306@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 20:48:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/11] Btrfs: use percpu counter for dirty metadata count
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

->dirty_metadata_bytes is accessed very frequently, so use percpu counter
instead of the u64 variant to reduce the contention of the lock.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h     |  9 ++++----
 fs/btrfs/disk-io.c   | 64 ++++++++++++++++++++++++++++------------------------
 fs/btrfs/extent_io.c |  9 +++-----
 3 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 201be7d..1dcbbfd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -191,6 +191,8 @@ static int btrfs_csum_sizes[] = { 4, 0 };
 /* ioprio of readahead is set to idle */
 #define BTRFS_IOPRIO_READA (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0))
 
+#define BTRFS_DIRTY_METADATA_THRESH	(32 * 1024 * 1024)
+
 /*
  * The key defines the order in the tree, and so it also defines (optimal)
  * block layout.
@@ -1439,10 +1441,9 @@ struct btrfs_fs_info {
 
 	u64 total_pinned;
 
-	/* protected by the delalloc lock, used to keep from writing
-	 * metadata until there is a nice batch
-	 */
-	u64 dirty_metadata_bytes;
+	/* used to keep from writing metadata until there is a nice batch */
+	struct percpu_counter dirty_metadata_bytes;
+	s32 dirty_metadata_batch;
 	struct list_head dirty_cowonly_roots;
 
 	struct btrfs_fs_devices *fs_devices;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9263c6e..adf270e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -946,18 +946,20 @@ static int btree_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
 	struct extent_io_tree *tree;
+	struct btrfs_fs_info *fs_info;
+	int ret;
+
 	tree = &BTRFS_I(mapping->host)->io_tree;
 	if (wbc->sync_mode == WB_SYNC_NONE) {
-		struct btrfs_root *root = BTRFS_I(mapping->host)->root;
-		u64 num_dirty;
-		unsigned long thresh = 32 * 1024 * 1024;
 
 		if (wbc->for_kupdate)
 			return 0;
 
+		fs_info = BTRFS_I(mapping->host)->root->fs_info;
 		/* this is a bit racy, but that's ok */
-		num_dirty = root->fs_info->dirty_metadata_bytes;
-		if (num_dirty < thresh)
+		ret = percpu_counter_compare(&fs_info->dirty_metadata_bytes,
+					     BTRFS_DIRTY_METADATA_THRESH);
+		if (ret < 0)
 			return 0;
 	}
 	return btree_write_cache_pages(mapping, wbc);
@@ -1125,24 +1127,16 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      struct extent_buffer *buf)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
 	if (btrfs_header_generation(buf) ==
-	    root->fs_info->running_transaction->transid) {
+	    fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
 
 		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
-			spin_lock(&root->fs_info->delalloc_lock);
-			if (root->fs_info->dirty_metadata_bytes >= buf->len)
-				root->fs_info->dirty_metadata_bytes -= buf->len;
-			else {
-				spin_unlock(&root->fs_info->delalloc_lock);
-				btrfs_panic(root->fs_info, -EOVERFLOW,
-					  "Can't clear %lu bytes from "
-					  " dirty_mdatadata_bytes (%llu)",
-					  buf->len,
-					  root->fs_info->dirty_metadata_bytes);
-			}
-			spin_unlock(&root->fs_info->delalloc_lock);
-
+			__percpu_counter_add(&fs_info->dirty_metadata_bytes,
+					     -buf->len,
+					     fs_info->dirty_metadata_batch);
 			/* ugh, clear_extent_buffer_dirty needs to lock the page */
 			btrfs_set_lock_blocking(buf);
 			clear_extent_buffer_dirty(buf);
@@ -2004,10 +1998,18 @@ int open_ctree(struct super_block *sb,
 		goto fail_srcu;
 	}
 
+	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0);
+	if (ret) {
+		err = ret;
+		goto fail_bdi;
+	}
+	fs_info->dirty_metadata_batch = PAGE_CACHE_SIZE *
+					(1 + ilog2(nr_cpu_ids));
+
 	fs_info->btree_inode = new_inode(sb);
 	if (!fs_info->btree_inode) {
 		err = -ENOMEM;
-		goto fail_bdi;
+		goto fail_dirty_metadata_bytes;
 	}
 
 	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
@@ -2261,6 +2263,7 @@ int open_ctree(struct super_block *sb,
 	leafsize = btrfs_super_leafsize(disk_super);
 	sectorsize = btrfs_super_sectorsize(disk_super);
 	stripesize = btrfs_super_stripesize(disk_super);
+	fs_info->dirty_metadata_batch = leafsize * (1 + ilog2(nr_cpu_ids));
 
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
@@ -2723,6 +2726,8 @@ fail_iput:
 
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
+fail_dirty_metadata_bytes:
+	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
 fail_bdi:
 	bdi_destroy(&fs_info->bdi);
 fail_srcu:
@@ -3401,6 +3406,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
+	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
 	bdi_destroy(&fs_info->bdi);
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 
@@ -3443,11 +3449,10 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 			(unsigned long long)transid,
 			(u64)atomic64_read(&root->fs_info->generation));
 	was_dirty = set_extent_buffer_dirty(buf);
-	if (!was_dirty) {
-		spin_lock(&root->fs_info->delalloc_lock);
-		root->fs_info->dirty_metadata_bytes += buf->len;
-		spin_unlock(&root->fs_info->delalloc_lock);
-	}
+	if (!was_dirty)
+		__percpu_counter_add(&root->fs_info->dirty_metadata_bytes,
+				     buf->len,
+				     root->fs_info->dirty_metadata_batch);
 }
 
 static void __btrfs_btree_balance_dirty(struct btrfs_root *root,
@@ -3457,8 +3462,7 @@ static void __btrfs_btree_balance_dirty(struct btrfs_root *root,
 	 * looks as though older kernels can get into trouble with
 	 * this code, they end up stuck in balance_dirty_pages forever
 	 */
-	u64 num_dirty;
-	unsigned long thresh = 32 * 1024 * 1024;
+	int ret;
 
 	if (current->flags & PF_MEMALLOC)
 		return;
@@ -3466,9 +3470,9 @@ static void __btrfs_btree_balance_dirty(struct btrfs_root *root,
 	if (flush_delayed)
 		btrfs_balance_delayed_items(root);
 
-	num_dirty = root->fs_info->dirty_metadata_bytes;
-
-	if (num_dirty > thresh) {
+	ret = percpu_counter_compare(&root->fs_info->dirty_metadata_bytes,
+				     BTRFS_DIRTY_METADATA_THRESH);
+	if (ret > 0) {
 		balance_dirty_pages_ratelimited_nr(
 				   root->fs_info->btree_inode->i_mapping, 1);
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1b319df..2d4bdfd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3124,12 +3124,9 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
 		spin_unlock(&eb->refs_lock);
 		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-		spin_lock(&fs_info->delalloc_lock);
-		if (fs_info->dirty_metadata_bytes >= eb->len)
-			fs_info->dirty_metadata_bytes -= eb->len;
-		else
-			WARN_ON(1);
-		spin_unlock(&fs_info->delalloc_lock);
+		__percpu_counter_add(&fs_info->dirty_metadata_bytes,
+				     -eb->len,
+				     fs_info->dirty_metadata_batch);
 		ret = 1;
 	} else {
 		spin_unlock(&eb->refs_lock);
-- 
1.7.11.7
