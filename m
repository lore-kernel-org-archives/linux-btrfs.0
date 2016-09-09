Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46240 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751944AbcIIIWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 04:22:11 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, s.priebe@profihost.ag
Subject: [PATCH v3] btrfs: should block unused block groups deletion work when allocating data space
Date: Fri,  9 Sep 2016 16:17:48 +0800
Message-Id: <20160909081748.26540-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cleaner_kthread() may run at any time, in which it'll call btrfs_delete_unused_bgs()
to delete unused block groups. Because this work is asynchronous, it may also result
in false ENOSPC error. Please see below race window:

               CPU1                           |             CPU2
                                              |
|-> btrfs_alloc_data_chunk_ondemand()         |-> cleaner_kthread()
    |-> do_chunk_alloc()                      |   |
    |   assume it returns ENOSPC, which means |   |
    |   btrfs_space_info is full and have free|   |
    |   space to satisfy data request.        |   |
    |                                         |   |- > btrfs_delete_unused_bgs()
    |                                         |   |    it will decrease btrfs_space_info
    |                                         |   |    total_bytes and make
    |                                         |   |    btrfs_space_info is not full.
    |                                         |   |
In this case, we may get ENOSPC error, but btrfs_space_info is not full.

To fix this issue, in btrfs_alloc_data_chunk_ondemand(), if we need to call
do_chunk_alloc() to allocating new chunk, we should block btrfs_delete_unused_bgs().
Here we introduce a new struct rw_semaphore bg_delete_sem to do this job.

Indeed there is already a "struct mutex delete_unused_bgs_mutex", but it's mutex,
we can not use it for this purpose. Of course, we can re-define it to be struct
rw_semaphore, then use it in btrfs_alloc_data_chunk_ondemand(). Either method will
work.

But given that delete_unused_bgs_mutex's name length is longer than bg_delete_sem,
I choose the first method, to create a new struct rw_semaphore bg_delete_sem and
delete delete_unused_bgs_mutex :)

Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
V2: fix a deadlock revealed by fstests case btrfs/071, we call
    start_transaction() before in down_write(bg_delete_sem) in
    btrfs_delete_unused_bgs().

v3: Stefan Priebe reported another similar deadlock, so here we choose
    to not call down_read(bg_delete_sem) for free space inode in
    btrfs_alloc_data_chunk_ondemand(). Meanwhile because we only do the
    data space reservation for free space cache in the transaction context,
    btrfs_delete_unused_bgs() will either have finished its job, or start
    a new transaction waiting current transaction to complete, there will
    be no unused block groups to be deleted, so it's safe to not call
    down_read(bg_delete_sem)
