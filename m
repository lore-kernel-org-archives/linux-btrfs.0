Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48603 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945951Ab3FUUif (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 16:38:35 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8AB5A7C035B
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 14:38:35 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id QKxX9tFC9lEW3u4e (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 14:38:34 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check if we can nocow if we don't have data space
Date: Fri, 21 Jun 2013 16:38:32 -0400
Message-ID: <1371847112-22111-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We always just try and reserve data space when we write, but if we are out of
space but have prealloc'ed extents we should still successfully write.  This
patch will try and see if we can write to prealloc'ed space and if we can go
ahead and allow the write to continue.  With this patch we now pass xfstests
generic/274.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h       |    4 ++
 fs/btrfs/extent-tree.c |    1 +
 fs/btrfs/extent_io.c   |    3 +
 fs/btrfs/extent_io.h   |    1 +
 fs/btrfs/file.c        |  125 +++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/inode.c       |   40 ++++++++++------
 6 files changed, 148 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b528a55..e795bf1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3552,6 +3552,10 @@ void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work);
 struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
 					   size_t pg_offset, u64 start, u64 len,
 					   int create);
+noinline int can_nocow_extent(struct btrfs_trans_handle *trans,
+			      struct inode *inode, u64 offset, u64 *len,
+			      u64 *orig_start, u64 *orig_block_len,
+			      u64 *ram_bytes);
 
 /* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
 #if defined(ClearPageFsMisc) && !defined(ClearPageChecked)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5154b91..11ba82e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3666,6 +3666,7 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 
 	data_sinfo = root->fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
+	WARN_ON(data_sinfo->bytes_may_use < bytes);
 	data_sinfo->bytes_may_use -= bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
 				      data_sinfo->flags, bytes, 0);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a83d701..f8586a9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -543,6 +543,9 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
 
+	if (bits & EXTENT_DELALLOC)
+		bits |= EXTENT_NORESERVE;
+
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
 	bits |= EXTENT_FIRST_DELALLOC;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 41fb81e..3b8c4e2 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -19,6 +19,7 @@
 #define EXTENT_FIRST_DELALLOC (1 << 12)
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
+#define EXTENT_NORESERVE (1 << 15)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5ffde56..2d70849 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1312,6 +1312,56 @@ fail:
 
 }
 
+static noinline int check_can_nocow(struct inode *inode, loff_t pos,
+				    size_t *write_bytes)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_ordered_extent *ordered;
+	u64 lockstart, lockend;
+	u64 num_bytes;
+	int ret;
+
+	lockstart = round_down(pos, root->sectorsize);
+	lockend = lockstart + round_up(*write_bytes, root->sectorsize) - 1;
+
+	while (1) {
+		lock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
+		ordered = btrfs_lookup_ordered_range(inode, lockstart,
+						     lockend - lockstart + 1);
+		if (!ordered) {
+			break;
+		}
+		unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
+		btrfs_start_ordered_extent(inode, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+	}
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
+		return PTR_ERR(trans);
+	}
+
+	num_bytes = lockend - lockstart + 1;
+	ret = can_nocow_extent(trans, inode, lockstart, &num_bytes, NULL, NULL,
+			       NULL);
+	btrfs_end_transaction(trans, root);
+	if (ret <= 0) {
+		ret = 0;
+	} else {
+		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+				 EXTENT_DIRTY | EXTENT_DELALLOC |
+				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
+				 NULL, GFP_NOFS);
+		*write_bytes = min_t(size_t, *write_bytes, num_bytes);
+	}
+
+	unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
+
+	return ret;
+}
+
 static noinline ssize_t __btrfs_buffered_write(struct file *file,
 					       struct iov_iter *i,
 					       loff_t pos)
@@ -1319,10 +1369,12 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page **pages = NULL;
+	u64 release_bytes = 0;
 	unsigned long first_index;
 	size_t num_written = 0;
 	int nrptrs;
 	int ret = 0;
+	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
 
 	nrptrs = min((iov_iter_count(i) + PAGE_CACHE_SIZE - 1) /
@@ -1343,6 +1395,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 					 offset);
 		size_t num_pages = (write_bytes + offset +
 				    PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		size_t reserve_bytes;
 		size_t dirty_pages;
 		size_t copied;
 
@@ -1357,11 +1410,41 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			break;
 		}
 
-		ret = btrfs_delalloc_reserve_space(inode,
-					num_pages << PAGE_CACHE_SHIFT);
+		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+		ret = btrfs_check_data_free_space(inode, reserve_bytes);
+		if (ret == -ENOSPC &&
+		    (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+					      BTRFS_INODE_PREALLOC))) {
+			ret = check_can_nocow(inode, pos, &write_bytes);
+			if (ret > 0) {
+				only_release_metadata = true;
+				/*
+				 * our prealloc extent may be smaller than
+				 * write_bytes, so scale down.
+				 */
+				num_pages = (write_bytes + offset +
+					     PAGE_CACHE_SIZE - 1) >>
+					PAGE_CACHE_SHIFT;
+				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+				ret = 0;
+			} else {
+				ret = -ENOSPC;
+			}
+		}
+
 		if (ret)
 			break;
 
