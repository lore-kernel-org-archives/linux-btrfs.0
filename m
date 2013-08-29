Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52473 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3H2SCl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 14:02:41 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D1A287C0695
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 12:02:40 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id P7xOlIfJKrAi8fOf (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 12:02:40 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: allow partial ordered extent completion
Date: Thu, 29 Aug 2013 14:02:37 -0400
Message-ID: <1377799357-9071-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We currently have this problem where you can truncate pages that have not yet
been written for an ordered extent.  We do this because the truncate will be
coming behind to clean us up anyway so what's the harm right?  Well if truncate
fails for whatever reason we leave an orphan item around for the file to be
cleaned up later.  But if the user goes and truncates up the file and tries to
read from the area that had been discarded previously they will get a csum error
because we never actually wrote that data out.

This patch fixes this by allowing us to either discard the ordered extent
completely, by which I mean we just free up the space we had allocated and not
add the file extent, or adjust the length of the file extent we write.  We do
this by setting the length we truncated down to in the ordered extent, and then
we set the file extent length and ram bytes to this length.  The total disk
space stays unchanged since we may be compressed and we can't just chop off the
disk space, but at least this way the file extent only points to the valid data.
Then when the file extent is free'd the extent and csums will be freed normally.

This patch is needed for the next series which will give us more graceful
recovery of failed truncates.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c        |   60 ++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/ordered-data.c |   13 +++++++---
 fs/btrfs/ordered-data.h |    7 +++++
 3 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1c86f9d..11b5927 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2562,8 +2562,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	struct extent_state *cached_state = NULL;
 	struct new_sa_defrag_extent *new = NULL;
 	int compress_type = 0;
-	int ret;
+	int ret = 0;
+	u64 logical_len = ordered_extent->len;
 	bool nolock;
+	bool truncated = false;
 
 	nolock = btrfs_is_free_space_inode(inode);
 
@@ -2572,6 +2574,14 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
+	if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered_extent->flags)) {
+		truncated = true;
+		logical_len = ordered_extent->truncated_len;
+		/* Truncated the entire extent, don't bother adding */
+		if (!logical_len)
+			goto out;
+	}
+
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
 		BUG_ON(!list_empty(&ordered_extent->list)); /* Logic error */
 		btrfs_ordered_update_i_size(inode, 0, ordered_extent);
@@ -2627,15 +2637,14 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		ret = btrfs_mark_extent_written(trans, inode,
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
-						ordered_extent->len);
+						logical_len);
 	} else {
 		BUG_ON(root == root->fs_info->tree_root);
 		ret = insert_reserved_file_extent(trans, inode,
 						ordered_extent->file_offset,
 						ordered_extent->start,
 						ordered_extent->disk_len,
-						ordered_extent->len,
-						ordered_extent->len,
+						logical_len, logical_len,
 						compress_type, 0, 0,
 						BTRFS_FILE_EXTENT_REG);
 	}
@@ -2667,17 +2676,27 @@ out:
 	if (trans)
 		btrfs_end_transaction(trans, root);
 
-	if (ret) {
-		clear_extent_uptodate(io_tree, ordered_extent->file_offset,
-				      ordered_extent->file_offset +
-				      ordered_extent->len - 1, NULL, GFP_NOFS);
+	if (ret || truncated) {
+		u64 start, end;
+
+		if (truncated)
+			start = ordered_extent->file_offset + logical_len;
+		else
+			start = ordered_extent->file_offset;
+		end = ordered_extent->file_offset + ordered_extent->len - 1;
+		clear_extent_uptodate(io_tree, start, end, NULL, GFP_NOFS);
+
+		/* Drop the cache for the part of the extent we didn't write. */
+		btrfs_drop_extent_cache(inode, start, end, 0);
 
 		/*
 		 * If the ordered extent had an IOERR or something else went
 		 * wrong we need to return the space for this ordered extent
-		 * back to the allocator.
+		 * back to the allocator.  We only free the extent in the
+		 * truncated case if we didn't write out the extent at all.
 		 */
-		if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
+		if ((ret || !logical_len) &&
+		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
 			btrfs_free_reserved_extent(root, ordered_extent->start,
 						   ordered_extent->disk_len);
@@ -7352,10 +7371,23 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
 		 */
-		if (TestClearPagePrivate2(page) &&
-		    btrfs_dec_test_ordered_pending(inode, &ordered, page_start,
-						   PAGE_CACHE_SIZE, 1)) {
-			btrfs_finish_ordered_io(ordered);
+		if (TestClearPagePrivate2(page)) {
+			struct btrfs_ordered_inode_tree *tree;
+			u64 new_len;
+
+			tree = &BTRFS_I(inode)->ordered_tree;
+
+			spin_lock_irq(&tree->lock);
+			set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
+			new_len = page_start - ordered->file_offset;
+			if (new_len < ordered->truncated_len)
+				ordered->truncated_len = new_len;
+			spin_unlock_irq(&tree->lock);
+
+			if (btrfs_dec_test_ordered_pending(inode, &ordered,
+							   page_start,
+							   PAGE_CACHE_SIZE, 1))
+				btrfs_finish_ordered_io(ordered);
 		}
 		btrfs_put_ordered_extent(ordered);
 		cached_state = NULL;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index f2023cc..966b413 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -205,6 +205,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->bytes_left = len;
 	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
+	entry->truncated_len = (u64)-1;
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
@@ -920,12 +921,16 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	struct btrfs_ordered_extent *test;
 	int ret = 1;
 
-	if (ordered)
+	spin_lock_irq(&tree->lock);
+	if (ordered) {
 		offset = entry_end(ordered);
-	else
+		if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags))
+			offset = min(offset,
+				     ordered->file_offset +
+				     ordered->truncated_len);
+	} else {
 		offset = ALIGN(offset, BTRFS_I(inode)->root->sectorsize);
-
-	spin_lock_irq(&tree->lock);
+	}
 	disk_i_size = BTRFS_I(inode)->disk_i_size;
 
 	/* truncate file */
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 68844d5..d9a5aa0 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -69,6 +69,7 @@ struct btrfs_ordered_sum {
 				       * the isize. */
 #define BTRFS_ORDERED_LOGGED_CSUM 8 /* We've logged the csums on this ordered
 				       ordered extent */
+#define BTRFS_ORDERED_TRUNCATED 9 /* Set when we have to truncate an extent */
 
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
@@ -96,6 +97,12 @@ struct btrfs_ordered_extent {
 	 */
 	u64 outstanding_isize;
 
+	/*
+	 * If we get truncated we need to adjust the file extent we enter for
+	 * this ordered extent so that we do not expose stale data.
+	 */
+	u64 truncated_len;
+
 	/* flags (described above) */
 	unsigned long flags;
 
-- 
1.7.7.6

