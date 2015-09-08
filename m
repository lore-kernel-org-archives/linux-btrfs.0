Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48982 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbbIIFF3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 01:05:29 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t888dQvH019126
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 16:39:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 18/19] btrfs: qgroup: Cleanup old inaccurate facilities
Date: Tue,  8 Sep 2015 16:37:35 +0800
Message-Id: <1441701456-8034-19-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441701456-8034-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441701456-8034-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup the old facilities which use old btrfs_qgroup_reserve() function
call, replace them with the newer version, and remove the "__" prefix in
them.

Also, make btrfs_qgroup_reserve/free() functions private, as they are
now only used inside qgroup codes.

Now, the whole btrfs qgroup is swithed to use the new reserve facilities.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  6 ++----
 fs/btrfs/extent-tree.c | 56 ++++----------------------------------------------
 fs/btrfs/file.c        |  2 +-
 fs/btrfs/inode-map.c   |  2 +-
 fs/btrfs/inode.c       | 12 +++++------
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/qgroup.c      | 19 ++++++++++-------
 fs/btrfs/qgroup.h      |  7 -------
 8 files changed, 27 insertions(+), 79 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 12f14fd..8489419 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3452,8 +3452,7 @@ enum btrfs_reserve_flush_enum {
 	BTRFS_RESERVE_FLUSH_ALL,
 };
 
-int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes);
-int __btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
+int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
 int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
@@ -3471,8 +3470,7 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      u64 qgroup_reserved);
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
-int __btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 07f45b7..ab1b1a1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3352,7 +3352,7 @@ again:
 	num_pages *= 16;
 	num_pages *= PAGE_CACHE_SIZE;
 
-	ret = __btrfs_check_data_free_space(inode, 0, num_pages);
+	ret = btrfs_check_data_free_space(inode, 0, num_pages);
 	if (ret)
 		goto out_put;
 
@@ -4037,27 +4037,11 @@ commit_trans:
 }
 
 /*
- * This will check the space that the inode allocates from to make sure we have
- * enough space for bytes.
- */
-int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes)
-{
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	int ret;
-
-	ret = btrfs_alloc_data_chunk_ondemand(inode, bytes);
-	if (ret < 0)
-		return ret;
-	ret = btrfs_qgroup_reserve(root, write_bytes);
-	return ret;
-}
-
-/*
  * New check_data_free_space() with ability for precious data reserveation
  * Will replace old btrfs_check_data_free_space(), but for patch split,
  * add a new function first and then replace it.
  */
-int __btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
+int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -5710,11 +5694,11 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
  * Return 0 for success
  * Return <0 for error(-ENOSPC or -EQUOT)
  */
