From: bchociej@gmail.com
Subject: [RFC v2 PATCH 6/6] Btrfs: Add hooks to enable hot data tracking
Date: Thu, 12 Aug 2010 17:22:06 -0500
Message-ID: <1281651726-23501-7-git-send-email-bchociej@gmail.com>
References: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, bchociej@gmail.com, mlupfer@gmail.com,
	conscott@vt.edu
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ben Chociej <bchociej@gmail.com>

Miscellaneous features that implement hot data tracking, enable hot data
migration to faster media, and generally make the hot data functions a
bit more friendly.

ctree.h: Add the root hot_inode_tree and heat hashlists. Defines some
mount options and inode flags for turning all of the hot data
functionality on and off globally and per file. Defines some guard
macros that enforce the mount options and inode flags.

disk-io.c: Initialization and freeing of various structures.

extent-tree.c: Add block group types for SSD data and SSD metadata to
be relocated.

extent_io.c: Add hook into extent_write_cache_pages to enable hot data
tracking and migration functionality. Added miscellaneous code to set
some extent flags for migration / relocation.

inode.c: Add hooks into btrfs_direct_IO, btrfs_fiemap,
btrfs_writepage(s), and btrfs_readpages to enable hot data tracking
and relocation functionality.

super.c: Implement aforementioned mount options, does various
initializing and freeing.

volumes.c: Change the allocator to direct hot data on to SSD, cold data
to spinning disk.

Signed-off-by: Ben Chociej <bchociej@gmail.com>
Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
Signed-off-by: Conor Scott <conscott@vt.edu>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/btrfs/Makefile      |    3 +-
 fs/btrfs/ctree.h       |   96 ++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c     |   28 ++++++++
 fs/btrfs/extent-tree.c |   60 ++++++++++++++++--
 fs/btrfs/extent_io.c   |   34 ++++++++++
 fs/btrfs/extent_io.h   |    7 ++
 fs/btrfs/inode.c       |  162 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/super.c       |   62 +++++++++++++++++-
 fs/btrfs/volumes.c     |   38 ++++++++++-
 9 files changed, 473 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index a35eb36..46a4613 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,4 +7,5 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o \
-	   compression.o delayed-ref.o relocation.o
+	   compression.o delayed-ref.o relocation.o debugfs.o hotdata_map.o \
+	   hotdata_hash.o hotdata_relocate.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e9bf864..20d6351 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -31,6 +31,8 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -664,6 +666,17 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID1    (1 << 4)
 #define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