---
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/disk-io.c     | 13 +++++------
 fs/btrfs/extent-tree.c | 59 ++++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/volumes.c     | 42 +++++++++++++++++------------------
 4 files changed, 76 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eff3993..fa78ef9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -788,6 +788,7 @@ struct btrfs_fs_info {
 	struct mutex cleaner_mutex;
 	struct mutex chunk_mutex;
 	struct mutex volume_mutex;
+	struct rw_semaphore bg_delete_sem;
 
 	/*
 	 * this is taken to make sure we don't set block groups ro after
@@ -1068,7 +1069,6 @@ struct btrfs_fs_info {
 	spinlock_t unused_bgs_lock;
 	struct list_head unused_bgs;
 	struct mutex unused_bg_unpin_mutex;
-	struct mutex delete_unused_bgs_mutex;
 
 	/* For btrfs to record security options */
 	struct security_mnt_opts security_opts;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 54bc8c7..3cdbd05 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1868,12 +1868,11 @@ static int cleaner_kthread(void *arg)
 		btrfs_run_defrag_inodes(root->fs_info);
 
 		/*
-		 * Acquires fs_info->delete_unused_bgs_mutex to avoid racing
-		 * with relocation (btrfs_relocate_chunk) and relocation
-		 * acquires fs_info->cleaner_mutex (btrfs_relocate_block_group)
-		 * after acquiring fs_info->delete_unused_bgs_mutex. So we
-		 * can't hold, nor need to, fs_info->cleaner_mutex when deleting
-		 * unused block groups.
+		 * Acquires fs_info->bg_delete_sem to avoid racing with
+		 * relocation (btrfs_relocate_chunk) and relocation acquires
+		 * fs_info->cleaner_mutex (btrfs_relocate_block_group) after
+		 * acquiring fs_info->bg_delete_sem. So we can't hold, nor need
+		 * to, fs_info->cleaner_mutex when deleting unused block groups.
 		 */
 		btrfs_delete_unused_bgs(root->fs_info);
 sleep:
@@ -2634,7 +2633,6 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->unused_bgs_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->unused_bg_unpin_mutex);
-	mutex_init(&fs_info->delete_unused_bgs_mutex);
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	mutex_init(&fs_info->cleaner_delayed_iput_mutex);
@@ -2723,6 +2721,7 @@ int open_ctree(struct super_block *sb,
 	init_rwsem(&fs_info->commit_root_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
+	init_rwsem(&fs_info->bg_delete_sem);
 	sema_init(&fs_info->uuid_tree_rescan_sem, 1);
 
 	btrfs_init_dev_replace_locks(fs_info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8c8a4d1..f037769 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4128,18 +4128,35 @@ int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
 	int ret = 0;
 	int need_commit = 2;
 	int have_pinned_space;
+	int have_bg_delete_sem = 0;
+	bool free_space_inode = btrfs_is_free_space_inode(inode);
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
 
-	if (btrfs_is_free_space_inode(inode)) {
+	if (free_space_inode) {
 		need_commit = 0;
 		ASSERT(current->journal_info);
 	}
 
+	/*
+	 * Here we shouldn't call down_read(bg_delete_sem) for free space inode,
+	 * there is lock order between bg_delete_sem and "wait current trans
+	 * finished". Meanwhile because we only do the data space reservation
+	 * for free space cache in the transaction context,
+	 * btrfs_delete_unused_bgs() will either have finished its job, or start
+	 * a new transaction waiting current transaction to complete, there will
+	 * be no unused block groups to be deleted, so it's safe to not call
+	 * down_read(bg_delete_sem).
+	 */
 	data_sinfo = fs_info->data_sinfo;
-	if (!data_sinfo)
+	if (!data_sinfo) {
+		if (!free_space_inode) {
+			down_read(&root->fs_info->bg_delete_sem);
+			have_bg_delete_sem = 1;
+		}
 		goto alloc;
+	}
 
 again:
 	/* make sure we have enough space to handle the data first */
@@ -4152,6 +4169,17 @@ again:
 		struct btrfs_trans_handle *trans;
 
 		/*
+		 * We may need to allocate new chunk, so we should block
+		 * btrfs_delete_unused_bgs()
+		 */
+		if (!have_bg_delete_sem && !free_space_inode) {
+			spin_unlock(&data_sinfo->lock);
+			down_read(&root->fs_info->bg_delete_sem);
+			have_bg_delete_sem = 1;
+			goto again;
+		}
+
+		/*
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
 		 */
@@ -4173,8 +4201,10 @@ alloc:
 			 * the fs.
 			 */
 			trans = btrfs_join_transaction(root);
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto out;
+			}
 
 			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 					     alloc_target,
@@ -4182,7 +4212,7 @@ alloc:
 			btrfs_end_transaction(trans, root);
 			if (ret < 0) {
 				if (ret != -ENOSPC)
-					return ret;
+					goto out;
 				else {
 					have_pinned_space = 1;
 					goto commit_trans;
@@ -4217,15 +4247,17 @@ commit_trans:
 			}
 
 			trans = btrfs_join_transaction(root);
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto out;
+			}
 			if (have_pinned_space >= 0 ||
 			    test_bit(BTRFS_TRANS_HAVE_FREE_BGS,
 				     &trans->transaction->flags) ||
 			    need_commit > 0) {
 				ret = btrfs_commit_transaction(trans, root);
 				if (ret)
-					return ret;
+					goto out;
 				/*
 				 * The cleaner kthread might still be doing iput
 				 * operations. Wait for it to finish so that
@@ -4242,13 +4274,18 @@ commit_trans:
 		trace_btrfs_space_reservation(root->fs_info,
 					      "space_info:enospc",
 					      data_sinfo->flags, bytes, 1);
-		return -ENOSPC;
+		ret = -ENOSPC;
+		goto out;
 	}
 	data_sinfo->bytes_may_use += bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
 				      data_sinfo->flags, bytes, 1);
 	spin_unlock(&data_sinfo->lock);
 
+out:
+	if (have_bg_delete_sem && !free_space_inode)
+		up_read(&root->fs_info->bg_delete_sem);
+
 	return ret;
 }
 
@@ -10806,7 +10843,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		}
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		mutex_lock(&fs_info->delete_unused_bgs_mutex);
+		down_write(&root->fs_info->bg_delete_sem);
 
 		/* Don't want to race with allocators so take the groups_sem */
 		down_write(&space_info->groups_sem);
@@ -10934,7 +10971,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 end_trans:
 		btrfs_end_transaction(trans, root);
 next:
-		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+		up_write(&root->fs_info->bg_delete_sem);
 		btrfs_put_block_group(block_group);
 		spin_lock(&fs_info->unused_bgs_lock);
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 035efce..408fb0c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2926,7 +2926,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *root, u64 chunk_offset)
 	 * we release the path used to search the chunk/dev tree and before
 	 * the current task acquires this mutex and calls us.
 	 */
-	ASSERT(mutex_is_locked(&root->fs_info->delete_unused_bgs_mutex));
+	ASSERT(rwsem_is_locked(&root->fs_info->bg_delete_sem));
 
 	ret = btrfs_can_relocate(extent_root, chunk_offset);
 	if (ret)
@@ -2979,10 +2979,10 @@ again:
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
 	while (1) {
-		mutex_lock(&root->fs_info->delete_unused_bgs_mutex);
+		down_read(&root->fs_info->bg_delete_sem);
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0) {
-			mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+			up_read(&root->fs_info->bg_delete_sem);
 			goto error;
 		}
 		BUG_ON(ret == 0); /* Corruption */
@@ -2990,7 +2990,7 @@ again:
 		ret = btrfs_previous_item(chunk_root, path, key.objectid,
 					  key.type);
 		if (ret)
-			mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+			up_read(&root->fs_info->bg_delete_sem);
 		if (ret < 0)
 			goto error;
 		if (ret > 0)
@@ -3012,7 +3012,7 @@ again:
 			else
 				BUG_ON(ret);
 		}
-		mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+		up_read(&root->fs_info->bg_delete_sem);
 
 		if (found_key.offset == 0)
 			break;
@@ -3568,10 +3568,10 @@ again:
 			goto error;
 		}
 
-		mutex_lock(&fs_info->delete_unused_bgs_mutex);
+		down_read(&fs_info->bg_delete_sem);
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
 		if (ret < 0) {
-			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+			up_read(&fs_info->bg_delete_sem);
 			goto error;
 		}
 
@@ -3585,7 +3585,7 @@ again:
 		ret = btrfs_previous_item(chunk_root, path, 0,
 					  BTRFS_CHUNK_ITEM_KEY);
 		if (ret) {
-			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+			up_read(&fs_info->bg_delete_sem);
 			ret = 0;
 			break;
 		}
@@ -3595,7 +3595,7 @@ again:
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
 		if (found_key.objectid != key.objectid) {
-			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+			up_read(&fs_info->bg_delete_sem);
 			break;
 		}
 
@@ -3613,12 +3613,12 @@ again:
 
 		btrfs_release_path(path);
 		if (!ret) {
-			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+			up_read(&fs_info->bg_delete_sem);
 			goto loop;
 		}
 
 		if (counting) {
-			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+			up_read(&fs_info->bg_delete_sem);
 			spin_lock(&fs_info->balance_lock);
 			bctl->stat.expected++;
 			spin_unlock(&fs_info->balance_lock);
@@ -3643,7 +3643,7 @@ again:
 					count_meta < bctl->meta.limit_min)
 				|| ((chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) &&
 					count_sys < bctl->sys.limit_min)) {
-			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+			up_read(&fs_info->bg_delete_sem);
 			goto loop;
 		}
 
