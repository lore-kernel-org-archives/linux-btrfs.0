Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18275 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754933AbbBJK1L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:11 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQOBT000908
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:24 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs: qgroup: do a reservation in a higher level.
Date: Tue, 10 Feb 2015 18:23:48 +0800
Message-ID: <1423563828-9053-5-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563828-9053-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563828-9053-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two problems in qgroup:

a). The PAGE_CACHE is 4K, even when we are writing a data of 1K,
qgroup will reserve a 4K size. It will cause the last 3K in a qgroup
is not available to user.

b). When user is writing a inline data, qgroup will not reserve it,
it means this is a window we can exceed the limit of a qgroup.

The main idea of this patch is reserving the data size of write_bytes
rather than the reserve_bytes. It means qgroup will not care about
the data size btrfs will reserve for user, but only care about the
data size user is going to write. Then reserve it when user want to
write and release it in transaction committed.

In this way, qgroup can be released from the complex procedure in
btrfs and only do the reserve when user want to write and account
when the data is written in commit_transaction().

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c | 38 +++++----------------------
 fs/btrfs/file.c        |  4 +--
 fs/btrfs/inode.c       | 15 -----------
 fs/btrfs/qgroup.c      | 70 +++-----------------------------------------------
 fs/btrfs/qgroup.h      |  4 ---
 fs/btrfs/relocation.c  |  2 +-
 7 files changed, 14 insertions(+), 121 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7e60741..1d17e7a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3433,7 +3433,7 @@ enum btrfs_reserve_flush_enum {
 	BTRFS_RESERVE_FLUSH_ALL,
 };
 
-int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
+int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 67c2e28..652be74 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3286,7 +3286,7 @@ again:
 	num_pages *= 16;
 	num_pages *= PAGE_CACHE_SIZE;
 
-	ret = btrfs_check_data_free_space(inode, num_pages);
+	ret = btrfs_check_data_free_space(inode, num_pages, num_pages);
 	if (ret)
 		goto out_put;
 
@@ -3673,7 +3673,7 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
  * This will check the space that the inode allocates from to make sure we have
  * enough space for bytes.
  */
-int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
+int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes)
 {
 	struct btrfs_space_info *data_sinfo;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -3774,7 +3774,7 @@ commit_trans:
 					      data_sinfo->flags, bytes, 1);
 		return -ENOSPC;
 	}
-	ret = btrfs_qgroup_reserve(root, bytes);
+	ret = btrfs_qgroup_reserve(root, write_bytes);
 	if (ret)
 		goto out;
 	data_sinfo->bytes_may_use += bytes;
@@ -3800,7 +3800,6 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	data_sinfo = root->fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
 	WARN_ON(data_sinfo->bytes_may_use < bytes);
-	btrfs_qgroup_free(root, bytes);
 	data_sinfo->bytes_may_use -= bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
 				      data_sinfo->flags, bytes, 0);
@@ -5041,8 +5040,6 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      u64 qgroup_reserved)
 {
 	btrfs_block_rsv_release(root, rsv, (u64)-1);
-	if (qgroup_reserved)
-		btrfs_qgroup_free(root, qgroup_reserved);
 }
 
 /**
@@ -5278,11 +5275,8 @@ out_fail:
 			to_free = 0;
 	}
 	spin_unlock(&BTRFS_I(inode)->lock);
-	if (dropped) {
-		if (root->fs_info->quota_enabled)
-			btrfs_qgroup_free(root, dropped * root->nodesize);
+	if (dropped)
 		to_free += btrfs_calc_trans_metadata_size(root, dropped);
-	}
 
 	if (to_free) {
 		btrfs_block_rsv_release(root, block_rsv, to_free);
@@ -5321,9 +5315,6 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 
 	trace_btrfs_space_reservation(root->fs_info, "delalloc",
 				      btrfs_ino(inode), to_free, 0);
-	if (root->fs_info->quota_enabled) {
-		btrfs_qgroup_free(root, dropped * root->nodesize);
-	}
 
 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
 				to_free);
@@ -5348,7 +5339,7 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes)
 {
 	int ret;
 
-	ret = btrfs_check_data_free_space(inode, num_bytes);
+	ret = btrfs_check_data_free_space(inode, num_bytes, num_bytes);
 	if (ret)
 		return ret;
 
@@ -5514,12 +5505,8 @@ static int pin_down_extent(struct btrfs_root *root,
 
 	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
-	if (reserved) {
-		btrfs_qgroup_update_reserved_bytes(root->fs_info,
-						   root->root_key.objectid,
-						   num_bytes, -1);
+	if (reserved)
 		trace_btrfs_reserved_extent_free(root, bytenr, num_bytes);
-	}
 	return 0;
 }
 
@@ -6250,9 +6237,6 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE, 0);
 		trace_btrfs_reserved_extent_free(root, buf->start, buf->len);
 		pin = 0;
-		btrfs_qgroup_update_reserved_bytes(root->fs_info,
-						   root->root_key.objectid,
-						   buf->len, -1);
 	}
 out:
 	if (pin)
@@ -6987,9 +6971,6 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 	else {
 		btrfs_add_free_space(cache, start, len);
 		btrfs_update_reserved_bytes(cache, len, RESERVE_FREE, delalloc);
-		btrfs_qgroup_update_reserved_bytes(root->fs_info,
-						   root->root_key.objectid,
-						   len, -1);
 	}
 
 	btrfs_put_block_group(cache);
@@ -7227,9 +7208,6 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	BUG_ON(ret); /* logic error */
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
-	btrfs_qgroup_update_reserved_bytes(root->fs_info,
-					   root->root_key.objectid,
-					   ins->offset, 1);
 	btrfs_put_block_group(block_group);
 	return ret;
 }
