Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18275 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754917AbbBJK1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:09 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQMIi000902
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:22 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] Btrfs: qgroup: Introduce a may_use to account space_info->bytes_may_use.
Date: Tue, 10 Feb 2015 18:23:46 +0800
Message-ID: <1423563828-9053-3-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563828-9053-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563828-9053-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, for pre_alloc or delay_alloc, the bytes will be accounted
in space_info by the three guys.
space_info->bytes_may_use --- space_info->reserved --- space_info->used.
But on the other hand, in qgroup, there are only two counters to account the
bytes, qgroup->reserved and qgroup->excl. And qg->reserved accounts
bytes in space_info->bytes_may_use and qg->excl accounts bytes in
space_info->used. So the bytes in space_info->reserved is not accounted
in qgroup. If so, there is a window we can exceed the quota limit when
bytes is in space_info->reserved.

Example:
	# btrfs quota enable /mnt
	# btrfs qgroup limit -e 10M /mnt
	# for((i=0;i<20;i++));do fallocate -l 1M /mnt/data$i; done
	# sync
	# btrfs qgroup show -pcre /mnt
qgroupid rfer     excl     max_rfer max_excl parent  child
-------- ----     ----     -------- -------- ------  -----
0/5      20987904 20987904 0        10485760 ---     ---

qg->excl is 20987904 larger than max_excl 10485760.

This patch introduce a new counter named may_use to qgroup, then
there are three counters in qgroup to account bytes in space_info
as below.
space_info->bytes_may_use --- space_info->reserved --- space_info->used.
qgroup->may_use           --- qgroup->reserved     --- qgroup->excl

With this patch applied:
	# btrfs quota enable /mnt
	# btrfs qgroup limit -e 10M /mnt
	# for((i=0;i<20;i++));do fallocate -l 1M /mnt/data$i; done
fallocate: /mnt/data9: fallocate failed: Disk quota exceeded
fallocate: /mnt/data10: fallocate failed: Disk quota exceeded
fallocate: /mnt/data11: fallocate failed: Disk quota exceeded
fallocate: /mnt/data12: fallocate failed: Disk quota exceeded
fallocate: /mnt/data13: fallocate failed: Disk quota exceeded
fallocate: /mnt/data14: fallocate failed: Disk quota exceeded
fallocate: /mnt/data15: fallocate failed: Disk quota exceeded
fallocate: /mnt/data16: fallocate failed: Disk quota exceeded
fallocate: /mnt/data17: fallocate failed: Disk quota exceeded
fallocate: /mnt/data18: fallocate failed: Disk quota exceeded
fallocate: /mnt/data19: fallocate failed: Disk quota exceeded
	# sync
	# btrfs qgroup show -pcre /mnt
qgroupid rfer    excl    max_rfer max_excl parent  child
-------- ----    ----    -------- -------- ------  -----
0/5      9453568 9453568 0        10485760 ---     ---

Reported-by: Cyril SCETBON <cyril.scetbon@free.fr>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 20 ++++++++++++++-
 fs/btrfs/inode.c       | 18 ++++++++++++-
 fs/btrfs/qgroup.c      | 68 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/qgroup.h      |  4 +++
 4 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 88b4e32..d1a7ce0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5512,8 +5512,12 @@ static int pin_down_extent(struct btrfs_root *root,
 
 	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
-	if (reserved)
+	if (reserved) {
+		btrfs_qgroup_update_reserved_bytes(root->fs_info,
+						   root->root_key.objectid,
+						   num_bytes, -1);
 		trace_btrfs_reserved_extent_free(root, bytenr, num_bytes);
+	}
 	return 0;
 }
 
@@ -6244,6 +6248,9 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE, 0);
 		trace_btrfs_reserved_extent_free(root, buf->start, buf->len);
 		pin = 0;
+		btrfs_qgroup_update_reserved_bytes(root->fs_info,
+						   root->root_key.objectid,
+						   buf->len, -1);
 	}
 out:
 	if (pin)
@@ -6978,7 +6985,11 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 	else {
 		btrfs_add_free_space(cache, start, len);
 		btrfs_update_reserved_bytes(cache, len, RESERVE_FREE, delalloc);
+		btrfs_qgroup_update_reserved_bytes(root->fs_info,
+						   root->root_key.objectid,
+						   len, -1);
 	}
+
 	btrfs_put_block_group(cache);
 
 	trace_btrfs_reserved_extent_free(root, start, len);
@@ -7214,6 +7225,9 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	BUG_ON(ret); /* logic error */
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
+	btrfs_qgroup_update_reserved_bytes(root->fs_info,
+					   root->root_key.objectid,
+					   ins->offset, 1);
 	btrfs_put_block_group(block_group);
 	return ret;
 }
@@ -7360,6 +7374,10 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		return ERR_PTR(ret);
 	}
 
+	btrfs_qgroup_update_reserved_bytes(root->fs_info,
+					   root_objectid,
+					   ins.offset, 1);
+
 	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
 				    blocksize, level);
 	BUG_ON(IS_ERR(buf)); /* -ENOMEM */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e687bb0..e350cd6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -59,6 +59,7 @@
 #include "backref.h"
 #include "hash.h"
 #include "props.h"
