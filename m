Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51031 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaKUIPY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 03:15:24 -0500
From: Daniel Dressler <danieru.dressler@gmail.com>
To: danieru.dressler@gmail.c
Cc: Daniel Dressler <danieru.dressler@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Btrfs: disk-io: replace root args iff only fs_info used
Date: Fri, 21 Nov 2014 17:15:07 +0900
Message-Id: <1416557707-9243-1-git-send-email-danieru.dressler@gmail.com>
In-Reply-To: <danieru.dressler@gmail.com>
References: <danieru.dressler@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the 3rd independent patch of a larger
project to cleanup btrfs's internal usage of
btrfs_root. Many functions take btrfs_root
only to grab the fs_info struct.

By requiring a root these functions cause
programmer overhead. That these functions can
accept any valid root is not obvious until
inspection.

This patch reduces the specificity of such
functions to accept the fs_info directly.

These patches can be applied independently
and thus are not being submitted as a patch
series. There should be about 26 patches by
the project's completion. Each patch will
cleanup between 1 and 34 functions apiece.
Each patch covers a single file's functions.

This patch affects the following function(s):
  1) csum_tree_block
  2) csum_dirty_buffer
  3) check_tree_block_fsid
  4) btrfs_find_tree_block
  5) clean_tree_block

Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
---
 fs/btrfs/ctree.c       | 26 +++++++++++++-------------
 fs/btrfs/disk-io.c     | 32 ++++++++++++++++----------------
 fs/btrfs/disk-io.h     |  4 ++--
 fs/btrfs/extent-tree.c |  6 +++---
 4 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 19bc616..e76a6ba 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1075,7 +1075,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			ret = btrfs_dec_ref(trans, root, buf, 1);
 			BUG_ON(ret); /* -ENOMEM */
 		}
-		clean_tree_block(trans, root, buf);
+		clean_tree_block(trans, root->fs_info, buf);
 		*last_ref = 1;
 	}
 	return 0;
@@ -1681,7 +1681,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		cur = btrfs_find_tree_block(root, blocknr);
+		cur = btrfs_find_tree_block(root->fs_info, blocknr);
 		if (cur)
 			uptodate = btrfs_buffer_uptodate(cur, gen, 0);
 		else
@@ -1946,7 +1946,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 		path->locks[level] = 0;
 		path->nodes[level] = NULL;
-		clean_tree_block(trans, root, mid);
+		clean_tree_block(trans, root->fs_info, mid);
 		btrfs_tree_unlock(mid);
 		/* once for the path */
 		free_extent_buffer(mid);
