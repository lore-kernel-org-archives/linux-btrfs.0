Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48395 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753123AbdHUJn5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:43:57 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 092E7ABE4
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:43:56 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/10] btrfs: Remove unused parameter from extent_clear_unlock_delalloc
Date: Mon, 21 Aug 2017 12:43:47 +0300
Message-Id: <1503308630-6652-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This variable was added as part of ba8b04c1d4ad ("btrfs: extend
btrfs_set_extent_delalloc and its friends to support in-band dedupe and subpage size patchset")
however those patchsets haven't materialized yet. Let's remove the argument and 
when the time comes (e.g. whiever patchset lands first) should introduce all of 
its pre-requisites in the same series. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Hello David, 

I was a ambivalent whether I should send this one since it removes some
preparatory work. However, the said patchsets haven't really moved anywhere for
quite some time and will likely require substantial amount of rebasing effort, 
so let's remove *possibly* outdated leftovers. But then again, I have no 
strong opinion on this. 

 fs/btrfs/extent_io.c |  3 +--
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/inode.c     | 24 ++++++++----------------
 3 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d17783d70228..5eab66ec74f3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1739,8 +1739,7 @@ static int __process_pages_contig(struct address_space *mapping,
 }
 
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 u64 delalloc_end, struct page *locked_page,
-				 unsigned clear_bits,
+				 struct page *locked_page, unsigned clear_bits,
 				 unsigned long page_ops)
 {
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, clear_bits, 1, 0,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index faffa28ba707..ff71256f6fae 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -492,7 +492,7 @@ int map_private_extent_buffer(const struct extent_buffer *eb,
 void extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
 void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 u64 delalloc_end, struct page *locked_page,
+				 struct page *locked_page,
 				 unsigned bits_to_clear,
 				 unsigned long page_ops);
 struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_byte);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1b3d6146924..98b56aca0a6f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -583,7 +583,7 @@ static noinline void compress_file_range(struct inode *inode,
 			 * we don't need to create any more async work items.
 			 * Unlock and free up our temp pages.
 			 */
-			extent_clear_unlock_delalloc(inode, start, end, end,
+			extent_clear_unlock_delalloc(inode, start, end,
 						     NULL, clear_flags,
 						     PAGE_UNLOCK |
 						     PAGE_CLEAR_DIRTY |
@@ -836,8 +836,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
 		extent_clear_unlock_delalloc(inode, async_extent->start,
 				async_extent->start +
 				async_extent->ram_size - 1,
-				async_extent->start +
-				async_extent->ram_size - 1,
 				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				PAGE_SET_WRITEBACK);
@@ -856,7 +854,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 			tree->ops->writepage_end_io_hook(p, start, end,
 							 NULL, 0);
 			p->mapping = NULL;
-			extent_clear_unlock_delalloc(inode, start, end, end,
+			extent_clear_unlock_delalloc(inode, start, end,
 						     NULL, 0,
 						     PAGE_END_WRITEBACK |
 						     PAGE_SET_ERROR);
@@ -874,8 +872,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
 	extent_clear_unlock_delalloc(inode, async_extent->start,
 				     async_extent->start +
 				     async_extent->ram_size - 1,
-				     async_extent->start +
-				     async_extent->ram_size - 1,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DELALLOC_NEW |
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
@@ -970,8 +966,7 @@ static noinline int cow_file_range(struct inode *inode,
 		ret = cow_file_range_inline(root, inode, start, end, 0,
 					BTRFS_COMPRESS_NONE, NULL);
 		if (ret == 0) {
-			extent_clear_unlock_delalloc(inode, start, end,
-				     delalloc_end, NULL,
+			extent_clear_unlock_delalloc(inode, start, end, NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DELALLOC_NEW |
 				     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1057,7 +1052,7 @@ static noinline int cow_file_range(struct inode *inode,
 
 		extent_clear_unlock_delalloc(inode, start,
 					     start + ram_size - 1,
-					     delalloc_end, locked_page,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC,
 					     page_ops);
 		if (disk_num_bytes < cur_alloc_size)
@@ -1103,7 +1098,6 @@ static noinline int cow_file_range(struct inode *inode,
 	if (extent_reserved) {
 		extent_clear_unlock_delalloc(inode, start,
 					     start + cur_alloc_size,
-					     start + cur_alloc_size,
 					     locked_page,
 					     clear_bits,
 					     page_ops);
@@ -1111,8 +1105,7 @@ static noinline int cow_file_range(struct inode *inode,
 		if (start >= end)
 			goto out;
 	}
-	extent_clear_unlock_delalloc(inode, start, end, delalloc_end,
-				     locked_page,
+	extent_clear_unlock_delalloc(inode, start, end, locked_page,
 				     clear_bits | EXTENT_CLEAR_DATA_RESV,
 				     page_ops);
 	goto out;
@@ -1285,8 +1278,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		extent_clear_unlock_delalloc(inode, start, end, end,
-					     locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1497,7 +1489,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 						      num_bytes);
 
 		extent_clear_unlock_delalloc(inode, cur_offset,
-					     cur_offset + num_bytes - 1, end,
+					     cur_offset + num_bytes - 1,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC |
 					     EXTENT_CLEAR_DATA_RESV,
@@ -1533,7 +1525,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 error:
 	if (ret && cur_offset < end)
-		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
+		extent_clear_unlock_delalloc(inode, cur_offset, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
 					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
-- 
2.7.4