-int __btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
 {
 	int ret;
 
-	ret = __btrfs_check_data_free_space(inode, start, len);
+	ret = btrfs_check_data_free_space(inode, start, len);
 	if (ret < 0)
 		return ret;
 	ret = btrfs_delalloc_reserve_metadata(inode, len);
@@ -5724,38 +5708,6 @@ int __btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
 }
 
 /**
- * btrfs_delalloc_reserve_space - reserve data and metadata space for delalloc
- * @inode: inode we're writing to
- * @num_bytes: the number of bytes we want to allocate
- *
- * This will do the following things
- *
- * o reserve space in the data space info for num_bytes
- * o reserve space in the metadata space info based on number of outstanding
- *   extents and how much csums will be needed
- * o add to the inodes ->delalloc_bytes
- * o add it to the fs_info's delalloc inodes list.
- *
- * This will return 0 for success and -ENOSPC if there is no space left.
- */
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes)
-{
-	int ret;
-
-	ret = btrfs_check_data_free_space(inode, num_bytes, num_bytes);
-	if (ret)
-		return ret;
-
-	ret = btrfs_delalloc_reserve_metadata(inode, num_bytes);
-	if (ret) {
-		btrfs_free_reserved_data_space(inode, num_bytes);
-		return ret;
-	}
-
-	return 0;
-}
-
-/**
  * btrfs_delalloc_release_space - release data and metadata space for delalloc
  * @inode: inode we're releasing space for
  * @num_bytes: the number of bytes we want to free up
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 26e59bc..124c1d4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1532,7 +1532,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				goto reserve_metadata;
 			}
 		}
-		ret = __btrfs_check_data_free_space(inode, pos, write_bytes);
+		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
 		if (ret < 0)
 			break;
 
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index ab639d3..9a0ad27 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -488,7 +488,7 @@ again:
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_CACHE_SIZE;
 
-	ret = __btrfs_delalloc_reserve_space(inode, 0, prealloc);
+	ret = btrfs_delalloc_reserve_space(inode, 0, prealloc);
 	if (ret)
 		goto out_put;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d70cb26..8c09197 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1985,8 +1985,8 @@ again:
 		goto again;
 	}
 
-	ret = __btrfs_delalloc_reserve_space(inode, page_start,
-					     PAGE_CACHE_SIZE);
+	ret = btrfs_delalloc_reserve_space(inode, page_start,
+					   PAGE_CACHE_SIZE);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
 		end_extent_writepage(page, ret, page_start, page_end);
@@ -4582,7 +4582,7 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
-	ret = __btrfs_delalloc_reserve_space(inode,
+	ret = btrfs_delalloc_reserve_space(inode,
 			round_down(from, PAGE_CACHE_SIZE), PAGE_CACHE_SIZE);
 	if (ret)
 		goto out;
@@ -8375,7 +8375,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			mutex_unlock(&inode->i_mutex);
 			relock = true;
 		}
-		ret = __btrfs_delalloc_reserve_space(inode, offset, count);
+		ret = btrfs_delalloc_reserve_space(inode, offset, count);
 		if (ret)
 			goto out;
 		outstanding_extents = div64_u64(count +
@@ -8625,8 +8625,8 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	page_start = page_offset(page);
 	page_end = page_start + PAGE_CACHE_SIZE - 1;
 
-	ret = __btrfs_delalloc_reserve_space(inode, page_start,
-					     PAGE_CACHE_SIZE);
+	ret = btrfs_delalloc_reserve_space(inode, page_start,
+					   PAGE_CACHE_SIZE);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
 		reserved = 1;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e0291fc..c057317 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1119,7 +1119,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
-	ret = __btrfs_delalloc_reserve_space(inode,
+	ret = btrfs_delalloc_reserve_space(inode,
 			start_index << PAGE_CACHE_SHIFT,
 			page_cnt << PAGE_CACHE_SHIFT);
 	if (ret)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b759e96..5f7d7f5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2088,7 +2088,7 @@ out:
 	return ret;
 }
 
-int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
+static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -2221,6 +2221,11 @@ out:
 	spin_unlock(&fs_info->qgroup_lock);
 }
 
+static inline void qgroup_free(struct btrfs_root *root, u64 num_bytes)
+{
+	return btrfs_qgroup_free_refroot(root->fs_info, root->objectid,
+					 num_bytes);
+}
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 {
 	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
@@ -2782,7 +2787,7 @@ static int reserve_data_range(struct btrfs_root *root,
 		cur_start = next_start;
 	}
 insert:
-	ret = btrfs_qgroup_reserve(root, reserve);
+	ret = qgroup_reserve(root, reserve);
 	if (ret < 0)
 		return ret;
 	/* ranges must be inserted after we are sure it has enough space */
@@ -3001,7 +3006,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 	if (ret == 0)
 		kfree(tmp);
 	if (free_reserved)
-		btrfs_qgroup_free(BTRFS_I(inode)->root, reserved);
+		qgroup_free(BTRFS_I(inode)->root, reserved);
 	spin_unlock(&map->lock);
 	return 0;
 }
@@ -3089,7 +3094,7 @@ void btrfs_qgroup_free_data_rsv_map(struct inode *inode)
 	/* insanity check */
 	WARN_ON(!root->fs_info->quota_enabled || !is_fstree(root->objectid));
 
-	btrfs_qgroup_free(root, dirty_map->reserved);
+	qgroup_free(root, dirty_map->reserved);
 	spin_lock(&dirty_map->lock);
 	while ((node = rb_first(&dirty_map->root)) != NULL) {
 		struct data_rsv_range *range;
@@ -3112,7 +3117,7 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes)
 		return 0;
 
 	BUG_ON(num_bytes != round_down(num_bytes, root->nodesize));
-	ret = btrfs_qgroup_reserve(root, num_bytes);
+	ret = qgroup_reserve(root, num_bytes);
 	if (ret < 0)
 		return ret;
 	atomic_add(num_bytes, &root->qgroup_meta_rsv);
@@ -3129,7 +3134,7 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
 	reserved = atomic_xchg(&root->qgroup_meta_rsv, 0);
 	if (reserved == 0)
 		return;
-	btrfs_qgroup_free(root, reserved);
+	qgroup_free(root, reserved);
 }
 
 void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
@@ -3140,5 +3145,5 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
 	BUG_ON(num_bytes != round_down(num_bytes, root->nodesize));
 	WARN_ON(atomic_read(&root->qgroup_meta_rsv) < num_bytes);
 	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
-	btrfs_qgroup_free(root, num_bytes);
+	qgroup_free(root, num_bytes);
 }
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 2d507c8..da849db 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -74,15 +74,8 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
-int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
 void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 			       u64 ref_root, u64 num_bytes);
-static inline void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
-{
-	return btrfs_qgroup_free_refroot(root->fs_info, root->objectid,
-					 num_bytes);
-}
-
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-- 
2.5.1

