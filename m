From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] Btrfs: introducing speed profiles and dedicated log devices
Date: Fri, 28 Jan 2011 14:11:30 +0100
Message-ID: <1296220290-27999-1-git-send-email-sensille@gmx.net>
Cc: chris.mason@oracle.com, josef@redhat.com, linux-btrfs@jan-o-sch.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces speed profiles into btrfs. Each device gets tagged with a
speed index. The purpose of profiles is to determine which writes go to which
devices.
A profile consists mainly of an enumeration of allowed speed indices, in
descending order. There are 4 predefined profiles, namely for meta data, data,
system data and log data. Profiles are handed down from tree to tree and pushed
into the inodes. By changing the profiles of an fs tree one can direct writes
for this tree to different devices.
The first application of this patch is to direct the log tree to dedicated
devices, thus enabling btrfs to take advantage of an additional SSD to speed up
synchronous writes. With the accompanying patch for mkfs and btrfs one can
dedicate the devices to either log only, meta+log, meta+data+log or data only.

The main idea behind this patch is to expand block reserves to be able to
reserve space from multiple space_infos. For this, each block_rsv has to track
from which space_info it reserves how many bytes. The same has to be done for
each inode, as they reserve space without using block reserves.

The other part of the patch deals with the separation of the log tree to
separate devices. For this, the log tree gets its own profile. Additionally,
btrfs_sync_log now writes supers only to the log devices, all other devices only
get flushed.

What might be added next:
 - currently sync file data always gets written directly to its final location
   unless it's an inline extent. This makes the log device much less useful
   than it could be. Add the capability to stash file data on the log devices.
 - during a transaction log tree blocks get used and freed in rapid order. The
   freed blocks only get reused after the transaction commits. This leads to a
   massive waste of log space. Normally this shouldn't be a problem if the log
   device is reasonably large.
 - instead of flushing all devices and writing supers only to the fastest log
   devices, track which devices receive sync file data and which receive log
   tree blocks during a log transaction and flush / write supers to only those.
 - save profiles to disk
 - save profile assignments with the fs trees
 - make profiles changeable
 - make speeds changeable

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/btrfs_inode.h  |   15 +-
 fs/btrfs/ctree.h        |   74 +++-
 fs/btrfs/disk-io.c      |  183 +++++++++-
 fs/btrfs/disk-io.h      |    3 +-
 fs/btrfs/extent-tree.c  |  928 +++++++++++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.c    |    8 +-
 fs/btrfs/inode.c        |   53 ++--
 fs/btrfs/ioctl.c        |   23 ++-
 fs/btrfs/ioctl.h        |    8 +-
 fs/btrfs/ordered-data.c |    2 +-
 fs/btrfs/relocation.c   |    3 +-
 fs/btrfs/transaction.c  |    5 +-
 fs/btrfs/tree-log.c     |    4 +-
 fs/btrfs/volumes.c      |   88 ++++-
 fs/btrfs/volumes.h      |   13 +-
 15 files changed, 1066 insertions(+), 344 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ccc991c..b03a4f9 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -68,8 +68,8 @@ struct btrfs_inode {
 	/* node for the red-black tree that links inodes in subvolume root */
 	struct rb_node rb_node;
 
-	/* the space_info for where this inode's data allocations are done */
-	struct btrfs_space_info *space_info;
+	/* the profile for where this inode's data allocations are done */
+	struct btrfs_profile *profile;
 
 	/* full 64 bit generation number, struct vfs_inode doesn't have a big
 	 * enough field for this.
@@ -99,10 +99,19 @@ struct btrfs_inode {
 	 */
 	u64 delalloc_bytes;
 
+	/* used to protect reserved_total and reserved_from
+	 */
+	spinlock_t reserved_lock;
+
 	/* total number of bytes that may be used for this inode for
 	 * delalloc
 	 */
-	u64 reserved_bytes;
+	u64 reserved_total;
+
+	/* where did we reserve the bytes from? indices correspond to the
+	 * profile
+	 */
+	u64 reserved_from[MAX_PROFILE_ENTRIES];
 
 	/*
 	 * the size of the file stored in the metadata on disk.  data=ordered
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7219537..fe49bc5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -728,7 +728,8 @@ struct btrfs_space_info {
 	u64 disk_used;		/* total bytes used on disk */
 	u64 disk_total;		/* total bytes on disk, takes mirrors into
 				   account */
-
+	int speed;		/* device's seek_speed, used to classify devices
+				   for profiles */
 	int full;		/* indicates that we cannot allocate any more
 				   chunks for this space */
 	int force_alloc;	/* set if we need to force a chunk alloc for
@@ -743,18 +744,39 @@ struct btrfs_space_info {
 	atomic_t caching_threads;
 };
 
+#define MAX_PROFILE_ENTRIES	16
+#define MAX_PROFILE_NAME	64
+
+struct btrfs_profile {
+	u8 speed[MAX_PROFILE_ENTRIES];
+	int nentries;
+	struct list_head profile_list;
+	char name[MAX_PROFILE_NAME];
+	struct btrfs_space_info	*data_sinfo[MAX_PROFILE_ENTRIES];
+	struct btrfs_space_info	*meta_sinfo[MAX_PROFILE_ENTRIES];
+};
+
 struct btrfs_block_rsv {
-	u64 size;
-	u64 reserved;
-	u64 freed[2];
-	struct btrfs_space_info *space_info;
-	struct list_head list;
+	u64 size;		/* target size of the reserve */
+	u64 reserved_total;	/* # of bytes reserved in the space_info, i.e
+				   number of bytes to expend */
+	u64 freed_total[2];	/* only for durable block_rsv, freed bytes for
+	                           [transaction & 1] */
+	struct list_head list;	/* element of fs_info.durable_block_rsv_list */
 	spinlock_t lock;
-	atomic_t usage;
-	unsigned int priority:8;
-	unsigned int durable:1;
-	unsigned int refill_used:1;
-	unsigned int full:1;
+	atomic_t usage;		/* refcount */
+	unsigned int priority:8;/* unused for now */
+	unsigned int durable:1;	/* spans transactions */
+	unsigned int refill_used:1; /* refill reserve from space_info if
+	                               getting empty */
+
+	unsigned int full:1;	/* set when reserved >= size. Full means we
+	                           have a full reserve to expend from */
+	/* track from which speeds we allocated space. the indices into the
+	   arrays correspond to the index into the profile */
+	u64 reserved_from[MAX_PROFILE_ENTRIES];
+	u64 freed_from[2][MAX_PROFILE_ENTRIES];
+	struct btrfs_profile *profile;
 };
 
 /*
@@ -820,6 +842,7 @@ struct btrfs_block_group_cache {
 	u64 bytes_super;
 	u64 flags;
 	u64 sectorsize;
+	int speed;
 	int extents_thresh;
 	int free_extents;
 	int total_bitmaps;
@@ -895,6 +918,12 @@ struct btrfs_fs_info {
 	struct btrfs_block_rsv chunk_block_rsv;
 
 	struct btrfs_block_rsv empty_block_rsv;
+	struct btrfs_block_rsv log_block_rsv;
+
+	struct btrfs_profile default_data_profile;
+	struct btrfs_profile default_meta_profile;
+	struct btrfs_profile default_system_profile;
+	struct btrfs_profile default_log_profile;
 
 	/* list of block reservations that cross multiple transactions */
 	struct list_head durable_block_rsv_list;
@@ -1136,6 +1165,12 @@ struct btrfs_root {
 	char *name;
 	int in_sysfs;
 
+	/* profiles to use for allocations for this tree */
+	struct btrfs_profile *data_profile;
+	struct btrfs_profile *meta_profile;
+	struct btrfs_profile *system_profile;
+	struct btrfs_profile *log_profile;
+
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
 
@@ -2085,6 +2120,8 @@ static inline bool btrfs_mixed_space_info(struct btrfs_space_info *space_info)
 }
 
 /* extent-tree.c */
+int btrfs_init_profile(struct btrfs_fs_info *fs_info,
+                       struct btrfs_profile *profile, int is_system);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, unsigned long count);
@@ -2132,7 +2169,15 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  u64 num_bytes, u64 min_alloc_size,
 				  u64 empty_size, u64 hint_byte,
 				  u64 search_end, struct btrfs_key *ins,
-				  u64 data);
+				  u64 data, struct btrfs_profile *profile,
+				  int pix);
+int btrfs_reserve_data_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 struct inode *inode,
+			 u64 num_bytes, u64 min_alloc_size,
+			 u64 empty_size, u64 hint_byte,
+			 u64 search_end, struct btrfs_key *ins,
+			 u64 data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -2170,7 +2215,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
-void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
+void btrfs_set_inode_profile(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
@@ -2189,7 +2234,8 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv);
-struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root);
+struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
+                                              struct btrfs_profile *profile);
 void btrfs_free_block_rsv(struct btrfs_root *root,
 			  struct btrfs_block_rsv *rsv);
 void btrfs_add_durable_block_rsv(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1a3af9e..3ed3ec5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -945,7 +945,11 @@ int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 			u32 stripesize, struct btrfs_root *root,
 			struct btrfs_fs_info *fs_info,
-			u64 objectid)
+			u64 objectid,
+                        struct btrfs_profile *data_profile,
+                        struct btrfs_profile *meta_profile,
+                        struct btrfs_profile *system_profile,
+                        struct btrfs_profile *log_profile)
 {
 	root->node = NULL;
 	root->commit_root = NULL;
@@ -968,6 +972,10 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->inode_tree = RB_ROOT;
 	root->block_rsv = NULL;
 	root->orphan_block_rsv = NULL;
+	root->data_profile = data_profile;
+	root->system_profile = system_profile;
+	root->meta_profile = meta_profile;
+	root->log_profile = log_profile;
 
 	INIT_LIST_HEAD(&root->dirty_list);
 	INIT_LIST_HEAD(&root->orphan_list);
@@ -1018,7 +1026,10 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
 		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, objectid);
+		     root, fs_info, objectid, tree_root->data_profile,
+	             tree_root->meta_profile, tree_root->system_profile,
+	             tree_root->log_profile);
+
 	ret = btrfs_find_last_root(tree_root, objectid,
 				   &root->root_item, &root->root_key);
 	if (ret > 0)
@@ -1050,7 +1061,9 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
 		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, BTRFS_TREE_LOG_OBJECTID);
+		     root, fs_info, BTRFS_TREE_LOG_OBJECTID,
+	             tree_root->log_profile, tree_root->log_profile,
+	             tree_root->system_profile, tree_root->log_profile);
 
 	root->root_key.objectid = BTRFS_TREE_LOG_OBJECTID;
 	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -1153,7 +1166,9 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
 		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, location->objectid);
+		     root, fs_info, location->objectid,
+	             tree_root->data_profile, tree_root->meta_profile,
+	             tree_root->system_profile, tree_root->log_profile);
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -1656,6 +1671,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	btrfs_init_block_rsv(&fs_info->trans_block_rsv);
 	btrfs_init_block_rsv(&fs_info->chunk_block_rsv);
 	btrfs_init_block_rsv(&fs_info->empty_block_rsv);
+	btrfs_init_block_rsv(&fs_info->log_block_rsv);
 	INIT_LIST_HEAD(&fs_info->durable_block_rsv_list);
 	mutex_init(&fs_info->durable_block_rsv_mutex);
 	atomic_set(&fs_info->nr_async_submits, 0);
@@ -1732,8 +1748,34 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
 