+		ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes);
+		if (ret) {
+			if (!only_release_metadata)
+				btrfs_free_reserved_data_space(inode,
+							       reserve_bytes);
+			break;
+		}
+
+		release_bytes = reserve_bytes;
+
 		/*
 		 * This is going to setup the pages array with the number of
 		 * pages we want, so we don't really need to worry about the
@@ -1370,11 +1453,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		ret = prepare_pages(root, file, pages, num_pages,
 				    pos, first_index, write_bytes,
 				    force_page_uptodate);
-		if (ret) {
-			btrfs_delalloc_release_space(inode,
-					num_pages << PAGE_CACHE_SHIFT);
+		if (ret)
 			break;
-		}
 
 		copied = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, i);
@@ -1404,30 +1484,46 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		 * managed to copy.
 		 */
 		if (num_pages > dirty_pages) {
+			release_bytes = (num_pages - dirty_pages) <<
+				PAGE_CACHE_SHIFT;
 			if (copied > 0) {
 				spin_lock(&BTRFS_I(inode)->lock);
 				BTRFS_I(inode)->outstanding_extents++;
 				spin_unlock(&BTRFS_I(inode)->lock);
 			}
-			btrfs_delalloc_release_space(inode,
-					(num_pages - dirty_pages) <<
-					PAGE_CACHE_SHIFT);
+			if (only_release_metadata)
+				btrfs_delalloc_release_metadata(inode,
+								release_bytes);
+			else
+				btrfs_delalloc_release_space(inode,
+							     release_bytes);
 		}
 
+		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
 		if (copied > 0) {
 			ret = btrfs_dirty_pages(root, inode, pages,
 						dirty_pages, pos, copied,
 						NULL);
 			if (ret) {
-				btrfs_delalloc_release_space(inode,
-					dirty_pages << PAGE_CACHE_SHIFT);
 				btrfs_drop_pages(pages, num_pages);
 				break;
 			}
 		}
 
+		release_bytes = 0;
 		btrfs_drop_pages(pages, num_pages);
 
+		if (only_release_metadata && copied > 0) {
+			u64 lockstart = round_down(pos, root->sectorsize);
+			u64 lockend = lockstart +
+				(dirty_pages << PAGE_CACHE_SHIFT) - 1;
+
+			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				       lockend, EXTENT_NORESERVE, NULL,
+				       NULL, GFP_NOFS);
+			only_release_metadata = false;
+		}
+
 		cond_resched();
 
 		balance_dirty_pages_ratelimited(inode->i_mapping);
@@ -1440,6 +1536,13 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	kfree(pages);
 
+	if (release_bytes) {
+		if (only_release_metadata)
+			btrfs_delalloc_release_metadata(inode, release_bytes);
+		else
+			btrfs_delalloc_release_space(inode, release_bytes);
+	}
+
 	return num_written ? num_written : ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7b9144c..53c616f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1641,7 +1641,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 			btrfs_delalloc_release_metadata(inode, len);
 
 		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
-		    && do_list)
+		    && do_list && !(state->state & EXTENT_NORESERVE))
 			btrfs_free_reserved_data_space(inode, len);
 
 		__percpu_counter_add(&root->fs_info->delalloc_bytes, -len,
@@ -6421,10 +6421,10 @@ out:
  * returns 1 when the nocow is safe, < 1 on error, 0 if the
  * block must be cow'd
  */
-static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
-				      struct inode *inode, u64 offset, u64 *len,
-				      u64 *orig_start, u64 *orig_block_len,
-				      u64 *ram_bytes)
+noinline int can_nocow_extent(struct btrfs_trans_handle *trans,
+			      struct inode *inode, u64 offset, u64 *len,
+			      u64 *orig_start, u64 *orig_block_len,
+			      u64 *ram_bytes)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -6438,7 +6438,7 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	u64 num_bytes;
 	int slot;
 	int found_type;
-
+	bool nocow = (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW);
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -6478,18 +6478,28 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 		/* not a regular extent, must cow */
 		goto out;
 	}
+
+	if (!nocow && found_type == BTRFS_FILE_EXTENT_REG)
+		goto out;
+
 	disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+	if (disk_bytenr == 0)
+		goto out;
+
+	if (btrfs_file_extent_compression(leaf, fi) ||
+	    btrfs_file_extent_encryption(leaf, fi) ||
+	    btrfs_file_extent_other_encoding(leaf, fi))
+		goto out;
+
 	backref_offset = btrfs_file_extent_offset(leaf, fi);
 
-	*orig_start = key.offset - backref_offset;
-	*orig_block_len = btrfs_file_extent_disk_num_bytes(leaf, fi);
-	*ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+	if (orig_start) {
+		*orig_start = key.offset - backref_offset;
+		*orig_block_len = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		*ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+	}
 
 	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
-	if (extent_end < offset + *len) {
-		/* extent doesn't include our full range, must cow */
-		goto out;
-	}
 
 	if (btrfs_extent_readonly(root, disk_bytenr))
 		goto out;
@@ -6733,8 +6743,8 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		if (IS_ERR(trans))
 			goto must_cow;
 
-		if (can_nocow_odirect(trans, inode, start, &len, &orig_start,
-				      &orig_block_len, &ram_bytes) == 1) {
+		if (can_nocow_extent(trans, inode, start, &len, &orig_start,
+				     &orig_block_len, &ram_bytes) == 1) {
 			if (type == BTRFS_ORDERED_PREALLOC) {
 				free_extent_map(em);
 				em = create_pinned_em(inode, start, len,
-- 
1.7.7.6

