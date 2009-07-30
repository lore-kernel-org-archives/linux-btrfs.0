From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] properly preserve commit_root for async caching
Date: Thu, 30 Jul 2009 21:27:28 +0800
Message-ID: <4A719FC0.5000601@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The extent allocation tree is recursive, it may change after
update_cowonly_root is called. So we shouldn't update extent
tree's commit_root directly in update_cowonly_root. 


Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2009-07-29 10:03:04.258858190 +0800
+++ 2/fs/btrfs/ctree.h	2009-07-30 10:06:08.837786432 +0800
@@ -827,6 +827,7 @@ struct btrfs_fs_info {
 	struct mutex drop_mutex;
 	struct mutex volume_mutex;
 	struct mutex tree_reloc_mutex;
+	struct rw_semaphore extent_commit_sem;
 
 	/*
 	 * this protects the ordered operations list only while we are
@@ -961,9 +962,6 @@ struct btrfs_root {
 	/* the node lock is held while changing the node pointer */
 	spinlock_t node_lock;
 
-	/* taken when updating the commit root */
-	struct rw_semaphore commit_root_sem;
-
 	struct extent_buffer *commit_root;
 	struct btrfs_root *log_root;
 	struct btrfs_root *reloc_root;
diff -urp 1/fs/btrfs/disk-io.c 2/fs/btrfs/disk-io.c
--- 1/fs/btrfs/disk-io.c	2009-07-29 10:03:04.260858403 +0800
+++ 2/fs/btrfs/disk-io.c	2009-07-30 10:07:27.230037079 +0800
@@ -907,7 +907,6 @@ static int __setup_root(u32 nodesize, u3
 	spin_lock_init(&root->inode_lock);
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
-	init_rwsem(&root->commit_root_sem);
 	init_waitqueue_head(&root->log_writer_wait);
 	init_waitqueue_head(&root->log_commit_wait[0]);
 	init_waitqueue_head(&root->log_commit_wait[1]);
@@ -1624,6 +1623,7 @@ struct btrfs_root *open_ctree(struct sup
 	mutex_init(&fs_info->cleaner_mutex);
 	mutex_init(&fs_info->volume_mutex);
 	mutex_init(&fs_info->tree_reloc_mutex);
+	init_rwsem(&fs_info->extent_commit_sem);
 
 	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
 	btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-07-29 10:03:04.264855268 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-07-30 10:08:34.582036148 +0800
@@ -267,7 +267,7 @@ static int caching_kthread(void *data)
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 again:
 	/* need to make sure the commit_root doesn't disappear */
-	down_read(&fs_info->extent_root->commit_root_sem);
+	down_read(&fs_info->extent_commit_sem);
 
 	/*
 	 * We don't want to deadlock with somebody trying to allocate a new
@@ -304,7 +302,7 @@ again:
 
 			if (need_resched()) {
 				btrfs_release_path(fs_info->extent_root, path);
-				up_read(&fs_info->extent_root->commit_root_sem);
+				up_read(&fs_info->extent_commit_sem);
 				cond_resched();
 				goto again;
 			}
@@ -345,7 +343,7 @@ next:
 
 err:
 	btrfs_free_path(path);
-	up_read(&fs_info->extent_root->commit_root_sem);
+	up_read(&fs_info->extent_commit_sem);
 	atomic_dec(&block_group->space_info->caching_threads);
 	wake_up(&block_group->caching_q);
 
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-07-29 10:03:04.481858667 +0800
+++ 2/fs/btrfs/transaction.c	2009-07-30 10:18:04.331033676 +0800
@@ -42,10 +42,8 @@ static noinline void put_transaction(str
 
 static noinline void switch_commit_root(struct btrfs_root *root)
 {
-	down_write(&root->commit_root_sem);
 	free_extent_buffer(root->commit_root);
 	root->commit_root = btrfs_root_node(root);
-	up_write(&root->commit_root_sem);
 }
 
 /*
@@ -466,7 +464,10 @@ static int update_cowonly_root(struct bt
 		ret = btrfs_write_dirty_block_groups(trans, root);
 		BUG_ON(ret);
 	}
-	switch_commit_root(root);
+	
+	if (root != root->fs_info->extent_root)
+		switch_commit_root(root);
+
 	return 0;
 }
 
@@ -499,6 +500,11 @@ static noinline int commit_cowonly_roots
 
 		update_cowonly_root(trans, root);
 	}
+
+	down_write(&fs_info->extent_commit_sem);
+	switch_commit_root(fs_info->extent_root);
+	up_write(&fs_info->extent_commit_sem);
+
 	return 0;
 }
 