+/*
+ * New block groups for use with hot data relocation feature.  When hot data
+ * relocation is on, *_SSD block groups are forced to nonrotating drives and
+ * the plain DATA and METADATA block groups are forced to rotating drives.
+ *
+ * This should be further optimized, i.e. force metadata to SSD or relocate
+ * inode metadata to SSD when any of its subfile ranges are relocated to SSD
+ * so that reads and writes aren't delayed by HDD seeks.
+ */
+#define BTRFS_BLOCK_GROUP_DATA_SSD (1 << 7)
+#define BTRFS_BLOCK_GROUP_METADATA_SSD (1 << 8)
 #define BTRFS_NR_RAID_TYPES	   5
 
 struct btrfs_block_group_item {
@@ -877,6 +890,22 @@ struct btrfs_fs_info {
 	struct mutex cleaner_mutex;
 	struct mutex chunk_mutex;
 	struct mutex volume_mutex;
+
+	/* protects hot data items while being iterated and updated */
+	struct mutex hot_data_update_kthread_mutex;
+
+	/*
+	 * protects heat hash list while iterating through it for hot data
+	 * relocation operations
+	 */
+	struct mutex hot_data_relocate_kthread_mutex;
+
+	/*
+	 * will eventually protect ssd scan operations that bring previously
+	 * hot inode and range items into memory after a mount
+	 */
+	struct mutex ssd_scan_kthread_mutex;
+
 	/*
 	 * this protects the ordered operations list only while we are
 	 * processing all of the entries on it.  This way we make
@@ -950,6 +979,13 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_meta_write_workers;
 	struct btrfs_workers endio_write_workers;
 	struct btrfs_workers submit_workers;
+
+	/*
+	 * Workers to update hot_data_hash and relocate data
+	 */
+	struct btrfs_workers hot_data_update_workers;
+	struct btrfs_workers hot_data_relocate_workers;
+
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
 	 * the cow mechanism and make them safe to write.  It happens
@@ -958,6 +994,10 @@ struct btrfs_fs_info {
 	struct btrfs_workers fixup_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
+	struct task_struct *hot_data_update_kthread;
+	struct task_struct *hot_data_relocate_kthread;
+	struct task_struct *ssd_scan_kthread;
+
 	int thread_pool_size;
 
 	struct kobject super_kobj;
@@ -1009,6 +1049,9 @@ struct btrfs_fs_info {
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
 
+	unsigned data_ssd_chunk_allocations;
+	unsigned metadata_ssd_ratio;
+
 	void *bdev_holder;
 };
 
@@ -1092,6 +1135,20 @@ struct btrfs_root {
 	/* red-black tree that keeps track of in-memory inodes */
 	struct rb_root inode_tree;
 
+	/* red-black tree that keeps track of fs-wide hot data */
+	struct hot_inode_tree hot_inode_tree;
+
+	/* hash map of inode temperature */
+	struct heat_hashlist_entry heat_inode_hl[HEAT_HASH_SIZE];
+
+	/* hash map of range temperature */
+	struct heat_hashlist_entry heat_range_hl[HEAT_HASH_SIZE];
+
+	int heat_threshold;
+
+	struct btrfs_work work_inode;
+
+	struct btrfs_work work_range;
 	/*
 	 * right now this just gets used so that a root has its own devid
 	 * for stat.  It may be used for more later
@@ -1192,6 +1249,12 @@ struct btrfs_root {
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
 #define BTRFS_MOUNT_DISCARD		(1 << 10)
 #define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
+/*
+ * for activating hot data tracking and relocation.
+ * always ensure that HOTDATA_MOVE implies HOTDATA_TRACK.
+ */
+#define BTRFS_MOUNT_HOTDATA_TRACK	(1 << 12)
+#define BTRFS_MOUNT_HOTDATA_MOVE		(1 << 13)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
@@ -1211,6 +1274,28 @@ struct btrfs_root {
 #define BTRFS_INODE_NODUMP		(1 << 8)
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
+/*
+ * same as mount flags, but these turn off tracking/relocation when set
+ * to 1. (not implemented)
+ */
+#define BTRFS_INODE_NO_HOTDATA_TRACK	(1 << 11)
+#define BTRFS_INODE_NO_HOTDATA_MOVE	(1 << 12)
+
+/* Hot data tracking and relocation -- guard macros */
+#define BTRFS_TRACKING_HOT_DATA(btrfs_root)				\
+(btrfs_test_opt(btrfs_root, HOTDATA_TRACK))
+
+#define BTRFS_MOVING_HOT_DATA(btrfs_root)				\
+((btrfs_test_opt(btrfs_root, HOTDATA_MOVE)) &&				\
+!(btrfs_root->fs_info->sb->s_flags & MS_RDONLY))
+
+#define BTRFS_TRACK_THIS_INODE(btrfs_inode)				\
+((BTRFS_TRACKING_HOT_DATA(btrfs_inode->root)) &&			\
+!(btrfs_inode->flags & BTRFS_INODE_NO_HOTDATA_TRACK))
+
+#define BTRFS_MOVE_THIS_INODE(btrfs_inode)				\
+((BTRFS_MOVING_HOT_DATA(btrfs_inode->root)) &&				\
+!(btrfs_inode->flags & BTRFS_INODE_NO_HOTDATA_MOVE))
 
 /* some macros to generate set/get funcs for the struct fields.  This
  * assumes there is a lefoo_to_cpu for every type, so lets make a simple
@@ -2376,6 +2461,10 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
 int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state);
+int btrfs_set_extent_prefer_nonrotating(struct inode *inode, u64 start, u64 end,
+			      struct extent_state **cached_state);
+int btrfs_set_extent_prefer_rotating(struct inode *inode, u64 start, u64 end,
+			      struct extent_state **cached_state);
 int btrfs_writepages(struct address_space *mapping,
 		     struct writeback_control *wbc);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
@@ -2457,6 +2546,13 @@ int btrfs_sysfs_add_root(struct btrfs_root *root);
 void btrfs_sysfs_del_root(struct btrfs_root *root);
 void btrfs_sysfs_del_super(struct btrfs_fs_info *root);
 
+
+/* debugfs.c */
+int btrfs_init_debugfs(void);
+void btrfs_exit_debugfs(void);
+int btrfs_init_debugfs_volume(const char *, struct super_block *);
+void btrfs_exit_debugfs_volume(struct super_block *);
+
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..1758fa6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -39,6 +39,7 @@
 #include "locking.h"
 #include "tree-log.h"
 #include "free-space-cache.h"
+#include "hotdata_hash.h"
 
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -898,6 +899,8 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 			struct btrfs_fs_info *fs_info,
 			u64 objectid)
 {
+	int i;
+
 	root->node = NULL;
 	root->commit_root = NULL;
 	root->sectorsize = sectorsize;
@@ -917,6 +920,7 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->name = NULL;
 	root->in_sysfs = 0;
 	root->inode_tree = RB_ROOT;
+	hot_inode_tree_init(&root->hot_inode_tree);
 	root->block_rsv = NULL;
 	root->orphan_block_rsv = NULL;
 
@@ -938,6 +942,7 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->log_batch = 0;
 	root->log_transid = 0;
 	root->last_log_commit = 0;
+	root->heat_threshold = HEAT_INITIAL_THRESH;
 	extent_io_tree_init(&root->dirty_log_pages,
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 
@@ -945,6 +950,19 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
 	memset(&root->root_kobj, 0, sizeof(root->root_kobj));
+	memset(&root->heat_inode_hl, 0, sizeof(root->heat_inode_hl));
+	memset(&root->heat_range_hl, 0, sizeof(root->heat_range_hl));
+	for (i = 0; i < HEAT_HASH_SIZE; i++) {
+		INIT_HLIST_HEAD(&root->heat_inode_hl[i].hashhead);
+		INIT_HLIST_HEAD(&root->heat_range_hl[i].hashhead);
+
+		rwlock_init(&root->heat_inode_hl[i].rwlock);
+		rwlock_init(&root->heat_range_hl[i].rwlock);
+
+		root->heat_inode_hl[i].temperature = i;
+		root->heat_range_hl[i].temperature = i;
+	}
+
 	root->defrag_trans_start = fs_info->generation;
 	init_completion(&root->kobj_unregister);
 	root->defrag_running = 0;
@@ -1671,6 +1689,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
 	mutex_init(&fs_info->volume_mutex);
+	mutex_init(&fs_info->hot_data_update_kthread_mutex);
+	mutex_init(&fs_info->hot_data_relocate_kthread_mutex);
+	mutex_init(&fs_info->ssd_scan_kthread_mutex);
 	init_rwsem(&fs_info->extent_commit_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
@@ -2324,6 +2345,9 @@ static void free_fs_root(struct btrfs_root *root)
 		down_write(&root->anon_super.s_umount);
 		kill_anon_super(&root->anon_super);
 	}
+
+	free_heat_hashlists(root);
+	free_hot_inode_tree(root);
 	free_extent_buffer(root->node);
 	free_extent_buffer(root->commit_root);
 	kfree(root->name);
@@ -2429,6 +2453,10 @@ int close_ctree(struct btrfs_root *root)
 
 	kthread_stop(root->fs_info->transaction_kthread);
 	kthread_stop(root->fs_info->cleaner_kthread);
+	if (btrfs_test_opt(root, HOTDATA_TRACK))
+		kthread_stop(root->fs_info->hot_data_update_kthread);
+	if (btrfs_test_opt(root, HOTDATA_TRACK))
+		kthread_stop(root->fs_info->hot_data_relocate_kthread);
 
 	fs_info->closing = 2;
 	smp_mb();
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a46b64d..642a946 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -505,7 +505,8 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 	struct btrfs_space_info *found;
 
 	flags &= BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_SYSTEM |
-		 BTRFS_BLOCK_GROUP_METADATA;
+		 BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA_SSD |
+		 BTRFS_BLOCK_GROUP_METADATA_SSD;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
@@ -2780,7 +2781,9 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	spin_lock_init(&found->lock);
 	found->flags = flags & (BTRFS_BLOCK_GROUP_DATA |
 				BTRFS_BLOCK_GROUP_SYSTEM |
-				BTRFS_BLOCK_GROUP_METADATA);
+				BTRFS_BLOCK_GROUP_METADATA |
+				BTRFS_BLOCK_GROUP_DATA_SSD |
+				BTRFS_BLOCK_GROUP_METADATA_SSD);
 	found->total_bytes = total_bytes;
 	found->bytes_used = bytes_used;
 	found->disk_used = bytes_used * factor;
@@ -2854,12 +2857,21 @@ static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
 	return btrfs_reduce_alloc_profile(root, flags);
 }
 
+/*
+ * Turns a chunk_type integer into set of block group flags (a profile).
+ * Hot data relocation code adds chunk_types 2 and 3 for hot data specific
+ * block group types.
+ */
 static u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 {
 	u64 flags;
 
-	if (data)
+	if (data == 1)
 		flags = BTRFS_BLOCK_GROUP_DATA;
+	else if (data == 2)
+		flags = BTRFS_BLOCK_GROUP_DATA_SSD;
+	else if (data == 3)
+		flags = BTRFS_BLOCK_GROUP_METADATA_SSD;
 	else if (root == root->fs_info->chunk_root)
 		flags = BTRFS_BLOCK_GROUP_SYSTEM;
 	else
@@ -2998,6 +3010,19 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
 	rcu_read_unlock();
 }
 
+static void force_metadata_ssd_allocation(struct btrfs_fs_info *info)
+{
+	struct list_head *head = &info->space_info;
+	struct btrfs_space_info *found;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(found, head, list) {
+		if (found->flags & BTRFS_BLOCK_GROUP_METADATA_SSD)
+			found->force_alloc = 1;
+	}
+	rcu_read_unlock();
+}
+
 static int should_alloc_chunk(struct btrfs_space_info *sinfo,
 			      u64 alloc_bytes)
 {
@@ -3060,6 +3085,14 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			force_metadata_allocation(fs_info);
 	}
 
+	if (flags & BTRFS_BLOCK_GROUP_DATA_SSD &&
+		fs_info->metadata_ssd_ratio) {
+		fs_info->data_ssd_chunk_allocations++;
+		if (!(fs_info->data_ssd_chunk_allocations %
+		      fs_info->metadata_ssd_ratio))
+			force_metadata_ssd_allocation(fs_info);
+	}
+
 	ret = btrfs_alloc_chunk(trans, extent_root, flags);
 	spin_lock(&space_info->lock);
 	if (ret)
@@ -3503,6 +3536,20 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 	meta_used = sinfo->bytes_used;
 	spin_unlock(&sinfo->lock);
 
+	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA_SSD);
+	if (sinfo) {
+		spin_lock(&sinfo->lock);
+		data_used += sinfo->bytes_used;
+		spin_unlock(&sinfo->lock);
+	}
+
+	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA_SSD);
+	if (sinfo) {
+		spin_lock(&sinfo->lock);
+		meta_used += sinfo->bytes_used;
+		spin_unlock(&sinfo->lock);
+	}
+
 	num_bytes = (data_used >> fs_info->sb->s_blocksize_bits) *
 		    csum_size * 2;
 	num_bytes += div64_u64(data_used + meta_used, 50);
@@ -3518,7 +3565,6 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	struct btrfs_space_info *sinfo = block_rsv->space_info;
 	u64 num_bytes;
-
 	num_bytes = calc_global_metadata_size(fs_info);
 
 	spin_lock(&block_rsv->lock);
@@ -4831,7 +4877,8 @@ checks:
 		BUG_ON(offset > search_start);
 
 		ret = update_reserved_bytes(block_group, num_bytes, 1,
-					    (data & BTRFS_BLOCK_GROUP_DATA));
+					  (data & BTRFS_BLOCK_GROUP_DATA) ||
+					  (data & BTRFS_BLOCK_GROUP_DATA_SSD));
 		if (ret == -EAGAIN) {
 			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
@@ -4939,7 +4986,8 @@ loop:
 
 	/* we found what we needed */
 	if (ins->objectid) {
-		if (!(data & BTRFS_BLOCK_GROUP_DATA))
+		if (!(data & BTRFS_BLOCK_GROUP_DATA) &&
+		    !(data & BTRFS_BLOCK_GROUP_DATA_SSD))
 			trans->block_group = block_group->key.objectid;
 
 		btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a4080c2..d17118a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -961,6 +961,22 @@ int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			      0, NULL, cached_state, mask);
 }
 
+int set_extent_prefer_nonrotating(struct extent_io_tree *tree, u64 start,
+				  u64 end, struct extent_state **cached_state,
+				  gfp_t mask)
+{
+	return set_extent_bit(tree, start, end, EXTENT_PREFER_NONROTATING,
+			      0, NULL, cached_state, mask);
+}
+
+int set_extent_prefer_rotating(struct extent_io_tree *tree, u64 start,
+				  u64 end, struct extent_state **cached_state,
+				  gfp_t mask)
+{
+	return set_extent_bit(tree, start, end, EXTENT_PREFER_ROTATING,
+			      0, NULL, cached_state, mask);
+}
+
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask)
 {
@@ -2468,8 +2484,10 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 	int ret = 0;
 	int done = 0;
 	int nr_to_write_done = 0;
+	int nr_written = 0;
 	struct pagevec pvec;
 	int nr_pages;
+	pgoff_t start;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
@@ -2486,6 +2504,7 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 			range_whole = 1;
 		scanned = 1;
 	}
