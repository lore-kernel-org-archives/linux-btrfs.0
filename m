From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 75/99] btrfs: Use mempools for delayed refs
Date: Wed, 23 Nov 2011 19:36:48 -0500
Message-ID: <20111124004228.498879042@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch converts the delayed ref code to use slab cache-backed mempools
 for allocating its nodes.

 The allocations happen deep in the call path where error recovery is
 impossible.

 By using mempools, we ensure that the allocations can't fail. Each
 mempool keeps a page of structures available for each type.

 This also has an advantage of eliminating the error path from a big
 chunk of code, simplifying the error handling.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-ref.c |  119 ++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/delayed-ref.h |    6 ++-
 fs/btrfs/super.c       |    9 +++-
 3 files changed, 107 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e388ca3..a70c40d 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -18,11 +18,20 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/mempool.h>
 #include <linux/sort.h>
 #include "ctree.h"
 #include "delayed-ref.h"
 #include "transaction.h"
 
+static struct kmem_cache *ref_head_cache;
+static struct kmem_cache *tree_ref_cache;
+static struct kmem_cache *data_ref_cache;
+
+static mempool_t *ref_head_pool;
+static mempool_t *tree_ref_pool;
+static mempool_t *data_ref_pool;
+
 /*
  * delayed back reference update tracking.  For subvolume trees
  * we queue up extent allocations and backref maintenance for
@@ -455,7 +464,7 @@ static noinline void add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(head_ref);
+		mempool_free(head_ref, ref_head_pool);
 	} else {
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
@@ -510,7 +519,7 @@ static noinline void add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(full_ref);
+		mempool_free(full_ref, tree_ref_pool);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
@@ -565,7 +574,7 @@ static noinline void add_delayed_data_ref(struct btrfs_trans_handle *trans,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(full_ref);
+		mempool_free(full_ref, data_ref_pool);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
@@ -587,15 +596,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	BUG_ON(extent_op && extent_op->is_data);
-	ref = kmalloc(sizeof(*ref), GFP_NOFS);
-	if (!ref)
-		return -ENOMEM;
-
-	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
-	if (!head_ref) {
-		kfree(ref);
-		return -ENOMEM;
-	}
+	ref = mempool_alloc(tree_ref_pool, GFP_NOFS);
+	head_ref = mempool_alloc(ref_head_pool, GFP_NOFS);
 
 	head_ref->extent_op = extent_op;
 
@@ -628,15 +630,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	BUG_ON(extent_op && !extent_op->is_data);
-	ref = kmalloc(sizeof(*ref), GFP_NOFS);
-	if (!ref)
-		return -ENOMEM;
-
-	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
-	if (!head_ref) {
-		kfree(ref);
-		return -ENOMEM;
-	}
+	ref = mempool_alloc(data_ref_pool, GFP_NOFS);
+	head_ref = mempool_alloc(ref_head_pool, GFP_NOFS);
 
 	head_ref->extent_op = extent_op;
 
@@ -662,10 +657,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 
-	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
-	if (!head_ref)
-		return -ENOMEM;
-
+	head_ref = mempool_alloc(ref_head_pool, GFP_NOFS);
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -694,3 +686,80 @@ btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr)
 		return btrfs_delayed_node_to_head(ref);
 	return NULL;
 }
+
+void btrfs_free_delayed_ref(struct btrfs_delayed_ref_node *ref)
+{
+	if (!ref->type)
+		mempool_free(ref, ref_head_pool);
+	else if (ref->type == BTRFS_SHARED_BLOCK_REF_KEY ||
+		 ref->type == BTRFS_TREE_BLOCK_REF_KEY)
+		mempool_free(ref, tree_ref_pool);
+	else if (ref->type == BTRFS_SHARED_DATA_REF_KEY ||
+		 ref->type == BTRFS_EXTENT_DATA_REF_KEY)
+		mempool_free(ref, data_ref_pool);
+	else
+		BUG();
+}
+
+void
+btrfs_destroy_delayed_ref_caches(void)
+{
+	if (data_ref_pool)
+		mempool_destroy(data_ref_pool);
+	if (data_ref_cache)
+		kmem_cache_destroy(data_ref_cache);
+
+	if (tree_ref_pool)
+		mempool_destroy(tree_ref_pool);
+	if (tree_ref_cache)
+		kmem_cache_destroy(tree_ref_cache);
+
+	if (ref_head_pool)
+		mempool_destroy(ref_head_pool);
+	if (ref_head_cache)
+		kmem_cache_destroy(ref_head_cache);
+}
+
+int __init
+btrfs_create_delayed_ref_caches(void)
+{
+	int objsize = sizeof(struct btrfs_delayed_ref_head);
+	ref_head_cache = kmem_cache_create("btrfs_delayed_ref_head", objsize,
+					   0, 0, NULL);
+	if (!ref_head_cache)
+		goto error;
+
+	ref_head_pool = mempool_create_slab_pool(PAGE_SIZE/objsize,
+						 ref_head_cache);
+	if (!ref_head_pool)
+		goto error;
+
+
+	objsize = sizeof(struct btrfs_delayed_tree_ref);
+	tree_ref_cache = kmem_cache_create("btrfs_delayed_tree_ref", objsize,
+					   0, 0, NULL);
+	if (!tree_ref_cache)
+		goto error;
+
+	tree_ref_pool = mempool_create_slab_pool(PAGE_SIZE/objsize,
+						 tree_ref_cache);
+	if (!tree_ref_pool)
+		goto error;
+
+
+	objsize = sizeof(struct btrfs_delayed_data_ref);
+	data_ref_cache = kmem_cache_create("btrfs_delayed_data_ref", objsize,
+					   0, 0, NULL);
+	if (!data_ref_cache)
+		goto error;
+
+	data_ref_pool = mempool_create_slab_pool(PAGE_SIZE/objsize,
+						 data_ref_cache);
+	if (!data_ref_pool)
+		goto error;
+
+	return 0;
+error:
+	btrfs_destroy_delayed_ref_caches();
+	return -ENOMEM;
+}
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index e287e3b..6c41d8d 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -142,12 +142,13 @@ struct btrfs_delayed_ref_root {
 	u64 run_delayed_start;
 };
 
+void btrfs_free_delayed_ref(struct btrfs_delayed_ref_node *ref);
 static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
 {
 	WARN_ON(atomic_read(&ref->refs) == 0);
 	if (atomic_dec_and_test(&ref->refs)) {
 		WARN_ON(ref->in_tree);
-		kfree(ref);
+		btrfs_free_delayed_ref(ref);
 	}
 }
 
@@ -202,4 +203,7 @@ btrfs_delayed_node_to_head(struct btrfs_delayed_ref_node *node)
 	WARN_ON(!btrfs_delayed_ref_is_head(node));
 	return container_of(node, struct btrfs_delayed_ref_head, node);
 }
+
+int btrfs_create_delayed_ref_caches(void);
+void btrfs_destroy_delayed_ref_caches(void);
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 26e1dcf..9719312 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1369,13 +1369,19 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_delayed_inode;
 
-	err = register_filesystem(&btrfs_fs_type);
+	err = btrfs_create_delayed_ref_caches();
 	if (err)
 		goto unregister_ioctl;
 
+	err = register_filesystem(&btrfs_fs_type);
+	if (err)
+		goto free_delayed_ref_caches;
+
 	printk(KERN_INFO "%s loaded\n", BTRFS_BUILD_VERSION);
 	return 0;
 
+free_delayed_ref_caches:
+	btrfs_destroy_delayed_ref_caches();
 unregister_ioctl:
 	btrfs_interface_exit();
 free_delayed_inode:
@@ -1394,6 +1400,7 @@ free_compress:
 
 static void __exit exit_btrfs_fs(void)
 {
+	btrfs_destroy_delayed_ref_caches();
 	btrfs_destroy_cachep();
 	btrfs_delayed_inode_exit();
 	extent_map_exit();



