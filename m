From: jeffm@suse.com
Subject: [patch v3 13/23] btrfs: volumes.c: Make functions with no error conditions return void
Date: Thu, 08 Sep 2011 20:22:53 -0400
Message-ID: <20110909002732.224239277@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_cleanup_fs_uuids, run_scheduled_bios, btrfs_close_extra_devices,
 schedule_bio, and fill_device_from_item have no error conditions and
 should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c |   25 +++++++++----------------
 fs/btrfs/volumes.h |    4 ++--
 2 files changed, 11 insertions(+), 18 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -65,7 +65,7 @@ static void free_fs_devices(struct btrfs
 	kfree(fs_devices);
 }
 
-int btrfs_cleanup_fs_uuids(void)
+void btrfs_cleanup_fs_uuids(void)
 {
 	struct btrfs_fs_devices *fs_devices;
 
@@ -75,7 +75,6 @@ int btrfs_cleanup_fs_uuids(void)
 		list_del(&fs_devices->list);
 		free_fs_devices(fs_devices);
 	}
-	return 0;
 }
 
 static noinline struct btrfs_device *__find_device(struct list_head *head,
@@ -128,7 +127,7 @@ static void requeue_list(struct btrfs_pe
  * the list if the block device is congested.  This way, multiple devices
  * can make progress from a single worker thread.
  */
-static noinline int run_scheduled_bios(struct btrfs_device *device)
+static noinline void run_scheduled_bios(struct btrfs_device *device)
 {
 	struct bio *pending;
 	struct backing_dev_info *bdi;
@@ -291,7 +290,6 @@ loop_lock:
 
 done:
 	blk_finish_plug(&plug);
-	return 0;
 }
 
 static void pending_bios_fn(struct btrfs_work *work)
@@ -422,7 +420,7 @@ error:
 	return ERR_PTR(-ENOMEM);
 }
 
-int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
+void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device, *next;
 
@@ -455,7 +453,6 @@ again:
 	}
 
 	mutex_unlock(&uuid_mutex);
-	return 0;
 }
 
 static void __free_device(struct work_struct *work)
@@ -3202,9 +3199,9 @@ struct async_sched {
  * This will add one bio to the pending list for a device and make sure
  * the work struct is scheduled.
  */
-static noinline int schedule_bio(struct btrfs_root *root,
-				 struct btrfs_device *device,
-				 int rw, struct bio *bio)
+static noinline void schedule_bio(struct btrfs_root *root,
+				  struct btrfs_device *device,
+				  int rw, struct bio *bio)
 {
 	int should_queue = 1;
 	struct btrfs_pending_bios *pending_bios;
@@ -3214,7 +3211,6 @@ static noinline int schedule_bio(struct
 		bio_get(bio);
 		submit_bio(rw, bio);
 		bio_put(bio);
-		return 0;
 	}
 
 	/*
@@ -3248,7 +3244,6 @@ static noinline int schedule_bio(struct
 	if (should_queue)
 		btrfs_queue_worker(&root->fs_info->submit_workers,
 				   &device->work);
-	return 0;
 }
 
 int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
@@ -3449,9 +3444,9 @@ static int read_one_chunk(struct btrfs_r
 	return 0;
 }
 
-static int fill_device_from_item(struct extent_buffer *leaf,
-				 struct btrfs_dev_item *dev_item,
-				 struct btrfs_device *device)
+static void fill_device_from_item(struct extent_buffer *leaf,
+				  struct btrfs_dev_item *dev_item,
+				  struct btrfs_device *device)
 {
 	unsigned long ptr;
 
@@ -3466,8 +3461,6 @@ static int fill_device_from_item(struct
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
-
-	return 0;
 }
 
 static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -195,12 +195,12 @@ int btrfs_open_devices(struct btrfs_fs_d
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
+void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
-int btrfs_cleanup_fs_uuids(void);
+void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);


