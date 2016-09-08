Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42718 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1756465AbcIHHNY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 03:13:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v13 01/15] btrfs: expand btrfs_set_extent_delalloc() and its friends to support in-band dedupe and subpage size patchset
Date: Thu,  8 Sep 2016 15:12:50 +0800
Message-Id: <20160908071304.25616-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
References: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extract btrfs_set_extent_delalloc() and extent_clear_unlock_delalloc()
parameters for both in-band dedupe and subpage sector size patchset.

This should reduce conflict of both patchset and the effort to rebase
them.

Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h             |  2 +-
 fs/btrfs/extent_io.c         |  2 +-
 fs/btrfs/extent_io.h         |  2 +-
 fs/btrfs/file.c              |  2 +-
 fs/btrfs/inode.c             | 40 ++++++++++++++++++++++++++--------------
 fs/btrfs/relocation.c        |  2 +-
 fs/btrfs/tests/inode-tests.c | 12 ++++++------
 7 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e590152..ec46519 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3121,7 +3121,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
 int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 			       int nr);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
-			      struct extent_state **cached_state);
+			      struct extent_state **cached_state, int dedupe);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *new_root,
 			     struct btrfs_root *parent_root,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 05bb391..0764e95 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1709,7 +1709,7 @@ out_failed:
 }
 
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 struct page *locked_page,
+				 u64 delalloc_end, struct page *locked_page,
 				 unsigned clear_bits,
 				 unsigned long page_ops)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index aa6341c..c6177a9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -431,7 +431,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 void extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
 void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 struct page *locked_page,
+				 u64 delalloc_end, struct page *locked_page,
 				 unsigned bits_to_clear,
 				 unsigned long page_ops);
 struct bio *
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6a9ada0..cbefdc8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -503,7 +503,7 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 
 	end_of_last_block = start_pos + num_bytes - 1;
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
-					cached);
+					cached, 0);
 	if (err)
 		return err;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 353e80e..85c5b30 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -560,8 +560,9 @@ cont:
 			 * we don't need to create any more async work items.
 			 * Unlock and free up our temp pages.
 			 */
-			extent_clear_unlock_delalloc(inode, start, end, NULL,
-						     clear_flags, PAGE_UNLOCK |
+			extent_clear_unlock_delalloc(inode, start, end, end,
+						     NULL, clear_flags,
+						     PAGE_UNLOCK |
 						     PAGE_CLEAR_DIRTY |
 						     PAGE_SET_WRITEBACK |
 						     page_error_op |
@@ -837,6 +838,8 @@ retry:
 		extent_clear_unlock_delalloc(inode, async_extent->start,
 				async_extent->start +
 				async_extent->ram_size - 1,
+				async_extent->start +
+				async_extent->ram_size - 1,
 				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				PAGE_SET_WRITEBACK);
@@ -856,7 +859,8 @@ retry:
 			tree->ops->writepage_end_io_hook(p, start, end,
 							 NULL, 0);
 			p->mapping = NULL;
-			extent_clear_unlock_delalloc(inode, start, end, NULL, 0,
+			extent_clear_unlock_delalloc(inode, start, end, end,
+						     NULL, 0,
 						     PAGE_END_WRITEBACK |
 						     PAGE_SET_ERROR);
 			free_async_extent_pages(async_extent);
@@ -873,6 +877,8 @@ out_free:
 	extent_clear_unlock_delalloc(inode, async_extent->start,
 				     async_extent->start +
 				     async_extent->ram_size - 1,
+				     async_extent->start +
+				     async_extent->ram_size - 1,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
@@ -966,7 +972,8 @@ static noinline int cow_file_range(struct inode *inode,
 		ret = cow_file_range_inline(root, inode, start, end, 0, 0,
 					    NULL);
 		if (ret == 0) {
-			extent_clear_unlock_delalloc(inode, start, end, NULL,
+			extent_clear_unlock_delalloc(inode, start, end,
+				     delalloc_end, NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG, PAGE_UNLOCK |
 				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
@@ -1062,7 +1069,8 @@ static noinline int cow_file_range(struct inode *inode,
 		op |= PAGE_SET_PRIVATE2;
 
 		extent_clear_unlock_delalloc(inode, start,
-					     start + ram_size - 1, locked_page,
+					     start + ram_size - 1,
+					     delalloc_end, locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC,
 					     op);
 		disk_num_bytes -= cur_alloc_size;
@@ -1079,7 +1087,8 @@ out_reserve:
 	btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
 	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
 out_unlock:
-	extent_clear_unlock_delalloc(inode, start, end, locked_page,
+	extent_clear_unlock_delalloc(inode, start, end, delalloc_end,
+				     locked_page,
 				     EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 				     EXTENT_DELALLOC | EXTENT_DEFRAG,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
@@ -1258,7 +1267,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, end,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1276,7 +1286,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		trans = btrfs_join_transaction(root);
 
 	if (IS_ERR(trans)) {
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, end,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1490,7 +1501,7 @@ out_check:
 		}
 
 		extent_clear_unlock_delalloc(inode, cur_offset,
-					     cur_offset + num_bytes - 1,
+					     cur_offset + num_bytes - 1, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC |
 					     EXTENT_CLEAR_DATA_RESV,
@@ -1522,7 +1533,7 @@ error:
 		ret = err;
 
 	if (ret && cur_offset < end)
-		extent_clear_unlock_delalloc(inode, cur_offset, end,
+		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
 					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
@@ -1997,7 +2008,7 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
-			      struct extent_state **cached_state)
+			      struct extent_state **cached_state, int dedupe)
 {
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
 	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
@@ -2061,7 +2072,8 @@ again:
 		goto out;
 	 }
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
+	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state,
+				  0);
 	ClearPageChecked(page);
 	set_page_dirty(page);
 out:
@@ -4766,7 +4778,7 @@ again:
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, block_start, block_end,
-					&cached_state);
+					&cached_state, 0);
 	if (ret) {
 		unlock_extent_cached(io_tree, block_start, block_end,
 				     &cached_state, GFP_NOFS);
@@ -9076,7 +9088,7 @@ again:
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, end,
-					&cached_state);
+					&cached_state, 0);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 036c6f4..1b93699 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3203,7 +3203,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			nr++;
 		}
 
-		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
+		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL, 0);
 		set_page_dirty(page);
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 9f72aed..0bf4680 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -968,7 +968,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	/* [BTRFS_MAX_EXTENT_SIZE] */
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, 0, BTRFS_MAX_EXTENT_SIZE - 1,
-					NULL);
+					NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -984,7 +984,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
 					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
-					NULL);
+					NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1019,7 +1019,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
 					(BTRFS_MAX_EXTENT_SIZE >> 1)
 					+ sectorsize - 1,
-					NULL);
+					NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1042,7 +1042,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize,
 			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
-			NULL);
+			NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1060,7 +1060,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1097,7 +1097,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
-- 
2.9.3



