Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752827AbdDDOLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Apr 2017 10:11:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id BACDF20121
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Apr 2017 14:11:18 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CD2720120
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Apr 2017 14:11:16 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix reported number of inode blocks
Date: Tue,  4 Apr 2017 03:22:22 +0100
Message-Id: <1491272542-1434-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Currently when there are buffered writes that were not yet flushed and
they fall within allocated ranges of the file (that is, not in holes or
beyond eof assuming there are no prealloc extents beyond eof), btrfs
simply reports an incorrect number of used blocks through the stat(2)
system call (or any of its variants), regardless of mount options or
inode flags (compress, compress-force, nodatacow). This is because the
number of blocks used that is reported is based on the current number
of bytes in the vfs inode plus the number of dealloc bytes in the btrfs
inode. The later covers bytes that both fall within allocated regions
of the file and holes.

Example scenarios where the number of reported blocks is wrong while the
buffered writes are not flushed:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ xfs_io -f -c "pwrite -S 0xaa 0 64K" /mnt/sdc/foo1
  wrote 65536/65536 bytes at offset 0
  64 KiB, 16 ops; 0.0000 sec (259.336 MiB/sec and 66390.0415 ops/sec)

  $ sync

  $ xfs_io -c "pwrite -S 0xbb 0 64K" /mnt/sdc/foo1
  wrote 65536/65536 bytes at offset 0
  64 KiB, 16 ops; 0.0000 sec (192.308 MiB/sec and 49230.7692 ops/sec)

  # The following should have reported 64K...
  $ du -h /mnt/sdc/foo1
  128K	/mnt/sdc/foo1

  $ sync

  # After flushing the buffered write, it now reports the correct value.
  $ du -h /mnt/sdc/foo1
  64K	/mnt/sdc/foo1

  $ xfs_io -f -c "falloc -k 0 128K" -c "pwrite -S 0xaa 0 64K" /mnt/sdc/foo2
  wrote 65536/65536 bytes at offset 0
  64 KiB, 16 ops; 0.0000 sec (520.833 MiB/sec and 133333.3333 ops/sec)

  $ sync

  $ xfs_io -c "pwrite -S 0xbb 64K 64K" /mnt/sdc/foo2
  wrote 65536/65536 bytes at offset 65536
  64 KiB, 16 ops; 0.0000 sec (260.417 MiB/sec and 66666.6667 ops/sec)

  # The following should have reported 128K...
  $ du -h /mnt/sdc/foo2
  192K	/mnt/sdc/foo2

  $ sync

  # After flushing the buffered write, it now reports the correct value.
  $ du -h /mnt/sdc/foo2
  128K	/mnt/sdc/foo2

So the number of used file blocks is simply incorrect, unlike in other
filesystems such as ext4 and xfs for example, but only while the buffered
writes are not flushed.

Fix this by tracking the number of delalloc bytes that fall within holes
and beyond eof of a file, and use instead this new counter when reporting
the number of used blocks for an inode.