+#include "qgroup.h"
 
 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -745,7 +746,9 @@ retry:
 			}
 			goto out_free;
 		}
-
+		btrfs_qgroup_update_reserved_bytes(root->fs_info,
+						   root->root_key.objectid,
+						   ins.offset, 1);
 		/*
 		 * here we're doing allocation and writeback of the
 		 * compressed pages
@@ -970,6 +973,10 @@ static noinline int cow_file_range(struct inode *inode,
 		if (ret < 0)
 			goto out_unlock;
 
+		btrfs_qgroup_update_reserved_bytes(root->fs_info,
+						   root->root_key.objectid,
+						   ins.offset, 1);
+
 		em = alloc_extent_map();
 		if (!em) {
 			ret = -ENOMEM;
@@ -6797,6 +6804,10 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 		return ERR_PTR(ret);
 	}
 
+	btrfs_qgroup_update_reserved_bytes(root->fs_info,
+					   root->root_key.objectid,
+					   ins.offset, 1);
+
 	return em;
 }
 
@@ -9321,6 +9332,11 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 				btrfs_end_transaction(trans, root);
 			break;
 		}
+
+		btrfs_qgroup_update_reserved_bytes(root->fs_info,
+						   root->root_key.objectid,
+						   ins.offset, 1);
+
 		btrfs_drop_extent_cache(inode, cur_offset,
 					cur_offset + ins.offset -1, 0);
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b57fe45..0a86bb1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -72,6 +72,7 @@ struct btrfs_qgroup {
 	/*
 	 * reservation tracking
 	 */
+	u64 may_use;
 	u64 reserved;
 
 	/*
@@ -1431,6 +1432,8 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
 	qgroup->excl += sign * oper->num_bytes;
 	qgroup->excl_cmpr += sign * oper->num_bytes;
+	if (sign > 0)
+		qgroup->reserved -= oper->num_bytes;
 
 	qgroup_dirty(fs_info, qgroup);
 
@@ -1450,6 +1453,8 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		qgroup->rfer_cmpr += sign * oper->num_bytes;
 		WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
 		qgroup->excl += sign * oper->num_bytes;
+		if (sign > 0)
+			qgroup->reserved -= oper->num_bytes;
 		qgroup->excl_cmpr += sign * oper->num_bytes;
 		qgroup_dirty(fs_info, qgroup);
 
@@ -2392,6 +2397,61 @@ out:
 	return ret;
 }
 
+int btrfs_qgroup_update_reserved_bytes(struct btrfs_fs_info *fs_info,
+					    u64 ref_root,
+					    u64 num_bytes,
+					    int sign)
+{
+	struct btrfs_root *quota_root;
+	struct btrfs_qgroup *qgroup;
+	int ret = 0;
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+
+	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
+		return 0;
+
+	if (num_bytes == 0)
+		return 0;
+
+	spin_lock(&fs_info->qgroup_lock);
+	quota_root = fs_info->quota_root;
+	if (!quota_root)
+		goto out;
+
+	qgroup = find_qgroup_rb(fs_info, ref_root);
+	if (!qgroup)
+		goto out;
+
+	ulist_reinit(fs_info->qgroup_ulist);
+	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
+			(uintptr_t)qgroup, GFP_ATOMIC);
+	if (ret < 0)
+		goto out;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
+		struct btrfs_qgroup *qg;
+		struct btrfs_qgroup_list *glist;
+
+		qg = u64_to_ptr(unode->aux);
+
+		qg->reserved += sign * num_bytes;
+
+		list_for_each_entry(glist, &qg->groups, next_group) {
+			ret = ulist_add(fs_info->qgroup_ulist,
+					glist->group->qgroupid,
+					(uintptr_t)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				goto out;
+		}
+	}
+
+out:
+	spin_unlock(&fs_info->qgroup_lock);
+	return ret;
+}
+
 /*
  * reserve some space for a qgroup and all its parents. The reservation takes
  * place with start_transaction or dealloc_reserve, similar to ENOSPC
@@ -2440,14 +2500,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		qg = u64_to_ptr(unode->aux);
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    qg->reserved + (s64)qg->rfer + num_bytes >
+		    qg->reserved + qg->may_use + (s64)qg->rfer + num_bytes >
 		    qg->max_rfer) {
 			ret = -EDQUOT;
 			goto out;
 		}
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + (s64)qg->excl + num_bytes >
+		    qg->reserved + qg->may_use + (s64)qg->excl + num_bytes >
 		    qg->max_excl) {
 			ret = -EDQUOT;
 			goto out;
@@ -2471,7 +2531,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->reserved += num_bytes;
+		qg->may_use += num_bytes;
 	}
 
 out:
@@ -2517,7 +2577,7 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->reserved -= num_bytes;
+		qg->may_use -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 52d8b19..99f0487 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -97,6 +97,10 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
+int btrfs_qgroup_update_reserved_bytes(struct btrfs_fs_info *fs_info,
+				       u64 ref_root,
+				       u64 num_bytes,
+				       int sign);
 int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
 void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes);
 
-- 
1.8.4.2