+	fs_info->default_data_profile.nentries = 2;
+	fs_info->default_data_profile.speed[0] = 35;
+	fs_info->default_data_profile.speed[1] = 30;
+	ret = btrfs_init_profile(fs_info, &fs_info->default_data_profile, 0);
+	BUG_ON(ret);
+	fs_info->default_meta_profile.nentries = 2;
+	fs_info->default_meta_profile.speed[0] = 45;
+	fs_info->default_meta_profile.speed[1] = 30;
+	ret = btrfs_init_profile(fs_info, &fs_info->default_meta_profile, 0);
+	BUG_ON(ret);
+	fs_info->default_system_profile.nentries = 2;
+	fs_info->default_system_profile.speed[0] = 45;
+	fs_info->default_system_profile.speed[1] = 30;
+	ret = btrfs_init_profile(fs_info, &fs_info->default_system_profile, 1);
+	BUG_ON(ret);
+	fs_info->default_log_profile.nentries = 3;
+	fs_info->default_log_profile.speed[0] = 75;
+	fs_info->default_log_profile.speed[1] = 45;
+	fs_info->default_log_profile.speed[2] = 30;
+	ret = btrfs_init_profile(fs_info, &fs_info->default_log_profile, 0);
+	BUG_ON(ret);
+
 	__setup_root(4096, 4096, 4096, 4096, tree_root,
-		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
+		     fs_info, BTRFS_ROOT_TREE_OBJECTID,
+	             &fs_info->default_data_profile,
+	             &fs_info->default_meta_profile,
+	             &fs_info->default_system_profile,
+	             &fs_info->default_log_profile);
 
 	bh = btrfs_read_dev_super(fs_devices->latest_bdev);
 	if (!bh) {
@@ -1891,7 +1933,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	generation = btrfs_super_chunk_root_generation(disk_super);
 
 	__setup_root(nodesize, leafsize, sectorsize, stripesize,
-		     chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
+		     chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID,
+	             tree_root->data_profile, tree_root->meta_profile,
+	             tree_root->system_profile, tree_root->log_profile);
 
 	chunk_root->node = read_tree_block(chunk_root,
 					   btrfs_super_chunk_root(disk_super),
@@ -1968,6 +2012,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		goto fail_block_groups;
 	}
 
+	/* FIXME read profiles from disk */
+
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
 	if (IS_ERR(fs_info->cleaner_kthread))
@@ -2009,7 +2055,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		}
 
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
-			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
+			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID,
+		             tree_root->data_profile, tree_root->meta_profile,
+		             tree_root->system_profile, tree_root->log_profile);
 
 		log_tree_root->node = read_tree_block(tree_root, bytenr,
 						      blocksize,
@@ -2285,7 +2333,63 @@ static int write_dev_supers(struct btrfs_device *device,
 	return errors < i ? 0 : -1;
 }
 
-int write_all_supers(struct btrfs_root *root, int max_mirrors)
+static void btrfs_end_empty_barrier(struct bio *bio, int err)
+{
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	}
+	if (bio->bi_private)
+		complete(bio->bi_private);
+	bio_put(bio);
+}
+
+static int write_dev_flush(struct btrfs_device *device, int wait)
+{
+	struct bio *bio;
+	int ret = 0;
+
+	if (!device->barriers)
+		return 0;
+
+	if (wait) {
+		bio = device->flush_bio;
+		wait_for_completion(&device->flush_wait);
+
+		if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
+			printk("btrfs: disabling barriers on dev %s\n",
+			       device->name);
+			device->barriers = 0;
+		}
+		if (!bio_flagged(bio, BIO_UPTODATE)) {
+			ret = -EIO;
+		}
+
+		/* drop the reference from the wait == 0 run */
+		bio_put(bio);
+
+		return ret;
+	}
+
+	/*
+	 * one reference for us, and we leave it for the
+	 * caller
+	 */
+	bio = bio_alloc(GFP_NOFS, 0);
+	bio->bi_end_io = btrfs_end_empty_barrier;
+	bio->bi_bdev = device->bdev;
+	init_completion(&device->flush_wait);
+	bio->bi_private = &device->flush_wait;
+	device->flush_bio = bio;
+
+	bio_get(bio);
+	submit_bio(WRITE_BARRIER, bio);
+
+	return 0;
+}
+
+int write_all_supers(struct btrfs_root *root, int max_mirrors, int all_devices)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
@@ -2296,6 +2400,34 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	int max_errors;
 	int total_errors = 0;
 	u64 flags;
+	int log_pix = MAX_PROFILE_ENTRIES;
+	int pix;
+	struct btrfs_profile *log_profile = root->log_profile;
+
+	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+
+	/* determine the speed of the fastest log devices present */
+	if (!all_devices && log_profile) {
+		/* FIXME cache this somewhere */
+		log_pix = log_profile->nentries;
+		head = &root->fs_info->fs_devices->devices;
+		list_for_each_entry(dev, head, dev_list) {
+			if (!dev->bdev)
+				continue;
+			if (!dev->in_fs_metadata || !dev->writeable)
+				continue;
+
+			for (pix = 0; pix < log_pix; ++pix) {
+				int speed = log_profile->speed[pix];
+				if (speed == dev->seek_speed) {
+					log_pix = pix;
+					break;
+				}
+			}
+			if (log_pix == 0)
+				break;
+		}
+	}
 
 	max_errors = btrfs_super_num_devices(&root->fs_info->super_copy) - 1;
 	do_barriers = !btrfs_test_opt(root, NOBARRIER);
@@ -2303,7 +2435,6 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	sb = &root->fs_info->super_for_commit;
 	dev_item = &sb->dev_item;
 
-	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	head = &root->fs_info->fs_devices->devices;
 	list_for_each_entry(dev, head, dev_list) {
 		if (!dev->bdev) {
@@ -2313,6 +2444,23 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
+		if (!all_devices && root->log_profile) {
+			/*
+			 * only write the super to the fastest log devices,
+			 * all other devices only get flushed
+			 * FIXME: this is only a temporary solution. The correct
+			 * solution would be to track which devices received
+			 * log blocks and which devices received sync extents.
+			 * write supers to the former, flush the latter
+			 */
+			if (log_profile->speed[log_pix] != dev->seek_speed) {
+				/* device not in profile, only sync */
+				ret = write_dev_flush(dev, 0);
+				if (ret)
+					total_errors++;
+				continue;
+			}
+		}
 		btrfs_set_stack_device_generation(dev_item, 0);
 		btrfs_set_stack_device_type(dev_item, dev->type);
 		btrfs_set_stack_device_id(dev_item, dev->devid);
@@ -2344,6 +2492,15 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
+		if (!all_devices && log_profile) {
+			if (log_profile->speed[log_pix] != dev->seek_speed) {
+				/* device not in profile, only sync */
+				ret = write_dev_flush(dev, 1);
+				if (ret)
+					total_errors++;
+				continue;
+			}
+		}
 		ret = write_dev_supers(dev, sb, do_barriers, 1, max_mirrors);
 		if (ret)
 			total_errors++;
@@ -2358,11 +2515,11 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 }
 
 int write_ctree_super(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, int max_mirrors)
+		      struct btrfs_root *root, int max_mirrors, int all_devices)
 {
 	int ret;
 
-	ret = write_all_supers(root, max_mirrors);
+	ret = write_all_supers(root, max_mirrors, all_devices);
 	return ret;
 }
 
@@ -2472,7 +2629,7 @@ int btrfs_commit_super(struct btrfs_root *root)
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
 
-	ret = write_ctree_super(NULL, root, 0);
+	ret = write_ctree_super(NULL, root, 0, 1);
 	return ret;
 }
 
@@ -2707,7 +2864,7 @@ int btrfs_error_commit_super(struct btrfs_root *root)
 	/* cleanup FS via transaction */
 	btrfs_cleanup_transaction(root);
 
-	ret = write_ctree_super(NULL, root, 0);
+	ret = write_ctree_super(NULL, root, 0, 1);
 
 	return ret;
 }
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 07b20dc..b97891d 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -49,7 +49,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			      char *options);
 int close_ctree(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, int max_mirrors);
+		      struct btrfs_root *root, int max_mirrors,
+                      int all_devices);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_commit_super(struct btrfs_root *root);
 int btrfs_error_commit_super(struct btrfs_root *root);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bcf3032..c5a72b9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -59,7 +59,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     int level, struct btrfs_key *ins);
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
-			  u64 flags, int force);
+			  u64 flags, int force, struct btrfs_profile *profile,
+                          int pix, int in_logtree);
 static int find_next_key(struct btrfs_path *path, int level,
 			 struct btrfs_key *key);
 static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
@@ -541,7 +542,7 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
 }
 
 static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
-						  u64 flags)
+						  u64 flags, int speed)
 {
 	struct list_head *head = &info->space_info;
 	struct btrfs_space_info *found;
@@ -551,7 +552,7 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
-		if (found->flags & flags) {
+		if (found->flags & flags && found->speed == speed) {
 			rcu_read_unlock();
 			return found;
 		}
@@ -2975,7 +2976,7 @@ int btrfs_extent_readonly(struct btrfs_root *root, u64 bytenr)
 
 static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
-			     struct btrfs_space_info **space_info)
+                             int speed, struct btrfs_space_info **space_info)
 {
 	struct btrfs_space_info *found;
 	int i;
@@ -2987,7 +2988,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	else
 		factor = 1;
 
-	found = __find_space_info(info, flags);
+	found = __find_space_info(info, flags, speed);
 	if (found) {
 		spin_lock(&found->lock);
 		found->total_bytes += total_bytes;
@@ -3020,12 +3021,53 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	found->bytes_may_use = 0;
 	found->full = 0;
 	found->force_alloc = 0;
+	found->speed = speed;
 	*space_info = found;
 	list_add_rcu(&found->list, &info->space_info);
 	atomic_set(&found->caching_threads, 0);
 	return 0;
 }
 
+int btrfs_init_profile(struct btrfs_fs_info *fs_info,
+                       struct btrfs_profile *profile, int is_system)
+{
+	int pix;
+	int ret;
+	u64 flags = BTRFS_BLOCK_GROUP_METADATA;
+
+	if (is_system)
+		flags = BTRFS_BLOCK_GROUP_SYSTEM;
+
+	for (pix = 0; pix < profile->nentries; ++pix) {
+		struct btrfs_space_info *sinfo;
+		sinfo = __find_space_info(fs_info, flags, profile->speed[pix]);
+		if (!sinfo) {
+			ret = update_space_info(fs_info, flags, 0, 0,
+			                        profile->speed[pix], &sinfo);
+			if (ret)
+				return ret;
+		}
+		BUG_ON(!sinfo);
+		profile->meta_sinfo[pix] = sinfo;
+
+		if (is_system)
+			continue;
+
+		sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA,
+		                          profile->speed[pix]);
+		if (!sinfo) {
+			ret = update_space_info(fs_info,
+			                        BTRFS_BLOCK_GROUP_DATA, 0,
+			                        0, profile->speed[pix], &sinfo);
+			if (ret)
+				return ret;
+		}
+		BUG_ON(!sinfo);
+		profile->data_sinfo[pix] = sinfo;
+	}
+	return 0;
+}
+
 static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
 	u64 extra_flags = flags & (BTRFS_BLOCK_GROUP_RAID0 |
@@ -3104,10 +3146,9 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 	return get_alloc_profile(root, flags);
 }
 
-void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *inode)
+void btrfs_set_inode_profile(struct btrfs_root *root, struct inode *inode)
 {
-	BTRFS_I(inode)->space_info = __find_space_info(root->fs_info,
-						       BTRFS_BLOCK_GROUP_DATA);
+	BTRFS_I(inode)->profile = root->data_profile;
 }
 
 /*
@@ -3119,7 +3160,11 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	struct btrfs_space_info *data_sinfo;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 used;
+	u64 to_reserve;
 	int ret = 0, committed = 0, alloc_chunk = 1;
+	int pix = 0;
+	u64 from[MAX_PROFILE_ENTRIES] = {0};
+	struct btrfs_trans_handle *trans;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
@@ -3129,20 +3174,18 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 		committed = 1;
 	}
 
-	data_sinfo = BTRFS_I(inode)->space_info;
-	if (!data_sinfo)
-		goto alloc;
-
 again:
+	data_sinfo = BTRFS_I(inode)->profile->data_sinfo[pix];
+	BUG_ON(!data_sinfo);
+
 	/* make sure we have enough space to handle the data first */
 	spin_lock(&data_sinfo->lock);
 	used = data_sinfo->bytes_used + data_sinfo->bytes_reserved +
 		data_sinfo->bytes_pinned + data_sinfo->bytes_readonly +
 		data_sinfo->bytes_may_use;
 
