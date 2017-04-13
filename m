Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754914AbdDMP1p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 11:27:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 7772C2038E
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2017 15:27:42 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C494C20376
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2017 15:27:39 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix reported number of inode blocks
Date: Thu, 13 Apr 2017 16:27:36 +0100
Message-Id: <20170413152736.27616-1-fdmanana@kernel.org>
In-Reply-To: <1491272542-1434-1-git-send-email-fdmanana@kernel.org>
References: <1491272542-1434-1-git-send-email-fdmanana@kernel.org>
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

V2: Fixed a performance regression for write append worloads, reported
    at lkml by the intel test robots (fs_mark test).

 fs/btrfs/btrfs_inode.h |  7 ++++++
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/file.c        | 62 ++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/inode.c       | 67 ++++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 119 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0c6baaba0651..b8622e4d1744 100644
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
index 48a30d0e71fb..d5ff51b973a4 100644
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
index 56304c400db5..f7d022bc7998 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1404,6 +1404,47 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 
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
@@ -1432,8 +1473,11 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		+ round_up(pos + write_bytes - start_pos,
 			   fs_info->sectorsize) - 1;
 
-	if (start_pos < inode->vfs_inode.i_size) {
+	if (start_pos < inode->vfs_inode.i_size ||
+	    (inode->flags & BTRFS_INODE_PREALLOC)) {
 		struct btrfs_ordered_extent *ordered;
+		unsigned int clear_bits;
+
 		lock_extent_bits(&inode->io_tree, start_pos, last_pos,
 				cached_state);
 		ordered = btrfs_lookup_ordered_range(inode, start_pos,
@@ -1454,11 +1498,19 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		}
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
-
+		ret = btrfs_find_new_delalloc_bytes(inode, start_pos,
+						    last_pos - start_pos + 1,
+						    cached_state);
+		clear_bits = EXTENT_DIRTY | EXTENT_DELALLOC |
+			EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG;
+		if (ret)
+			clear_bits |= EXTENT_DELALLOC_NEW | EXTENT_LOCKED;
 		clear_extent_bit(&inode->io_tree, start_pos,
-				  last_pos, EXTENT_DIRTY | EXTENT_DELALLOC |
-				  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-				  0, 0, cached_state, GFP_NOFS);
+				 last_pos, clear_bits,
+				 (clear_bits & EXTENT_LOCKED) ? 1 : 0,
+				 0, cached_state, GFP_NOFS);
+		if (ret)
+			return ret;
 		*lockstart = start_pos;
 		*lockend = last_pos;
 		ret = 1;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7058ae4e87a7..ce2d2cd9e505 100644
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
@@ -2872,6 +2890,13 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	u64 logical_len = ordered_extent->len;
 	bool nolock;
 	bool truncated = false;
+	bool range_locked = false;
+	bool clear_new_delalloc_bytes = false;
+
+	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
+	    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
+	    !test_bit(BTRFS_ORDERED_DIRECT, &ordered_extent->flags))
+		clear_new_delalloc_bytes = true;
 
 	nolock = btrfs_is_free_space_inode(BTRFS_I(inode));
 
@@ -2920,6 +2945,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
+	range_locked = true;
 	lock_extent_bits(io_tree, ordered_extent->file_offset,
 			 ordered_extent->file_offset + ordered_extent->len - 1,
 			 &cached_state);
@@ -2945,7 +2971,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		trans = NULL;
-		goto out_unlock;
+		goto out;
 	}
 
 	trans->block_rsv = &fs_info->delalloc_block_rsv;
@@ -2977,7 +3003,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			   trans->transid);
 	if (ret < 0) {
 		btrfs_abort_transaction(trans, ret);
-		goto out_unlock;
+		goto out;
 	}
 
 	add_pending_csums(trans, inode, &ordered_extent->list);
@@ -2986,14 +3012,26 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	ret = btrfs_update_inode_fallback(trans, root, inode);
 	if (ret) { /* -ENOMEM or corruption */
 		btrfs_abort_transaction(trans, ret);
-		goto out_unlock;
+		goto out;
 	}
 	ret = 0;
-out_unlock:
-	unlock_extent_cached(io_tree, ordered_extent->file_offset,
-			     ordered_extent->file_offset +
-			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
+	if (range_locked || clear_new_delalloc_bytes) {
+		unsigned int clear_bits = 0;
+
+		if (range_locked)
+			clear_bits |= EXTENT_LOCKED;
+		if (clear_new_delalloc_bytes)
+			clear_bits |= EXTENT_DELALLOC_NEW;
+		clear_extent_bit(&BTRFS_I(inode)->io_tree,
+				 ordered_extent->file_offset,
+				 ordered_extent->file_offset +
+				 ordered_extent->len - 1,
+				 clear_bits,
+				 (clear_bits & EXTENT_LOCKED) ? 1 : 0,
+				 0, &cached_state, GFP_NOFS);
+	}
+
 	if (root != fs_info->tree_root)
 		btrfs_delalloc_release_metadata(BTRFS_I(inode),
 				ordered_extent->len);
@@ -8894,6 +8932,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 		if (!inode_evicting)
 			clear_extent_bit(tree, start, end,
 					 EXTENT_DIRTY | EXTENT_DELALLOC |
+					 EXTENT_DELALLOC_NEW |
 					 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 					 EXTENT_DEFRAG, 1, 0, &cached_state,
 					 GFP_NOFS);
@@ -8951,8 +8990,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
-				 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
-				 EXTENT_DEFRAG, 1, 1,
+				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1, 1,
 				 &cached_state, GFP_NOFS);
 
 		__btrfs_releasepage(page, GFP_NOFS);
@@ -9323,6 +9362,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
 	ei->delalloc_bytes = 0;
+	ei->new_delalloc_bytes = 0;
 	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
 	ei->flags = 0;
@@ -9388,6 +9428,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	WARN_ON(BTRFS_I(inode)->outstanding_extents);
 	WARN_ON(BTRFS_I(inode)->reserved_extents);
 	WARN_ON(BTRFS_I(inode)->delalloc_bytes);
+	WARN_ON(BTRFS_I(inode)->new_delalloc_bytes);
 	WARN_ON(BTRFS_I(inode)->csum_bytes);
 	WARN_ON(BTRFS_I(inode)->defrag_bytes);
 
@@ -9511,7 +9552,7 @@ static int btrfs_getattr(struct vfsmount *mnt,
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	delalloc_bytes = BTRFS_I(inode)->delalloc_bytes;
+	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
 	stat->blocks = (ALIGN(inode_get_bytes(inode), blocksize) +
 			ALIGN(delalloc_bytes, blocksize)) >> 9;
-- 
2.11.0