+	start = index << PAGE_CACHE_SHIFT;
 retry:
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
@@ -2547,10 +2566,13 @@ retry:
 			 * at any time
 			 */
 			nr_to_write_done = wbc->nr_to_write <= 0;
+			nr_written += 1;
 		}
+
 		pagevec_release(&pvec);
 		cond_resched();
 	}
+
 	if (!scanned && !done) {
 		/*
 		 * We hit the last page and there is more work to be done: wrap
@@ -2560,6 +2582,18 @@ retry:
 		index = 0;
 		goto retry;
 	}
+
+	/*
+	 * Update access frequency statistics.
+	 * i_ino = 1 appears to come from metadata operations, ignore
+	 * those writes.
+	 */
+	if (BTRFS_TRACK_THIS_INODE(BTRFS_I(mapping->host)) &&
+		mapping->host->i_ino > 1 && nr_written > 0) {
+		btrfs_update_freqs(mapping->host, start,
+			nr_written * PAGE_CACHE_SIZE, 1);
+	}
+
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5691c7b..a51e7c6 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -17,6 +17,8 @@
 #define EXTENT_NODATASUM (1 << 10)
 #define EXTENT_DO_ACCOUNTING (1 << 11)
 #define EXTENT_FIRST_DELALLOC (1 << 12)
+#define EXTENT_PREFER_NONROTATING (1 << 13)
+#define EXTENT_PREFER_ROTATING (1 << 14)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -205,6 +207,11 @@ int clear_extent_ordered_metadata(struct extent_io_tree *tree, u64 start,
 				  u64 end, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
+int set_extent_prefer_nonrotating(struct extent_io_tree *tree, u64 start,
+			u64 end, struct extent_state **cached_state,
+			gfp_t mask);
+int set_extent_prefer_rotating(struct extent_io_tree *tree, u64 start, u64 end,
+			struct extent_state **cached_state, gfp_t mask);
 int set_extent_ordered(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f08427c..25d2404 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -37,6 +37,7 @@
 #include <linux/posix_acl.h>
 #include <linux/falloc.h>
 #include <linux/slab.h>
+#include <linux/pagevec.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -50,6 +51,8 @@
 #include "tree-log.h"
 #include "compression.h"
 #include "locking.h"
+#include "hotdata_map.h"
+#include "hotdata_relocate.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -763,6 +766,9 @@ static noinline int cow_file_range(struct inode *inode,
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;
+	int prefer_nonrot;
+	int prefer_rot;
+	int chunk_type = 1;
 
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(!trans);
@@ -776,6 +782,79 @@ static noinline int cow_file_range(struct inode *inode,
 	disk_num_bytes = num_bytes;
 	ret = 0;
 
+	/*
+	 * Use COW operations to move hot data to SSD and cold data
+	 * back to rotating disk.  Sets chunk_type to 1 to indicate
+	 * to write to BTRFS_BLOCK_GROUP_DATA or 2 to indicate
+	 * BTRFS_BLOCK_GROUP_DATA_SSD.
+	 */
+	if (BTRFS_MOVE_THIS_INODE(BTRFS_I(inode))) {
+		prefer_nonrot = test_range_bit(&BTRFS_I(inode)->io_tree,
+			start, end, EXTENT_PREFER_NONROTATING, 1, NULL);
+		prefer_rot = test_range_bit(&BTRFS_I(inode)->io_tree,
+			start, end, EXTENT_PREFER_ROTATING, 1, NULL);
+		WARN_ON(prefer_nonrot && prefer_rot);
+
+		if (prefer_nonrot)
+			chunk_type = 2;
+		if (prefer_rot)
+			chunk_type = 1;
+
+		/*
+		 * Although the async thread has not chosen this range
+		 * for relocation to SSD, we're COWing the data anyway
+		 * so let's test the range now. Note that "range" here
+		 * is different from ranges on RANGE_SIZE boundaries.
+		 */
+		if (!(prefer_rot || prefer_nonrot)) {
+			int temperature = 0;
+			struct hot_inode_item *he;
+			struct hot_range_item *hr;
+
+			/* Test just the first proper hotdata range */
+			he = lookup_hot_inode_item(
+				&root->hot_inode_tree, inode->i_ino);
+			if (!he)
+				goto skip_cow_reloc;
+			hr = lookup_hot_range_item(&he->hot_range_tree,
+						   start & RANGE_SIZE_MASK);
+			if (!hr) {
+				free_hot_inode_item(he);
+				goto skip_cow_reloc;
+			}
+
+			spin_lock(&hr->lock);
+			temperature = btrfs_get_temp(&hr->freq_data);
+			spin_unlock(&hr->lock);
+
+			if (temperature >=
+				root->fs_info->fs_root->heat_threshold) {
+				/* This range is hot */
+				chunk_type = 2;
+
+				/*
+				 * Set extent flags and location so future
+				 * operations keep the range on SSD
+				 */
+				btrfs_set_extent_prefer_nonrotating(inode,
+					start, end, NULL);
+				clear_extent_bits(&BTRFS_I(inode)->io_tree,
+					start, end, EXTENT_PREFER_ROTATING,
+					GFP_NOFS);
+				spin_lock(&hr->lock);
+				spin_lock(&hr->heat_node->location_lock);
+				hr->heat_node->location = BTRFS_ON_NONROTATING;
+				spin_unlock(&hr->heat_node->location_lock);
+				spin_unlock(&hr->lock);
+			} else
+				chunk_type = 1;
+
+			free_hot_range_item(hr);
+			free_hot_inode_item(he);
+		}
+	}
+
+skip_cow_reloc:
 	if (start == 0) {
 		/* lets try to make an inline extent */
 		ret = cow_file_range_inline(trans, root, inode,
@@ -811,7 +890,10 @@ static noinline int cow_file_range(struct inode *inode,
 		cur_alloc_size = disk_num_bytes;
 		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
-					   (u64)-1, &ins, 1);
+					   (u64)-1, &ins, chunk_type);
+		if (ret)
+			printk(KERN_INFO "btrfs cow_file_range btrfs_reserve"
+				"_extent returned %d\n", ret);
 		BUG_ON(ret);
 
 		em = alloc_extent_map(GFP_NOFS);
@@ -1225,9 +1307,25 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 			      unsigned long *nr_written)
 {
 	int ret;
+	int prefer_rot = 0;
+	int prefer_nonrot = 0;
+
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)
+	/*
+	 * Force COW for hot data relocation
+	 */
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW &&
+		BTRFS_MOVE_THIS_INODE(BTRFS_I(inode))) {
+		prefer_nonrot = test_range_bit(&BTRFS_I(inode)->io_tree,
+			start, end, EXTENT_PREFER_NONROTATING, 1, NULL);
+		prefer_rot = test_range_bit(&BTRFS_I(inode)->io_tree,
+			start, end, EXTENT_PREFER_ROTATING, 1, NULL);
+		WARN_ON(prefer_nonrot && prefer_rot);
+	}
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !(prefer_rot ||
+		prefer_nonrot))
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
 	else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC)