+	to_reserve = bytes;
 	if (used + bytes > data_sinfo->total_bytes) {
-		struct btrfs_trans_handle *trans;
-
 		/*
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
@@ -3152,42 +3195,37 @@ again:
 
 			data_sinfo->force_alloc = 1;
 			spin_unlock(&data_sinfo->lock);
-alloc:
 			alloc_target = btrfs_get_alloc_profile(root, 1);
 			trans = btrfs_join_transaction(root, 1);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
-
 			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 					     bytes + 2 * 1024 * 1024,
-					     alloc_target, 0);
+					     alloc_target, 0,
+			                     BTRFS_I(inode)->profile, pix, 0);
 			btrfs_end_transaction(trans, root);
-			if (ret < 0) {
-				if (ret != -ENOSPC)
-					return ret;
-				else
-					goto commit_trans;
-			}
 
-			if (!data_sinfo) {
-				btrfs_set_inode_space_info(root, inode);
-				data_sinfo = BTRFS_I(inode)->space_info;
+			if (ret < 0 && ret != -ENOSPC)
+				return ret;
+
+			if (!ret)
+				goto again;
+
+			if (pix + 1 < BTRFS_I(inode)->profile->nentries) {
+				++pix;
+				goto again;
 			}
-			goto again;
+			spin_lock(&data_sinfo->lock);
 		}
-		spin_unlock(&data_sinfo->lock);
 
-		/* commit the current transaction and try again */
-commit_trans:
-		if (!committed && !root->fs_info->open_ioctl_trans) {
-			committed = 1;
-			trans = btrfs_join_transaction(root, 1);
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
-			ret = btrfs_commit_transaction(trans, root);
-			if (ret)
-				return ret;
-			goto again;
+		/* reserve what we can get, taking the rest from the other
+		 * space_infos if possible
+		 */
+		if (used < data_sinfo->total_bytes) {
+			to_reserve = data_sinfo->total_bytes - used;
+			from[pix] = to_reserve;
+		} else {
+			to_reserve = 0;
 		}
 
 #if 0 /* I hope we never need this code again, just in case */
@@ -3202,12 +3240,60 @@ commit_trans:
 		       (unsigned long long)data_sinfo->bytes_may_use,
 		       (unsigned long long)data_sinfo->total_bytes);
 #endif
-		return -ENOSPC;
 	}
-	data_sinfo->bytes_may_use += bytes;
-	BTRFS_I(inode)->reserved_bytes += bytes;
+
+	data_sinfo->bytes_may_use += to_reserve;
+
 	spin_unlock(&data_sinfo->lock);
 
+	if (to_reserve) {
+		spin_lock(&BTRFS_I(inode)->reserved_lock);
+		BTRFS_I(inode)->reserved_total += to_reserve;
+		BTRFS_I(inode)->reserved_from[pix] += to_reserve;
+		spin_unlock(&BTRFS_I(inode)->reserved_lock);
+
+		bytes -= to_reserve;
+	}
+
+	if (bytes && pix + 1 < BTRFS_I(inode)->profile->nentries) {
+		++pix;
+		goto again;
+	}
+
+	/* commit the current transaction and try again */
+	if (bytes && !committed && !root->fs_info->open_ioctl_trans) {
+		committed = 1;
+		trans = btrfs_join_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret)
+			return ret;
+		pix = 0;
+		goto again;
+	}
+
+	if (bytes) {
+		/* we didn't succeed in reserving all requested space, so free
+		 * what we already reserved
+		 */
+		for (pix = 0; pix < BTRFS_I(inode)->profile->nentries; ++pix) {
+			data_sinfo = __find_space_info(root->fs_info,
+				       BTRFS_BLOCK_GROUP_DATA,
+				       BTRFS_I(inode)->profile->speed[pix]);
+
+			spin_lock(&BTRFS_I(inode)->reserved_lock);
+			BTRFS_I(inode)->reserved_total -= from[pix];
+			BTRFS_I(inode)->reserved_from[pix] -= from[pix];
+			spin_unlock(&BTRFS_I(inode)->reserved_lock);
+
+			spin_lock(&data_sinfo->lock);
+			data_sinfo->bytes_may_use -= from[pix];
+			spin_unlock(&data_sinfo->lock);
+		}
+		return -ENOSPC;
+	}
+
 	return 0;
 }
 
@@ -3219,16 +3305,51 @@ commit_trans:
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_profile *profile = BTRFS_I(inode)->profile;
+	int pix;
 	struct btrfs_space_info *data_sinfo;
+	u64 to_free;
+	u64 sum = 0;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
-	data_sinfo = BTRFS_I(inode)->space_info;
-	spin_lock(&data_sinfo->lock);
-	data_sinfo->bytes_may_use -= bytes;
-	BTRFS_I(inode)->reserved_bytes -= bytes;
-	spin_unlock(&data_sinfo->lock);
+	spin_lock(&BTRFS_I(inode)->reserved_lock);
+
+	BTRFS_I(inode)->reserved_total -= bytes;
+
+	/*
+	 * Freeing reservations takes place in two steps.
+	 *
+	 * reserved_from[] is decremented when the space actually gets
+	 * allocated. reserved_total is decremented only here. If the sum of
+	 * all reserved_from is bigger than reserved_total, some space has
+	 * been freed (unreserved) without actually being allocated. In this
+	 * case we return enough allocation with the lowest priority to its
+	 * space_info.
+	 */
+
+	for (pix = 0; pix < profile->nentries; ++pix) {
+		sum += BTRFS_I(inode)->reserved_from[pix];
+	}
+	for (pix = profile->nentries - 1;
+	     sum > BTRFS_I(inode)->reserved_total; --pix) {
+		BUG_ON(pix < 0);
+		if (BTRFS_I(inode)->reserved_from[pix] == 0)
+			continue;
+
+		data_sinfo = __find_space_info(root->fs_info,
+					       BTRFS_BLOCK_GROUP_DATA,
+					       profile->speed[pix]);
+		to_free = min(BTRFS_I(inode)->reserved_from[pix],
+		              sum - BTRFS_I(inode)->reserved_total);
+		spin_lock(&data_sinfo->lock);
+		data_sinfo->bytes_may_use -= to_free;
+		BTRFS_I(inode)->reserved_from[pix] -= to_free;
+		sum -= to_free;
+		spin_unlock(&data_sinfo->lock);
+	}
+	spin_unlock(&BTRFS_I(inode)->reserved_lock);
 }
 
 static void force_metadata_allocation(struct btrfs_fs_info *info)
@@ -3238,29 +3359,40 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_METADATA)
+		if (found->flags & BTRFS_BLOCK_GROUP_METADATA) {
 			found->force_alloc = 1;
+			break;
+		}
 	}
 	rcu_read_unlock();
 }
 
 static int should_alloc_chunk(struct btrfs_root *root,
-			      struct btrfs_space_info *sinfo, u64 alloc_bytes)
+			      struct btrfs_space_info *sinfo, u64 alloc_bytes,
+                              int in_logtree)
 {
 	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
 	u64 thresh;
+	u64 used;
+
+	used = sinfo->bytes_used + sinfo->bytes_reserved;
+	if (in_logtree)
+		used += sinfo->bytes_pinned;
 
-	if (sinfo->bytes_used + sinfo->bytes_reserved +
-	    alloc_bytes + 256 * 1024 * 1024 < num_bytes)
+	/* if at least 256 MB are free after this alloc, we have enough */
+	if (used + alloc_bytes + 256 * 1024 * 1024 < num_bytes)
 		return 0;
 
-	if (sinfo->bytes_used + sinfo->bytes_reserved +
-	    alloc_bytes < div_factor(num_bytes, 8))
+	/* if after this alloc we still use <80%, we have enough */
+	if (used + alloc_bytes < div_factor(num_bytes, 8))
 		return 0;
 
 	thresh = btrfs_super_total_bytes(&root->fs_info->super_copy);
 	thresh = max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, 5));
 
+	/* if this space occupies more than %5 of the total space and has
+	 * less than 30% in use, we have enough
+	 */
 	if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 3))
 		return 0;
 
@@ -3269,22 +3401,29 @@ static int should_alloc_chunk(struct btrfs_root *root,
 
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
-			  u64 flags, int force)
+			  u64 flags, int force, struct btrfs_profile *profile,
+                          int pix, int in_logtree)
 {
 	struct btrfs_space_info *space_info;
 	struct btrfs_fs_info *fs_info = extent_root->fs_info;
 	int ret = 0;
+	int ix = pix;
+
+	if (pix == -1)
+		ix = 0; /* loop through all speeds */
+
+	if (profile->nentries == 0) {
+		WARN_ON(1);
+		return ret;
+	}
 
 	mutex_lock(&fs_info->chunk_mutex);
 
 	flags = btrfs_reduce_alloc_profile(extent_root, flags);
 
-	space_info = __find_space_info(extent_root->fs_info, flags);
-	if (!space_info) {
-		ret = update_space_info(extent_root->fs_info, flags,
-					0, 0, &space_info);
-		BUG_ON(ret);
-	}
+again:
+	space_info = __find_space_info(extent_root->fs_info, flags,
+	                               profile->speed[ix]);
 	BUG_ON(!space_info);
 
 	spin_lock(&space_info->lock);
@@ -3292,11 +3431,11 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 		force = 1;
 	if (space_info->full) {
 		spin_unlock(&space_info->lock);
-		goto out;
+		goto loop;
 	}
 
 	if (!force && !should_alloc_chunk(extent_root, space_info,
-					  alloc_bytes)) {
+					  alloc_bytes, in_logtree)) {
 		spin_unlock(&space_info->lock);
 		goto out;
 	}
@@ -3321,7 +3460,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			force_metadata_allocation(fs_info);
 	}
 
-	ret = btrfs_alloc_chunk(trans, extent_root, flags);
+	ret = btrfs_alloc_chunk(trans, extent_root, flags, profile->speed[ix]);
 	spin_lock(&space_info->lock);
 	if (ret)
 		space_info->full = 1;
@@ -3329,6 +3468,13 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 		ret = 1;
 	space_info->force_alloc = 0;
 	spin_unlock(&space_info->lock);
+loop:
+	if (ret <= 0 && pix == -1 && ix < profile->nentries - 1) {
+		++ix;
+		ret = 0;
+		goto again;
+	}
+
 out:
 	mutex_unlock(&extent_root->fs_info->chunk_mutex);
 	return ret;