@@ -3656,7 +3656,7 @@ again:
 		    !chunk_reserved && !bytes_used) {
 			trans = btrfs_start_transaction(chunk_root, 0);
 			if (IS_ERR(trans)) {
-				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+				up_read(&fs_info->bg_delete_sem);
 				ret = PTR_ERR(trans);
 				goto error;
 			}
@@ -3665,7 +3665,7 @@ again:
 						      BTRFS_BLOCK_GROUP_DATA);
 			btrfs_end_transaction(trans, chunk_root);
 			if (ret < 0) {
-				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+				up_read(&fs_info->bg_delete_sem);
 				goto error;
 			}
 			chunk_reserved = 1;
@@ -3673,7 +3673,7 @@ again:
 
 		ret = btrfs_relocate_chunk(chunk_root,
 					   found_key.offset);
-		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+		up_read(&fs_info->bg_delete_sem);
 		if (ret && ret != -ENOSPC)
 			goto error;
 		if (ret == -ENOSPC) {
@@ -4400,16 +4400,16 @@ again:
 	key.type = BTRFS_DEV_EXTENT_KEY;
 
 	do {
-		mutex_lock(&root->fs_info->delete_unused_bgs_mutex);
+		down_read(&root->fs_info->bg_delete_sem);
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0) {
-			mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+			up_read(&root->fs_info->bg_delete_sem);
 			goto done;
 		}
 
 		ret = btrfs_previous_item(root, path, 0, key.type);
 		if (ret)
-			mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+			up_read(&root->fs_info->bg_delete_sem);
 		if (ret < 0)
 			goto done;
 		if (ret) {
@@ -4423,7 +4423,7 @@ again:
 		btrfs_item_key_to_cpu(l, &key, path->slots[0]);
 
 		if (key.objectid != device->devid) {
-			mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+			up_read(&root->fs_info->bg_delete_sem);
 			btrfs_release_path(path);
 			break;
 		}
@@ -4432,7 +4432,7 @@ again:
 		length = btrfs_dev_extent_length(l, dev_extent);
 
 		if (key.offset + length <= new_size) {
-			mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+			up_read(&root->fs_info->bg_delete_sem);
 			btrfs_release_path(path);
 			break;
 		}
@@ -4441,7 +4441,7 @@ again:
 		btrfs_release_path(path);
 
 		ret = btrfs_relocate_chunk(root, chunk_offset);
-		mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
+		up_read(&root->fs_info->bg_delete_sem);
 		if (ret && ret != -ENOSPC)
 			goto done;
 		if (ret == -ENOSPC)
-- 
2.9.0



