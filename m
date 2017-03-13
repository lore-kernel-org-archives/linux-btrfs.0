Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17807 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751590AbdCMHw5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:52:57 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8F8EB47D8B9C
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 15:52:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 8/9] btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
Date: Mon, 13 Mar 2017 15:52:15 +0800
Message-ID: <20170313075216.5125-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new parameter, struct extent_changeset for
btrfs_qgroup_reserved_data() and its callers.

Such extent_changeset was used in btrfs_qgroup_reserve_data() to record
which range it reserved in current reserve, so it can free it at error
path.

The reason we need to export it to callers is, at buffered write error
path, without knowing what exactly which range we reserved in current
allocation, we can free space which is not reserved by us.

This will lead to qgroup reserved space underflow.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  6 ++++--
 fs/btrfs/extent-tree.c | 17 ++++++++++++-----
 fs/btrfs/extent_io.h   | 12 ++++++++++++
 fs/btrfs/file.c        | 17 ++++++++++++++---
 fs/btrfs/inode-map.c   |  6 +++++-
 fs/btrfs/inode.c       | 24 ++++++++++++++++++++----
 fs/btrfs/ioctl.c       |  7 ++++++-
 fs/btrfs/qgroup.c      | 33 +++++++++++++++++++++------------
 fs/btrfs/qgroup.h      |  3 ++-
 fs/btrfs/relocation.c  |  5 ++++-
 10 files changed, 100 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 29b7fc28c607..8349b3bd6522 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2687,8 +2687,9 @@ enum btrfs_flush_state {
 	COMMIT_TRANS		=	6,
 };
 
-int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
 int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
+int btrfs_check_data_free_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len);
 void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 					    u64 len);
@@ -2706,7 +2707,8 @@ void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes);
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
+int btrfs_delalloc_reserve_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 89d1bcba3f8c..67f4e97ef8c6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3355,12 +3355,14 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct btrfs_root *root = fs_info->tree_root;
 	struct inode *inode = NULL;
+	struct extent_changeset data_reserved;
 	u64 alloc_hint = 0;
 	int dcs = BTRFS_DC_ERROR;
 	u64 num_pages = 0;
 	int retries = 0;
 	int ret = 0;
 
+	extent_changeset_init(&data_reserved);
 	/*
 	 * If this block group is smaller than 100 megs don't bother caching the
 	 * block group.
@@ -3473,7 +3475,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 	num_pages *= 16;
 	num_pages *= PAGE_SIZE;
 
-	ret = btrfs_check_data_free_space(inode, 0, num_pages);
+	ret = btrfs_check_data_free_space(inode, &data_reserved, 0, num_pages);
 	if (ret)
 		goto out_put;
 
@@ -3504,6 +3506,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 	block_group->disk_cache_state = dcs;
 	spin_unlock(&block_group->lock);
 
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
@@ -4272,7 +4275,8 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
  * Will replace old btrfs_check_data_free_space(), but for patch split,
  * add a new function first and then replace it.
  */
-int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
+int btrfs_check_data_free_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	int ret;
@@ -4287,9 +4291,11 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
 		return ret;
 
 	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
-	ret = btrfs_qgroup_reserve_data(inode, start, len);
+	ret = btrfs_qgroup_reserve_data(inode, reserved, start, len);
 	if (ret < 0)
 		btrfs_free_reserved_data_space_noquota(inode, start, len);
+	else
+		ret = 0;
 	return ret;
 }
 
@@ -6130,11 +6136,12 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
  * Return 0 for success
  * Return <0 for error(-ENOSPC or -EQUOT)
  */
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
+int btrfs_delalloc_reserve_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len)
 {
 	int ret;
 
-	ret = btrfs_check_data_free_space(inode, start, len);
+	ret = btrfs_check_data_free_space(inode, reserved, start, len);
 	if (ret < 0)
 		return ret;
 	ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index bdca004dc859..61db0fca74f9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -207,6 +207,18 @@ struct extent_changeset {
 	struct ulist range_changed;
 };
 
+static inline void extent_changeset_init(struct extent_changeset *changeset)
+{
+	changeset->bytes_changed = 0;
+	ulist_init(&changeset->range_changed);
+}
+
+static inline void extent_changeset_release(struct extent_changeset *changeset)
+{
+	changeset->bytes_changed = 0;
+	ulist_release(&changeset->range_changed);
+}
+
 static inline void extent_set_compress_type(unsigned long *bio_flags,
 					    int compress_type)
 {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 520cb7230b2d..209e67051c07 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1529,6 +1529,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page **pages = NULL;
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved;
 	u64 release_bytes = 0;
 	u64 lockstart;
 	u64 lockend;
@@ -1539,6 +1540,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	bool force_page_uptodate = false;
 	bool need_unlock;
 
+	extent_changeset_init(&data_reserved);
+
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
 	nrptrs = min(nrptrs, current->nr_dirtied_pause - current->nr_dirtied);
@@ -1576,7 +1579,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		reserve_bytes = round_up(write_bytes + sector_offset,
 				fs_info->sectorsize);
 
-		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
+		extent_changeset_release(&data_reserved);
+		ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
+						  write_bytes);
 		if (ret < 0) {
 			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 						      BTRFS_INODE_PREALLOC)) &&