@@ -1480,6 +1578,26 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 				   cached_state, GFP_NOFS);
 }
 
+int btrfs_set_extent_prefer_nonrotating(struct inode *inode, u64 start,
+				     u64 end, struct extent_state
+				     **cached_state)
+{
+	if ((end & (PAGE_CACHE_SIZE - 1)) == 0)
+		WARN_ON(1);
+	return set_extent_prefer_nonrotating(&BTRFS_I(inode)->io_tree, start,
+					  end, cached_state, GFP_NOFS);
+}
+
+int btrfs_set_extent_prefer_rotating(struct inode *inode, u64 start,
+				     u64 end, struct extent_state
+				     **cached_state)
+{
+	if ((end & (PAGE_CACHE_SIZE - 1)) == 0)
+		WARN_ON(1);
+	return set_extent_prefer_rotating(&BTRFS_I(inode)->io_tree, start,
+					  end, cached_state, GFP_NOFS);
+}
+
 /* see btrfs_writepage_start_hook for details on why this is required */
 struct btrfs_writepage_fixup {
 	struct page *page;
@@ -2870,6 +2988,18 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 				 dentry->d_name.name, dentry->d_name.len);
 	BUG_ON(ret);
 
+	if (BTRFS_TRACKING_HOT_DATA(root)) {
+		struct hot_inode_item *he;
+
+		he = lookup_hot_inode_item(
+			&root->hot_inode_tree, inode->i_ino);
+
+		if (he) {
+			btrfs_remove_inode_from_heat_index(he, root);
+			free_hot_inode_item(he);
+		}
+	}
+
 	if (inode->i_nlink == 0) {
 		ret = btrfs_orphan_add(trans, inode);
 		BUG_ON(ret);
@@ -5781,6 +5911,11 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	lockstart = offset;
 	lockend = offset + count - 1;
 
+	/* Update access frequency statistics */
+	if (BTRFS_TRACK_THIS_INODE(BTRFS_I(inode)) && count > 0)
+		btrfs_update_freqs(inode, lockstart, (u64) count,
+			writing);
+
 	if (writing) {
 		ret = btrfs_delalloc_reserve_space(inode, count);
 		if (ret)
@@ -5860,7 +5995,16 @@ static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 int btrfs_readpage(struct file *file, struct page *page)
 {
 	struct extent_io_tree *tree;
+	u64 start;
+
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	start = (u64) page->index << PAGE_CACHE_SHIFT;
+
+	/* Update access frequency statistics */
+	if (BTRFS_TRACK_THIS_INODE(BTRFS_I(page->mapping->host)))
+		btrfs_update_freqs(page->mapping->host, start,
+			PAGE_CACHE_SIZE, 0);
+
 	return extent_read_full_page(tree, page, btrfs_get_extent);
 }
 
@@ -5868,13 +6012,14 @@ static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct extent_io_tree *tree;
 
-
 	if (current->flags & PF_MEMALLOC) {
 		redirty_page_for_writepage(wbc, page);
 		unlock_page(page);
 		return 0;
 	}
+
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
+
 	return extent_write_full_page(tree, page, btrfs_get_extent, wbc);
 }
 
@@ -5884,6 +6029,7 @@ int btrfs_writepages(struct address_space *mapping,
 	struct extent_io_tree *tree;
 
 	tree = &BTRFS_I(mapping->host)->io_tree;
+
 	return extent_writepages(tree, mapping, btrfs_get_extent, wbc);
 }
 
@@ -5892,7 +6038,17 @@ btrfs_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
 	struct extent_io_tree *tree;
+	u64 start, len;
+
 	tree = &BTRFS_I(mapping->host)->io_tree;
+	start = (u64) (list_entry(pages->prev, struct page, lru)->index)
+		<< PAGE_CACHE_SHIFT;
+	len = nr_pages * PAGE_CACHE_SIZE;
+
+	/* Update access frequency statistics */
+	if (len > 0 && BTRFS_TRACK_THIS_INODE(BTRFS_I(mapping->host)))
+		btrfs_update_freqs(mapping->host, start, len, 0);
+
 	return extent_readpages(tree, mapping, pages, nr_pages,
 				btrfs_get_extent);
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 859ddaa..c1c22a0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -51,6 +51,9 @@
 #include "version.h"
 #include "export.h"
 #include "compression.h"
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
+#include "hotdata_relocate.h"
 
 static const struct super_operations btrfs_super_ops;
 
@@ -59,6 +62,11 @@ static void btrfs_put_super(struct super_block *sb)
 	struct btrfs_root *root = btrfs_sb(sb);
 	int ret;
 
+	root->heat_threshold = 0;
+
+	if (btrfs_test_opt(root, HOTDATA_TRACK))
+		btrfs_exit_debugfs_volume(sb);
+
 	ret = close_ctree(root);
 	sb->s_fs_info = NULL;
 }