@@ -3341,18 +3487,24 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 to_reclaim, int sync)
 {
 	struct btrfs_block_rsv *block_rsv;
-	struct btrfs_space_info *space_info;
+	struct btrfs_profile *profile;
 	u64 reserved;
 	u64 max_reclaim;
 	u64 reclaimed = 0;
 	int pause = 1;
 	int nr_pages = (2 * 1024 * 1024) >> PAGE_CACHE_SHIFT;
+	u64 sum;
+	int pix;
 
 	block_rsv = &root->fs_info->delalloc_block_rsv;
-	space_info = block_rsv->space_info;
+	profile = block_rsv->profile;
 
 	smp_mb();
-	reserved = space_info->bytes_reserved;
+	sum = 0;
+	for (pix = 0; pix < profile->nentries; ++pix)
+		sum += profile->meta_sinfo[pix]->bytes_reserved;
+
+	reserved = sum;
 
 	if (reserved == 0)
 		return 0;
@@ -3364,13 +3516,19 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 		smp_mb();
 		nr_pages = min_t(unsigned long, nr_pages,
 		       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
+		/*
+		 * FIXME limit it to inodes that share at least one space_info
+		 */
 		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages);
 
-		spin_lock(&space_info->lock);
-		if (reserved > space_info->bytes_reserved)
-			reclaimed += reserved - space_info->bytes_reserved;
-		reserved = space_info->bytes_reserved;
-		spin_unlock(&space_info->lock);
+		sum = 0;
+		for (pix = 0; pix < profile->nentries; ++pix)
+			sum += profile->meta_sinfo[pix]->bytes_reserved;
+
+		if (reserved > sum)
+			reclaimed += reserved - sum;
+
+		reserved = sum;
 
 		if (reserved == 0 || reclaimed >= max_reclaim)
 			break;
@@ -3402,71 +3560,74 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 static int reserve_metadata_bytes(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  struct btrfs_block_rsv *block_rsv,
-				  u64 orig_bytes, int flush)
+				  u64 orig_bytes, int flush, int *ppix)
 {
-	struct btrfs_space_info *space_info = block_rsv->space_info;
+	struct btrfs_space_info *space_info;
+	u64 used;
 	u64 unused;
 	u64 num_bytes = orig_bytes;
 	int retries = 0;
 	int ret = 0;
-	bool reserved = false;
 	bool committed = false;
+	int pix;
+	u64 max_pinned;
 
 again:
 	ret = -ENOSPC;
-	if (reserved)
-		num_bytes = 0;
 
-	spin_lock(&space_info->lock);
-	unused = space_info->bytes_used + space_info->bytes_reserved +
-		 space_info->bytes_pinned + space_info->bytes_readonly +
-		 space_info->bytes_may_use;
+	for (pix = 0; pix < block_rsv->profile->nentries; ++pix) {
+		space_info = block_rsv->profile->meta_sinfo[pix];
 
-	/*
-	 * The idea here is that we've not already over-reserved the block group
-	 * then we can go ahead and save our reservation first and then start
-	 * flushing if we need to.  Otherwise if we've already overcommitted
-	 * lets start flushing stuff first and then come back and try to make
-	 * our reservation.
-	 */
-	if (unused <= space_info->total_bytes) {
-		unused = space_info->total_bytes - unused;
-		if (unused >= num_bytes) {
-			if (!reserved)
-				space_info->bytes_reserved += orig_bytes;
-			ret = 0;
-		} else {
+		if (space_info->full)
+			continue;
+
+		spin_lock(&space_info->lock);
+
+		if (space_info->total_bytes == 0) {
 			/*
-			 * Ok set num_bytes to orig_bytes since we aren't
-			 * overocmmitted, this way we only try and reclaim what
-			 * we need.
+			 * bootstrap: this space info does not have an initial
+			 * chunk. try to allocate it here.
+			 * FIXME: check, under which conditions we are allowed
+			 * to allocate a chunk. are we allowed to join a trans-
+			 * action?
 			 */
-			num_bytes = orig_bytes;
+			int in_logtree = root->root_key.objectid ==
+					 BTRFS_TREE_LOG_OBJECTID &&
+					 !root->fs_info->log_root_recovering;
+			if (trans && (root->ref_cows || in_logtree)) {
+				spin_unlock(&space_info->lock);
+				ret = do_chunk_alloc(trans, root, num_bytes,
+						     BTRFS_BLOCK_GROUP_METADATA,
+				                     0, block_rsv->profile, -1,
+						     in_logtree);
+				if (ret < 0)
+					return ret;
+				spin_lock(&space_info->lock);
+			}
 		}
-	} else {
-		/*
-		 * Ok we're over committed, set num_bytes to the overcommitted
-		 * amount plus the amount of bytes that we need for this
-		 * reservation.
-		 */
-		num_bytes = unused - space_info->total_bytes +
-			(orig_bytes * (retries + 1));
+		used = space_info->bytes_used + space_info->bytes_reserved +
+		       space_info->bytes_pinned + space_info->bytes_readonly +
+		       space_info->bytes_may_use;
+
+		if (used <= space_info->total_bytes) {
+			unused = space_info->total_bytes - used;
+			if (unused >= orig_bytes) {
+				space_info->bytes_reserved += orig_bytes;
+				spin_unlock(&space_info->lock);
+				*ppix = pix;
+				return 0;
+			}
+		}
+		spin_unlock(&space_info->lock);
 	}
 
 	/*
-	 * Couldn't make our reservation, save our place so while we're trying
-	 * to reclaim space we can actually use it instead of somebody else
-	 * stealing it from us.
+	 * There is a risk someone else is claiming the space we are freeing
+	 * below. To mitigate this risk, we try to reclaim more than we actually
+	 * need.
+	 * FIXME try to reserve the space upfront, but in which space info?
 	 */
-	if (ret && !reserved) {
-		space_info->bytes_reserved += orig_bytes;
-		reserved = true;
-	}
-
-	spin_unlock(&space_info->lock);
-
-	if (!ret)
-		return 0;
+	num_bytes = orig_bytes * (retries + 1);
 
 	if (!flush)
 		goto out;
@@ -3476,9 +3637,7 @@ again:
 	 * metadata until after the IO is completed.
 	 */
 	ret = shrink_delalloc(trans, root, num_bytes, 1);
-	if (ret > 0)
-		return 0;
-	else if (ret < 0)
+	if (ret < 0)
 		goto out;
 
 	/*
@@ -3486,21 +3645,27 @@ again:
 	 * out enough space and we simply didn't have enough space to reclaim,
 	 * so go back around and try again.
 	 */
-	if (retries < 2) {
+	if (retries < 2 || ret > 0) {
 		retries++;
 		goto again;
 	}
 
-	spin_lock(&space_info->lock);
+	max_pinned = 0;
+	for (pix = 0; pix < block_rsv->profile->nentries; ++pix) {
+		space_info = block_rsv->profile->meta_sinfo[pix];
+		spin_lock(&space_info->lock);
+		if (space_info->bytes_pinned > max_pinned)
+			max_pinned = space_info->bytes_pinned;
+		spin_unlock(&space_info->lock);
+	}
 	/*
 	 * Not enough space to be reclaimed, don't bother committing the
 	 * transaction.
 	 */
-	if (space_info->bytes_pinned < orig_bytes)
+	if (max_pinned < orig_bytes) {
 		ret = -ENOSPC;
-	spin_unlock(&space_info->lock);
-	if (ret)
 		goto out;
+	}
 
 	ret = -EAGAIN;
 	if (trans || committed)
@@ -3518,17 +3683,11 @@ again:
 	}
 
 out:
-	if (reserved) {
-		spin_lock(&space_info->lock);
-		space_info->bytes_reserved -= orig_bytes;
-		spin_unlock(&space_info->lock);
-	}
-
 	return ret;
 }
 
 static struct btrfs_block_rsv *get_block_rsv(struct btrfs_trans_handle *trans,
-					     struct btrfs_root *root)
+                                             struct btrfs_root *root)
 {
 	struct btrfs_block_rsv *block_rsv;
 	if (root->ref_cows)
@@ -3536,35 +3695,47 @@ static struct btrfs_block_rsv *get_block_rsv(struct btrfs_trans_handle *trans,
 	else
 		block_rsv = root->block_rsv;
 
-	if (!block_rsv)
-		block_rsv = &root->fs_info->empty_block_rsv;
+	if (!block_rsv) {
+		if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
+			block_rsv = &root->fs_info->log_block_rsv;
+		else
+			block_rsv = &root->fs_info->empty_block_rsv;
+	}
 
 	return block_rsv;
 }
 
 static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
-			       u64 num_bytes)
+			       u64 num_bytes, int *ppix)
 {
 	int ret = -ENOSPC;
+	int pix;
+	struct btrfs_profile *profile = block_rsv->profile;
 	spin_lock(&block_rsv->lock);
-	if (block_rsv->reserved >= num_bytes) {
-		block_rsv->reserved -= num_bytes;
-		if (block_rsv->reserved < block_rsv->size)
-			block_rsv->full = 0;
-		ret = 0;
+	for (pix=0; pix < profile->nentries; ++pix) {
+		if (block_rsv->reserved_from[pix] >= num_bytes) {
+			block_rsv->reserved_from[pix] -= num_bytes;
+			block_rsv->reserved_total -= num_bytes;
+			if (block_rsv->reserved_total < block_rsv->size)
+				block_rsv->full = 0;
+			ret = 0;
+			*ppix = pix;
+			break;
+		}
 	}
 	spin_unlock(&block_rsv->lock);
 	return ret;
 }
 
 static void block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
-				u64 num_bytes, int update_size)
+				u64 num_bytes, int update_size, int pix)
 {
 	spin_lock(&block_rsv->lock);
-	block_rsv->reserved += num_bytes;
+	block_rsv->reserved_total += num_bytes;
+	block_rsv->reserved_from[pix] += num_bytes;
 	if (update_size)
 		block_rsv->size += num_bytes;
-	else if (block_rsv->reserved >= block_rsv->size)
+	else if (block_rsv->reserved_total >= block_rsv->size)
 		block_rsv->full = 1;
 	spin_unlock(&block_rsv->lock);
 }
@@ -3572,42 +3743,90 @@ static void block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
 void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 			     struct btrfs_block_rsv *dest, u64 num_bytes)
 {
-	struct btrfs_space_info *space_info = block_rsv->space_info;
+	struct btrfs_space_info *space_info;
+	int pix;
+
+	if (dest) {
+		BUG_ON(block_rsv->profile != dest->profile);
+	}
 
 	spin_lock(&block_rsv->lock);
 	if (num_bytes == (u64)-1)
 		num_bytes = block_rsv->size;
 	block_rsv->size -= num_bytes;
-	if (block_rsv->reserved >= block_rsv->size) {
-		num_bytes = block_rsv->reserved - block_rsv->size;
-		block_rsv->reserved = block_rsv->size;
+	if (block_rsv->reserved_total >= block_rsv->size) {
+		num_bytes = block_rsv->reserved_total - block_rsv->size;
+		block_rsv->reserved_total = block_rsv->size;
 		block_rsv->full = 1;
 	} else {
 		num_bytes = 0;
 	}
 	spin_unlock(&block_rsv->lock);
 
-	if (num_bytes > 0) {
+	pix = block_rsv->profile->nentries - 1;
+	BUG_ON(pix < 0);
+	while (num_bytes > 0 && pix >= 0) {
+		u64 n;
+
+		spin_lock(&block_rsv->lock);
+		n = min(num_bytes, block_rsv->reserved_from[pix]);
+		block_rsv->reserved_from[pix] -= n;
+		spin_unlock(&block_rsv->lock);
+
+		space_info = block_rsv->profile->meta_sinfo[pix];
 		if (dest) {
-			block_rsv_add_bytes(dest, num_bytes, 0);
+			block_rsv_add_bytes(dest, n, 0, pix);
 		} else {
 			spin_lock(&space_info->lock);
-			space_info->bytes_reserved -= num_bytes;
+			space_info->bytes_reserved -= n;
+			WARN_ON((s64)space_info->bytes_reserved < 0);
 			spin_unlock(&space_info->lock);
 		}
+		num_bytes -= n;
+		--pix;
 	}
+	BUG_ON(num_bytes);
 }
 
 static int block_rsv_migrate_bytes(struct btrfs_block_rsv *src,
-				   struct btrfs_block_rsv *dst, u64 num_bytes)
+				   struct btrfs_block_rsv *dst,
+                                   u64 num_bytes)
 {
-	int ret;
+	int pix;
+	int n;
+	struct btrfs_profile *profile;
 
-	ret = block_rsv_use_bytes(src, num_bytes);
-	if (ret)
-		return ret;
+	BUG_ON(src == dst);
+
+	spin_lock(&src->lock);
+
+	profile = src->profile;
+	BUG_ON(profile != dst->profile);
+
+	if (num_bytes > src->reserved_total) {
+		spin_unlock(&src->lock);
+		return -ENOSPC;
+	}
+
+	for (pix = 0; pix < profile->nentries && num_bytes; ++pix) {
+		n = min(num_bytes, src->reserved_from[pix]);
+		if (n == 0) {
+			continue;
+		}
+		src->reserved_from[pix] -= n;
+		src->reserved_total -= n;
+		spin_unlock(&src->lock);
+
+		block_rsv_add_bytes(dst, n, 1, pix);
+
+		num_bytes -= n;
+
+		spin_lock(&src->lock);
+	}
+	if (src->reserved_total < src->size)
+		src->full = 0;
+	spin_unlock(&src->lock);
 
-	block_rsv_add_bytes(dst, num_bytes, 1);
 	return 0;
 }
 
@@ -3620,18 +3839,18 @@ void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv)
 	INIT_LIST_HEAD(&rsv->list);
 }
 
-struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root)
+struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
+                                              struct btrfs_profile *profile)
 {
 	struct btrfs_block_rsv *block_rsv;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	block_rsv = kmalloc(sizeof(*block_rsv), GFP_NOFS);
 	if (!block_rsv)
 		return NULL;
 
 	btrfs_init_block_rsv(block_rsv);
-	block_rsv->space_info = __find_space_info(fs_info,
-						  BTRFS_BLOCK_GROUP_METADATA);
+	block_rsv->profile = profile;
+
 	return block_rsv;
 }
 
@@ -3665,13 +3884,15 @@ int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
 			u64 num_bytes)
 {
 	int ret;
+	int pix;
 
 	if (num_bytes == 0)
 		return 0;
 
-	ret = reserve_metadata_bytes(trans, root, block_rsv, num_bytes, 1);
+	ret = reserve_metadata_bytes(trans, root, block_rsv, num_bytes, 1,
+	                             &pix);
 	if (!ret) {
-		block_rsv_add_bytes(block_rsv, num_bytes, 1);
+		block_rsv_add_bytes(block_rsv, num_bytes, 1, pix);
 		return 0;
 	}
 
@@ -3686,6 +3907,7 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 	u64 num_bytes = 0;
 	int commit_trans = 0;
 	int ret = -ENOSPC;
+	int pix;
 
 	if (!block_rsv)
 		return 0;
@@ -3696,12 +3918,13 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 	if (min_reserved > num_bytes)
 		num_bytes = min_reserved;
 
-	if (block_rsv->reserved >= num_bytes) {
+	if (block_rsv->reserved_total >= num_bytes) {
 		ret = 0;
 	} else {
-		num_bytes -= block_rsv->reserved;
+		num_bytes -= block_rsv->reserved_total;
 		if (block_rsv->durable &&
-		    block_rsv->freed[0] + block_rsv->freed[1] >= num_bytes)
+		    block_rsv->freed_total[0] + block_rsv->freed_total[1]
+		      >= num_bytes)
 			commit_trans = 1;
 	}
 	spin_unlock(&block_rsv->lock);
@@ -3709,10 +3932,13 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 		return 0;
 
 	if (block_rsv->refill_used) {
+		/* FIXME should we loop here? or be content with a partial
+		 * re-fill? currently we do all-or-nothing here
+		 */
 		ret = reserve_metadata_bytes(trans, root, block_rsv,
-					     num_bytes, 0);
+					     num_bytes, 0, &pix);
 		if (!ret) {
-			block_rsv_add_bytes(block_rsv, num_bytes, 0);
+			block_rsv_add_bytes(block_rsv, num_bytes, 0, pix);
 			return 0;
 		}
 	}
@@ -3743,7 +3969,7 @@ void btrfs_block_rsv_release(struct btrfs_root *root,
 {
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	if (global_rsv->full || global_rsv == block_rsv ||
-	    block_rsv->space_info != global_rsv->space_info)
+	    block_rsv->profile != global_rsv->profile)
 		global_rsv = NULL;
 	block_rsv_release_bytes(block_rsv, global_rsv, num_bytes);
 }
@@ -3756,9 +3982,10 @@ void btrfs_block_rsv_release(struct btrfs_root *root,
 static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *sinfo;
+	struct list_head *head;
 	u64 num_bytes;
-	u64 meta_used;
-	u64 data_used;
+	u64 meta_used = 0;
+	u64 data_used = 0;
 	int csum_size = btrfs_super_csum_size(&fs_info->super_copy);
 #if 0
 	/*
@@ -3777,17 +4004,18 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 	num_bytes += btrfs_root_used(&fs_info->tree_root->root_item);
 	spin_unlock(&fs_info->tree_root->accounting_lock);
 #endif
-	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
-	spin_lock(&sinfo->lock);
-	data_used = sinfo->bytes_used;
-	spin_unlock(&sinfo->lock);
-
-	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
-	spin_lock(&sinfo->lock);
-	if (sinfo->flags & BTRFS_BLOCK_GROUP_DATA)
-		data_used = 0;
-	meta_used = sinfo->bytes_used;
-	spin_unlock(&sinfo->lock);
+	head = &fs_info->space_info;
+	rcu_read_lock();
+	list_for_each_entry_rcu(sinfo, head, list) {
+		spin_lock(&sinfo->lock);
+		if (sinfo->flags & BTRFS_BLOCK_GROUP_METADATA) {
+			meta_used += sinfo->bytes_used;
+		} else if (sinfo->flags & BTRFS_BLOCK_GROUP_DATA) {
+			data_used += sinfo->bytes_used;
+		}
+		spin_unlock(&sinfo->lock);
+	}
+	rcu_read_unlock();
 
 	num_bytes = (data_used >> fs_info->sb->s_blocksize_bits) *
 		    csum_size * 2;
@@ -3802,56 +4030,76 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
-	struct btrfs_space_info *sinfo = block_rsv->space_info;
+	struct btrfs_space_info *sinfo;
+	struct btrfs_profile *profile;
 	u64 num_bytes;
+	int pix;
 
 	num_bytes = calc_global_metadata_size(fs_info);
 
 	spin_lock(&block_rsv->lock);
-	spin_lock(&sinfo->lock);
+
+	profile = block_rsv->profile;
 
 	block_rsv->size = num_bytes;
 
-	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
-		    sinfo->bytes_reserved + sinfo->bytes_readonly +
-		    sinfo->bytes_may_use;
+	for (pix = 0; pix < profile->nentries; ++pix) {
+		sinfo = profile->meta_sinfo[pix];
+		BUG_ON(!sinfo);
+		spin_lock(&sinfo->lock);
+		num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
+			    sinfo->bytes_reserved + sinfo->bytes_readonly +
+			    sinfo->bytes_may_use;
 
-	if (sinfo->total_bytes > num_bytes) {
-		num_bytes = sinfo->total_bytes - num_bytes;
-		block_rsv->reserved += num_bytes;
-		sinfo->bytes_reserved += num_bytes;
+		if (sinfo->total_bytes > num_bytes) {
+			num_bytes = sinfo->total_bytes - num_bytes;
+			block_rsv->reserved_total += num_bytes;
+			block_rsv->reserved_from[pix] += num_bytes;
+			sinfo->bytes_reserved += num_bytes;
+		}
+		spin_unlock(&sinfo->lock);
 	}
+	for (pix = profile->nentries - 1; pix >= 0; --pix) {
+		sinfo = profile->meta_sinfo[pix];
 
-	if (block_rsv->reserved >= block_rsv->size) {
-		num_bytes = block_rsv->reserved - block_rsv->size;
+		if (block_rsv->reserved_total <= block_rsv->size)
+			break;
+
+		spin_lock(&sinfo->lock);
+		num_bytes = block_rsv->reserved_total - block_rsv->size;
+		num_bytes = min(num_bytes,
+				block_rsv->reserved_from[pix]);
 		sinfo->bytes_reserved -= num_bytes;
-		block_rsv->reserved = block_rsv->size;
-		block_rsv->full = 1;
+		block_rsv->reserved_total -= num_bytes;
+		block_rsv->reserved_from[pix] -= num_bytes;
+		spin_unlock(&sinfo->lock);
 	}
+	if (block_rsv->size == block_rsv->reserved_total)
+		block_rsv->full = 1;
+
 #if 0
 	printk(KERN_INFO"global block rsv size %llu reserved %llu\n",
-		block_rsv->size, block_rsv->reserved);
+		block_rsv->size, block_rsv->reserved_total);
 #endif
-	spin_unlock(&sinfo->lock);
 	spin_unlock(&block_rsv->lock);
 }
 
-static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
+static int init_global_block_rsv(struct btrfs_fs_info *fs_info,
+                                 struct btrfs_profile *log_profile,
+                                 struct btrfs_profile *meta_profile,
+                                 struct btrfs_profile *system_profile)
 {
-	struct btrfs_space_info *space_info;
-
-	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
-	fs_info->chunk_block_rsv.space_info = space_info;
+	fs_info->chunk_block_rsv.profile = system_profile;
 	fs_info->chunk_block_rsv.priority = 10;
-
-	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
-	fs_info->global_block_rsv.space_info = space_info;
+	fs_info->global_block_rsv.profile = meta_profile;
 	fs_info->global_block_rsv.priority = 10;
 	fs_info->global_block_rsv.refill_used = 1;
-	fs_info->delalloc_block_rsv.space_info = space_info;
-	fs_info->trans_block_rsv.space_info = space_info;
-	fs_info->empty_block_rsv.space_info = space_info;
+	fs_info->delalloc_block_rsv.profile = meta_profile;
+	fs_info->trans_block_rsv.profile = meta_profile;
+	fs_info->empty_block_rsv.profile = meta_profile;
 	fs_info->empty_block_rsv.priority = 10;
+	fs_info->log_block_rsv.profile = log_profile;
+	fs_info->log_block_rsv.priority = 10;
 
 	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
@@ -3864,17 +4112,19 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 	btrfs_add_durable_block_rsv(fs_info, &fs_info->delalloc_block_rsv);
 
 	update_global_block_rsv(fs_info);
+
+	return 0;
 }
 
 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	block_rsv_release_bytes(&fs_info->global_block_rsv, NULL, (u64)-1);
 	WARN_ON(fs_info->delalloc_block_rsv.size > 0);
-	WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
+	WARN_ON(fs_info->delalloc_block_rsv.reserved_total > 0);
 	WARN_ON(fs_info->trans_block_rsv.size > 0);
-	WARN_ON(fs_info->trans_block_rsv.reserved > 0);
+	WARN_ON(fs_info->trans_block_rsv.reserved_total > 0);
 	WARN_ON(fs_info->chunk_block_rsv.size > 0);
-	WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
+	WARN_ON(fs_info->chunk_block_rsv.reserved_total > 0);
 }
 
 static u64 calc_trans_metadata_size(struct btrfs_root *root, int num_items)
@@ -3954,7 +4204,6 @@ int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
 	 * and one for root of the snapshot.
 	 */
 	u64 num_bytes = calc_trans_metadata_size(root, 5);
-	dst_rsv->space_info = src_rsv->space_info;
 	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
 }
 
@@ -3970,6 +4219,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	u64 to_reserve;
 	int nr_extents;
 	int ret;
+	int pix;
 
 	if (btrfs_transaction_in_commit(root->fs_info))
 		schedule_timeout(1);
@@ -3988,7 +4238,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
 	to_reserve += calc_csum_metadata_size(inode, num_bytes);
-	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve, 1);
+	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve, 1,
+	                             &pix);
 	if (ret)
 		return ret;
 
@@ -3997,7 +4248,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	atomic_inc(&BTRFS_I(inode)->outstanding_extents);
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
-	block_rsv_add_bytes(block_rsv, to_reserve, 1);
+	block_rsv_add_bytes(block_rsv, to_reserve, 1, pix);
 
 	if (block_rsv->size > 512 * 1024 * 1024)
 		shrink_delalloc(NULL, root, to_reserve, 0);
@@ -4320,6 +4571,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	u64 start;
 	u64 end;
 	int idx;
+	int pix;
 	int ret;
 
 	if (fs_info->pinned_extents == &fs_info->freed_extents[0])
