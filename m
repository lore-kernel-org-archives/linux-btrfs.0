From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 7/7] Btrfs: Support reading/writing on disk free ino cache
Date: Mon, 25 Apr 2011 17:00:05 +0800
Message-ID: <4DB53815.4050009@cn.fujitsu.com>
References: <4DB5378B.2070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB5378B.2070904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is similar to block group caching.

We dedicate a special inode in fs tree to save free ino cache.

At the very first time we create/delete a file after mount, the free ino
cache will be loaded from disk into memory. When the fs tree is commited,
the cache will be written back to disk.

To keep compatibility, we check the root generation against the generation
of the special inode when loading the cache, so the loading will fail
if the btrfs filesystem was mounted in an older kernel before.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h            |    7 +++
 fs/btrfs/disk-io.c          |    1 +
 fs/btrfs/extent-tree.c      |    3 +-
 fs/btrfs/free-space-cache.c |   97 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/free-space-cache.h |   11 +++++
 fs/btrfs/inode-map.c        |   87 ++++++++++++++++++++++++++++++++++++++
 fs/btrfs/inode-map.h        |    2 +
 fs/btrfs/inode.c            |   45 ++++++++++++--------
 fs/btrfs/transaction.c      |    2 +
 9 files changed, 236 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c96a4e4..b20082e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -105,6 +105,12 @@ struct btrfs_ordered_sum;
 /* For storing free space cache */
 #define BTRFS_FREE_SPACE_OBJECTID -11ULL
 
+/*
+ * The inode number assigned to the special inode for sotring
+ * free ino cache
+ */
+#define BTRFS_FREE_INO_OBJECTID -12ULL
+
 /* dummy objectid represents multiple objectids */
 #define BTRFS_MULTIPLE_OBJECTIDS -255ULL
 