@@ -1750,6 +1755,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 	}
 
+	extent_changeset_release(&data_reserved);
 	return num_written ? num_written : ret;
 }
 
@@ -2722,6 +2728,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 {
 	struct inode *inode = file_inode(file);
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved;
 	struct falloc_range *range;
 	struct falloc_range *tmp;
 	struct list_head reserve_list;
@@ -2736,6 +2743,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 	int blocksize = btrfs_inode_sectorsize(inode);
 	int ret;
 
+	extent_changeset_init(&data_reserved);
+
 	alloc_start = round_down(offset, blocksize);
 	alloc_end = round_up(offset + len, blocksize);
 	cur_offset = alloc_start;
@@ -2854,10 +2863,11 @@ static long btrfs_fallocate(struct file *file, int mode,
 				free_extent_map(em);
 				break;
 			}
-			ret = btrfs_qgroup_reserve_data(inode, cur_offset,
-					last_byte - cur_offset);
+			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
+					cur_offset, last_byte - cur_offset);
 			if (ret < 0)
 				break;
+			ret = 0;
 		} else {
 			/*
 			 * Do not need to reserve unwritten extent for this
@@ -2925,6 +2935,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	if (ret != 0)
 		btrfs_free_reserved_data_space(inode, alloc_start,
 				       alloc_end - cur_offset);
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 5c6c20ec64d8..66003fa79935 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -400,6 +400,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	struct btrfs_path *path;
 	struct inode *inode;
 	struct btrfs_block_rsv *rsv;
+	struct extent_changeset data_reserved;
 	u64 num_bytes;
 	u64 alloc_hint = 0;
 	int ret;
@@ -419,6 +420,8 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	if (!btrfs_test_opt(fs_info, INODE_MAP_CACHE))
 		return 0;
 
+	extent_changeset_init(&data_reserved);
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -492,7 +495,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, 0, prealloc);
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, 0, prealloc);
 	if (ret)
 		goto out_put;
 
@@ -516,6 +519,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	trans->bytes_reserved = num_bytes;
 
 	btrfs_free_path(path);
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 36b08abff564..216f28e94d57 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1936,12 +1936,15 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved;
 	struct page *page;
 	struct inode *inode;
 	u64 page_start;
 	u64 page_end;
 	int ret;
 
+	extent_changeset_init(&data_reserved);
+
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
 again:
@@ -1973,7 +1976,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 		goto again;
 	}
 
-	ret = btrfs_delalloc_reserve_space(inode, page_start,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   PAGE_SIZE);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
@@ -1993,6 +1996,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	unlock_page(page);
 	put_page(page);
 	kfree(fixup);
+	extent_changeset_release(&data_reserved);
 }
 
 /*
@@ -4647,6 +4651,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved;
 	char *kaddr;
 	u32 blocksize = fs_info->sectorsize;
 	pgoff_t index = from >> PAGE_SHIFT;
@@ -4657,11 +4662,13 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	u64 block_start;
 	u64 block_end;
 
+	extent_changeset_init(&data_reserved);
+
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
 
-	ret = btrfs_delalloc_reserve_space(inode,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
 			round_down(from, blocksize), blocksize);
 	if (ret)
 		goto out;
@@ -4746,6 +4753,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	unlock_page(page);
 	put_page(page);
 out:
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
@@ -8583,6 +8591,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	struct inode *inode = file->f_mapping->host;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_dio_data dio_data = { 0 };
+	struct extent_changeset data_reserved;
 	loff_t offset = iocb->ki_pos;
 	size_t count = 0;
 	int flags = 0;
@@ -8593,6 +8602,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (check_direct_IO(fs_info, iocb, iter, offset))
 		return 0;
 
+	extent_changeset_init(&data_reserved);
 	inode_dio_begin(inode);
 	smp_mb__after_atomic();
 
@@ -8619,7 +8629,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			inode_unlock(inode);
 			relock = true;
 		}
-		ret = btrfs_delalloc_reserve_space(inode, offset, count);
+		ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
+						   offset, count);
 		if (ret)
 			goto out;
 		dio_data.outstanding_extents = count_max_extents(count);
@@ -8676,6 +8687,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (relock)
 		inode_lock(inode);
 
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
@@ -8907,6 +8919,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved;
 	char *kaddr;
 	unsigned long zero_start;
 	loff_t size;
@@ -8917,6 +8930,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	u64 page_end;
 	u64 end;
 
+	extent_changeset_init(&data_reserved);
 	reserved_space = PAGE_SIZE;
 
 	sb_start_pagefault(inode->i_sb);
@@ -8932,7 +8946,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	 * end up waiting indefinitely to get a lock on the page currently
 	 * being processed by btrfs_page_mkwrite() function.
 	 */
-	ret = btrfs_delalloc_reserve_space(inode, page_start,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   reserved_space);
 	if (!ret) {
 		ret = file_update_time(vmf->vma->vm_file);
@@ -9038,6 +9052,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 out_unlock:
 	if (!ret) {
 		sb_end_pagefault(inode->i_sb);
+		extent_changeset_release(&data_reserved);
 		return VM_FAULT_LOCKED;
 	}
 	unlock_page(page);
@@ -9045,6 +9060,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	btrfs_delalloc_release_space(inode, page_start, reserved_space);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dabfc7ac48a6..876e177a55fc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1127,15 +1127,18 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_io_tree *tree;
+	struct extent_changeset data_reserved;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
+	extent_changeset_init(&data_reserved);
+
 	file_end = (isize - 1) >> PAGE_SHIFT;
 	if (!isize || start_index > file_end)
 		return 0;
 
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
-	ret = btrfs_delalloc_reserve_space(inode,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT);
 	if (ret)
@@ -1247,6 +1250,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		unlock_page(pages[i]);
 		put_page(pages[i]);
 	}
+	extent_changeset_release(&data_reserved);
 	return i_done;
 out:
 	for (i = 0; i < i_done; i++) {
@@ -1256,6 +1260,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	btrfs_delalloc_release_space(inode,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT);
+	extent_changeset_release(&data_reserved);
 	return ret;
 
 }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 87aeefb34959..a8eff593cabd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2813,43 +2813,52 @@ btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
  * Return <0 for error (including -EQUOT)
  *
  * NOTE: this function may sleep for memory allocation.
+ *       if btrfs_qgroup_reserve_data() is called multiple times with
+ *       same @reserved, caller must ensure when error happens it's OK
+ *       to free *ALL* reserved space.
  */
-int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
+int btrfs_qgroup_reserve_data(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_changeset changeset;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
+	u64 orig_reserved;
+	u64 to_reserve;
 	int ret;
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags) ||
 	    !is_fstree(root->objectid) || len == 0)
 		return 0;
 
