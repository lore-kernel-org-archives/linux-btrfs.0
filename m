Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4923 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752437AbcLBCDS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 21:03:18 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chandan@linux.vnet.ibm.com
Subject: [PATCH 1/2] btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
Date: Fri,  2 Dec 2016 10:03:06 +0800
Message-Id: <20161202020307.6025-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
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

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  6 ++++--
 fs/btrfs/extent-tree.c | 18 ++++++++++++------
 fs/btrfs/extent_io.h   | 22 ++++++++++++++++++++++
 fs/btrfs/file.c        | 13 ++++++++++---
 fs/btrfs/inode-map.c   |  4 +++-
 fs/btrfs/inode.c       | 19 ++++++++++++++-----
 fs/btrfs/ioctl.c       |  5 ++++-
 fs/btrfs/qgroup.c      | 25 +++++++++++++++----------
 fs/btrfs/qgroup.h      |  3 ++-
 fs/btrfs/relocation.c  |  4 +++-
 10 files changed, 89 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0db037c..9f7e109 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2694,7 +2694,8 @@ enum btrfs_flush_state {
 	COMMIT_TRANS		=	6,
 };
 
-int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
+int btrfs_check_data_free_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len);
 int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len);
 void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
@@ -2716,7 +2717,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes,
 			enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes,
 			enum btrfs_metadata_reserve_type reserve_type);
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len,
+int btrfs_delalloc_reserve_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len,
 			enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
 			enum btrfs_metadata_reserve_type reserve_type);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dae287d..f116bcf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3357,6 +3357,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 {
 	struct btrfs_root *root = block_group->fs_info->tree_root;
 	struct inode *inode = NULL;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	u64 alloc_hint = 0;
 	int dcs = BTRFS_DC_ERROR;
 	u64 num_pages = 0;
@@ -3474,7 +3475,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 	num_pages *= 16;
 	num_pages *= PAGE_SIZE;
 
-	ret = btrfs_check_data_free_space(inode, 0, num_pages);
+	ret = btrfs_check_data_free_space(inode, &data_reserved, 0, num_pages);
 	if (ret)
 		goto out_put;
 
@@ -3505,6 +3506,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 	block_group->disk_cache_state = dcs;
 	spin_unlock(&block_group->lock);
 
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
@@ -4302,7 +4304,8 @@ int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
  * Will replace old btrfs_check_data_free_space(), but for patch split,
  * add a new function first and then replace it.
  */
-int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
+int btrfs_check_data_free_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -4317,9 +4320,11 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
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
 
@@ -6254,12 +6259,13 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes,
  * Return 0 for success
  * Return <0 for error(-ENOSPC or -EQUOT)
  */
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len,
-				 enum btrfs_metadata_reserve_type reserve_type)
+int btrfs_delalloc_reserve_space(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
 	int ret;
 
-	ret = btrfs_check_data_free_space(inode, start, len);
+	ret = btrfs_check_data_free_space(inode, reserved, start, len);
 	if (ret < 0)
 		return ret;
 	ret = btrfs_delalloc_reserve_metadata(inode, len, reserve_type);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 13edb86..43784b4 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -196,6 +196,28 @@ struct extent_changeset {
 	struct ulist *range_changed;
 };
 
+#define EMPTY_CHANGESET (struct extent_changeset) { 0, }
+
+static inline void extent_changeset_init(struct extent_changeset *changeset)
+{
+	changeset->bytes_changed = 0;
+	changeset->range_changed = NULL;
+}
+
+static inline void extent_changeset_reinit(struct extent_changeset *changeset)
+{
+	changeset->bytes_changed = 0;
+	if (changeset->range_changed)
+		ulist_reinit(changeset->range_changed);
+}
+
+static inline void extent_changeset_release(struct extent_changeset *changeset)
+{
+	changeset->bytes_changed = 0;
+	ulist_free(changeset->range_changed);
+	changeset->range_changed = NULL;
+}
+
 static inline void extent_set_compress_type(unsigned long *bio_flags,
 					    int compress_type)
 {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 861ff47..b5d0f79 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1521,6 +1521,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page **pages = NULL;
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	u64 release_bytes = 0;
 	u64 lockstart;
 	u64 lockend;
@@ -1572,7 +1573,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		reserve_bytes = round_up(write_bytes + sector_offset,
 				root->sectorsize);
 
-		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
+		extent_changeset_reinit(&data_reserved);
+		ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
+						  write_bytes);
 		if (ret < 0) {
 			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 						      BTRFS_INODE_PREALLOC)) &&
