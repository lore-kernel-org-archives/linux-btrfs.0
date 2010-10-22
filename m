From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix df regression V2
Date: Fri, 22 Oct 2010 14:41:37 -0400
Message-ID: <1287772897-5944-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The new ENOSPC stuff breaks out the raid types which breaks the way we were
reporting df to the system.  This fixes it back so that Available is the total
space available to data and used is the actual bytes used by the filesystem.
This means that Available is Total - data used - all of the metadata space.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: Forgot to properly update disk_total when removing block groups.
 fs/btrfs/ctree.h       |    5 ++++-
 fs/btrfs/extent-tree.c |   11 +++++++++++
 fs/btrfs/super.c       |   11 +++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e25e96e..4833a01 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -696,7 +696,8 @@ struct btrfs_block_group_item {
 struct btrfs_space_info {
 	u64 flags;
 
-	u64 total_bytes;	/* total bytes in the space */
+	u64 total_bytes;	/* total bytes in the space,
+				   this doesn't take mirrors into account */
 	u64 bytes_used;		/* total bytes used,
 				   this does't take mirrors into account */
 	u64 bytes_pinned;	/* total bytes pinned, will be freed when the
@@ -708,6 +709,8 @@ struct btrfs_space_info {
 	u64 bytes_may_use;	/* number of bytes that may be used for
 				   delalloc/allocations */
 	u64 disk_used;		/* total bytes used on disk */
+	u64 disk_total;		/* total bytes on disk, takes mirrors into
+				   account */
 
 	int full;		/* indicates that we cannot allocate any more
 				   chunks for this space */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3f8aee5..1de2a67 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2982,6 +2982,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	if (found) {
 		spin_lock(&found->lock);
 		found->total_bytes += total_bytes;
+		found->disk_total += total_bytes * factor;
 		found->bytes_used += bytes_used;
 		found->disk_used += bytes_used * factor;
 		found->full = 0;
@@ -3001,6 +3002,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 				BTRFS_BLOCK_GROUP_SYSTEM |
 				BTRFS_BLOCK_GROUP_METADATA);
 	found->total_bytes = total_bytes;
+	found->disk_total = total_bytes * factor;
 	found->bytes_used = bytes_used;
 	found->disk_used = bytes_used * factor;
 	found->bytes_pinned = 0;
@@ -8393,6 +8395,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct inode *inode;
 	int ret;
+	int factor;
 
 	root = root->fs_info->extent_root;
 
@@ -8400,6 +8403,13 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	BUG_ON(!block_group);
 	BUG_ON(!block_group->ro);
 
+	if (block_group->flags & (BTRFS_BLOCK_GROUP_DUP |
+				  BTRFS_BLOCK_GROUP_RAID1 |
+				  BTRFS_BLOCK_GROUP_RAID10))
+		factor = 2;
+	else
+		factor = 1;
+
 	/* make sure this block group isn't part of an allocation cluster */
 	cluster = &root->fs_info->data_alloc_cluster;
 	spin_lock(&cluster->refill_lock);
@@ -8472,6 +8482,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	spin_lock(&block_group->space_info->lock);
 	block_group->space_info->total_bytes -= block_group->key.offset;
 	block_group->space_info->bytes_readonly -= block_group->key.offset;
+	block_group->space_info->disk_total -= block_group->key.offset * factor;
 	spin_unlock(&block_group->space_info->lock);
 
 	memcpy(&key, &block_group->key, sizeof(key));
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1b92f57..0570211 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -729,18 +729,25 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct list_head *head = &root->fs_info->space_info;
 	struct btrfs_space_info *found;
 	u64 total_used = 0;
+	u64 total_used_data = 0;
 	int bits = dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid = (__be32 *)root->fs_info->fsid;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(found, head, list)
+	list_for_each_entry_rcu(found, head, list) {
+		if (found->flags & (BTRFS_BLOCK_GROUP_METADATA |
+				    BTRFS_BLOCK_GROUP_SYSTEM))
+			total_used_data += found->disk_total;
+		else
+			total_used_data += found->disk_used;
 		total_used += found->disk_used;
+	}
 	rcu_read_unlock();
 
 	buf->f_namelen = BTRFS_NAME_LEN;
 	buf->f_blocks = btrfs_super_total_bytes(disk_super) >> bits;
 	buf->f_bfree = buf->f_blocks - (total_used >> bits);
-	buf->f_bavail = buf->f_bfree;
+	buf->f_bavail = buf->f_blocks - (total_used_data >> bits);
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	buf->f_type = BTRFS_SUPER_MAGIC;
 
-- 
1.6.6.1