@@ -2000,7 +2000,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (wret < 0 && wret != -ENOSPC)
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
-			clean_tree_block(trans, root, right);
+			clean_tree_block(trans, root->fs_info, right);
 			btrfs_tree_unlock(right);
 			del_ptr(root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
@@ -2044,7 +2044,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		BUG_ON(wret == 1);
 	}
 	if (btrfs_header_nritems(mid) == 0) {
-		clean_tree_block(trans, root, mid);
+		clean_tree_block(trans, root->fs_info, mid);
 		btrfs_tree_unlock(mid);
 		del_ptr(root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
@@ -2262,7 +2262,7 @@ static void reada_for_search(struct btrfs_root *root,
 
 	search = btrfs_node_blockptr(node, slot);
 	blocksize = root->nodesize;
-	eb = btrfs_find_tree_block(root, search);
+	eb = btrfs_find_tree_block(root->fs_info, search);
 	if (eb) {
 		free_extent_buffer(eb);
 		return;
@@ -2324,7 +2324,7 @@ static noinline void reada_for_balance(struct btrfs_root *root,
 	if (slot > 0) {
 		block1 = btrfs_node_blockptr(parent, slot - 1);
 		gen = btrfs_node_ptr_generation(parent, slot - 1);
-		eb = btrfs_find_tree_block(root, block1);
+		eb = btrfs_find_tree_block(root->fs_info, block1);
 		/*
 		 * if we get -eagain from btrfs_buffer_uptodate, we
 		 * don't want to return eagain here.  That will loop
@@ -2337,7 +2337,7 @@ static noinline void reada_for_balance(struct btrfs_root *root,
 	if (slot + 1 < nritems) {
 		block2 = btrfs_node_blockptr(parent, slot + 1);
 		gen = btrfs_node_ptr_generation(parent, slot + 1);
-		eb = btrfs_find_tree_block(root, block2);
+		eb = btrfs_find_tree_block(root->fs_info, block2);
 		if (eb && btrfs_buffer_uptodate(eb, gen, 1) != 0)
 			block2 = 0;
 		free_extent_buffer(eb);
@@ -2455,7 +2455,7 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 	blocknr = btrfs_node_blockptr(b, slot);
 	gen = btrfs_node_ptr_generation(b, slot);
 
-	tmp = btrfs_find_tree_block(root, blocknr);
+	tmp = btrfs_find_tree_block(root->fs_info, blocknr);
 	if (tmp) {
 		/* first we do an atomic uptodate check */
 		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
@@ -3705,7 +3705,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	if (left_nritems)
 		btrfs_mark_buffer_dirty(left);
 	else
-		clean_tree_block(trans, root, left);
+		clean_tree_block(trans, root->fs_info, left);
 
 	btrfs_mark_buffer_dirty(right);
 
@@ -3717,7 +3717,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	if (path->slots[0] >= left_nritems) {
 		path->slots[0] -= left_nritems;
 		if (btrfs_header_nritems(path->nodes[0]) == 0)
-			clean_tree_block(trans, root, path->nodes[0]);
+			clean_tree_block(trans, root->fs_info, path->nodes[0]);
 		btrfs_tree_unlock(path->nodes[0]);
 		free_extent_buffer(path->nodes[0]);
 		path->nodes[0] = right;
@@ -3941,7 +3941,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	if (right_nritems)
 		btrfs_mark_buffer_dirty(right);
 	else
-		clean_tree_block(trans, root, right);
+		clean_tree_block(trans, root->fs_info, right);
 
 	btrfs_item_key(right, &disk_key, 0);
 	fixup_low_keys(root, path, &disk_key, 1);
@@ -4992,7 +4992,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			btrfs_set_header_level(leaf, 0);
 		} else {
 			btrfs_set_path_blocking(path);
-			clean_tree_block(trans, root, leaf);
+			clean_tree_block(trans, root->fs_info, leaf);
 			btrfs_del_leaf(trans, root, path, leaf);
 		}
 	} else {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1bf9f89..8acc011 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -274,10 +274,11 @@ void btrfs_csum_final(u32 crc, char *result)
  * compute the csum for a btree block, and either verify it or write it
  * into the csum field of the block.
  */
-static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
+static int csum_tree_block(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *buf,
 			   int verify)
 {
-	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	char *result = NULL;
 	unsigned long len;
 	unsigned long cur_len;
@@ -321,7 +322,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			printk_ratelimited(KERN_INFO
 				"BTRFS: %s checksum verify failed on %llu wanted %X found %X "
 				"level %d\n",
-				root->fs_info->sb->s_id, buf->start,
+				fs_info->sb->s_id, buf->start,
 				val, found, btrfs_header_level(buf));
 			if (result != (char *)&inline_result)
 				kfree(result);
@@ -500,7 +501,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
  * we only fill in the checksum field in the first page of a multi-page block
  */
 
-static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
+static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 {
 	u64 start = page_offset(page);
 	u64 found_start;
@@ -512,14 +513,14 @@ static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 	found_start = btrfs_header_bytenr(eb);
 	if (WARN_ON(found_start != start || !PageUptodate(page)))
 		return 0;
-	csum_tree_block(root, eb, 0);
+	csum_tree_block(fs_info, eb, 0);
 	return 0;
 }
 
-static int check_tree_block_fsid(struct btrfs_root *root,
+static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb)
 {
-	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u8 fsid[BTRFS_UUID_SIZE];
 	int ret = 1;
 
@@ -639,7 +640,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		ret = -EIO;
 		goto err;
 	}
-	if (check_tree_block_fsid(root, eb)) {
+	if (check_tree_block_fsid(root->fs_info, eb)) {
 		printk_ratelimited(KERN_INFO "BTRFS (device %s): bad fsid on block %llu\n",
 			       eb->fs_info->sb->s_id, eb->start);
 		ret = -EIO;
@@ -656,7 +657,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb),
 				       eb, found_level);
 
-	ret = csum_tree_block(root, eb, 1);
+	ret = csum_tree_block(root->fs_info, eb, 1);
 	if (ret) {
 		ret = -EIO;
 		goto err;
@@ -881,7 +882,7 @@ static int btree_csum_one_bio(struct bio *bio)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
-		ret = csum_dirty_buffer(root, bvec->bv_page);
+		ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
 		if (ret)
 			break;
 	}
@@ -1118,10 +1119,10 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	return 0;
 }
 
-struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
+struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 					    u64 bytenr)
 {
-	return find_extent_buffer(root->fs_info, bytenr);
+	return find_extent_buffer(fs_info, bytenr);
 }
 
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
@@ -1165,11 +1166,10 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 
 }
 
-void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+void clean_tree_block(struct btrfs_trans_handle *trans,
+		      struct btrfs_fs_info *fs_info,
 		      struct extent_buffer *buf)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
-
 	if (btrfs_header_generation(buf) ==
 	    fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
@@ -4073,7 +4073,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 
 		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
 		while (start <= end) {
-			eb = btrfs_find_tree_block(root, start);
+			eb = btrfs_find_tree_block(root->fs_info, start);
 			start += root->nodesize;
 			if (!eb)
 				continue;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 4146518..8019227 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -52,7 +52,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						   u64 bytenr, u32 blocksize);
 void clean_tree_block(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, struct extent_buffer *buf);
+		      struct btrfs_fs_info *fs_info, struct extent_buffer *buf);
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
@@ -61,7 +61,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_commit_super(struct btrfs_root *root);
-struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
+struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 					    u64 bytenr);
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 				      struct btrfs_key *location);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 47c1ba1..a75c35d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7213,7 +7213,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_header_generation(buf, trans->transid);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
-	clean_tree_block(trans, root, buf);
+	clean_tree_block(trans, root->fs_info, buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
 
 	btrfs_set_lock_blocking(buf);
@@ -7812,7 +7812,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
 	blocksize = root->nodesize;
 
-	next = btrfs_find_tree_block(root, bytenr);
+	next = btrfs_find_tree_block(root->fs_info, bytenr);
 	if (!next) {
 		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 		if (!next)
@@ -8013,7 +8013,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			btrfs_set_lock_blocking(eb);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 		}
-		clean_tree_block(trans, root, eb);
+		clean_tree_block(trans, root->fs_info, eb);
 	}
 
 	if (eb == root->node) {
-- 
2.1.0