@@ -68,7 +76,7 @@ enum {
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_err,
+	Opt_discard, Opt_hotdatatrack, Opt_hotdatamove, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -92,6 +100,8 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_hotdatatrack, "hotdatatrack"},
+	{Opt_hotdatamove, "hotdatamove"},
 	{Opt_err, NULL},
 };
 
@@ -235,6 +245,18 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_hotdatamove:
+			printk(KERN_INFO "btrfs: turning on hot data "
+				"migration\n");
+			printk(KERN_INFO "       (implies hotdatatrack, "
+				"no ssd_spread)\n");
+			btrfs_set_opt(info->mount_opt, HOTDATA_MOVE);
+			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
+		case Opt_hotdatatrack:
+			printk(KERN_INFO "btrfs: turning on hot data"
+				" tracking\n");
+			btrfs_set_opt(info->mount_opt, HOTDATA_TRACK);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -457,6 +479,17 @@ static int btrfs_fill_super(struct super_block *sb,
 		printk("btrfs: open_ctree failed\n");
 		return PTR_ERR(tree_root);
 	}
+
+	/*
+	 * Initialize relocate kthread with HOTDATA_TRACK
+	 * to allow seamless remount to enable HOTDATA_MOVE
+	 */
+	if (btrfs_test_opt(tree_root, HOTDATA_TRACK)) {
+		init_hash_list_kthread(tree_root);
+		init_hot_data_relocate_kthread(tree_root);
+		init_ssd_scan_kthread(tree_root);
+	}
+
 	sb->s_fs_info = tree_root;
 	disk_super = &tree_root->fs_info->super_copy;
 