@@ -4345,16 +4597,20 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 				 &fs_info->durable_block_rsv_list, list) {
 
 		idx = trans->transid & 0x1;
-		if (block_rsv->freed[idx] > 0) {
-			block_rsv_add_bytes(block_rsv,
-					    block_rsv->freed[idx], 0);
-			block_rsv->freed[idx] = 0;
+		if (block_rsv->freed_total[idx] > 0) {
+			for (pix=0; pix < block_rsv->profile->nentries; ++pix) {
+				block_rsv_add_bytes(block_rsv,
+					    block_rsv->freed_from[idx][pix], 0,
+				            pix);
+				block_rsv->freed_from[idx][pix] = 0;
+			}
+			block_rsv->freed_total[idx] = 0;
 		}
 		if (atomic_read(&block_rsv->usage) == 0) {
 			btrfs_block_rsv_release(root, block_rsv, (u64)-1);
 
-			if (block_rsv->freed[0] == 0 &&
-			    block_rsv->freed[1] == 0) {
+			if (block_rsv->freed_total[0] == 0 &&
+			    block_rsv->freed_total[1] == 0) {
 				list_del_init(&block_rsv->list);
 				kfree(block_rsv);
 			}
@@ -4642,6 +4898,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_group_cache *cache = NULL;
 	int ret;
+	int pix;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(trans, buf->start, buf->len,
@@ -4656,7 +4913,15 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 	block_rsv = get_block_rsv(trans, root);
 	cache = btrfs_lookup_block_group(root->fs_info, buf->start);
-	if (block_rsv->space_info != cache->space_info)
+
+	ret = -1;
+	for (pix = 0; pix < block_rsv->profile->nentries; ++pix) {
+		if (block_rsv->profile->meta_sinfo[pix] == cache->space_info) {
+			ret = 0;
+			break;
+		}
+	}
+	if (ret)
 		goto out;
 
 	if (btrfs_header_generation(buf) == trans->transid) {
@@ -4683,8 +4948,9 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 		ret = 1;
 		spin_lock(&block_rsv->lock);
-		if (block_rsv->reserved < block_rsv->size) {
-			block_rsv->reserved += buf->len;
+		if (block_rsv->reserved_total < block_rsv->size) {
+			block_rsv->reserved_total += buf->len;
+			block_rsv->reserved_from[pix] += buf->len;
 			ret = 0;
 		}
 		spin_unlock(&block_rsv->lock);
@@ -4707,8 +4973,10 @@ pin:
 		spin_unlock(&cache->lock);
 
 		if (ret) {
+			int index = trans->transid & 0x1;
 			spin_lock(&block_rsv->lock);
-			block_rsv->freed[trans->transid & 0x1] += buf->len;
+			block_rsv->freed_total[index] += buf->len;
+			block_rsv->freed_from[index][pix] += buf->len;
 			spin_unlock(&block_rsv->lock);
 		}
 	}
@@ -4835,7 +5103,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				     u64 num_bytes, u64 empty_size,
 				     u64 search_start, u64 search_end,
 				     u64 hint_byte, struct btrfs_key *ins,
-				     int data)
+				     int data,
+                                     struct btrfs_space_info *space_info)
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
@@ -4844,7 +5113,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
 	int done_chunk_alloc = 0;
-	struct btrfs_space_info *space_info;
 	int last_ptr_loop = 0;
 	int loop = 0;
 	int index = 0;
@@ -4860,12 +5128,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	ins->objectid = 0;
 	ins->offset = 0;
 
-	space_info = __find_space_info(root->fs_info, data);
-	if (!space_info) {
-		printk(KERN_ERR "No space info for %d\n", data);
-		return -ENOSPC;
-	}
-
 	/*
 	 * If the space info is for both data and metadata it means we have a
 	 * small filesystem and we can't use the clustering stuff.
@@ -4884,11 +5146,23 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	if ((data & BTRFS_BLOCK_GROUP_DATA) && use_cluster &&
 	    btrfs_test_opt(root, SSD)) {
+		/* FIXME do we need last_ptr per speed? */
 		last_ptr = &root->fs_info->data_alloc_cluster;
 	}
 
 	if (last_ptr) {
 		spin_lock(&last_ptr->lock);
+		if (last_ptr->block_group &&
+		    last_ptr->block_group->speed != space_info->speed) {
+			spin_unlock(&last_ptr->lock);
+			last_ptr = NULL;
+		} else {
+			spin_unlock(&last_ptr->lock);
+		}
+	}
+
+	if (last_ptr) {
+		spin_lock(&last_ptr->lock);
 		if (last_ptr->block_group)
 			hint_byte = last_ptr->window_start;
 		spin_unlock(&last_ptr->lock);
@@ -4912,6 +5186,7 @@ ideal_cache:
 		 * picked out then we don't care that the block group is cached.
 		 */
 		if (block_group && block_group_bits(block_group, data) &&
+		    block_group->speed == space_info->speed &&
 		    (block_group->cached != BTRFS_CACHE_NO ||
 		     search_start == ideal_cache_offset)) {
 			down_read(&space_info->groups_sem);
@@ -4963,6 +5238,7 @@ search:
 		}
 
 have_block_group:
+		BUG_ON(block_group->speed != space_info->speed);
 		if (unlikely(block_group->cached == BTRFS_CACHE_NO)) {
 			u64 free_percent;
 
@@ -5250,8 +5526,13 @@ loop:
 		}
 
 		if (allowed_chunk_alloc) {
+			struct btrfs_profile profile;
+			memset(&profile, 0, sizeof(profile));
+			profile.nentries = 1;
+			profile.speed[0] = space_info->speed;
 			ret = do_chunk_alloc(trans, root, num_bytes +
-					     2 * 1024 * 1024, data, 1);
+					     2 * 1024 * 1024, data, 1,
+			                     &profile, 0, 0);
 			allowed_chunk_alloc = 0;
 			done_chunk_alloc = 1;
 		} else if (!done_chunk_alloc) {
@@ -5286,7 +5567,8 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 	int index = 0;
 
 	spin_lock(&info->lock);
-	printk(KERN_INFO "space_info has %llu free, is %sfull\n",
+	printk(KERN_INFO "space_info 0x%llx has %llu free, is %sfull\n",
+		info->flags,
 	       (unsigned long long)(info->total_bytes - info->bytes_used -
 				    info->bytes_pinned - info->bytes_reserved -
 				    info->bytes_readonly),
@@ -5323,15 +5605,90 @@ again:
 	up_read(&info->groups_sem);
 }
 
-int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
+int btrfs_reserve_data_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
+			 struct inode *inode,
 			 u64 num_bytes, u64 min_alloc_size,
 			 u64 empty_size, u64 hint_byte,
 			 u64 search_end, struct btrfs_key *ins,
 			 u64 data)
 {
+	u64 max_size = 0;
+	int max_pix = 0;
+	int pix;
 	int ret;
+	struct btrfs_profile *profile = BTRFS_I(inode)->profile;
+	struct btrfs_inode *bino = BTRFS_I(inode);
+
+	spin_lock(&BTRFS_I(inode)->reserved_lock);
+
+	BUG_ON(BTRFS_I(inode)->reserved_total < min_alloc_size);
+
+	for (pix = 0; pix < profile->nentries; ++pix) {
+		if (bino->reserved_from[pix] >= num_bytes)
+			break;
+		if (bino->reserved_from[pix] > max_size) {
+			max_size = bino->reserved_from[pix];
+			max_pix = pix;
+		}
+	}
+	if (pix == profile->nentries) {
+		if (max_size >= min_alloc_size) {
+			pix = max_pix;
+			num_bytes = max_size;
+		}
+	}
+	if (pix == profile->nentries) {
+		spin_unlock(&BTRFS_I(inode)->reserved_lock);
+		return -ENOSPC;
+	}
+	bino->reserved_from[pix] -= num_bytes;
+	spin_unlock(&BTRFS_I(inode)->reserved_lock);
+
+	ret = btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
+	                           empty_size, hint_byte, search_end, ins,
+	                           data, profile, pix);
+	if (ret == 0) {
+		struct btrfs_space_info *sinfo;
+
+		spin_lock(&BTRFS_I(inode)->reserved_lock);
+		bino->reserved_from[pix] += num_bytes;
+		bino->reserved_from[pix] -= ins->offset;
+		spin_unlock(&BTRFS_I(inode)->reserved_lock);
+
+		sinfo = __find_space_info(root->fs_info,
+				       BTRFS_BLOCK_GROUP_DATA,
+				       BTRFS_I(inode)->profile->speed[pix]);
+		BUG_ON(!sinfo);
+		spin_lock(&sinfo->lock);
+		sinfo->bytes_may_use -= ins->offset;
+		spin_unlock(&sinfo->lock);
+	} else {
+		spin_lock(&BTRFS_I(inode)->reserved_lock);
+		bino->reserved_from[pix] += num_bytes;
+		spin_unlock(&BTRFS_I(inode)->reserved_lock);
+	}
+	return ret;
+}
+
+/*
+ * pix is the index into the profile to indicate from which speed the extent
+ * should get allocated. pix==-1 means any speed from the profile is ok
+ */
+int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 u64 num_bytes, u64 min_alloc_size,
+			 u64 empty_size, u64 hint_byte,
+			 u64 search_end, struct btrfs_key *ins,
+			 u64 data, struct btrfs_profile *profile, int pix)
+{
+	int ret = -ENOSPC;
 	u64 search_start = 0;
+	struct btrfs_space_info *sinfo;
+	int ix;
+	int p_start, p_end;
+	int nospc;
+	int in_logtree = root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID;
 
 	data = btrfs_get_alloc_profile(root, data);
 again:
@@ -5339,31 +5696,54 @@ again:
 	 * the only place that sets empty_size is btrfs_realloc_node, which
 	 * is not called recursively on allocations
 	 */
-	if (empty_size || root->ref_cows)
+	if (empty_size || root->ref_cows ||
+	    (in_logtree && !root->fs_info->log_root_recovering))  {
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     num_bytes + 2 * 1024 * 1024, data, 0);
+				     num_bytes + 2 * 1024 * 1024, data, 0,
+		                     profile, pix, in_logtree);
+	}
 
 	WARN_ON(num_bytes < root->sectorsize);
-	ret = find_free_extent(trans, root, num_bytes, empty_size,
-			       search_start, search_end, hint_byte,
-			       ins, data);
 
-	if (ret == -ENOSPC && num_bytes > min_alloc_size) {
+	if (pix == -1) {
+		p_start = 0;
+		p_end = profile->nentries - 1;
+	} else {
+		p_start = pix;
+		p_end = pix;
+	}
+	nospc = 0;
+	for (ix = p_start; ix <= p_end; ++ix) {
+
+		sinfo = __find_space_info(root->fs_info, data,
+		                          profile->speed[ix]);
+		ret = find_free_extent(trans, root, num_bytes, empty_size,
+				       search_start, search_end, hint_byte,
+				       ins, data, sinfo);
+		if (ret == 0) {
+			return 0;
+		}
+		if (ret == -ENOSPC)
+			++nospc;
+	}
+
+	if (nospc && num_bytes > min_alloc_size) {
 		num_bytes = num_bytes >> 1;
 		num_bytes = num_bytes & ~(root->sectorsize - 1);
 		num_bytes = max(num_bytes, min_alloc_size);
 		do_chunk_alloc(trans, root->fs_info->extent_root,
-			       num_bytes, data, 1);
+			       num_bytes, data, 1, profile, pix, 0);
 		goto again;
 	}
-	if (ret == -ENOSPC) {
-		struct btrfs_space_info *sinfo;
-
-		sinfo = __find_space_info(root->fs_info, data);
-		printk(KERN_ERR "btrfs allocation failed flags %llu, "
-		       "wanted %llu\n", (unsigned long long)data,
-		       (unsigned long long)num_bytes);
-		dump_space_info(sinfo, num_bytes, 1);
+	if (nospc) {
+		for (ix = p_start; ix <= p_end; ++ix) {
+			sinfo = __find_space_info(root->fs_info, data,
+		                          profile->speed[ix]);
+			printk(KERN_ERR "btrfs allocation failed flags %llu, "
+			       "wanted %llu\n", (unsigned long long)data,
+			       (unsigned long long)num_bytes);
+			dump_space_info(sinfo, num_bytes, 1);
+		}
 	}
 
 	return ret;
@@ -5631,31 +6011,34 @@ struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 
 static struct btrfs_block_rsv *
 use_block_rsv(struct btrfs_trans_handle *trans,
-	      struct btrfs_root *root, u32 blocksize)
+	      struct btrfs_root *root, u32 blocksize, int *ppix)
 {
 	struct btrfs_block_rsv *block_rsv;
 	int ret;
 
+	BUG_ON(!ppix);
+
 	block_rsv = get_block_rsv(trans, root);
 
 	if (block_rsv->size == 0) {
 		ret = reserve_metadata_bytes(trans, root, block_rsv,
-					     blocksize, 0);
+					     blocksize, 0, ppix);
 		if (ret)
 			return ERR_PTR(ret);
 		return block_rsv;
 	}
 
-	ret = block_rsv_use_bytes(block_rsv, blocksize);
+	ret = block_rsv_use_bytes(block_rsv, blocksize, ppix);
 	if (!ret)
 		return block_rsv;
 
 	return ERR_PTR(-ENOSPC);
 }
 
