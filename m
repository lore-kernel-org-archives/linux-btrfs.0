Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4923 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbcLBCDP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 21:03:15 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chandan@linux.vnet.ibm.com
Subject: [PATCH 2/2] btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges
Date: Fri,  2 Dec 2016 10:03:07 +0800
Message-Id: <20161202020307.6025-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161202020307.6025-1-quwenruo@cn.fujitsu.com>
References: <20161202020307.6025-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
For the following case, btrfs can underflow qgroup reserved space
at error path:
(Page size 4K, function name without "btrfs_" prefix)

         Task A                  |             Task B
----------------------------------------------------------------------
Buffered_write [0, 2K)           |
|- check_data_free_space()       |
|  |- qgroup_reserve_data()      |
|     Range aligned to page      |
|     range [0, 4K)          <<< |
|     4K bytes reserved      <<< |
|- copy pages to page cache      |
                                 | Buffered_write [2K, 4K)
                                 | |- check_data_free_space()
                                 | |  |- qgroup_reserved_data()
                                 | |     Range alinged to page
                                 | |     range [0, 4K)
                                 | |     Already reserved by A <<<
                                 | |     0 bytes reserved      <<<
                                 | |- delalloc_reserve_metadata()
                                 | |  And it *FAILED* (Maybe EQUOTA)
                                 | |- free_reserved_data_space()
                                      |- qgroup_free_data()
                                         Range aligned to page range
                                         [0, 4K)
                                         Freeing 4K
(Special thanks to Chandan for the detailed report and analyse)

[CAUSE]
Above Task B is freeing reserved data range [0, 4K) which is actually
reserved by Task A.

And at write back time, page dirty by Task A will go through writeback
routine, which will free 4K reserved data space at file extent insert
time, causing the qgroup underflow.

[FIX]
For btrfs_qgroup_free_data(), add @reserved parameter to only free
data ranges reserved by previous btrfs_qgroup_reserve_data().
So in above case, Task B will try to free 0 byte, so no underflow.

Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  8 ++++---
 fs/btrfs/extent-tree.c | 12 ++++++----
 fs/btrfs/file.c        | 32 +++++++++++++++----------
 fs/btrfs/inode.c       | 35 +++++++++++++--------------
 fs/btrfs/ioctl.c       |  4 ++--
 fs/btrfs/qgroup.c      | 64 ++++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/qgroup.h      |  3 ++-
 fs/btrfs/relocation.c  |  8 +++----
 8 files changed, 117 insertions(+), 49 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9f7e109..1d5eaf3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2697,7 +2697,11 @@ enum btrfs_flush_state {
 int btrfs_check_data_free_space(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
 int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes);
-void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len);
+void btrfs_free_reserved_data_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len);
+void btrfs_delalloc_release_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 					    u64 len);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
@@ -2720,8 +2724,6 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes,
 int btrfs_delalloc_reserve_space(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len,
 			enum btrfs_metadata_reserve_type reserve_type);
-void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
-			enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 					      unsigned short type);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f116bcf..a1e9c7b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4365,7 +4365,8 @@ void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
  * This one will handle the per-inode data rsv map for accurate reserved
  * space framework.
  */
-void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len)
+void btrfs_free_reserved_data_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
@@ -4375,7 +4376,7 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len)
 	start = round_down(start, root->sectorsize);
 
 	btrfs_free_reserved_data_space_noquota(inode, start, len);
-	btrfs_qgroup_free_data(inode, start, len);
+	btrfs_qgroup_free_data(inode, reserved, start, len);
 }
 
 static void force_metadata_allocation(struct btrfs_fs_info *info)
@@ -6270,7 +6271,7 @@ int btrfs_delalloc_reserve_space(struct inode *inode,
 		return ret;
 	ret = btrfs_delalloc_reserve_metadata(inode, len, reserve_type);
 	if (ret < 0)
-		btrfs_free_reserved_data_space(inode, start, len);
+		btrfs_free_reserved_data_space(inode, reserved, start, len);
 	return ret;
 }
 