@@ -658,6 +691,8 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 
 	mnt->mnt_sb = s;
 	mnt->mnt_root = root;
+	if (btrfs_test_opt(btrfs_sb(s), HOTDATA_TRACK))
+		btrfs_init_debugfs_volume(dev_name, s);
 
 	kfree(subvol_name);
 	return 0;
@@ -846,18 +881,30 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_sysfs;
 
-	err = extent_io_init();
+	err = btrfs_init_debugfs();
 	if (err)
 		goto free_cachep;
 
+	err = extent_io_init();
+	if (err)
+		goto free_debugfs;
+
 	err = extent_map_init();
 	if (err)
 		goto free_extent_io;
 
-	err = btrfs_interface_init();
+	err = hot_inode_item_init();
 	if (err)
 		goto free_extent_map;
 
+	err = hot_range_item_init();
+	if (err)
+		goto free_hot_inode_item;
+
+	err = btrfs_interface_init();
+	if (err)
+		goto free_hot_range_item;
+
 	err = register_filesystem(&btrfs_fs_type);
 	if (err)
 		goto unregister_ioctl;
@@ -867,10 +914,16 @@ static int __init init_btrfs_fs(void)
 
 unregister_ioctl:
 	btrfs_interface_exit();
+free_hot_range_item:
+	hot_range_item_exit();
+free_hot_inode_item:
+	hot_inode_item_exit();
 free_extent_map:
 	extent_map_exit();
 free_extent_io:
 	extent_io_exit();