-static void unuse_block_rsv(struct btrfs_block_rsv *block_rsv, u32 blocksize)
+static void unuse_block_rsv(struct btrfs_block_rsv *block_rsv, u32 blocksize,
+                            int pix)
 {
-	block_rsv_add_bytes(block_rsv, blocksize, 0);
+	block_rsv_add_bytes(block_rsv, blocksize, 0, pix);
 	block_rsv_release_bytes(block_rsv, NULL, 0);
 }
 
@@ -5677,16 +6060,18 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	struct extent_buffer *buf;
 	u64 flags = 0;
 	int ret;
+	int pix;
 
-
-	block_rsv = use_block_rsv(trans, root, blocksize);
-	if (IS_ERR(block_rsv))
+	block_rsv = use_block_rsv(trans, root, blocksize, &pix);
+	if (IS_ERR(block_rsv)) {
 		return ERR_CAST(block_rsv);
+	}
 
 	ret = btrfs_reserve_extent(trans, root, blocksize, blocksize,
-				   empty_size, hint, (u64)-1, &ins, 0);
+				   empty_size, hint, (u64)-1, &ins, 0,
+	                           block_rsv->profile, pix);
 	if (ret) {
-		unuse_block_rsv(block_rsv, blocksize);
+		unuse_block_rsv(block_rsv, blocksize, pix);
 		return ERR_PTR(ret);
 	}
 
@@ -7991,6 +8376,13 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 	struct btrfs_trans_handle *trans;
 	u64 alloc_flags;
 	int ret;
+	struct btrfs_profile profile;
+
+	memset(&profile, 0, sizeof(profile));
+	profile.nentries = 1;
+	profile.speed[0] = cache->speed;
+	btrfs_init_profile(root->fs_info, &profile,
+	                   !!(cache->flags & BTRFS_BLOCK_GROUP_SYSTEM));
 
 	BUG_ON(cache->ro);
 
@@ -7999,13 +8391,15 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 
 	alloc_flags = update_block_group_flags(root, cache->flags);
 	if (alloc_flags != cache->flags)
-		do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags, 1);
+		do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags, 1,
+		               &profile, 0, 0);
 
 	ret = set_block_group_ro(cache);
 	if (!ret)
 		goto out;
 	alloc_flags = get_alloc_profile(root, cache->space_info->flags);
-	ret = do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags, 1);
+	ret = do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags, 1,
+		             &profile, 0, 0);
 	if (ret < 0)
 		goto out;
 	ret = set_block_group_ro(cache);
@@ -8384,6 +8778,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		btrfs_release_path(root, path);
 		cache->flags = btrfs_block_group_flags(&cache->item);
 		cache->sectorsize = root->sectorsize;
+		cache->speed = btrfs_chunk_seek_speed(root, found_key.objectid);
 
 		/*
 		 * check for two cases, either we are full, and therefore
@@ -8410,7 +8805,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
-					&space_info);
+					cache->speed, &space_info);
 		BUG_ON(ret);
 		cache->space_info = space_info;
 		spin_lock(&cache->space_info->lock);
@@ -8443,8 +8838,8 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			set_block_group_ro(cache);
 	}
 
-	init_global_block_rsv(info);
-	ret = 0;
+	ret = init_global_block_rsv(info, root->log_profile, root->meta_profile,
+	                            root->system_profile);
 error:
 	btrfs_free_path(path);
 	return ret;
@@ -8500,8 +8895,9 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	free_excluded_extents(root, cache);
 
+	cache->speed = btrfs_chunk_seek_speed(root, chunk_offset);
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
-				&cache->space_info);
+				cache->speed, &cache->space_info);
 	BUG_ON(ret);
 
 	spin_lock(&cache->space_info->lock);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b8d3d9..1df90d7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2535,7 +2535,6 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 			  struct writeback_control *wbc)
 {
 	int ret;
-	struct address_space *mapping = page->mapping;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
@@ -2543,6 +2542,8 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
+#if 0
+	struct address_space *mapping = page->mapping;
 	struct writeback_control wbc_writepages = {
 		.sync_mode	= wbc->sync_mode,
 		.older_than_this = NULL,
@@ -2550,11 +2551,16 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 		.range_start	= page_offset(page) + PAGE_CACHE_SIZE,
 		.range_end	= (loff_t)-1,
 	};
+#endif
 
 	ret = __extent_writepage(page, wbc, &epd);
 
+#if 0	/* FIXME this code is disable for the moment as it might triggers
+	 * writes from different space_infos. This hurts log tree writes
+	 * badly */
 	extent_write_cache_pages(tree, mapping, &wbc_writepages,
 				 __extent_writepage, &epd, flush_write_bio);
+#endif
 	flush_epd_write_bio(&epd);
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1562765..38be1ba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -612,11 +612,11 @@ retry:
 			    GFP_NOFS);
 
 		trans = btrfs_join_transaction(root, 1);