@@ -6291,11 +6292,12 @@ int btrfs_delalloc_reserve_space(struct inode *inode,
  * list if there are no delalloc bytes left.
  * Also it will handle the qgroup reserved space.
  */
-void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
+void btrfs_delalloc_release_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len,
 			enum btrfs_metadata_reserve_type reserve_type)
 {
 	btrfs_delalloc_release_metadata(inode, len, reserve_type);
-	btrfs_free_reserved_data_space(inode, start, len);
+	btrfs_free_reserved_data_space(inode, reserved, start, len);
 }
 
 static int update_block_group(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b5d0f79..5cfa065 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1603,8 +1603,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 						      reserve_type);
 		if (ret) {
 			if (!only_release_metadata)
-				btrfs_free_reserved_data_space(inode, pos,
-							       write_bytes);
+				btrfs_free_reserved_data_space(inode,
+						&data_reserved, pos,
+						write_bytes);
 			else
 				btrfs_end_write_no_snapshoting(root);
 			break;
@@ -1690,9 +1691,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 				__pos = round_down(pos, root->sectorsize) +
 					(dirty_pages << PAGE_SHIFT);
-				btrfs_delalloc_release_space(inode, __pos,
-							     release_bytes,
-							     reserve_type);
+				btrfs_delalloc_release_space(inode,
+						&data_reserved, __pos,
+						release_bytes, reserve_type);
 			}
 		}
 
