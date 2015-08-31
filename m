Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42571 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbbIBHvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 03:51:23 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7V8udCB031126
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 16:57:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 15/15] btrfs: fallocate: Add support to accurate qgroup reserve
Date: Mon, 31 Aug 2015 16:54:46 +0800
Message-Id: <1441011286-23733-16-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441011286-23733-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441011286-23733-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now fallocate will do accurate qgroup reserve space check, unlike old
method, which will always reserve the whole length of the range.

With this patch, fallocate will:
1) Iterate the desired range and mark in data rsv map
   Only range which is going to be allocated will be recorded in data
   rsv map and reserve the space.
   For already allocated range (normal/prealloc extent) they will be
   skipped.
   Also, record the marked range into a new list for later use.

2) If 1) succeeded, do real file extent allocate.
   And at file extent allocation time, corresponding range will be
   removed from the range in data rsv map.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file.c | 171 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 117 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c1eec4f..41861d0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2545,17 +2545,61 @@ out_only_mutex:
 	return err;
 }
 
+/* Helper structure to record which range is already reserved */
+struct falloc_range {
+	struct list_head list;
+	u64 start;
+	u64 len;
+};
+
+/*
+ * Helper function to add falloc range
+ *
+ * Caller should have locked the larger range of extent containing
+ * [start, len)
+ */
+static int add_falloc_range(struct list_head *head, u64 start, u64 len)
+{
+	struct falloc_range *prev = NULL;
+	struct falloc_range *range = NULL;
+
+	if (list_empty(head))
+		goto insert;
+
+	/*
+	 * As fallocate iterate by bytenr order, we only need to check
+	 * the last range.
+	 */
+	prev = list_entry(head->prev, struct falloc_range, list);
+	if (prev->start + prev->len == start) {
+		prev->len += len;
+		return 0;
+	}
+insert:
+	range = kmalloc(sizeof(*range), GFP_NOFS);
+	if (!range)
+		return -ENOMEM;
+	range->start = start;
+	range->len = len;
+	list_add_tail(&range->list, head);
+	return 0;
+}
+
 static long btrfs_fallocate(struct file *file, int mode,
 			    loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
 	struct extent_state *cached_state = NULL;
+	struct falloc_range *range;
+	struct falloc_range *tmp;
+	struct list_head reserve_list;
 	u64 cur_offset;
 	u64 last_byte;
 	u64 alloc_start;
 	u64 alloc_end;
 	u64 alloc_hint = 0;
 	u64 locked_end;
+	u64 update_end = 0;
 	struct extent_map *em;
 	int blocksize = BTRFS_I(inode)->root->sectorsize;
 	int ret;
@@ -2571,8 +2615,9 @@ static long btrfs_fallocate(struct file *file, int mode,
 		return btrfs_punch_hole(inode, offset, len);
 
 	/*
-	 * Make sure we have enough space before we do the
-	 * allocation.
+	 * Make sure we have enough disk space before we do the allocation.
+	 *
+	 * For qgroup space, it will be checked later.
 	 */
 	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start, alloc_end - alloc_start);
 	if (ret)
@@ -2583,22 +2628,6 @@ static long btrfs_fallocate(struct file *file, int mode,
 	if (ret)
 		goto out;
 
-	if (alloc_start > inode->i_size) {
-		ret = btrfs_cont_expand(inode, i_size_read(inode),
-					alloc_start);
-		if (ret)
-			goto out;
-	} else {
-		/*
-		 * If we are fallocating from the end of the file onward we
-		 * need to zero out the end of the page if i_size lands in the
-		 * middle of a page.
-		 */
-		ret = btrfs_truncate_page(inode, inode->i_size, 0, 0);
-		if (ret)
-			goto out;
-	}
-
 	/*
 	 * wait for ordered IO before we have any locks.  We'll loop again
 	 * below with the locks held.
@@ -2641,6 +2670,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 		}
 	}
 
+	/* First, check if we exceed the qgroup limit */
+	INIT_LIST_HEAD(&reserve_list);
 	cur_offset = alloc_start;
 	while (1) {
 		u64 actual_end;
@@ -2657,54 +2688,86 @@ static long btrfs_fallocate(struct file *file, int mode,
 		last_byte = min(extent_map_end(em), alloc_end);
 		actual_end = min_t(u64, extent_map_end(em), offset + len);
 		last_byte = ALIGN(last_byte, blocksize);
-
 		if (em->block_start == EXTENT_MAP_HOLE ||
 		    (cur_offset >= inode->i_size &&
 		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
-			ret = btrfs_prealloc_file_range(inode, mode, cur_offset,
-							last_byte - cur_offset,
-							1 << inode->i_blkbits,
-							offset + len,
-							&alloc_hint);
-		} else if (actual_end > inode->i_size &&
-			   !(mode & FALLOC_FL_KEEP_SIZE)) {
-			struct btrfs_trans_handle *trans;
-			struct btrfs_root *root = BTRFS_I(inode)->root;
-
-			/*
-			 * We didn't need to allocate any more space, but we
-			 * still extended the size of the file so we need to
-			 * update i_size and the inode item.
-			 */
-			trans = btrfs_start_transaction(root, 1);
-			if (IS_ERR(trans)) {
-				ret = PTR_ERR(trans);
-			} else {
-				inode->i_ctime = CURRENT_TIME;
-				i_size_write(inode, actual_end);
-				btrfs_ordered_update_i_size(inode, actual_end,
-							    NULL);
-				ret = btrfs_update_inode(trans, root, inode);
-				if (ret)
-					btrfs_end_transaction(trans, root);
-				else
-					ret = btrfs_end_transaction(trans,
-								    root);
+			ret = add_falloc_range(&reserve_list, cur_offset,
+					       last_byte - cur_offset);
+			if (ret < 0) {
+				free_extent_map(em);
+				goto out;
 			}
-		}
+			ret = btrfs_qgroup_reserve_data(inode, cur_offset,
+					last_byte - cur_offset);
+		} else if (actual_end > inode->i_size &&
+			   !(mode & FALLOC_FL_KEEP_SIZE))
+			update_end = actual_end;
 		free_extent_map(em);
-		if (ret < 0)
-			break;
-
 		cur_offset = last_byte;
-		if (cur_offset >= alloc_end) {
-			ret = 0;
+		if (cur_offset >= alloc_end)
 			break;
+	}
+	if (ret < 0)
+		goto out;
+
+	if (alloc_start > inode->i_size) {
+		ret = btrfs_cont_expand(inode, i_size_read(inode),
+					alloc_start);
+		if (ret)
+			goto out;
+	} else {
+		/*
+		 * If we are fallocating from the end of the file onward we
+		 * need to zero out the end of the page if i_size lands in the
+		 * middle of a page.
+		 */
+		ret = btrfs_truncate_page(inode, inode->i_size, 0, 0);
+		if (ret)
+			goto out;
+	}
+
+	/* Now we are sure qgroup reserved enough space now */
+	list_for_each_entry_safe(range, tmp, &reserve_list, list) {
+		ret = btrfs_prealloc_file_range(inode, mode, range->start,
+				range->len, 1 << inode->i_blkbits,
+				offset + len, &alloc_hint);
+		if (ret < 0)
+			goto out;
+	}
+	if (update_end) {
+		struct btrfs_trans_handle *trans;
+		struct btrfs_root *root = BTRFS_I(inode)->root;
+
+		/*
+		 * We didn't need to allocate any more space, but we
+		 * still extended the size of the file so we need to
+		 * update i_size and the inode item.
+		 */
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+		} else {
+			inode->i_ctime = CURRENT_TIME;
+			i_size_write(inode, update_end);
+			btrfs_ordered_update_i_size(inode, update_end, NULL);
+			ret = btrfs_update_inode(trans, root, inode);
+			if (ret)
+				btrfs_end_transaction(trans, root);
+			else
+				ret = btrfs_end_transaction(trans, root);
 		}
 	}
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
 			     &cached_state, GFP_NOFS);
 out:
+	/*
+	 * As we waited the extent range, the data_rsv_map must be empty
+	 * in the range, as written data range will be released from it.
+	 * And for prelloacted extent, it will also be released when
+	 * its metadata is written.
+	 * So this is completely used as cleanup.
+	 */
+	btrfs_qgroup_free_data(inode, alloc_start, alloc_end - alloc_start);
 	mutex_unlock(&inode->i_mutex);
 	/* Let go of our reservation. */
 	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
-- 
2.5.0