@@ -1749,6 +1752,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 	}
 
+	extent_changeset_release(&data_reserved);
 	return num_written ? num_written : ret;
 }
 
@@ -2716,6 +2720,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 {
 	struct inode *inode = file_inode(file);
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	struct falloc_range *range;
 	struct falloc_range *tmp;
 	struct list_head reserve_list;
@@ -2847,10 +2852,11 @@ static long btrfs_fallocate(struct file *file, int mode,
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
@@ -2918,6 +2924,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	if (ret != 0)
 		btrfs_free_reserved_data_space(inode, alloc_start,
 				       alloc_end - cur_offset);
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 0335862..72f7d4e 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -399,6 +399,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	struct btrfs_path *path;
 	struct inode *inode;
 	struct btrfs_block_rsv *rsv;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	u64 num_bytes;
 	u64 alloc_hint = 0;
 	int ret;
@@ -491,7 +492,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, 0, prealloc,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, 0, prealloc,
 					   BTRFS_RESERVE_NORMAL);
 	if (ret)
 		goto out_put;
@@ -516,6 +517,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	trans->bytes_reserved = num_bytes;
 
 	btrfs_free_path(path);
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3db58d9..9477424 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2145,6 +2145,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	struct page *page;
 	struct inode *inode;
 	u64 page_start;
@@ -2185,7 +2186,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-	ret = btrfs_delalloc_reserve_space(inode, page_start,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   PAGE_SIZE, reserve_type);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
@@ -2205,6 +2206,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	unlock_page(page);
 	put_page(page);
 	kfree(fixup);
+	extent_changeset_release(&data_reserved);
 }
 
 /*
@@ -4843,6 +4845,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	char *kaddr;
 	u32 blocksize = root->sectorsize;
 	pgoff_t index = from >> PAGE_SHIFT;
@@ -4861,7 +4864,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
 
-	ret = btrfs_delalloc_reserve_space(inode,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
 			round_down(from, blocksize), blocksize, reserve_type);
 	if (ret)
 		goto out;
@@ -4946,6 +4949,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	unlock_page(page);
 	put_page(page);
 out:
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
@@ -8743,6 +8747,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	struct inode *inode = file->f_mapping->host;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_dio_data dio_data = { 0 };
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	loff_t offset = iocb->ki_pos;
 	size_t count = 0;
 	int flags = 0;
@@ -8778,8 +8783,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			inode_unlock(inode);
 			relock = true;
 		}
-		ret = btrfs_delalloc_reserve_space(inode, offset, count,
-						   BTRFS_RESERVE_NORMAL);
+		ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
+					offset, count, BTRFS_RESERVE_NORMAL);
 		if (ret)
 			goto out;
 		dio_data.outstanding_extents = div64_u64(count +
@@ -8836,6 +8841,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (relock)
 		inode_lock(inode);
 
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
@@ -9067,6 +9073,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	char *kaddr;
 	unsigned long zero_start;
@@ -9095,7 +9102,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * end up waiting indefinitely to get a lock on the page currently
 	 * being processed by btrfs_page_mkwrite() function.
 	 */
-	ret = btrfs_delalloc_reserve_space(inode, page_start,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   reserved_space, reserve_type);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
@@ -9200,6 +9207,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 out_unlock:
 	if (!ret) {
 		sb_end_pagefault(inode->i_sb);
+		extent_changeset_release(&data_reserved);
 		return VM_FAULT_LOCKED;
 	}
 	unlock_page(page);