Another different problem that exists is that the delalloc bytes counter
is reset when writeback starts (by clearing the EXTENT_DEALLOC flag from
the respective range in the inode's iotree) and the vfs inode's bytes
counter is only incremented when writeback finishes (through
insert_reserved_file_extent()). Therefore while writeback is ongoing we
simply report a wrong number of blocks used by an inode if the write
operation covers a range previously unallocated. While this change does
not fix this problem, it does minimizes it a lot by shortening that time
window, as the new dealloc bytes counter (new_delalloc_bytes) is only
decremented when writeback finishes right before updating the vfs inode's
bytes counter. Fully fixing this second problem is not trivial and will
be addressed later by a different patch.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

This applies on top of the following patches:

  btrfs: Fix metadata underflow caused by btrfs_reloc_clone_csum error
  btrfs: Handle delalloc error correctly to avoid ordered extent hang
  Btrfs: fix invalid attempt to free reserved space on failure to cow range
  Btrfs: fix incorrect space accounting after failure to insert inline extent

All in my integration-4.12 branch:

https://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git/log/?h=integration-4.12


 fs/btrfs/btrfs_inode.h |  7 ++++
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/file.c        | 95 +++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/inode.c       | 53 ++++++++++++++++++++++++----
 4 files changed, 125 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0c6baab..b8622e4 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -125,6 +125,13 @@ struct btrfs_inode {
 	u64 delalloc_bytes;
 
 	/*
+	 * Total number of bytes pending delalloc that fall within a file
+	 * range that is either a hole or beyond EOF (and no prealloc extent
+	 * exists in the range). This is always <= delalloc_bytes.
+	 */
+	u64 new_delalloc_bytes;
+
+	/*
 	 * total number of bytes pending defrag, used by stat to check whether
 	 * it needs COW.
 	 */
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 48a30d0..d5ff51b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -21,6 +21,7 @@
 #define EXTENT_NORESERVE	(1U << 15)
 #define EXTENT_QGROUP_RESERVED	(1U << 16)
 #define EXTENT_CLEAR_DATA_RESV	(1U << 17)
+#define EXTENT_DELALLOC_NEW	(1U << 18)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_DO_ACCOUNTING    (EXTENT_CLEAR_META_RESV | \
 				 EXTENT_CLEAR_DATA_RESV)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 56304c4..e8ec520 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1404,15 +1404,53 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 
 }
 