+free_debugfs:
+	btrfs_exit_debugfs();
 free_cachep:
 	btrfs_destroy_cachep();
 free_sysfs:
@@ -882,10 +935,13 @@ static void __exit exit_btrfs_fs(void)
 {
 	btrfs_destroy_cachep();
 	extent_map_exit();
+	hot_inode_item_exit();
+	hot_range_item_exit();
 	extent_io_exit();
 	btrfs_interface_exit();
 	unregister_filesystem(&btrfs_fs_type);
 	btrfs_exit_sysfs();
+	btrfs_exit_debugfs();
 	btrfs_cleanup_fs_uuids();
 	btrfs_zlib_exit();
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d6e3af8..62fd1ab 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2210,10 +2210,12 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		min_stripes = 4;
 	}
 
-	if (type & BTRFS_BLOCK_GROUP_DATA) {
+	if (type & BTRFS_BLOCK_GROUP_DATA ||
+	    type & BTRFS_BLOCK_GROUP_DATA_SSD) {
 		max_chunk_size = 10 * calc_size;
 		min_stripe_size = 64 * 1024 * 1024;
-	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
+	} else if (type & BTRFS_BLOCK_GROUP_METADATA ||
+		   type & BTRFS_BLOCK_GROUP_METADATA_SSD) {
 		max_chunk_size = 256 * 1024 * 1024;
 		min_stripe_size = 32 * 1024 * 1024;
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
@@ -2274,15 +2276,43 @@ again:
 
 	INIT_LIST_HEAD(&private_devs);
 	while (index < num_stripes) {
+		int dev_rotating;
+		int skip_device = 0;
 		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
 		BUG_ON(!device->writeable);
+		dev_rotating = !blk_queue_nonrot(bdev_get_queue(device->bdev));
+
+		/*
+		 * If HOTDATA_MOVE is set, the chunk type being allocated
+		 * determines which disks the data may be allocated on.
+		 * This can cause problems if, for example, the data alloc
+		 * profile is RAID0 and there are only two devices, 1 SSD +
+		 * 1 HDD.  All allocations to BTRFS_BLOCK_GROUP_DATA_SSD
+		 * in this config will return -ENOSPC as the allocation code
+		 * can't find allowable space for the second stripe.
+		 */
+		if (btrfs_test_opt(extent_root, HOTDATA_MOVE)) {
+			if (type & BTRFS_BLOCK_GROUP_DATA &&
+				!dev_rotating)
+				skip_device = 1;
+			if (type & BTRFS_BLOCK_GROUP_METADATA &&
+				!dev_rotating)
+				skip_device = 1;
+			if (type & BTRFS_BLOCK_GROUP_DATA_SSD &&
+				dev_rotating)
+				skip_device = 1;
+			if (type & BTRFS_BLOCK_GROUP_METADATA_SSD &&
+				dev_rotating)
+				skip_device = 1;
+		}
 		if (device->total_bytes > device->bytes_used)
 			avail = device->total_bytes - device->bytes_used;
 		else
 			avail = 0;
-		cur = cur->next;
 
-		if (device->in_fs_metadata && avail >= min_free) {
+		cur = cur->next;
+		if (!skip_device &&
+			device->in_fs_metadata && avail >= min_free) {
 			ret = find_free_dev_extent(trans, device,
 						   min_free, &dev_offset,
 						   &max_avail);
-- 
1.7.1