-		ret = btrfs_reserve_extent(trans, root,
-					   async_extent->compressed_size,
-					   async_extent->compressed_size,
-					   0, alloc_hint,
-					   (u64)-1, &ins, 1);
+		ret = btrfs_reserve_data_extent(trans, root, inode,
+					        async_extent->compressed_size,
+					        async_extent->compressed_size,
+					        0, alloc_hint,
+					        (u64)-1, &ins, 1);
 		btrfs_end_transaction(trans, root);
 
 		if (ret) {
@@ -813,9 +813,10 @@ static noinline int cow_file_range(struct inode *inode,
 		unsigned long op;
 
 		cur_alloc_size = disk_num_bytes;
-		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
-					   root->sectorsize, 0, alloc_hint,
-					   (u64)-1, &ins, 1);
+		ret = btrfs_reserve_data_extent(trans, root, inode,
+		                                cur_alloc_size,
+					        root->sectorsize, 0, alloc_hint,
+					        (u64)-1, &ins, 1);
 		BUG_ON(ret);
 
 		em = alloc_extent_map(GFP_NOFS);
@@ -2072,9 +2073,11 @@ void btrfs_orphan_pre_snapshot(struct btrfs_trans_handle *trans,
 	 * reserved space.
 	 */
 	index = trans->transid & 0x1;
-	if (block_rsv->reserved + block_rsv->freed[index] < block_rsv->size) {
+	if (block_rsv->reserved_total + block_rsv->freed_total[index]
+	      < block_rsv->size) {
 		num_bytes += block_rsv->size -
-			     (block_rsv->reserved + block_rsv->freed[index]);
+			(block_rsv->reserved_total +
+		         block_rsv->freed_total[index]);
 	}
 
 	*bytes_to_reserve += num_bytes;
@@ -2096,9 +2099,11 @@ void btrfs_orphan_post_snapshot(struct btrfs_trans_handle *trans,
 	/* refill source subvolume's orphan block reservation */
 	block_rsv = root->orphan_block_rsv;
 	index = trans->transid & 0x1;
-	if (block_rsv->reserved + block_rsv->freed[index] < block_rsv->size) {
+	if (block_rsv->reserved_total + block_rsv->freed_total[index]
+	      < block_rsv->size) {
 		num_bytes = block_rsv->size -
-			    (block_rsv->reserved + block_rsv->freed[index]);
+			(block_rsv->reserved_total +
+		         block_rsv->freed_total[index]);
 		ret = btrfs_block_rsv_migrate(&pending->block_rsv,
 					      root->orphan_block_rsv,
 					      num_bytes);
@@ -2106,7 +2111,7 @@ void btrfs_orphan_post_snapshot(struct btrfs_trans_handle *trans,
 	}
 
 	/* setup orphan block reservation for the snapshot */
-	block_rsv = btrfs_alloc_block_rsv(snap);
+	block_rsv = btrfs_alloc_block_rsv(snap, root->meta_profile);
 	BUG_ON(!block_rsv);
 
 	btrfs_add_durable_block_rsv(root->fs_info, block_rsv);
@@ -2177,7 +2182,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	int ret;
 
 	if (!root->orphan_block_rsv) {
-		block_rsv = btrfs_alloc_block_rsv(root);
+		block_rsv = btrfs_alloc_block_rsv(root, root->meta_profile);
 		BUG_ON(!block_rsv);
 	}
 
@@ -4020,7 +4025,7 @@ static int btrfs_init_locked_inode(struct inode *inode, void *p)
 	struct btrfs_iget_args *args = p;
 	inode->i_ino = args->ino;
 	BTRFS_I(inode)->root = args->root;
-	btrfs_set_inode_space_info(args->root, inode);
+	btrfs_set_inode_profile(args->root, inode);
 	return 0;
 }
 
@@ -4521,7 +4526,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->root = root;
 	BTRFS_I(inode)->generation = trans->transid;
 	inode->i_generation = BTRFS_I(inode)->generation;
-	btrfs_set_inode_space_info(root, inode);
+	btrfs_set_inode_profile(root, inode);
 
 	if (mode & S_IFDIR)
 		owner = 0;
@@ -5288,8 +5293,9 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 	alloc_hint = get_extent_allocation_hint(inode, start, len);
-	ret = btrfs_reserve_extent(trans, root, len, root->sectorsize, 0,
-				   alloc_hint, (u64)-1, &ins, 1);
+	ret = btrfs_reserve_data_extent(trans, root, inode,
+	                                len, root->sectorsize, 0,
+				        alloc_hint, (u64)-1, &ins, 1);
 	if (ret) {
 		em = ERR_PTR(ret);
 		goto out;
@@ -6483,19 +6489,21 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	ei->root = NULL;
-	ei->space_info = NULL;
+	ei->profile = NULL;
 	ei->generation = 0;
 	ei->sequence = 0;
 	ei->last_trans = 0;
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
 	ei->delalloc_bytes = 0;
-	ei->reserved_bytes = 0;
+	ei->reserved_total = 0;
+	memset(&ei->reserved_from, 0, sizeof(ei->reserved_from));
 	ei->disk_i_size = 0;
 	ei->flags = 0;
 	ei->index_cnt = (u64)-1;
 	ei->last_unlink_trans = 0;
 
+	spin_lock_init(&ei->reserved_lock);
 	spin_lock_init(&ei->accounting_lock);
 	atomic_set(&ei->outstanding_extents, 0);
 	ei->reserved_extents = 0;
@@ -7056,8 +7064,9 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			}
 		}
 
-		ret = btrfs_reserve_extent(trans, root, num_bytes, min_size,
-					   0, *alloc_hint, (u64)-1, &ins, 1);
+		ret = btrfs_reserve_data_extent(trans, root, inode,
+		                                num_bytes, min_size, 0,
+					        *alloc_hint, (u64)-1, &ins, 1);
 		if (ret) {
 			if (own_trans)
 				btrfs_end_transaction(trans, root);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a506a22..a42e464 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1683,7 +1683,26 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 		return PTR_ERR(vol_args);
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	ret = btrfs_init_new_device(root, vol_args->name);
+	ret = btrfs_init_new_device(root, vol_args->name, 30);
+
+	kfree(vol_args);
+	return ret;
+}
+
+static long btrfs_ioctl_add_dev_v2(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_vol_args_v2 *vol_args;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
+
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	ret = btrfs_init_new_device(root, vol_args->name, vol_args->seek_speed);
 
 	kfree(vol_args);
 	return ret;
@@ -2392,6 +2411,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_resize(root, argp);
 	case BTRFS_IOC_ADD_DEV:
 		return btrfs_ioctl_add_dev(root, argp);
+	case BTRFS_IOC_ADD_DEV_V2:
+		return btrfs_ioctl_add_dev_v2(root, argp);
 	case BTRFS_IOC_RM_DEV:
 		return btrfs_ioctl_rm_dev(root, argp);
 	case BTRFS_IOC_BALANCE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 8fb3821..45158f1 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -38,8 +38,10 @@ struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
 	__u64 transid;
 	__u64 flags;
-	__u64 unused[4];
-	char name[BTRFS_SUBVOL_NAME_MAX + 1];
+	__u8  seek_speed;
+	__u8  unused_u8[3];
+	__u64 unused_u64[3];
+	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
@@ -203,4 +205,6 @@ struct btrfs_ioctl_space_args {
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
+#define BTRFS_IOC_ADD_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 27, \
+				   struct btrfs_ioctl_vol_args_v2)
 #endif
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 2b61e1d..083a554 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -141,7 +141,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
 					  u64 file_offset)
 {
 	struct rb_root *root = &tree->tree;
-	struct rb_node *prev;
+	struct rb_node *prev = NULL;
 	struct rb_node *ret;
 	struct btrfs_ordered_extent *entry;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 045c9c2..710b714 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3601,7 +3601,8 @@ int prepare_to_relocate(struct reloc_control *rc)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	rc->block_rsv = btrfs_alloc_block_rsv(rc->extent_root);
+	rc->block_rsv = btrfs_alloc_block_rsv(rc->extent_root,
+	                                      rc->extent_root->meta_profile);
 	if (!rc->block_rsv)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bae5c7b..144c0a9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -510,11 +510,13 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 	u64 end;
 	unsigned long index;
 
+	start = 0;
 	while (1) {
 		ret = find_first_extent_bit(dirty_pages, start, &start, &end,
 					    mark);
 		if (ret)
 			break;
+
 		while (start <= end) {
 			cond_resched();
 
@@ -530,7 +532,6 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 				page_cache_release(page);
 				continue;
 			}
-
 			if (PageWriteback(page)) {
 				if (PageDirty(page))
 					wait_on_page_writeback(page);
@@ -1363,7 +1364,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	mutex_unlock(&root->fs_info->trans_mutex);
 	ret = btrfs_write_and_wait_transaction(trans, root);
 	BUG_ON(ret);
-	write_ctree_super(trans, root, 0);
+	write_ctree_super(trans, root, 0, 1);
 
 	/*
 	 * the super is written, we can safely allow the tree-loggers
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 054744a..faaecab 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1960,7 +1960,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		unsigned long batch = root->log_batch;
-		if (root->log_multiple_pids) {
+		if (0 && root->log_multiple_pids) {
 			mutex_unlock(&root->log_mutex);
 			schedule_timeout_uninterruptible(1);
 			mutex_lock(&root->log_mutex);
@@ -2078,7 +2078,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * the running transaction open, so a full commit can't hop
 	 * in and cause problems either.
 	 */
-	write_ctree_super(trans, root->fs_info->tree_root, 1);
+	write_ctree_super(trans, log, 1, 0);
 	ret = 0;
 
 	mutex_lock(&root->log_mutex);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2d2f4c..ab93cae 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1181,7 +1181,7 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 	btrfs_set_device_total_bytes(leaf, dev_item, device->total_bytes);
 	btrfs_set_device_bytes_used(leaf, dev_item, device->bytes_used);
 	btrfs_set_device_group(leaf, dev_item, 0);
-	btrfs_set_device_seek_speed(leaf, dev_item, 0);
+	btrfs_set_device_seek_speed(leaf, dev_item, device->seek_speed);
 	btrfs_set_device_bandwidth(leaf, dev_item, 0);
 	btrfs_set_device_start_offset(leaf, dev_item, 0);
 
@@ -1544,7 +1544,7 @@ error:
 	return ret;
 }
 
-int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
+int btrfs_init_new_device(struct btrfs_root *root, char *device_path, int speed)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
@@ -1621,7 +1621,9 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
 	device->mode = 0;
+	device->seek_speed = speed;
 	set_blocksize(device->bdev, 4096);
+	device->flush_bio = NULL;
 
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
@@ -2280,15 +2282,33 @@ int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2)
 }
 
 static int __btrfs_calc_nstripes(struct btrfs_fs_devices *fs_devices, u64 type,
-				 int *num_stripes, int *min_stripes,
+				 int speed, int *num_stripes, int *min_stripes,
 				 int *sub_stripes)
 {
+	struct btrfs_device *device = NULL;
+	int ndevs = 0;
+	struct list_head *cur;
+
 	*num_stripes = 1;
 	*min_stripes = 1;
 	*sub_stripes = 0;
 
+	/*
+	 * count devides with this speed. FIXME: this number could be cached
+	 */
+	cur = fs_devices->alloc_list.next;
+	while(1) {
+		device =list_entry(cur, struct btrfs_device, dev_alloc_list);
+		BUG_ON(!device->writeable);
+		if (device->in_fs_metadata && device->seek_speed == speed)
+			++ndevs;
+		cur = cur->next;
+		if (cur == &fs_devices->alloc_list)
+			break;
+	}
+
 	if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
-		*num_stripes = fs_devices->rw_devices;
+		*num_stripes = ndevs;
 		*min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
@@ -2296,13 +2316,13 @@ static int __btrfs_calc_nstripes(struct btrfs_fs_devices *fs_devices, u64 type,
 		*min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
-		if (fs_devices->rw_devices < 2)
+		if (ndevs < 2)
 			return -ENOSPC;
 		*num_stripes = 2;
 		*min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-		*num_stripes = fs_devices->rw_devices;
+		*num_stripes = ndevs;
 		if (*num_stripes < 4)
 			return -ENOSPC;
 		*num_stripes &= ~(u32)1;
@@ -2484,7 +2504,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *extent_root,
 			       struct map_lookup **map_ret,
 			       u64 *num_bytes, u64 *stripe_size,
-			       u64 start, u64 type)
+			       u64 start, u64 type, int speed)
 {
 	struct btrfs_fs_info *info = extent_root->fs_info;
 	struct btrfs_device *device = NULL;
@@ -2515,7 +2535,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	if (list_empty(&fs_devices->alloc_list))
 		return -ENOSPC;
 
-	ret = __btrfs_calc_nstripes(fs_devices, type, &num_stripes,
+	ret = __btrfs_calc_nstripes(fs_devices, type, speed, &num_stripes,
 				    &min_stripes, &sub_stripes);
 	if (ret)
 		return ret;
@@ -2557,6 +2577,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			avail = 0;
 		cur = cur->next;
 
+		if (device->seek_speed != speed)
+			goto next;
+
 		if (device->in_fs_metadata && avail >= min_free) {
 			ret = find_free_dev_extent(trans, device, min_free,
 						   &devices_info[i].dev_offset,
@@ -2586,7 +2609,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			devices_info[i].max_avail = avail;
 			i++;
 		}
-
+next:
 		if (cur == &fs_devices->alloc_list)
 			break;
 	}
@@ -2745,7 +2768,7 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
  * bootstrap process of adding storage to a seed btrfs.
  */
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *extent_root, u64 type)
+		      struct btrfs_root *extent_root, u64 type, int speed)
 {
 	u64 chunk_offset;
 	u64 chunk_size;
@@ -2760,7 +2783,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		return ret;
 
 	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
-				  &stripe_size, chunk_offset, type);
+				  &stripe_size, chunk_offset, type, speed);
 	if (ret)
 		return ret;
 
@@ -2797,7 +2820,8 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	alloc_profile = btrfs_reduce_alloc_profile(root, alloc_profile);
 
 	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
-				  &stripe_size, chunk_offset, alloc_profile);
+				  &stripe_size, chunk_offset, alloc_profile,
+	                          device->seek_speed);
 	BUG_ON(ret);
 
 	sys_chunk_offset = chunk_offset + chunk_size;
@@ -2809,7 +2833,8 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 
 	ret = __btrfs_alloc_chunk(trans, extent_root, &sys_map,
 				  &sys_chunk_size, &sys_stripe_size,
-				  sys_chunk_offset, alloc_profile);
+				  sys_chunk_offset, alloc_profile,
+	                          device->seek_speed);
 	BUG_ON(ret);
 
 	ret = btrfs_add_device(trans, fs_info->chunk_root, device);
@@ -2862,6 +2887,33 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 	return readonly;
 }
 
+int btrfs_chunk_seek_speed(struct btrfs_root *root, u64 chunk_offset)
+{
+	struct extent_map *em;
+	struct map_lookup *map;
+	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	int seek_speed = 256;
+	int i;
+
+	read_lock(&map_tree->map_tree.lock);
+	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
+	read_unlock(&map_tree->map_tree.lock);
+	if (!em)
+		return 0;
+
+	map = (struct map_lookup *)em->bdev;
+	for (i = 0; i < map->num_stripes; i++) {
+		if (map->stripes[i].dev->seek_speed < seek_speed) {
+			seek_speed = map->stripes[i].dev->seek_speed;
+		}
+	}
+	free_extent_map(em);
+
+	WARN_ON(seek_speed == 256);
+
+	return seek_speed;
+}
+
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree)
 {
 	extent_map_tree_init(&tree->map_tree, GFP_NOFS);
@@ -3494,6 +3546,16 @@ static int fill_device_from_item(struct extent_buffer *leaf,
 	device->io_align = btrfs_device_io_align(leaf, dev_item);
 	device->io_width = btrfs_device_io_width(leaf, dev_item);
 	device->sector_size = btrfs_device_sector_size(leaf, dev_item);
+	device->seek_speed = btrfs_device_seek_speed(leaf, dev_item);
+	if (device->seek_speed <= 1) {
+		/* this is necessary, because in older versions of mkfs.btrfs
+		 * the seek_speed got initialized 1 for the first device and
+		 * 0 for the following. 30 is the default for data + metadata
+		 */
+		device->seek_speed = 30;
+	}
+	printk(KERN_DEBUG "btrfs: device %llu has speed %d\n", device->devid,
+	                  device->seek_speed);
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7af6144..4894e36 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -83,10 +83,17 @@ struct btrfs_device {
 	/* type and info about this device */
 	u64 type;
 
+	/* the speed is used to determine if the device should be a preferred
+	 * log device */
+	u8 seek_speed;
+
 	/* physical drive uuid (or lvm uuid) */
 	u8 uuid[BTRFS_UUID_SIZE];
 
 	struct btrfs_work work;
+
+	struct bio *flush_bio;
+	struct completion flush_wait;
 };
 
 struct btrfs_fs_devices {
@@ -180,7 +187,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 int btrfs_read_sys_array(struct btrfs_root *root);
 int btrfs_read_chunk_tree(struct btrfs_root *root);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *extent_root, u64 type);
+		      struct btrfs_root *extent_root, u64 type, int speed);
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
 int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
@@ -205,7 +212,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
-int btrfs_init_new_device(struct btrfs_root *root, char *path);
+int btrfs_init_new_device(struct btrfs_root *root, char *path, int speed);
 int btrfs_balance(struct btrfs_root *dev_root);
 void btrfs_unlock_volumes(void);
 void btrfs_lock_volumes(void);
@@ -213,4 +220,6 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+int btrfs_chunk_seek_speed(struct btrfs_root *root, u64 chunk_offset);
+
 #endif
-- 
1.7.2.2