+static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
+					 const u64 start,
+					 const u64 len,
+					 struct extent_state **cached_state)
+{
+	u64 search_start = start;
+	const u64 end = start + len - 1;
+
+	while (search_start < end) {
+		const u64 search_len = end - search_start + 1;
+		struct extent_map *em;
+		u64 em_len;
+		int ret = 0;
+
+		em = btrfs_get_extent(inode, NULL, 0, search_start,
+				      search_len, 0);
+		if (IS_ERR(em))
+			return PTR_ERR(em);
+
+		if (em->block_start != EXTENT_MAP_HOLE)
+			goto next;
+
+		em_len = em->len;
+		if (em->start < search_start)
+			em_len -= search_start - em->start;
+		if (em_len > search_len)
+			em_len = search_len;
+
+		ret = set_extent_bit(&inode->io_tree, search_start,
+				     search_start + em_len - 1,
+				     EXTENT_DELALLOC_NEW,
+				     NULL, cached_state, GFP_NOFS);
+next:
+		search_start = extent_map_end(em);
+		free_extent_map(em);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 /*
  * This function locks the extent and properly waits for data=ordered extents
  * to finish before allowing the pages to be modified if need.
  *
- * The return value:
- * 1 - the extent is locked
- * 0 - the extent is not locked, and everything is OK
- * -EAGAIN - need re-prepare the pages
- * the other < 0 number - Something wrong happens
+ * Returns 0 on success and negative error otherwise. If -EAGAIN is returned,
+ * the caller needs to prepare the pages again.
  */
 static noinline int
 lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
@@ -1426,16 +1464,18 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 	u64 last_pos;
 	int i;
 	int ret = 0;
+	u64 isize = i_size_read(&inode->vfs_inode);
 
 	start_pos = round_down(pos, fs_info->sectorsize);
 	last_pos = start_pos
 		+ round_up(pos + write_bytes - start_pos,
 			   fs_info->sectorsize) - 1;
 
-	if (start_pos < inode->vfs_inode.i_size) {
+	lock_extent_bits(&inode->io_tree, start_pos, last_pos, cached_state);
+
+	if (start_pos < isize) {
 		struct btrfs_ordered_extent *ordered;
-		lock_extent_bits(&inode->io_tree, start_pos, last_pos,
-				cached_state);
+
 		ordered = btrfs_lookup_ordered_range(inode, start_pos,
 						     last_pos - start_pos + 1);
 		if (ordered &&
@@ -1454,16 +1494,26 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		}
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
+	}
 
+	ret = btrfs_find_new_delalloc_bytes(inode, start_pos,
+					    last_pos - start_pos + 1,
+					    cached_state);
+	if (ret) {
 		clear_extent_bit(&inode->io_tree, start_pos,
-				  last_pos, EXTENT_DIRTY | EXTENT_DELALLOC |
-				  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-				  0, 0, cached_state, GFP_NOFS);
-		*lockstart = start_pos;
-		*lockend = last_pos;
-		ret = 1;
+				 last_pos, EXTENT_DIRTY | EXTENT_DELALLOC |
+				 EXTENT_DELALLOC_NEW | EXTENT_DO_ACCOUNTING |
+				 EXTENT_DEFRAG | EXTENT_LOCKED,
+				 1, 0, cached_state, GFP_NOFS);
+		return ret;
 	}
 
+	if (start_pos < isize)
+		clear_extent_bit(&inode->io_tree, start_pos,
+				 last_pos, EXTENT_DIRTY | EXTENT_DELALLOC |
+				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
+				 0, 0, cached_state, GFP_NOFS);
+
 	for (i = 0; i < num_pages; i++) {
 		if (clear_page_dirty_for_io(pages[i]))
 			account_page_redirty(pages[i]);
@@ -1471,7 +1521,10 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		WARN_ON(!PageLocked(pages[i]));
 	}
 
-	return ret;
+	*lockstart = start_pos;
+	*lockend = last_pos;
+
+	return 0;
 }
 
 static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
@@ -1537,7 +1590,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	int ret = 0;
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
-	bool need_unlock;
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1613,7 +1665,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		release_bytes = reserve_bytes;
-		need_unlock = false;
 again:
 		/*
 		 * This is going to setup the pages array with the number of
@@ -1633,9 +1684,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			if (ret == -EAGAIN)
 				goto again;
 			break;
-		} else if (ret > 0) {
-			need_unlock = true;
-			ret = 0;
 		}
 
 		copied = btrfs_copy_from_user(pos, write_bytes, pages, i);
@@ -1699,10 +1747,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		if (copied > 0)
 			ret = btrfs_dirty_pages(inode, pages, dirty_pages,
 						pos, copied, NULL);
-		if (need_unlock)
-			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     lockstart, lockend, &cached_state,
-					     GFP_NOFS);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+				     lockstart, lockend, &cached_state,
+				     GFP_NOFS);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
 			break;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7058ae4..aa33783 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -572,7 +572,7 @@ static noinline void compress_file_range(struct inode *inode,
 		}
 		if (ret <= 0) {
 			unsigned long clear_flags = EXTENT_DELALLOC |
-				EXTENT_DEFRAG;
+				EXTENT_DELALLOC_NEW | EXTENT_DEFRAG;
 			unsigned long page_error_op;
 
 			clear_flags |= (ret < 0) ? EXTENT_DO_ACCOUNTING : 0;
@@ -879,6 +879,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 				     async_extent->start +
 				     async_extent->ram_size - 1,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
+				     EXTENT_DELALLOC_NEW |
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
@@ -974,6 +975,7 @@ static noinline int cow_file_range(struct inode *inode,
 			extent_clear_unlock_delalloc(inode, start, end,
 				     delalloc_end, NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
+				     EXTENT_DELALLOC_NEW |
 				     EXTENT_DEFRAG, PAGE_UNLOCK |
 				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
 				     PAGE_END_WRITEBACK);
@@ -1086,8 +1088,8 @@ static noinline int cow_file_range(struct inode *inode,
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
 out_unlock:
-	clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DEFRAG |
-		EXTENT_CLEAR_META_RESV;
+	clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+		EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV;
 	page_ops = PAGE_UNLOCK | PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
 		PAGE_END_WRITEBACK;
 	/*
@@ -1775,6 +1777,14 @@ static void btrfs_set_bit_hook(struct inode *inode,
 			btrfs_add_delalloc_inodes(root, inode);
 		spin_unlock(&BTRFS_I(inode)->lock);
 	}
+
+	if (!(state->state & EXTENT_DELALLOC_NEW) &&
+	    (*bits & EXTENT_DELALLOC_NEW)) {
+		spin_lock(&BTRFS_I(inode)->lock);
+		BTRFS_I(inode)->new_delalloc_bytes += state->end + 1 -
+			state->start;
+		spin_unlock(&BTRFS_I(inode)->lock);
+	}
 }
 
 /*
@@ -1840,6 +1850,14 @@ static void btrfs_clear_bit_hook(struct btrfs_inode *inode,
 			btrfs_del_delalloc_inode(root, inode);
 		spin_unlock(&inode->lock);
 	}
+
+	if ((state->state & EXTENT_DELALLOC_NEW) &&
+	    (*bits & EXTENT_DELALLOC_NEW)) {
+		spin_lock(&inode->lock);
+		ASSERT(inode->new_delalloc_bytes >= len);
+		inode->new_delalloc_bytes -= len;
+		spin_unlock(&inode->lock);
+	}
 }
 
 /*
@@ -2967,10 +2985,17 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						logical_len, logical_len,
 						compress_type, 0, 0,
 						BTRFS_FILE_EXTENT_REG);
-		if (!ret)
+		if (!ret) {
+			clear_extent_bit(&BTRFS_I(inode)->io_tree,
+					 ordered_extent->file_offset,
+					 ordered_extent->file_offset +
+					 ordered_extent->len - 1,
+					 EXTENT_DELALLOC_NEW, 0, 0,
+					 &cached_state, GFP_NOFS);
 			btrfs_release_delalloc_bytes(fs_info,
 						     ordered_extent->start,
 						     ordered_extent->disk_len);
+		}
 	}
 	unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
 			   ordered_extent->file_offset, ordered_extent->len,
@@ -2994,6 +3019,17 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			     ordered_extent->file_offset +
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
+	if (ret &&
+	    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
+	    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
+	    !test_bit(BTRFS_ORDERED_DIRECT, &ordered_extent->flags))
+		clear_extent_bit(&BTRFS_I(inode)->io_tree,
+				 ordered_extent->file_offset,
+				 ordered_extent->file_offset +
+				 ordered_extent->len - 1,
+				 EXTENT_DELALLOC_NEW, 0, 0,
+				 &cached_state, GFP_NOFS);
+
 	if (root != fs_info->tree_root)
 		btrfs_delalloc_release_metadata(BTRFS_I(inode),
 				ordered_extent->len);
@@ -8894,6 +8930,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 		if (!inode_evicting)
 			clear_extent_bit(tree, start, end,
 					 EXTENT_DIRTY | EXTENT_DELALLOC |
+					 EXTENT_DELALLOC_NEW |
 					 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 					 EXTENT_DEFRAG, 1, 0, &cached_state,
 					 GFP_NOFS);
@@ -8951,8 +8988,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
-				 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
-				 EXTENT_DEFRAG, 1, 1,
+				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1, 1,
 				 &cached_state, GFP_NOFS);
 
 		__btrfs_releasepage(page, GFP_NOFS);
@@ -9323,6 +9360,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
 	ei->delalloc_bytes = 0;
+	ei->new_delalloc_bytes = 0;
 	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
 	ei->flags = 0;
@@ -9388,6 +9426,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	WARN_ON(BTRFS_I(inode)->outstanding_extents);
 	WARN_ON(BTRFS_I(inode)->reserved_extents);
 	WARN_ON(BTRFS_I(inode)->delalloc_bytes);
+	WARN_ON(BTRFS_I(inode)->new_delalloc_bytes);
 	WARN_ON(BTRFS_I(inode)->csum_bytes);
 	WARN_ON(BTRFS_I(inode)->defrag_bytes);
 
@@ -9511,7 +9550,7 @@ static int btrfs_getattr(struct vfsmount *mnt,
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	delalloc_bytes = BTRFS_I(inode)->delalloc_bytes;
+	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
 	stat->blocks = (ALIGN(inode_get_bytes(inode), blocksize) +
 			ALIGN(delalloc_bytes, blocksize)) >> 9;
-- 
2.7.0.rc3