@@ -1110,6 +1116,7 @@ struct btrfs_root {
 	wait_queue_head_t cache_wait;
 	struct btrfs_free_space_ctl *free_ino_pinned;
 	u64 cache_progress;
+	struct inode *cache_inode;
 
 	struct mutex log_mutex;
 	wait_queue_head_t log_writer_wait;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d02683b..4f12c30 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2505,6 +2505,7 @@ int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 
 static void free_fs_root(struct btrfs_root *root)
 {
+	iput(root->cache_inode);
 	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
 	if (root->anon_super.s_dev) {
 		down_write(&root->anon_super.s_umount);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0e818c..95ce8da 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3145,7 +3145,8 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
-	if (root == root->fs_info->tree_root) {
+	if (root == root->fs_info->tree_root ||
+	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID) {
 		alloc_chunk = 0;
 		committed = 1;
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index fcbdcef..7d8b6b6 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -209,7 +209,8 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 		return ret;
 	}
 
-	return btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode);
+	return ret;
 }
 
 static int readahead_cache(struct inode *inode)
@@ -525,6 +526,7 @@ out:
 		spin_lock(&block_group->lock);
 		block_group->disk_cache_state = BTRFS_DC_CLEAR;
 		spin_unlock(&block_group->lock);
+		ret = 0;
 
 		printk(KERN_ERR "btrfs: failed to load free space cache "
 		       "for block group %llu\n", block_group->key.objectid);
@@ -893,6 +895,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		spin_lock(&block_group->lock);
 		block_group->disk_cache_state = BTRFS_DC_ERROR;
 		spin_unlock(&block_group->lock);
+		ret = 0;
 
 		printk(KERN_ERR "btrfs: failed to write free space cace "
 		       "for block group %llu\n", block_group->key.objectid);
@@ -2458,3 +2461,95 @@ out:
 
 	return ino;
 }
+
+struct inode *lookup_free_ino_inode(struct btrfs_root *root,
+				    struct btrfs_path *path)
+{
+	struct inode *inode = NULL;
+
+	spin_lock(&root->cache_lock);
+	if (root->cache_inode)
+		inode = igrab(root->cache_inode);
+	spin_unlock(&root->cache_lock);
+	if (inode)
+		return inode;
+
+	inode = __lookup_free_space_inode(root, path, 0);
+	if (IS_ERR(inode))
+		return inode;
+
+	spin_lock(&root->cache_lock);
+	if (!root->fs_info->closing)
+		root->cache_inode = igrab(inode);
+	spin_unlock(&root->cache_lock);
+
+	return inode;
+}
+
+int create_free_ino_inode(struct btrfs_root *root,
+			  struct btrfs_trans_handle *trans,
+			  struct btrfs_path *path)
+{
+	return __create_free_space_inode(root, trans, path,
+					 BTRFS_FREE_INO_OBJECTID, 0);
+}
+
+int load_free_ino_cache(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
+{
+	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
+	struct btrfs_path *path;
+	struct inode *inode;
+	int ret = 0;
+	u64 root_gen = btrfs_root_generation(&root->root_item);
+
+	/*
+	 * If we're unmounting then just return, since this does a search on the
+	 * normal root and not the commit root and we could deadlock.
+	 */
+	smp_mb();
+	if (fs_info->closing)
+		return 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return 0;
+
+	inode = lookup_free_ino_inode(root, path);
+	if (IS_ERR(inode))
+		goto out;
+
+	if (root_gen != BTRFS_I(inode)->generation)
+		goto out_put;
+
+	ret = __load_free_space_cache(root, inode, ctl, path, 0);
+
+	if (ret < 0)
+		printk(KERN_ERR "btrfs: failed to load free ino cache for "
+		       "root %llu\n", root->root_key.objectid);
+out_put:
+	iput(inode);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+int btrfs_write_out_ino_cache(struct btrfs_root *root,
+			      struct btrfs_trans_handle *trans,
+			      struct btrfs_path *path)
+{
+	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
+	struct inode *inode;
+	int ret;
+
+	inode = lookup_free_ino_inode(root, path);
+	if (IS_ERR(inode))
+		return 0;
+
+	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, trans, path, 0);
+	if (ret < 0)
+		printk(KERN_ERR "btrfs: failed to write free ino cache "
+		       "for root %llu\n", root->root_key.objectid);
+
+	iput(inode);
+	return ret;
+}
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index af06e6b..8f2613f 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -65,6 +65,17 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 			  struct btrfs_block_group_cache *block_group,
 			  struct btrfs_path *path);
 
+struct inode *lookup_free_ino_inode(struct btrfs_root *root,
+				    struct btrfs_path *path);
+int create_free_ino_inode(struct btrfs_root *root,
+			  struct btrfs_trans_handle *trans,
+			  struct btrfs_path *path);
+int load_free_ino_cache(struct btrfs_fs_info *fs_info,
+			struct btrfs_root *root);
+int btrfs_write_out_ino_cache(struct btrfs_root *root,
+			      struct btrfs_trans_handle *trans,
+			      struct btrfs_path *path);
+
 void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group);
 int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
 			   u64 bytenr, u64 size);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 5be62df..7967e85 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -137,6 +137,7 @@ out:
 static void start_caching(struct btrfs_root *root)
 {
 	struct task_struct *tsk;
+	int ret;
 
 	spin_lock(&root->cache_lock);
 	if (root->cached != BTRFS_CACHE_NO) {
@@ -147,6 +148,14 @@ static void start_caching(struct btrfs_root *root)
 	root->cached = BTRFS_CACHE_STARTED;
 	spin_unlock(&root->cache_lock);
 
+	ret = load_free_ino_cache(root->fs_info, root);
+	if (ret == 1) {
+		spin_lock(&root->cache_lock);
+		root->cached = BTRFS_CACHE_FINISHED;
+		spin_unlock(&root->cache_lock);
+		return;
+	}
+
 	tsk = kthread_run(caching_kthread, root, "btrfs-ino-cache-%llu\n",
 			  root->root_key.objectid);
 	BUG_ON(IS_ERR(tsk));
@@ -352,6 +361,84 @@ void btrfs_init_free_ino_ctl(struct btrfs_root *root)
 	pinned->op = &pinned_free_ino_op;
 }
 
+int btrfs_save_ino_cache(struct btrfs_root *root,
+			 struct btrfs_trans_handle *trans)
+{
+	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
+	struct btrfs_path *path;
+	struct inode *inode;
+	u64 alloc_hint = 0;
+	int ret;
+	int prealloc;
+	bool retry = false;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+again:
+	inode = lookup_free_ino_inode(root, path);
+	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
+		ret = PTR_ERR(inode);
+		goto out;
+	}
+
+	if (IS_ERR(inode)) {
+		BUG_ON(retry);
+		retry = true;
+
+		ret = create_free_ino_inode(root, trans, path);
+		if (ret)
+			goto out;
+		goto again;
+	}
+
+	BTRFS_I(inode)->generation = 0;
+	ret = btrfs_update_inode(trans, root, inode);
+	WARN_ON(ret);
+
+	if (i_size_read(inode) > 0) {
+		ret = btrfs_truncate_free_space_cache(root, trans, path, inode);
+		if (ret)
+			goto out_put;
+	}
+
+	spin_lock(&root->cache_lock);
+	if (root->cached != BTRFS_CACHE_FINISHED) {
+		ret = -1;
+		spin_unlock(&root->cache_lock);
+		goto out_put;
+	}
+	spin_unlock(&root->cache_lock);
+
+	spin_lock(&ctl->tree_lock);
+	prealloc = sizeof(struct btrfs_free_space) * ctl->free_extents;
+	prealloc = ALIGN(prealloc, PAGE_CACHE_SIZE);
+	prealloc += ctl->total_bitmaps * PAGE_CACHE_SIZE;
+	spin_unlock(&ctl->tree_lock);
+
+	/* Just to make sure we have enough space */
+	prealloc += 8 * PAGE_CACHE_SIZE;
+
+	ret = btrfs_check_data_free_space(inode, prealloc);
+	if (ret)
+		goto out_put;
+
+	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
+					      prealloc, prealloc, &alloc_hint);
+	if (ret)
+		goto out_put;
+	btrfs_free_reserved_data_space(inode, prealloc);
+
+out_put:
+	iput(inode);
+out:
+	if (ret == 0)
+		ret = btrfs_write_out_ino_cache(root, trans, path);
+
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
 {
 	struct btrfs_path *path;
diff --git a/fs/btrfs/inode-map.h b/fs/btrfs/inode-map.h
index eb91845..ddb347b 100644
--- a/fs/btrfs/inode-map.h
+++ b/fs/btrfs/inode-map.h
@@ -5,6 +5,8 @@ void btrfs_init_free_ino_ctl(struct btrfs_root *root);
 void btrfs_unpin_free_ino(struct btrfs_root *root);
 void btrfs_return_ino(struct btrfs_root *root, u64 objectid);
 int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid);
