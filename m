Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753691AbdJaRtt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:49:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 84233AD9F
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:49:47 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: sink gfp parameter to clear_extent_bit
Date: Tue, 31 Oct 2017 18:47:58 +0100
Message-Id: <ec1ea1d817c0d05885fa572d9877ed3f4ad3c27b.1509471989.git.dsterba@suse.com>
In-Reply-To: <cover.1509471989.git.dsterba@suse.com>
References: <cover.1509471989.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers use GFP_NOFS, we don't have to pass it as an argument. The
built-in tests pass GFP_KERNEL, but they run only at module load time
and NOFS works there as well.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c         | 10 +++++-----
 fs/btrfs/extent_io.h         | 10 ++++------
 fs/btrfs/file.c              |  2 +-
 fs/btrfs/free-space-cache.c  |  8 +++-----
 fs/btrfs/inode.c             | 22 ++++++++++------------
 fs/btrfs/ioctl.c             |  2 +-
 fs/btrfs/qgroup.c            |  3 +--
 fs/btrfs/tests/inode-tests.c | 12 ++++--------
 fs/btrfs/transaction.c       |  3 +--
 9 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2d16c609c12f..2d5f820462f9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1294,10 +1294,10 @@ int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     unsigned bits, int wake, int delete,
-		     struct extent_state **cached, gfp_t mask)
+		     struct extent_state **cached)
 {
 	return __clear_extent_bit(tree, start, end, bits, wake, delete,
-				  cached, mask, NULL);
+				  cached, GFP_NOFS, NULL);
 }
 
 int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1347,7 +1347,7 @@ int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 	if (err == -EEXIST) {
 		if (failed_start > start)
 			clear_extent_bit(tree, start, failed_start - 1,
-					 EXTENT_LOCKED, 1, 0, NULL, GFP_NOFS);
+					 EXTENT_LOCKED, 1, 0, NULL);
 		return 0;
 	}
 	return 1;
@@ -1743,7 +1743,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 				 unsigned long page_ops)
 {
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, clear_bits, 1, 0,
-			 NULL, GFP_NOFS);
+			 NULL);
 
 	__process_pages_contig(inode->i_mapping, locked_page,
 			       start >> PAGE_SHIFT, end >> PAGE_SHIFT,
@@ -4219,7 +4219,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 	clear_extent_bit(tree, start, end,
 			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
 			 EXTENT_DO_ACCOUNTING,
-			 1, 1, &cached_state, GFP_NOFS);
+			 1, 1, &cached_state);
 	return 0;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 09923d49b699..bc9ebc858fae 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -299,7 +299,7 @@ int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		unsigned bits, struct extent_changeset *changeset);
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     unsigned bits, int wake, int delete,
-		     struct extent_state **cached, gfp_t mask);
+		     struct extent_state **cached);
 int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     unsigned bits, int wake, int delete,
 		     struct extent_state **cached, gfp_t mask,
@@ -307,8 +307,7 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 static inline int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
-				GFP_NOFS);
+	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL);
 }
 
 static inline int unlock_extent_cached(struct extent_io_tree *tree, u64 start,
@@ -326,8 +325,7 @@ static inline int clear_extent_bits(struct extent_io_tree *tree, u64 start,
 	if (bits & EXTENT_LOCKED)
 		wake = 1;
 
-	return clear_extent_bit(tree, start, end, bits, wake, 0, NULL,
-			GFP_NOFS);
+	return clear_extent_bit(tree, start, end, bits, wake, 0, NULL);
 }
 
 int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
@@ -361,7 +359,7 @@ static inline int clear_extent_dirty(struct extent_io_tree *tree, u64 start,
 {
 	return clear_extent_bit(tree, start, end,
 				EXTENT_DIRTY | EXTENT_DELALLOC |
-				EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
+				EXTENT_DO_ACCOUNTING, 0, 0, NULL);
 }
 
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f80254d82f40..7881c5b821ff 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1508,7 +1508,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		clear_extent_bit(&inode->io_tree, start_pos,
 				 last_pos, clear_bits,
 				 (clear_bits & EXTENT_LOCKED) ? 1 : 0,
-				 0, cached_state, GFP_NOFS);
+				 0, cached_state);
 		if (ret)
 			return ret;
 		*lockstart = start_pos;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cdc9f4015ec3..3872db67fdc0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -993,8 +993,7 @@ update_cache_item(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret < 0) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, inode->i_size - 1,
-				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL,
-				 GFP_NOFS);
+				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL);
 		goto fail;
 	}
 	leaf = path->nodes[0];
@@ -1008,7 +1007,7 @@ update_cache_item(struct btrfs_trans_handle *trans,
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, 0,
 					 inode->i_size - 1,
 					 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0,
-					 NULL, GFP_NOFS);
+					 NULL);
 			btrfs_release_path(path);
 			goto fail;
 		}
@@ -1105,8 +1104,7 @@ static int flush_dirty_cache(struct inode *inode)
 	ret = btrfs_wait_ordered_range(inode, 0, (u64)-1);
 	if (ret)
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, inode->i_size - 1,
-				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL,
-				 GFP_NOFS);
+				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL);
 
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8525a44a607e..c6d2798b5f67 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1203,7 +1203,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	u64 cur_end;
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
-			 1, 0, NULL, GFP_NOFS);
+			 1, 0, NULL);
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		BUG_ON(!async_cow); /* -ENOMEM */
@@ -2985,7 +2985,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 
 		clear_extent_bit(io_tree, ordered_extent->file_offset,
 			ordered_extent->file_offset + ordered_extent->len - 1,
-			EXTENT_DEFRAG, 0, 0, &cached_state, GFP_NOFS);
+			EXTENT_DEFRAG, 0, 0, &cached_state);
 	}
 
 	if (nolock)