@@ -7376,10 +7354,6 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		return ERR_PTR(ret);
 	}
 
-	btrfs_qgroup_update_reserved_bytes(root->fs_info,
-					   root_objectid,
-					   ins.offset, 1);
-
 	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
 				    blocksize, level);
 	BUG_ON(IS_ERR(buf)); /* -ENOMEM */
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0ab1333..4172144 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1514,7 +1514,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
-		ret = btrfs_check_data_free_space(inode, reserve_bytes);
+		ret = btrfs_check_data_free_space(inode, reserve_bytes, write_bytes);
 		if (ret == -ENOSPC &&
 		    (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 					      BTRFS_INODE_PREALLOC))) {
@@ -2551,7 +2551,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	 * Make sure we have enough space before we do the
 	 * allocation.
 	 */
-	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start);
+	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start, alloc_end - alloc_start);
 	if (ret)
 		return ret;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e350cd6..f666191 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -746,9 +746,6 @@ retry:
 			}
 			goto out_free;
 		}
-		btrfs_qgroup_update_reserved_bytes(root->fs_info,
-						   root->root_key.objectid,
-						   ins.offset, 1);
 		/*
 		 * here we're doing allocation and writeback of the
 		 * compressed pages
@@ -973,10 +970,6 @@ static noinline int cow_file_range(struct inode *inode,
 		if (ret < 0)
 			goto out_unlock;
 
-		btrfs_qgroup_update_reserved_bytes(root->fs_info,
-						   root->root_key.objectid,
-						   ins.offset, 1);
-
 		em = alloc_extent_map();
 		if (!em) {
 			ret = -ENOMEM;
@@ -6804,10 +6797,6 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 		return ERR_PTR(ret);
 	}
 
-	btrfs_qgroup_update_reserved_bytes(root->fs_info,
-					   root->root_key.objectid,
-					   ins.offset, 1);
-
 	return em;
 }
 
@@ -9333,10 +9322,6 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			break;
 		}
 
-		btrfs_qgroup_update_reserved_bytes(root->fs_info,
-						   root->root_key.objectid,
-						   ins.offset, 1);
-
 		btrfs_drop_extent_cache(inode, cur_offset,
 					cur_offset + ins.offset -1, 0);
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0a86bb1..5a1463d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -72,7 +72,6 @@ struct btrfs_qgroup {
 	/*
 	 * reservation tracking
 	 */
-	u64 may_use;
 	u64 reserved;
 
 	/*
@@ -2397,67 +2396,6 @@ out:
 	return ret;
 }
 
-int btrfs_qgroup_update_reserved_bytes(struct btrfs_fs_info *fs_info,
-					    u64 ref_root,
-					    u64 num_bytes,
-					    int sign)
-{
-	struct btrfs_root *quota_root;
-	struct btrfs_qgroup *qgroup;
-	int ret = 0;
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
-
-	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
-		return 0;
-
-	if (num_bytes == 0)
-		return 0;
-
-	spin_lock(&fs_info->qgroup_lock);
-	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		goto out;
-
-	qgroup = find_qgroup_rb(fs_info, ref_root);
-	if (!qgroup)
-		goto out;
-
-	ulist_reinit(fs_info->qgroup_ulist);
-	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
-			(uintptr_t)qgroup, GFP_ATOMIC);
-	if (ret < 0)
-		goto out;
-
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
-		struct btrfs_qgroup *qg;
-		struct btrfs_qgroup_list *glist;
-
-		qg = u64_to_ptr(unode->aux);
-
-		qg->reserved += sign * num_bytes;
-
-		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(fs_info->qgroup_ulist,
-					glist->group->qgroupid,
-					(uintptr_t)glist->group, GFP_ATOMIC);
-			if (ret < 0)
-				goto out;
-		}
-	}
-
-out:
-	spin_unlock(&fs_info->qgroup_lock);
-	return ret;
-}
-
-/*
- * reserve some space for a qgroup and all its parents. The reservation takes
- * place with start_transaction or dealloc_reserve, similar to ENOSPC
- * accounting. If not enough space is available, EDQUOT is returned.
- * We assume that the requested space is new for all qgroups.
- */
 int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 {
 	struct btrfs_root *quota_root;
@@ -2500,14 +2438,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		qg = u64_to_ptr(unode->aux);
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    qg->reserved + qg->may_use + (s64)qg->rfer + num_bytes >
+		    qg->reserved + (s64)qg->rfer + num_bytes >
 		    qg->max_rfer) {
 			ret = -EDQUOT;
 			goto out;
 		}
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + qg->may_use + (s64)qg->excl + num_bytes >
+		    qg->reserved + (s64)qg->excl + num_bytes >
 		    qg->max_excl) {
 			ret = -EDQUOT;
 			goto out;
@@ -2531,7 +2469,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->may_use += num_bytes;
+		qg->reserved += num_bytes;
 	}
 
 out:
@@ -2577,7 +2515,7 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->may_use -= num_bytes;
+		qg->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 99f0487..52d8b19 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -97,10 +97,6 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
-int btrfs_qgroup_update_reserved_bytes(struct btrfs_fs_info *fs_info,
-				       u64 ref_root,
-				       u64 num_bytes,
-				       int sign);
 int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
 void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 74257d6..3b66cd7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3027,7 +3027,7 @@ int prealloc_file_extent_cluster(struct inode *inode,
 	mutex_lock(&inode->i_mutex);
 
 	ret = btrfs_check_data_free_space(inode, cluster->end +
-					  1 - cluster->start);
+					  1 - cluster->start, 0);
 	if (ret)
 		goto out;
 
-- 
1.8.4.2