+int btrfs_save_ino_cache(struct btrfs_root *root,
+			 struct btrfs_trans_handle *trans);
 
 int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index adec228..b78d3ab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -745,6 +745,15 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
 	return alloc_hint;
 }
 
+static inline bool is_free_space_inode(struct btrfs_root *root,
+				       struct inode *inode)
+{
+	if (root == root->fs_info->tree_root ||
+	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
+		return true;
+	return false;
+}
+
 /*
  * when extent_io.c finds a delayed allocation range in the file,
  * the call backs end up in this code.  The basic idea is to
@@ -777,7 +786,7 @@ static noinline int cow_file_range(struct inode *inode,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;
 
-	BUG_ON(root == root->fs_info->tree_root);
+	BUG_ON(is_free_space_inode(root, inode));
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, inode);
@@ -1048,17 +1057,18 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	int type;
 	int nocow;
 	int check_prev = 1;
-	bool nolock = false;
+	bool nolock;
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
-	if (root == root->fs_info->tree_root) {
-		nolock = true;
+
+	nolock = is_free_space_inode(root, inode);
+
+	if (nolock)
 		trans = btrfs_join_transaction_nolock(root, 1);
-	} else {
+	else
 		trans = btrfs_join_transaction(root, 1);
-	}
 	BUG_ON(IS_ERR(trans));
 
 	cow_start = (u64)-1;
@@ -1316,8 +1326,7 @@ static int btrfs_set_bit_hook(struct inode *inode,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		int do_list = (root->root_key.objectid !=
-			       BTRFS_ROOT_TREE_OBJECTID);
+		bool do_list = !is_free_space_inode(root, inode);
 
 		if (*bits & EXTENT_FIRST_DELALLOC)
 			*bits &= ~EXTENT_FIRST_DELALLOC;
@@ -1350,8 +1359,7 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 	if ((state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		int do_list = (root->root_key.objectid !=
-			       BTRFS_ROOT_TREE_OBJECTID);
+		bool do_list = !is_free_space_inode(root, inode);
 
 		if (*bits & EXTENT_FIRST_DELALLOC)
 			*bits &= ~EXTENT_FIRST_DELALLOC;
@@ -1458,7 +1466,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
-	if (root == root->fs_info->tree_root)
+	if (is_free_space_inode(root, inode))
 		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 2);
 	else
 		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
@@ -1701,7 +1709,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	struct extent_state *cached_state = NULL;
 	int compress_type = 0;
 	int ret;
-	bool nolock = false;
+	bool nolock;
 
 	ret = btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
 					     end - start + 1);
@@ -1709,7 +1717,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 		return 0;
 	BUG_ON(!ordered_extent);
 
-	nolock = (root == root->fs_info->tree_root);
+	nolock = is_free_space_inode(root, inode);
 
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
 		BUG_ON(!list_empty(&ordered_extent->list));
@@ -3473,7 +3481,9 @@ delete:
 
 		if (path->slots[0] == 0 ||
 		    path->slots[0] != pending_del_slot) {
-			if (root->ref_cows) {
+			if (root->ref_cows &&
+			    BTRFS_I(inode)->location.objectid !=
+						BTRFS_FREE_INO_OBJECTID) {
 				err = -EAGAIN;
 				goto out;
 			}
@@ -3765,7 +3775,7 @@ void btrfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages(&inode->i_data, 0);
 	if (inode->i_nlink && (btrfs_root_refs(&root->root_item) != 0 ||
-			       root == root->fs_info->tree_root))
+			       is_free_space_inode(root, inode)))
 		goto no_delete;
 
 	if (is_bad_inode(inode)) {
@@ -4382,7 +4392,8 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		return 0;
 
 	smp_mb();
-	nolock = (root->fs_info->closing && root == root->fs_info->tree_root);
+	if (root->fs_info->closing && is_free_space_inode(root, inode))
+		nolock = true;
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		if (nolock)
@@ -6900,7 +6911,7 @@ int btrfs_drop_inode(struct inode *inode)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	if (btrfs_root_refs(&root->root_item) == 0 &&
-	    root != root->fs_info->tree_root)
+	    !is_free_space_inode(root, inode))
 		return 1;
 	else
 		return generic_drop_inode(inode);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f4c1184..4d1dbcb 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -761,6 +761,8 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			btrfs_update_reloc_root(trans, root);
 			btrfs_orphan_commit_root(trans, root);
 
+			btrfs_save_ino_cache(root, trans);
+
 			if (root->commit_root != root->node) {
 				mutex_lock(&root->fs_commit_mutex);
 				switch_commit_root(root);
-- 
1.7.3.1