@@ -3053,7 +3053,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 				 ordered_extent->len - 1,
 				 clear_bits,
 				 (clear_bits & EXTENT_LOCKED) ? 1 : 0,
-				 0, &cached_state, GFP_NOFS);
+				 0, &cached_state);
 	}
 
 	if (trans)
@@ -4795,7 +4795,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, block_start, block_end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC |
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-			  0, 0, &cached_state, GFP_NOFS);
+			  0, 0, &cached_state);
 
 	ret = btrfs_set_extent_delalloc(inode, block_start, block_end,
 					&cached_state, 0);
@@ -5231,8 +5231,7 @@ static void evict_inode_truncate_pages(struct inode *inode)
 		clear_extent_bit(io_tree, start, end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
 				 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
-				 EXTENT_DEFRAG, 1, 1,
-				 &cached_state, GFP_NOFS);
+				 EXTENT_DEFRAG, 1, 1, &cached_state);
 
 		cond_resched();
 		spin_lock(&io_tree->lock);
@@ -7917,7 +7916,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	if (lockstart < lockend) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				 lockend, unlock_bits, 1, 0,
-				 &cached_state, GFP_NOFS);
+				 &cached_state);
 	} else {
 		free_extent_state(cached_state);
 	}
@@ -7928,7 +7927,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 
 unlock_err:
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-			 unlock_bits, 1, 0, &cached_state, GFP_NOFS);
+			 unlock_bits, 1, 0, &cached_state);
 err:
 	if (dio_data)
 		current->journal_info = dio_data;
@@ -8969,8 +8968,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 					 EXTENT_DIRTY | EXTENT_DELALLOC |
 					 EXTENT_DELALLOC_NEW |
 					 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
-					 EXTENT_DEFRAG, 1, 0, &cached_state,
-					 GFP_NOFS);
+					 EXTENT_DEFRAG, 1, 0, &cached_state);
 		/*
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
@@ -9027,7 +9025,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
 				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
 				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1, 1,
-				 &cached_state, GFP_NOFS);
+				 &cached_state);
 
 		__btrfs_releasepage(page, GFP_NOFS);
 	}
@@ -9155,7 +9153,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC |
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-			  0, 0, &cached_state, GFP_NOFS);
+			  0, 0, &cached_state);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, end,
 					&cached_state, 0);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd172a93d11a..c3ea92ea6968 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1190,7 +1190,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
 			  page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
-			  &cached_state, GFP_NOFS);
+			  &cached_state);
 
 	if (i_done != page_cnt) {
 		spin_lock(&BTRFS_I(inode)->lock);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 168fd03ca3ac..9e61dd624f7b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2883,8 +2883,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode,
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(&reserved->range_changed, &uiter)))
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
-				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL,
-				 GFP_NOFS);
+				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL);
 	extent_changeset_release(reserved);
 	return ret;
 }
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index f797642c013d..3406c0a84a06 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -1001,8 +1001,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 			       BTRFS_MAX_EXTENT_SIZE >> 1,
 			       (BTRFS_MAX_EXTENT_SIZE >> 1) + sectorsize - 1,
 			       EXTENT_DELALLOC | EXTENT_DIRTY |
-			       EXTENT_UPTODATE, 0, 0,
-			       NULL, GFP_KERNEL);
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_msg("clear_extent_bit returned %d\n", ret);
 		goto out;
@@ -1070,8 +1069,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 			       BTRFS_MAX_EXTENT_SIZE + sectorsize,
 			       BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1,
 			       EXTENT_DIRTY | EXTENT_DELALLOC |
-			       EXTENT_UPTODATE, 0, 0,
-			       NULL, GFP_KERNEL);
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_msg("clear_extent_bit returned %d\n", ret);
 		goto out;
@@ -1104,8 +1102,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	/* Empty */
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
 			       EXTENT_DIRTY | EXTENT_DELALLOC |
-			       EXTENT_UPTODATE, 0, 0,
-			       NULL, GFP_KERNEL);
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_msg("clear_extent_bit returned %d\n", ret);
 		goto out;
@@ -1121,8 +1118,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	if (ret)
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_UPTODATE, 0, 0,
-				 NULL, GFP_KERNEL);
+				 EXTENT_UPTODATE, 0, 0, NULL);
 	iput(inode);
 	btrfs_free_dummy_root(root);
 	btrfs_free_dummy_fs_info(fs_info);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5a8c2649af2f..dac688c696c3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1016,8 +1016,7 @@ static int __btrfs_wait_marked_extents(struct btrfs_fs_info *fs_info,
 		 * it's safe to do it (through clear_btree_io_tree()).
 		 */
 		err = clear_extent_bit(dirty_pages, start, end,
-				       EXTENT_NEED_WAIT,
-				       0, 0, &cached_state, GFP_NOFS);
+				       EXTENT_NEED_WAIT, 0, 0, &cached_state);
 		if (err == -ENOMEM)
 			err = 0;
 		if (!err)
-- 
2.14.0

