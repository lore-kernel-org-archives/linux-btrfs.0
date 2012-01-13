From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: add a delalloc mutex to inodes for delalloc reservations
Date: Fri, 13 Jan 2012 12:08:55 -0500
Message-ID: <1326474535-3739-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was using i_mutex for this, but we're getting bogus lockdep warnings by doing
that and theres no real way to get rid of those, so just stop using i_mutex to
protect delalloc metadata reservations and use a delalloc mutex instead.  This
shouldn't be contended often at all, only if you are writing and mmap writing to
the file at the same time.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    3 +++
 fs/btrfs/extent-tree.c |    5 +++--
 fs/btrfs/inode.c       |   11 +----------
 fs/btrfs/ioctl.c       |    2 --
 fs/btrfs/relocation.c  |    2 --
 5 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 634608d..9b9b15f 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -51,6 +51,9 @@ struct btrfs_inode {
 	/* held while logging the inode in tree-log.c */
 	struct mutex log_mutex;
 
+	/* held while doing delalloc reservations */
+	struct mutex delalloc_mutex;
+
 	/* used to order data wrt metadata */
 	struct btrfs_ordered_inode_tree ordered_tree;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 673d32e..5519c65 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4245,12 +4245,11 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	/* Need to be holding the i_mutex here if we aren't free space cache */
 	if (btrfs_is_free_space_inode(root, inode))
 		flush = 0;
-	else
-		WARN_ON(!mutex_is_locked(&inode->i_mutex));
 
 	if (flush && btrfs_transaction_in_commit(root->fs_info))
 		schedule_timeout(1);
 
+	mutex_lock(&BTRFS_I(inode)->delalloc_mutex);
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -4305,6 +4304,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 						      btrfs_ino(inode),
 						      to_free, 0);
 		}
+		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
 		return ret;
 	}
 
@@ -4315,6 +4315,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	}
 	BTRFS_I(inode)->reserved_extents += nr_extents;
 	spin_unlock(&BTRFS_I(inode)->lock);
+	mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
 
 	if (to_reserve)
 		trace_btrfs_space_reservation(root->fs_info,"delalloc",
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85b8b90..f26fa6b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2239,14 +2239,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				continue;
 			}
 			nr_truncate++;
-			/*
-			 * Need to hold the imutex for reservation purposes, not
-			 * a huge deal here but I have a WARN_ON in
-			 * btrfs_delalloc_reserve_space to catch offenders.
-			 */
-			mutex_lock(&inode->i_mutex);
 			ret = btrfs_truncate(inode);
-			mutex_unlock(&inode->i_mutex);
 		} else {
 			nr_unlink++;
 		}
@@ -6417,10 +6410,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	u64 page_start;
 	u64 page_end;
 
-	/* Need this to keep space reservations serialized */
-	mutex_lock(&inode->i_mutex);
 	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
-	mutex_unlock(&inode->i_mutex);
 	if (!ret)
 		ret = btrfs_update_time(vma->vm_file);
 	if (ret) {
@@ -6764,6 +6754,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	extent_io_tree_init(&ei->io_tree, &inode->i_data);
 	extent_io_tree_init(&ei->io_failure_tree, &inode->i_data);
 	mutex_init(&ei->log_mutex);
+	mutex_init(&ei->delalloc_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c04f02c..40eaa9f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -858,10 +858,8 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		return 0;
 	file_end = (isize - 1) >> PAGE_CACHE_SHIFT;
 
-	mutex_lock(&inode->i_mutex);
 	ret = btrfs_delalloc_reserve_space(inode,
 					   num_pages << PAGE_CACHE_SHIFT);
-	mutex_unlock(&inode->i_mutex);
 	if (ret)
 		return ret;
 again:
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cfb5543..dff29d5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2947,9 +2947,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	index = (cluster->start - offset) >> PAGE_CACHE_SHIFT;
 	last_index = (cluster->end - offset) >> PAGE_CACHE_SHIFT;
 	while (index <= last_index) {
-		mutex_lock(&inode->i_mutex);
 		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_CACHE_SIZE);
-		mutex_unlock(&inode->i_mutex);
 		if (ret)
 			goto out;
 
-- 
1.7.5.2