-	changeset.bytes_changed = 0;
-	ulist_init(&changeset.range_changed);
+	/* @reserved parameter is mandatory for qgroup */
+	if (WARN_ON(!reserved))
+		return -EINVAL;
+	/* Record already reserved space */
+	orig_reserved = reserved->bytes_changed;
 	ret = set_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
-			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
+			start + len -1, EXTENT_QGROUP_RESERVED, reserved);
+
+	/* Newly reserved space */
+	to_reserve = reserved->bytes_changed - orig_reserved;
 	trace_btrfs_qgroup_reserve_data(inode, start, len,
-					changeset.bytes_changed,
-					QGROUP_RESERVE);
+					to_reserve, QGROUP_RESERVE);
 	if (ret < 0)
 		goto cleanup;
-	ret = qgroup_reserve(root, changeset.bytes_changed, true);
+	ret = qgroup_reserve(root, to_reserve, true);
 	if (ret < 0)
 		goto cleanup;
 
-	ulist_release(&changeset.range_changed);
 	return ret;
 
 cleanup:
-	/* cleanup already reserved ranges */
+	/* cleanup *ALL* already reserved ranges */
 	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(&changeset.range_changed, &uiter)))
+	while ((unode = ulist_next(&reserved->range_changed, &uiter)))
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
 				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL,
 				 GFP_NOFS);
-	ulist_release(&changeset.range_changed);
+	extent_changeset_release(reserved);
 	return ret;
 }
 
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index b3c77f029dfe..5fbe2023e17f 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -242,7 +242,8 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 #endif
 
 /* New io_tree based accurate qgroup reserve API */
-int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len);
+int btrfs_qgroup_reserve_data(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len);
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d60df51959f7..493d4dc19edf 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3093,11 +3093,13 @@ int prealloc_file_extent_cluster(struct inode *inode,
 	u64 prealloc_start = cluster->start - offset;
 	u64 prealloc_end = cluster->end - offset;
 	u64 cur_offset;
+	struct extent_changeset data_reserved;
 
 	BUG_ON(cluster->start != cluster->boundary[0]);
+	extent_changeset_init(&data_reserved);
 	inode_lock(inode);
 
-	ret = btrfs_check_data_free_space(inode, prealloc_start,
+	ret = btrfs_check_data_free_space(inode, &data_reserved, prealloc_start,
 					  prealloc_end + 1 - prealloc_start);
 	if (ret)
 		goto out;
@@ -3129,6 +3131,7 @@ int prealloc_file_extent_cluster(struct inode *inode,
 				       prealloc_end + 1 - cur_offset);
 out:
 	inode_unlock(inode);
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
-- 
2.12.0



