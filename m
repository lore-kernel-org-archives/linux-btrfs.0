Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41144 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab2KUCVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Nov 2012 21:21:04 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAL2L25A023638
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2012 10:21:02 +0800
Message-ID: <50AC3AA8.7050008@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:21:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use slabs for delayed reference allocation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The delayed reference allocation is in the fast path of the IO, so use slabs
to improve the speed of the allocation.

And besides that, it can do check for leaked objects when the module is removed.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 74 ++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/delayed-ref.h | 37 ++++++++++++++++++++++++-
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent-tree.c | 12 ++++----
 fs/btrfs/super.c       |  9 +++++-
 5 files changed, 114 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 364cb90..b7a0641 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -23,6 +23,10 @@
 #include "delayed-ref.h"
 #include "transaction.h"
 
+struct kmem_cache *btrfs_delayed_ref_head_cachep;
+struct kmem_cache *btrfs_delayed_tree_ref_cachep;
+struct kmem_cache *btrfs_delayed_data_ref_cachep;
+struct kmem_cache *btrfs_delayed_extent_op_cachep;
 /*
  * delayed back reference update tracking.  For subvolume trees
  * we queue up extent allocations and backref maintenance for
@@ -519,7 +523,7 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
 					ref->extent_op->flags_to_set;
 				existing_ref->extent_op->update_flags = 1;
 			}
-			kfree(ref->extent_op);
+			btrfs_free_delayed_extent_op(ref->extent_op);
 		}
 	}
 	/*
@@ -600,7 +604,7 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(head_ref);
+		kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
 	} else {
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
@@ -661,7 +665,7 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(full_ref);
+		kmem_cache_free(btrfs_delayed_tree_ref_cachep, full_ref);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
@@ -722,7 +726,7 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(full_ref);
+		kmem_cache_free(btrfs_delayed_data_ref_cachep, full_ref);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
@@ -746,13 +750,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	BUG_ON(extent_op && extent_op->is_data);
-	ref = kmalloc(sizeof(*ref), GFP_NOFS);
+	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
 	if (!ref)
 		return -ENOMEM;
 
-	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
+	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
 	if (!head_ref) {
-		kfree(ref);
+		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
 		return -ENOMEM;
 	}
 
@@ -794,13 +798,13 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	BUG_ON(extent_op && !extent_op->is_data);
-	ref = kmalloc(sizeof(*ref), GFP_NOFS);
+	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
 	if (!ref)
 		return -ENOMEM;
 
-	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
+	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
 	if (!head_ref) {
-		kfree(ref);
+		kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
 		return -ENOMEM;
 	}
 
@@ -834,7 +838,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 
-	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
+	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
 	if (!head_ref)
 		return -ENOMEM;
 
@@ -868,3 +872,51 @@ btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr)
 		return btrfs_delayed_node_to_head(ref);
 	return NULL;
 }
+
+void btrfs_delayed_ref_exit(void)
+{
+	if (btrfs_delayed_ref_head_cachep)
+		kmem_cache_destroy(btrfs_delayed_ref_head_cachep);
+	if (btrfs_delayed_tree_ref_cachep)
+		kmem_cache_destroy(btrfs_delayed_tree_ref_cachep);
+	if (btrfs_delayed_data_ref_cachep)
+		kmem_cache_destroy(btrfs_delayed_data_ref_cachep);
+	if (btrfs_delayed_extent_op_cachep)
+		kmem_cache_destroy(btrfs_delayed_extent_op_cachep);
+}
+
+int btrfs_delayed_ref_init(void)
+{
+	btrfs_delayed_ref_head_cachep = kmem_cache_create(
+				"btrfs_delayed_ref_head",
+				sizeof(struct btrfs_delayed_ref_head), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!btrfs_delayed_ref_head_cachep)
+		goto fail;
+
+	btrfs_delayed_tree_ref_cachep = kmem_cache_create(
+				"btrfs_delayed_tree_ref",
+				sizeof(struct btrfs_delayed_tree_ref), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!btrfs_delayed_tree_ref_cachep)
+		goto fail;
+
+	btrfs_delayed_data_ref_cachep = kmem_cache_create(
+				"btrfs_delayed_data_ref",
+				sizeof(struct btrfs_delayed_data_ref), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!btrfs_delayed_data_ref_cachep)
+		goto fail;
+
+	btrfs_delayed_extent_op_cachep = kmem_cache_create(
+				"btrfs_delayed_extent_op",
+				sizeof(struct btrfs_delayed_extent_op), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!btrfs_delayed_extent_op_cachep)
+		goto fail;
+
+	return 0;
+fail:
+	btrfs_delayed_ref_exit();
+	return -ENOMEM;
+}
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index fcc5a29..0014ea4 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -141,12 +141,47 @@ struct btrfs_delayed_ref_root {
 	u64 run_delayed_start;
 };
 
+extern struct kmem_cache *btrfs_delayed_ref_head_cachep;
+extern struct kmem_cache *btrfs_delayed_tree_ref_cachep;
+extern struct kmem_cache *btrfs_delayed_data_ref_cachep;
+extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
+
+int btrfs_delayed_ref_init(void);
+void btrfs_delayed_ref_exit(void);
+
+static inline struct btrfs_delayed_extent_op *
+btrfs_alloc_delayed_extent_op(void)
+{
+	return kmem_cache_alloc(btrfs_delayed_extent_op_cachep, GFP_NOFS);
+}
+
+static inline void
+btrfs_free_delayed_extent_op(struct btrfs_delayed_extent_op *op)
+{
+	if (op)
+		kmem_cache_free(btrfs_delayed_extent_op_cachep, op);
+}
+
 static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
 {
 	WARN_ON(atomic_read(&ref->refs) == 0);
 	if (atomic_dec_and_test(&ref->refs)) {
 		WARN_ON(ref->in_tree);
-		kfree(ref);
+		switch (ref->type) {
+		case BTRFS_TREE_BLOCK_REF_KEY:
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
+			break;
+		case BTRFS_EXTENT_DATA_REF_KEY:
+		case BTRFS_SHARED_DATA_REF_KEY:
+			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
+			break;
+		case 0:
+			kmem_cache_free(btrfs_delayed_ref_head_cachep, ref);
+			break;
+		default:
+			BUG();
+		}
 	}
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7cda519..6ef8f18 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3572,7 +3572,7 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				continue;
 			}
 
-			kfree(head->extent_op);
+			btrfs_free_delayed_extent_op(head->extent_op);
 			delayed_refs->num_heads--;
 			if (list_empty(&head->cluster))
 				delayed_refs->num_heads_ready--;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 93faf5e..c889629 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2301,7 +2301,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 			ref = &locked_ref->node;
 
 			if (extent_op && must_insert_reserved) {
-				kfree(extent_op);
+				btrfs_free_delayed_extent_op(extent_op);
 				extent_op = NULL;
 			}
 
@@ -2310,7 +2310,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 
 				ret = run_delayed_extent_op(trans, root,
 							    ref, extent_op);
-				kfree(extent_op);
+				btrfs_free_delayed_extent_op(extent_op);
 
 				if (ret) {
 					printk(KERN_DEBUG
@@ -2350,7 +2350,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 
 		ret = run_one_delayed_ref(trans, root, ref, extent_op,
 					  must_insert_reserved);
-		kfree(extent_op);
+		btrfs_free_delayed_extent_op(extent_op);
 		if (ret) {
 			btrfs_delayed_ref_unlock(locked_ref);
 			btrfs_put_delayed_ref(ref);
@@ -2608,7 +2608,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_extent_op *extent_op;
 	int ret;
 
-	extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+	extent_op = btrfs_alloc_delayed_extent_op();
 	if (!extent_op)
 		return -ENOMEM;
 
@@ -2620,7 +2620,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 	ret = btrfs_add_delayed_extent_op(root->fs_info, trans, bytenr,
 					  num_bytes, extent_op);
 	if (ret)
-		kfree(extent_op);
+		btrfs_free_delayed_extent_op(extent_op);
 	return ret;
 }
 
@@ -5303,7 +5303,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (head->extent_op) {
 		if (!head->must_insert_reserved)
 			goto out;
-		kfree(head->extent_op);
+		btrfs_free_delayed_extent_op(head->extent_op);
 		head->extent_op = NULL;
 	}
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..4b6e4cc 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1647,10 +1647,14 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_ordered_data;
 
-	err = btrfs_interface_init();
+	err = btrfs_delayed_ref_init();
 	if (err)
 		goto free_delayed_inode;
 
+	err = btrfs_interface_init();
+	if (err)
+		goto free_delayed_ref;
+
 	err = register_filesystem(&btrfs_fs_type);
 	if (err)
 		goto unregister_ioctl;
@@ -1662,6 +1666,8 @@ static int __init init_btrfs_fs(void)
 
 unregister_ioctl:
 	btrfs_interface_exit();
+free_delayed_ref:
+	btrfs_delayed_ref_exit();
 free_delayed_inode:
 	btrfs_delayed_inode_exit();
 free_ordered_data:
@@ -1681,6 +1687,7 @@ free_compress:
 static void __exit exit_btrfs_fs(void)
 {
 	btrfs_destroy_cachep();
+	btrfs_delayed_ref_exit();
 	btrfs_delayed_inode_exit();
 	ordered_data_exit();
 	extent_map_exit();
-- 
1.7.11.7

