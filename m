From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fail to mount if we have problems reading the block
	groups
Date: Fri, 19 Mar 2010 16:49:55 -0400
Message-ID: <20100319204955.GD2314@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We don't actually check the return value of btrfs_read_block_groups, so we can
possibly succeed to mount, but then fail to say read the superblock xattr for
selinux which will cause the vfs code to deactivate the super.  This is a
problem because in find_free_extent we just assume that we will find the right
space_info for the allocation we want.  But if we failed to read the block
groups, we won't have setup any space_info's, and we'll hit a NULL pointer deref
in find_free_extent.  This patch fixes that problem by checking the return value
of btrfs_read_block_groups, and failing out properly.  I've also added a check
in find_free_extent so if for some reason we don't find an appropriate
space_info, we just return -ENOSPC.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c     |   11 ++++++++---
 fs/btrfs/extent-tree.c |    5 ++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfe7a95..6632e5c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1921,7 +1921,11 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	csum_root->track_dirty = 1;
 
-	btrfs_read_block_groups(extent_root);
+	ret = btrfs_read_block_groups(extent_root);
+	if (ret) {
+		printk(KERN_ERR "Failed to read block groups: %d\n", ret);
+		goto fail_block_groups;
+	}
 
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
@@ -1931,7 +1935,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
 	if (IS_ERR(fs_info->cleaner_kthread))
-		goto fail_csum_root;
+		goto fail_block_groups;
 
 	fs_info->transaction_kthread = kthread_run(transaction_kthread,
 						   tree_root,
@@ -2019,7 +2023,8 @@ fail_cleaner:
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
-fail_csum_root:
+fail_block_groups:
+	btrfs_free_block_groups(fs_info);
 	free_extent_buffer(csum_root->node);
 	free_extent_buffer(csum_root->commit_root);
 fail_dev_root:
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1860969..ec84862 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4179,6 +4179,10 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	ins->offset = 0;
 
 	space_info = __find_space_info(root->fs_info, data);
+	if (!space_info) {
+		printk(KERN_ERR "No space info for %d\n", data);
+		return -ENOSPC;
+	}
 
 	if (orig_root->ref_cows || empty_size)
 		allowed_chunk_alloc = 1;
@@ -7378,7 +7382,6 @@ static int find_first_block_group(struct btrfs_root *root,
 		}
 		path->slots[0]++;
 	}
-	ret = -ENOENT;
 out:
 	return ret;
 }
-- 
1.6.6