@@ -9208,6 +9216,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 				     reserve_type);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b799d91..8678104 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1128,6 +1128,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_io_tree *tree;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
@@ -1139,7 +1140,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-	ret = btrfs_delalloc_reserve_space(inode,
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, reserve_type);
 	if (ret)
@@ -1250,6 +1251,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		unlock_page(pages[i]);
 		put_page(pages[i]);
 	}
+	extent_changeset_release(&data_reserved);
 	return i_done;
 out:
 	for (i = 0; i < i_done; i++) {
@@ -1259,6 +1261,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	btrfs_delalloc_release_space(inode,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, reserve_type);
+	extent_changeset_release(&data_reserved);
 	return ret;
 
 }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8a6b07d..05d210f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2820,10 +2820,10 @@ btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
  *
  * NOTE: this function may sleep for memory allocation.
  */
-int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
+int btrfs_qgroup_reserve_data(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_changeset changeset;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	int ret;
@@ -2832,30 +2832,35 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 	    !is_fstree(root->objectid) || len == 0)
 		return 0;
 
-	changeset.bytes_changed = 0;
-	changeset.range_changed = ulist_alloc(GFP_NOFS);
+	/* @reserved parameter is mandatory for qgroup */
+	if (WARN_ON(!reserved))
+		return -EINVAL;
+	if (!reserved->range_changed) {
+		reserved->range_changed = ulist_alloc(GFP_NOFS);
+		if (!reserved->range_changed)
+			return -ENOMEM;
+	}
+
 	ret = set_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
-			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
+			start + len -1, EXTENT_QGROUP_RESERVED, reserved);
 	trace_btrfs_qgroup_reserve_data(inode, start, len,
-					changeset.bytes_changed,
+					reserved->bytes_changed,
 					QGROUP_RESERVE);
 	if (ret < 0)
 		goto cleanup;
-	ret = qgroup_reserve(root, changeset.bytes_changed);
+	ret = qgroup_reserve(root, reserved->bytes_changed);
 	if (ret < 0)
 		goto cleanup;
 
-	ulist_free(changeset.range_changed);
 	return ret;
 
 cleanup:
 	/* cleanup already reserved ranges */
 	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(changeset.range_changed, &uiter)))
+	while ((unode = ulist_next(reserved->range_changed, &uiter)))
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
 				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL,
 				 GFP_NOFS);
-	ulist_free(changeset.range_changed);
 	return ret;
 }
 
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 99c879d..a15baf5 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -177,7 +177,8 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 #endif
 
 /* New io_tree based accurate qgroup reserve API */
-int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len);
+int btrfs_qgroup_reserve_data(struct inode *inode,
+			struct extent_changeset *reserved, u64 start, u64 len);
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 77ca5b5..72ac7d7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3077,11 +3077,12 @@ int prealloc_file_extent_cluster(struct inode *inode,
 	u64 prealloc_start = cluster->start - offset;
 	u64 prealloc_end = cluster->end - offset;
 	u64 cur_offset;
+	struct extent_changeset data_reserved = EMPTY_CHANGESET;
 
 	BUG_ON(cluster->start != cluster->boundary[0]);
 	inode_lock(inode);
 
-	ret = btrfs_check_data_free_space(inode, prealloc_start,
+	ret = btrfs_check_data_free_space(inode, &data_reserved, prealloc_start,
 					  prealloc_end + 1 - prealloc_start);
 	if (ret)
 		goto out;
@@ -3113,6 +3114,7 @@ int prealloc_file_extent_cluster(struct inode *inode,
 				       prealloc_end + 1 - cur_offset);
 out:
 	inode_unlock(inode);
+	extent_changeset_release(&data_reserved);
 	return ret;
 }
 
-- 
2.7.4



