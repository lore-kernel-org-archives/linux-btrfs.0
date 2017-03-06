Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754198AbdCFXc7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Mar 2017 18:32:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 7554D20212
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Mar 2017 23:32:57 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C16820160
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Mar 2017 23:32:55 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: remove unused delalloc_end parameter
Date: Mon,  6 Mar 2017 23:32:47 +0000
Message-Id: <1488843167-8511-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The delalloc_end parameter for extent_clear_unlock_delalloc() is never
used, and only making the code for all callers longer and more complex.
Just remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c |  2 +-
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/inode.c     | 32 +++++++++++++-------------------
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 28e8192..2cce08b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1760,7 +1760,7 @@ static int __process_pages_contig(struct address_space *mapping,
 }
 
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 u64 delalloc_end, struct page *locked_page,
+				 struct page *locked_page,
 				 unsigned clear_bits,
 				 unsigned long page_ops)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3e4fad4..b12f4db 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -452,7 +452,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 void extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
 void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 u64 delalloc_end, struct page *locked_page,
+				 struct page *locked_page,
 				 unsigned bits_to_clear,
 				 unsigned long page_ops);
 struct bio *
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b2bc07a..07bee7d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -106,7 +106,7 @@ static int btrfs_truncate(struct inode *inode);
 static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
 static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
-				   u64 start, u64 end, u64 delalloc_end,
+				   u64 start, u64 end,
 				   int *page_started, unsigned long *nr_written,
 				   int unlock, struct btrfs_dedupe_hash *hash);
 static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
@@ -558,7 +558,7 @@ static noinline void compress_file_range(struct inode *inode,
 			 * we don't need to create any more async work items.
 			 * Unlock and free up our temp pages.
 			 */
-			extent_clear_unlock_delalloc(inode, start, end, end,
+			extent_clear_unlock_delalloc(inode, start, end,
 						     NULL, clear_flags,
 						     PAGE_UNLOCK |
 						     PAGE_CLEAR_DIRTY |
@@ -713,8 +713,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
 					     async_extent->start,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
-					     async_extent->start +
-					     async_extent->ram_size - 1,
 					     &page_started, &nr_written, 0,
 					     NULL);
 
@@ -810,8 +808,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
 		extent_clear_unlock_delalloc(inode, async_extent->start,
 				async_extent->start +
 				async_extent->ram_size - 1,
-				async_extent->start +
-				async_extent->ram_size - 1,
 				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				PAGE_SET_WRITEBACK);
@@ -831,7 +827,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 			tree->ops->writepage_end_io_hook(p, start, end,
 							 NULL, 0);
 			p->mapping = NULL;
-			extent_clear_unlock_delalloc(inode, start, end, end,
+			extent_clear_unlock_delalloc(inode, start, end,
 						     NULL, 0,
 						     PAGE_END_WRITEBACK |
 						     PAGE_SET_ERROR);
@@ -849,8 +845,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
 	extent_clear_unlock_delalloc(inode, async_extent->start,
 				     async_extent->start +
 				     async_extent->ram_size - 1,
-				     async_extent->start +
-				     async_extent->ram_size - 1,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
@@ -908,7 +902,7 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
  */
 static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
-				   u64 start, u64 end, u64 delalloc_end,
+				   u64 start, u64 end,
 				   int *page_started, unsigned long *nr_written,
 				   int unlock, struct btrfs_dedupe_hash *hash)
 {
@@ -942,7 +936,7 @@ static noinline int cow_file_range(struct inode *inode,
 					BTRFS_COMPRESS_NONE, NULL);
 		if (ret == 0) {
 			extent_clear_unlock_delalloc(inode, start, end,
-				     delalloc_end, NULL,
+				     NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG, PAGE_UNLOCK |
 				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
@@ -1019,7 +1013,7 @@ static noinline int cow_file_range(struct inode *inode,
 
 		extent_clear_unlock_delalloc(inode, start,
 					     start + ram_size - 1,
-					     delalloc_end, locked_page,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC,
 					     op);
 		disk_num_bytes -= cur_alloc_size;
@@ -1036,7 +1030,7 @@ static noinline int cow_file_range(struct inode *inode,
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
 out_unlock:
-	extent_clear_unlock_delalloc(inode, start, end, delalloc_end,
+	extent_clear_unlock_delalloc(inode, start, end,
 				     locked_page,
 				     EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 				     EXTENT_DELALLOC | EXTENT_DEFRAG,
@@ -1212,7 +1206,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		extent_clear_unlock_delalloc(inode, start, end, end,
+		extent_clear_unlock_delalloc(inode, start, end,
 					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
@@ -1366,7 +1360,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		if (cow_start != (u64)-1) {
 			ret = cow_file_range(inode, locked_page,
 					     cow_start, found_key.offset - 1,
-					     end, page_started, nr_written, 1,
+					     page_started, nr_written, 1,
 					     NULL);
 			if (ret) {
 				if (!nolock && nocow)
@@ -1425,7 +1419,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		}
 
 		extent_clear_unlock_delalloc(inode, cur_offset,
-					     cur_offset + num_bytes - 1, end,
+					     cur_offset + num_bytes - 1,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC |
 					     EXTENT_CLEAR_DATA_RESV,
@@ -1445,7 +1439,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	}
 
 	if (cow_start != (u64)-1) {
-		ret = cow_file_range(inode, locked_page, cow_start, end, end,
+		ret = cow_file_range(inode, locked_page, cow_start, end,
 				     page_started, nr_written, 1, NULL);
 		if (ret)
 			goto error;
@@ -1453,7 +1447,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 error:
 	if (ret && cur_offset < end)
-		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
+		extent_clear_unlock_delalloc(inode, cur_offset, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
 					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
@@ -1501,7 +1495,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
 	} else if (!inode_need_compress(inode)) {
-		ret = cow_file_range(inode, locked_page, start, end, end,
+		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-- 
2.7.0.rc3