@@ -1746,7 +1747,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			btrfs_delalloc_release_metadata(inode, release_bytes,
 							reserve_type);
 		} else {
-			btrfs_delalloc_release_space(inode,
+			btrfs_delalloc_release_space(inode, &data_reserved,
 						round_down(pos, root->sectorsize),
 						release_bytes, reserve_type);
 		}
@@ -2831,6 +2832,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 	/* First, check if we exceed the qgroup limit */
 	INIT_LIST_HEAD(&reserve_list);
 	while (1) {
+		struct extent_changeset *changeset;
+
 		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
 				      alloc_end - cur_offset, 0);
 		if (IS_ERR_OR_NULL(em)) {
@@ -2863,8 +2866,12 @@ static long btrfs_fallocate(struct file *file, int mode,
 			 * range, free reserved data space first, otherwise
 			 * it'll result in false ENOSPC error.
 			 */
-			btrfs_free_reserved_data_space(inode, cur_offset,
-				last_byte - cur_offset);
+			if (data_reserved.range_changed)
+				changeset = &data_reserved;
+			else
+				changeset = NULL;
+			btrfs_free_reserved_data_space(inode, changeset,
+					cur_offset, last_byte - cur_offset);
 		}
 		free_extent_map(em);
 		cur_offset = last_byte;
@@ -2883,8 +2890,9 @@ static long btrfs_fallocate(struct file *file, int mode,
 					range->len, 1 << inode->i_blkbits,
 					offset + len, &alloc_hint);
 		else
-			btrfs_free_reserved_data_space(inode, range->start,
-						       range->len);
+			btrfs_free_reserved_data_space(inode,
+					&data_reserved, range->start,
+					range->len);
 		list_del(&range->list);
 		kfree(range);
 	}
@@ -2922,8 +2930,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 	inode_unlock(inode);
 	/* Let go of our reservation. */
 	if (ret != 0)
-		btrfs_free_reserved_data_space(inode, alloc_start,
-				       alloc_end - cur_offset);
+		btrfs_free_reserved_data_space(inode, &data_reserved,
+				alloc_start, alloc_end - cur_offset);
 	extent_changeset_release(&data_reserved);
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9477424..5ca88f0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -324,7 +324,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	 * And at reserve time, it's always aligned to page size, so
 	 * just free one page here.
 	 */
-	btrfs_qgroup_free_data(inode, 0, PAGE_SIZE);
+	btrfs_qgroup_free_data(inode, NULL, 0, PAGE_SIZE);
 	btrfs_free_path(path);
 	btrfs_end_transaction(trans, root);
 	return ret;
@@ -3041,7 +3041,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		 * space for NOCOW range.
 		 * As NOCOW won't cause a new delayed ref, just free the space
 		 */
-		btrfs_qgroup_free_data(inode, ordered_extent->file_offset,
+		btrfs_qgroup_free_data(inode, NULL, ordered_extent->file_offset,
 				       ordered_extent->len);
 		btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 		if (nolock)
@@ -4872,7 +4872,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 again:
 	page = find_or_create_page(mapping, index, mask);
 	if (!page) {
-		btrfs_delalloc_release_space(inode,
+		btrfs_delalloc_release_space(inode, &data_reserved,
 				round_down(from, blocksize),
 				blocksize, reserve_type);
 		ret = -ENOMEM;
@@ -4944,7 +4944,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 
 out_unlock:
 	if (ret)
-		btrfs_delalloc_release_space(inode, block_start,
+		btrfs_delalloc_release_space(inode, &data_reserved, block_start,
 					     blocksize, reserve_type);
 	unlock_page(page);
 	put_page(page);
@@ -5334,7 +5334,7 @@ static void evict_inode_truncate_pages(struct inode *inode)
 		 * Note, end is the bytenr of last byte, so we need + 1 here.
 		 */
 		if (state->state & EXTENT_DELALLOC)
-			btrfs_qgroup_free_data(inode, start, end - start + 1);
+			btrfs_qgroup_free_data(inode, NULL, start, end - start + 1);
 
 		clear_extent_bit(io_tree, start, end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
@@ -8815,8 +8815,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		current->journal_info = NULL;
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
-				btrfs_delalloc_release_space(inode, offset,
-					dio_data.reserve, BTRFS_RESERVE_NORMAL);
+				btrfs_delalloc_release_space(inode, &data_reserved,
+					offset, dio_data.reserve,
+					BTRFS_RESERVE_NORMAL);
 			/*
 			 * On error we might have left some ordered extents
 			 * without submitting corresponding bios for them, so
@@ -8831,9 +8832,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 					dio_data.unsubmitted_oe_range_start,
 					0);
 		} else if (ret >= 0 && (size_t)ret < count)
-			btrfs_delalloc_release_space(inode, offset,
-						     count - (size_t)ret,
-						     BTRFS_RESERVE_NORMAL);
+			btrfs_delalloc_release_space(inode, &data_reserved,
+					offset, count - (size_t)ret,
+					BTRFS_RESERVE_NORMAL);
 	}
 out:
 	if (wakeup)
@@ -9031,7 +9032,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	 *    free the entire extent.
 	 */
 	if (PageDirty(page))
-		btrfs_qgroup_free_data(inode, page_start, PAGE_SIZE);
+		btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
@@ -9154,9 +9155,9 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 			spin_lock(&BTRFS_I(inode)->lock);
 			BTRFS_I(inode)->outstanding_extents++;
 			spin_unlock(&BTRFS_I(inode)->lock);
-			btrfs_delalloc_release_space(inode, page_start,
-						PAGE_SIZE - reserved_space,
-						reserve_type);
+			btrfs_delalloc_release_space(inode, &data_reserved,
+					page_start, PAGE_SIZE - reserved_space,
+					reserve_type);
 		}
 	}
 
@@ -9212,8 +9213,8 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_space(inode, page_start, reserved_space,
-				     reserve_type);
+	btrfs_delalloc_release_space(inode, &data_reserved, page_start,
+			reserved_space, reserve_type);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	extent_changeset_release(&data_reserved);
@@ -10553,7 +10554,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			btrfs_end_transaction(trans, root);
 	}
 	if (cur_offset < end)
-		btrfs_free_reserved_data_space(inode, cur_offset,
+		btrfs_free_reserved_data_space(inode, NULL, cur_offset,
 			end - cur_offset + 1);
 	return ret;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8678104..adf5111 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1231,7 +1231,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->outstanding_extents++;
 		spin_unlock(&BTRFS_I(inode)->lock);
-		btrfs_delalloc_release_space(inode,
+		btrfs_delalloc_release_space(inode, &data_reserved,
 				start_index << PAGE_SHIFT,
 				(page_cnt - i_done) << PAGE_SHIFT,
 				reserve_type);
@@ -1258,7 +1258,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		unlock_page(pages[i]);
 		put_page(pages[i]);
 	}
-	btrfs_delalloc_release_space(inode,
+	btrfs_delalloc_release_space(inode, &data_reserved,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, reserve_type);
 	extent_changeset_release(&data_reserved);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 05d210f..df4261e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2864,13 +2864,64 @@ int btrfs_qgroup_reserve_data(struct inode *inode,
 	return ret;
 }
 
-static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
-				       int free)
+/* Free ranges specified by @reserved, normally in error path */
+static int qgroup_free_reserved_data(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct extent_changeset changeset = { 0 };
+	int freed = 0;
+	int ret;
+
+	len = round_up(start + len, root->sectorsize);
+	start = round_down(start, root->sectorsize);
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(reserved->range_changed, &uiter))) {
+		u64 range_start = unode->val;
+		/* unode->aux is the inclusive end */
+		u64 range_len = unode->aux - range_start + 1;
+		u64 free_start;
+		u64 free_len;
+
+		changeset.bytes_changed = 0;
+		if (changeset.range_changed)
+			ulist_reinit(changeset.range_changed);
+
+		/* Only free range in range [start, start + len) */
+		if (range_start >= start + len ||
+		    range_start + range_len <= start)
+			continue;
+		free_start = max(range_start, start);
+		free_len = min(start + len, range_start + range_len) -
+			   free_start;
+		ret = clear_record_extent_bits(&BTRFS_I(inode)->io_failure_tree,
+				free_start, free_start + free_len - 1,
+				EXTENT_QGROUP_RESERVED, &changeset);
+		if (ret < 0)
+			goto out;
+		freed += changeset.bytes_changed;
+	}
+	ret = freed;
+out:
+	ulist_free(changeset.range_changed);
+	return ret;
+}
+
+static int __btrfs_qgroup_release_data(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len,
+			int free)
 {
 	struct extent_changeset changeset;
 	int trace_op = QGROUP_RELEASE;
 	int ret;
 
+	/* In release case, we shouldn't have @reserved */
+	WARN_ON(!free && reserved);
+	if (reserved && reserved->range_changed)
+		return qgroup_free_reserved_data(inode, reserved, start, len);
 	changeset.bytes_changed = 0;
 	changeset.range_changed = ulist_alloc(GFP_NOFS);
 	if (!changeset.range_changed)
@@ -2898,14 +2949,17 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
  *
  * Should be called when a range of pages get invalidated before reaching disk.
  * Or for error cleanup case.
+ * if @reserved is given, only reserved range in [@start, @start + @len) will
+ * be freed.
  *
  * For data written to disk, use btrfs_qgroup_release_data().
  *
  * NOTE: This function may sleep for memory allocation.
  */
-int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len)
+int btrfs_qgroup_free_data(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len)
 {
-	return __btrfs_qgroup_release_data(inode, start, len, 1);
+	return __btrfs_qgroup_release_data(inode, reserved, start, len, 1);
 }
 
 /*
@@ -2925,7 +2979,7 @@ int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len)
  */
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len)
 {
-	return __btrfs_qgroup_release_data(inode, start, len, 0);
+	return __btrfs_qgroup_release_data(inode, NULL, start, len, 0);
 }
 
 int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index a15baf5..cc81997 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -180,7 +180,8 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 int btrfs_qgroup_reserve_data(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
-int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
+int btrfs_qgroup_free_data(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len);
 
 int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes);
 void btrfs_qgroup_free_meta_all(struct btrfs_root *root);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 72ac7d7..f57180a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3098,8 +3098,8 @@ int prealloc_file_extent_cluster(struct inode *inode,
 		lock_extent(&BTRFS_I(inode)->io_tree, start, end);
 		num_bytes = end + 1 - start;
 		if (cur_offset < start)
-			btrfs_free_reserved_data_space(inode, cur_offset,
-					start - cur_offset);
+			btrfs_free_reserved_data_space(inode, &data_reserved,
+					cur_offset, start - cur_offset);
 		ret = btrfs_prealloc_file_range(inode, 0, start,
 						num_bytes, num_bytes,
 						end + 1, &alloc_hint);
@@ -3110,8 +3110,8 @@ int prealloc_file_extent_cluster(struct inode *inode,
 		nr++;
 	}
 	if (cur_offset < prealloc_end)
-		btrfs_free_reserved_data_space(inode, cur_offset,
-				       prealloc_end + 1 - cur_offset);
+		btrfs_free_reserved_data_space(inode, &data_reserved,
+				cur_offset, prealloc_end + 1 - cur_offset);
 out:
 	inode_unlock(inode);
 	extent_changeset_release(&data_reserved);
-- 
2.7.4



