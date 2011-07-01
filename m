From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v5 3/7] btrfs: state information for readahead
Date: Fri,  1 Jul 2011 22:58:49 +0200
Message-ID: <866219e692abab35aa965d990854fa2a49b1a6cb.1309553533.git.sensille@gmx.net>
References: <cover.1309553533.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1309553533.git.sensille@gmx.net>
In-Reply-To: <cover.1309553533.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add state information for readahead to btrfs_fs_info and btrfs_device

Changes v2:
 - don't wait in radix_trees
 - add own set of workers for readahead

Reviewed-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h   |    5 +++++
 fs/btrfs/disk-io.c |   11 +++++++++++
 fs/btrfs/volumes.c |    8 ++++++++
 fs/btrfs/volumes.h |    8 ++++++++
 4 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e948ec..51534bf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1033,6 +1033,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_write_workers;
 	struct btrfs_workers endio_freespace_worker;
 	struct btrfs_workers submit_workers;
+	struct btrfs_workers readahead_workers;
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
 	 * the cow mechanism and make them safe to write.  It happens
@@ -1115,6 +1116,10 @@ struct btrfs_fs_info {
 	u64 fs_state;
 
 	struct btrfs_delayed_root *delayed_root;
+
+	/* readahead tree */
+	spinlock_t reada_lock;
+	struct radix_tree_root reada_tree;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b8c5790..7fbdfa1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1682,6 +1682,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->defrag_inodes = RB_ROOT;
 	fs_info->trans_no_join = 0;
 
+	/* readahead state */
+	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
+	spin_lock_init(&fs_info->reada_lock);
+
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
 
@@ -1871,6 +1875,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->delayed_workers, "delayed-meta",
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
+	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
+			   fs_info->thread_pool_size,
+			   &fs_info->generic_worker);
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -1881,6 +1888,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	fs_info->endio_write_workers.idle_thresh = 2;
 	fs_info->endio_meta_write_workers.idle_thresh = 2;
+	fs_info->readahead_workers.idle_thresh = 2;
 
 	btrfs_start_workers(&fs_info->workers, 1);
 	btrfs_start_workers(&fs_info->generic_worker, 1);
@@ -1893,6 +1901,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	btrfs_start_workers(&fs_info->endio_write_workers, 1);
 	btrfs_start_workers(&fs_info->endio_freespace_worker, 1);
 	btrfs_start_workers(&fs_info->delayed_workers, 1);
+	btrfs_start_workers(&fs_info->readahead_workers, 1);
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
@@ -2150,6 +2159,7 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
+	btrfs_stop_workers(&fs_info->readahead_workers);
 fail_alloc:
 	kfree(fs_info->delayed_root);
 fail_iput:
@@ -2617,6 +2627,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
+	btrfs_stop_workers(&fs_info->readahead_workers);
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1efa56e..a1a4b02 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -349,6 +349,14 @@ static noinline int device_list_add(const char *path,
 		}
 		INIT_LIST_HEAD(&device->dev_alloc_list);
 
+		/* init readahead state */
+		spin_lock_init(&device->reada_lock);
+		device->reada_curr_zone = NULL;
+		atomic_set(&device->reada_in_flight, 0);
+		device->reada_next = 0;
+		INIT_RADIX_TREE(&device->reada_zones, GFP_NOFS & ~__GFP_WAIT);
+		INIT_RADIX_TREE(&device->reada_extents, GFP_NOFS & ~__GFP_WAIT);
+
 		mutex_lock(&fs_devices->device_list_mutex);
 		list_add_rcu(&device->dev_list, &fs_devices->devices);
 		mutex_unlock(&fs_devices->device_list_mutex);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7c12d61..63ac242 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -91,6 +91,14 @@ struct btrfs_device {
 	struct btrfs_work work;
 	struct rcu_head rcu;
 	struct work_struct rcu_work;
+
+	/* readahead state */
+	spinlock_t reada_lock;
+	atomic_t reada_in_flight;
+	u64 reada_next;
+	struct reada_zone *reada_curr_zone;
+	struct radix_tree_root reada_zones;
+	struct radix_tree_root reada_extents;
 };
 
 struct btrfs_fs_devices {
-- 
1.7.3.4

