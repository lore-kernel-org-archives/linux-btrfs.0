From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 02/12] Btrfs: Kill allocate_wait in space_info
Date: Mon, 19 Apr 2010 18:45:44 +0800
Message-ID: <4BCC3458.5030600@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We already have fs_info->chunk_mutex to avoid concurrent
chunk creation.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/ctree.h 3/fs/btrfs/ctree.h
--- 2/fs/btrfs/ctree.h	2010-04-18 08:12:22.086699485 +0800
+++ 3/fs/btrfs/ctree.h	2010-04-18 08:13:15.457699211 +0800
@@ -700,9 +700,7 @@ struct btrfs_space_info {
 	struct list_head list;
 
 	/* for controlling how we free up space for allocations */
-	wait_queue_head_t allocate_wait;
 	wait_queue_head_t flush_wait;
-	int allocating_chunk;
 	int flushing;
 
 	/* for block groups in our same type */
diff -urp 2/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 2/fs/btrfs/extent-tree.c	2010-04-18 08:12:22.092698714 +0800
+++ 3/fs/btrfs/extent-tree.c	2010-04-18 08:13:15.463699138 +0800
@@ -70,6 +70,9 @@ static int find_next_key(struct btrfs_pa
 			 struct btrfs_key *key);
 static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups);
+static int maybe_allocate_chunk(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_space_info *sinfo, u64 num_bytes);
 
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
@@ -2687,7 +2690,6 @@ static int update_space_info(struct btrf
 		INIT_LIST_HEAD(&found->block_groups[i]);
 	init_rwsem(&found->groups_sem);
 	init_waitqueue_head(&found->flush_wait);
-	init_waitqueue_head(&found->allocate_wait);
 	spin_lock_init(&found->lock);
 	found->flags = flags & (BTRFS_BLOCK_GROUP_DATA |
 				BTRFS_BLOCK_GROUP_SYSTEM |
@@ -3000,71 +3002,6 @@ flush:
 	wake_up(&info->flush_wait);
 }
 
-static int maybe_allocate_chunk(struct btrfs_root *root,
-				 struct btrfs_space_info *info)
-{
-	struct btrfs_super_block *disk_super = &root->fs_info->super_copy;
-	struct btrfs_trans_handle *trans;
-	bool wait = false;
-	int ret = 0;
-	u64 min_metadata;
-	u64 free_space;
-
-	free_space = btrfs_super_total_bytes(disk_super);
-	/*
-	 * we allow the metadata to grow to a max of either 10gb or 5% of the
-	 * space in the volume.
-	 */
-	min_metadata = min((u64)10 * 1024 * 1024 * 1024,
-			     div64_u64(free_space * 5, 100));
-	if (info->total_bytes >= min_metadata) {
-		spin_unlock(&info->lock);
-		return 0;
-	}
-
-	if (info->full) {
-		spin_unlock(&info->lock);
-		return 0;
-	}
-
-	if (!info->allocating_chunk) {
-		info->force_alloc = 1;
-		info->allocating_chunk = 1;
-	} else {
-		wait = true;
-	}
-
-	spin_unlock(&info->lock);
-
-	if (wait) {
-		wait_event(info->allocate_wait,
-			   !info->allocating_chunk);
-		return 1;
-	}
-
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-			     4096 + 2 * 1024 * 1024,
-			     info->flags, 0);
-	btrfs_end_transaction(trans, root);
-	if (ret)
-		goto out;
-out:
-	spin_lock(&info->lock);
-	info->allocating_chunk = 0;
-	spin_unlock(&info->lock);
-	wake_up(&info->allocate_wait);
-
-	if (ret)
-		return 0;
-	return 1;
-}
-
 /*
  * Reserve metadata space for delalloc.
  */
@@ -3105,7 +3042,8 @@ again:
 		flushed++;
 
 		if (flushed == 1) {
-			if (maybe_allocate_chunk(root, meta_sinfo))
+			if (maybe_allocate_chunk(NULL, root, meta_sinfo,
+						 num_bytes))
 				goto again;
 			flushed++;
 		} else {
@@ -3220,7 +3158,8 @@ again:
 	if (used > meta_sinfo->total_bytes) {
 		retries++;
 		if (retries == 1) {
-			if (maybe_allocate_chunk(root, meta_sinfo))
+			if (maybe_allocate_chunk(NULL, root, meta_sinfo,
+						 num_bytes))
 				goto again;
 			retries++;
 		} else {
@@ -3417,13 +3356,28 @@ static void force_metadata_allocation(st
 	rcu_read_unlock();
 }
 
+static int should_alloc_chunk(struct btrfs_space_info *sinfo,
+			      u64 alloc_bytes)
+{
+	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
+
+	if (sinfo->bytes_used + sinfo->bytes_reserved +
+	    alloc_bytes + 256 * 1024 * 1024 < num_bytes)
+		return 0;
+
+	if (sinfo->bytes_used + sinfo->bytes_reserved +
+	    alloc_bytes < div_factor(num_bytes, 8))
+		return 0;
+
+	return 1;
+}
+
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force)
 {
 	struct btrfs_space_info *space_info;
 	struct btrfs_fs_info *fs_info = extent_root->fs_info;
-	u64 thresh;
 	int ret = 0;
 
 	mutex_lock(&fs_info->chunk_mutex);
@@ -3446,11 +3400,7 @@ static int do_chunk_alloc(struct btrfs_t
 		goto out;
 	}
 
-	thresh = space_info->total_bytes - space_info->bytes_readonly;
-	thresh = div_factor(thresh, 8);
-	if (!force &&
-	   (space_info->bytes_used + space_info->bytes_pinned +
-	    space_info->bytes_reserved + alloc_bytes) < thresh) {
+	if (!force && !should_alloc_chunk(space_info, alloc_bytes)) {
 		spin_unlock(&space_info->lock);
 		goto out;
 	}
@@ -3472,6 +3422,8 @@ static int do_chunk_alloc(struct btrfs_t
 	spin_lock(&space_info->lock);
 	if (ret)
 		space_info->full = 1;
+	else
+		ret = 1;
 	space_info->force_alloc = 0;
 	spin_unlock(&space_info->lock);
 out:
@@ -3479,6 +3431,38 @@ out:
 	return ret;
 }
 
+static int maybe_allocate_chunk(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_space_info *sinfo, u64 num_bytes)
+{
+	int ret;
+	int end_trans = 0;
+
+	if (sinfo->full)
+		return 0;
+
+	spin_lock(&sinfo->lock);
+	ret = should_alloc_chunk(sinfo, num_bytes + 2 * 1024 * 1024);
+	spin_unlock(&sinfo->lock);
+	if (!ret)
+		return 0;
+
+	if (!trans) {
+		trans = btrfs_join_transaction(root, 1);
+		BUG_ON(IS_ERR(trans));
+		end_trans = 1;
+	}
+
+	ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+			     num_bytes + 2 * 1024 * 1024,
+			     get_alloc_profile(root, sinfo->flags), 0);
+
+	if (end_trans)
+		btrfs_end_transaction(trans, root);
+
+	return ret == 1 ? 1 : 0;
+}
+
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc,
