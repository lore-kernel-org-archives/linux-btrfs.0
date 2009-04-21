From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs: try to keep a healthy ratio of metadata vs data block groups
Date: Tue, 21 Apr 2009 17:40:57 -0400
Message-ID: <1240350057-8554-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes the chunk allocator keep a good ratio of metadata vs data block
groups.  By default for every 8 data block groups, we'll allocate 1 metadata
chunk, or about 12% of the disk will be allocated for metadata.  This can be
changed by specifying the metadata_ratio mount option.  This is simply the
number of data block groups that have to be allocated to force a metadata chunk
allocation.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |    3 +++
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/extent-tree.c |   23 ++++++++++++++++++++++-
 fs/btrfs/super.c       |   12 +++++++++++-
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 86398a2..eff2ba5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -888,6 +888,9 @@ struct btrfs_fs_info {
 	u64 metadata_alloc_profile;
 	u64 system_alloc_profile;
 
+	unsigned data_chunk_allocations;
+	unsigned metadata_ratio;
+
 	void *bdev_holder;
 };
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d2e24c9..ddfd8af 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1601,6 +1601,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->btree_inode = new_inode(sb);
 	fs_info->btree_inode->i_ino = 1;
 	fs_info->btree_inode->i_nlink = 1;
+	fs_info->metadata_ratio = 8;
 
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index faa0c1d..f31da45 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1964,15 +1964,36 @@ void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 	spin_unlock(&info->lock);
 }
 
+static void force_metadata_allocation(struct btrfs_fs_info *info)
+{
+	struct list_head *head = &info->space_info;
+	struct btrfs_space_info *found;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(found, head, list) {
+		if (found->flags & BTRFS_BLOCK_GROUP_METADATA)
+			found->force_alloc = 1;
+	}
+	rcu_read_unlock();
+}
+
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force)
 {
 	struct btrfs_space_info *space_info;
+	struct btrfs_fs_info *fs_info = extent_root->fs_info;
 	u64 thresh;
 	int ret = 0;
 
-	mutex_lock(&extent_root->fs_info->chunk_mutex);
+	mutex_lock(&fs_info->chunk_mutex);
+
+	if (flags & BTRFS_BLOCK_GROUP_DATA) {
+		fs_info->data_chunk_allocations++;
+		if (!(fs_info->data_chunk_allocations %
+		      fs_info->metadata_ratio))
+			force_metadata_allocation(fs_info);
+	}
 
 	flags = btrfs_reduce_alloc_profile(extent_root, flags);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 19a4daf..92e3df0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -66,7 +66,7 @@ static void btrfs_put_super(struct super_block *sb)
 enum {
 	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
-	Opt_ssd, Opt_thread_pool, Opt_noacl,  Opt_compress, Opt_err,
+	Opt_ssd, Opt_thread_pool, Opt_noacl,  Opt_compress, Opt_ratio, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -83,6 +83,7 @@ static match_table_t tokens = {
 	{Opt_compress, "compress"},
 	{Opt_ssd, "ssd"},
 	{Opt_noacl, "noacl"},
+	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_err, NULL},
 };
 
@@ -222,6 +223,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_noacl:
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
+		case Opt_ratio:
+			intarg = 0;
+			match_int(&args[0], &intarg);
+			if (intarg) {
+				info->metadata_ratio = intarg;
+				printk(KERN_INFO "btrfs: metadata ratio %d\n",
+				       info->metadata_ratio);
+			}
+			break;
 		default:
 			break;
 		}
-- 
1.5.4.3

