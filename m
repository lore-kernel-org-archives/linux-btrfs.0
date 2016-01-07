Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43542 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752365AbcAGBIn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:43 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id EBDCF41887C1
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:21 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 05/16] btrfs: delayed-ref: Add support for atomic increasing extent ref
Date: Thu, 7 Jan 2016 09:08:06 +0800
Message-ID: <1452128897-5433-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Slightly modify btrfs_add_delayed_data_ref() to allow it accept
GFP_ATOMIC, and allow it to do be called inside a spinlock.

This is used by later dedup patches.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v3:
  Newly introduced
---
 fs/btrfs/ctree.h       |  4 ++++
 fs/btrfs/delayed-ref.c | 25 +++++++++++++++++--------
 fs/btrfs/delayed-ref.h |  2 +-
 fs/btrfs/extent-tree.c | 24 +++++++++++++++++++++---
 4 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 62fed1d..450790b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3469,6 +3469,10 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner, u64 offset);
+int btrfs_inc_extent_ref_atomic(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root, u64 bytenr,
+				u64 num_bytes, u64 parent,
+				u64 root_objectid, u64 owner, u64 offset);
 
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e06dd75..94609ec 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -812,26 +812,31 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
-			       struct btrfs_delayed_extent_op *extent_op)
+			       int atomic)
 {
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
+	gfp_t gfp_flags;
+
+	if (atomic)
+		gfp_flags = GFP_ATOMIC;
+	else
+		gfp_flags = GFP_NOFS;
 
-	BUG_ON(extent_op && !extent_op->is_data);
-	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
+	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, gfp_flags);
 	if (!ref)
 		return -ENOMEM;
 
-	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
+	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, gfp_flags);
 	if (!head_ref) {
 		kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
 		return -ENOMEM;
 	}
 
 	if (fs_info->quota_enabled && is_fstree(ref_root)) {
-		record = kmalloc(sizeof(*record), GFP_NOFS);
+		record = kmalloc(sizeof(*record), gfp_flags);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
 			kmem_cache_free(btrfs_delayed_ref_head_cachep,
@@ -840,10 +845,13 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	head_ref->extent_op = extent_op;
+	head_ref->extent_op = NULL;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	spin_lock(&delayed_refs->lock);
+
+	/* For atomic case, caller should already hold the delayed_refs lock */
+	if (!atomic)
+		spin_lock(&delayed_refs->lock);
 
 	/*
 	 * insert both the head node and the new ref without dropping
@@ -856,7 +864,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action);
-	spin_unlock(&delayed_refs->lock);
+	if (!atomic)
+		spin_unlock(&delayed_refs->lock);
 
 	return 0;
 }
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 00ed02c..8928fe7 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -249,7 +249,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
-			       struct btrfs_delayed_extent_op *extent_op);
+			       int atomic);
 int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
 				     struct btrfs_trans_handle *trans,
 				     u64 ref_root, u64 bytenr, u64 num_bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c4661db..d80f74d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2089,11 +2089,29 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
 					num_bytes, parent, root_objectid,
 					owner, offset, 0,
-					BTRFS_ADD_DELAYED_REF, NULL);
+					BTRFS_ADD_DELAYED_REF, 0);
 	}
 	return ret;
 }
 
+int btrfs_inc_extent_ref_atomic(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root, u64 bytenr,
+				u64 num_bytes, u64 parent,
+				u64 root_objectid, u64 owner, u64 offset)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
+	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
+
+	/* Only used by dedup, so only data is possible */
+	if (WARN_ON(owner < BTRFS_FIRST_FREE_OBJECTID))
+		return -EINVAL;
+	return btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
+			num_bytes, parent, root_objectid,
+			owner, offset, 0, BTRFS_ADD_DELAYED_REF, 1);
+}
+
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  struct btrfs_delayed_ref_node *node,
@@ -6836,7 +6854,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 						num_bytes,
 						parent, root_objectid, owner,
 						offset, 0,
-						BTRFS_DROP_DELAYED_REF, NULL);
+						BTRFS_DROP_DELAYED_REF, 0);
 	}
 	return ret;
 }
@@ -7778,7 +7796,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 					 ins->offset, 0,
 					 root_objectid, owner, offset,
 					 ram_bytes, BTRFS_ADD_DELAYED_EXTENT,
-					 NULL);
+					 0);
 	return ret;
 }
 
-- 
2.6.4



