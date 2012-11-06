Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:64566 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp2) (RZmta 31.1 OK)
	with ESMTP id g02b97oA6CtSYd for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/26] Btrfs: pass fs_info instead of root
Date: Tue,  6 Nov 2012 17:38:29 +0100
Message-Id: <6ad469638b072308beaa76244b699a8a3d789ecb.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

A small number of functions that are used in a device replace
procedure when the operation is resumed at mount time are unable
to pass the same root pointer that would be used in the regular
(ioctl) context. And since the root pointer is not required, only
the fs_info is, the root pointer argument is replaced with the
fs_info pointer argument.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h   | 11 ++++----
 fs/btrfs/disk-io.c |  4 +--
 fs/btrfs/ioctl.c   |  8 +++---
 fs/btrfs/scrub.c   | 76 ++++++++++++++++++++++++------------------------------
 fs/btrfs/super.c   |  2 +-
 fs/btrfs/volumes.c | 23 +++++++++--------
 fs/btrfs/volumes.h |  2 +-
 7 files changed, 60 insertions(+), 66 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 95c1a8e..ef83538 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3540,15 +3540,16 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 			      struct btrfs_pending_snapshot *pending);
 
 /* scrub.c */
-int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
-		    struct btrfs_scrub_progress *progress, int readonly);
+int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
+		    u64 end, struct btrfs_scrub_progress *progress,
+		    int readonly);
 void btrfs_scrub_pause(struct btrfs_root *root);
 void btrfs_scrub_pause_super(struct btrfs_root *root);
 void btrfs_scrub_continue(struct btrfs_root *root);
 void btrfs_scrub_continue_super(struct btrfs_root *root);
-int __btrfs_scrub_cancel(struct btrfs_fs_info *info);
-int btrfs_scrub_cancel(struct btrfs_root *root);
-int btrfs_scrub_cancel_dev(struct btrfs_root *root, struct btrfs_device *dev);
+int btrfs_scrub_cancel(struct btrfs_fs_info *info);
+int btrfs_scrub_cancel_dev(struct btrfs_fs_info *info,
+			   struct btrfs_device *dev);
 int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid);
 int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 			 struct btrfs_scrub_progress *progress);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f4b2733..53ab3cd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3283,9 +3283,9 @@ int close_ctree(struct btrfs_root *root)
 	smp_mb();
 
 	/* pause restriper - we want to resume on mount */
-	btrfs_pause_balance(root->fs_info);
+	btrfs_pause_balance(fs_info);
 
-	btrfs_scrub_cancel(root);
+	btrfs_scrub_cancel(fs_info);
 
 	/* wait for any defraggers to finish */
 	wait_event(fs_info->transaction_wait,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1a9c5ee..7ece1fe 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1340,7 +1340,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		printk(KERN_INFO "btrfs: resizing devid %llu\n",
 		       (unsigned long long)devid);
 	}
-	device = btrfs_find_device(root, devid, NULL, NULL);
+	device = btrfs_find_device(root->fs_info, devid, NULL, NULL);
 	if (!device) {
 		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
 		       (unsigned long long)devid);
@@ -2329,7 +2329,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 		s_uuid = di_args->uuid;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(root, di_args->devid, s_uuid, NULL);
+	dev = btrfs_find_device(root->fs_info, di_args->devid, s_uuid, NULL);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
@@ -3086,7 +3086,7 @@ static long btrfs_ioctl_scrub(struct btrfs_root *root, void __user *arg)
 	if (IS_ERR(sa))
 		return PTR_ERR(sa);
 
-	ret = btrfs_scrub_dev(root, sa->devid, sa->start, sa->end,
+	ret = btrfs_scrub_dev(root->fs_info, sa->devid, sa->start, sa->end,
 			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY);
 
 	if (copy_to_user(arg, sa, sizeof(*sa)))
@@ -3101,7 +3101,7 @@ static long btrfs_ioctl_scrub_cancel(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	return btrfs_scrub_cancel(root);
+	return btrfs_scrub_cancel(root->fs_info);
 }
 
 static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 894bb27..6cf23f4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2262,9 +2262,8 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 /*
  * get a reference count on fs_info->scrub_workers. start worker if necessary
  */
-static noinline_for_stack int scrub_workers_get(struct btrfs_root *root)
+static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret = 0;
 
 	mutex_lock(&fs_info->scrub_lock);
@@ -2283,10 +2282,8 @@ out:
 	return ret;
 }
 
-static noinline_for_stack void scrub_workers_put(struct btrfs_root *root)
+static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
-
 	mutex_lock(&fs_info->scrub_lock);
 	if (--fs_info->scrub_workers_refcnt == 0)
 		btrfs_stop_workers(&fs_info->scrub_workers);
@@ -2294,29 +2291,29 @@ static noinline_for_stack void scrub_workers_put(struct btrfs_root *root)
 	mutex_unlock(&fs_info->scrub_lock);
 }
 
-
-int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
-		    struct btrfs_scrub_progress *progress, int readonly)
+int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
+		    u64 end, struct btrfs_scrub_progress *progress,
+		    int readonly)
 {
 	struct scrub_ctx *sctx;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	struct btrfs_device *dev;
 
-	if (btrfs_fs_closing(root->fs_info))
+	if (btrfs_fs_closing(fs_info))
 		return -EINVAL;
 
 	/*
 	 * check some assumptions
 	 */
-	if (root->nodesize != root->leafsize) {
+	if (fs_info->chunk_root->nodesize != fs_info->chunk_root->leafsize) {
 		printk(KERN_ERR
 		       "btrfs_scrub: size assumption nodesize == leafsize (%d == %d) fails\n",
-		       root->nodesize, root->leafsize);
+		       fs_info->chunk_root->nodesize,
+		       fs_info->chunk_root->leafsize);
 		return -EINVAL;
 	}
 
-	if (root->nodesize > BTRFS_STRIPE_LEN) {
+	if (fs_info->chunk_root->nodesize > BTRFS_STRIPE_LEN) {
 		/*
 		 * in this case scrub is unable to calculate the checksum
 		 * the way scrub is implemented. Do not handle this
@@ -2324,15 +2321,16 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 		 */
 		printk(KERN_ERR
 		       "btrfs_scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails\n",
-		       root->nodesize, BTRFS_STRIPE_LEN);
+		       fs_info->chunk_root->nodesize, BTRFS_STRIPE_LEN);
 		return -EINVAL;
 	}
 
-	if (root->sectorsize != PAGE_SIZE) {
+	if (fs_info->chunk_root->sectorsize != PAGE_SIZE) {
 		/* not supported for data w/o checksums */
 		printk(KERN_ERR
 		       "btrfs_scrub: size assumption sectorsize != PAGE_SIZE (%d != %lld) fails\n",
-		       root->sectorsize, (unsigned long long)PAGE_SIZE);
+		       fs_info->chunk_root->sectorsize,
+		       (unsigned long long)PAGE_SIZE);
 		return -EINVAL;
 	}
 
@@ -2352,37 +2350,37 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 		return -EINVAL;
 	}
 
-	ret = scrub_workers_get(root);
+	ret = scrub_workers_get(fs_info);
 	if (ret)
 		return ret;
 
-	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(root, devid, NULL, NULL);
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!dev || dev->missing) {
-		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(root);
+		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		scrub_workers_put(fs_info);
 		return -ENODEV;
 	}
 	mutex_lock(&fs_info->scrub_lock);
 
 	if (!dev->in_fs_metadata) {
 		mutex_unlock(&fs_info->scrub_lock);
-		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(root);
-		return -ENODEV;
+		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		scrub_workers_put(fs_info);
+		return -EIO;
 	}
 
 	if (dev->scrub_device) {
 		mutex_unlock(&fs_info->scrub_lock);
-		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(root);
+		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		scrub_workers_put(fs_info);
 		return -EINPROGRESS;
 	}
 	sctx = scrub_setup_ctx(dev);
 	if (IS_ERR(sctx)) {
 		mutex_unlock(&fs_info->scrub_lock);
-		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(root);
+		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		scrub_workers_put(fs_info);
 		return PTR_ERR(sctx);
 	}
 	sctx->readonly = readonly;
@@ -2390,7 +2388,7 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 
 	atomic_inc(&fs_info->scrubs_running);
 	mutex_unlock(&fs_info->scrub_lock);
-	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	down_read(&fs_info->scrub_super_lock);
 	ret = scrub_supers(sctx, dev);
@@ -2413,7 +2411,7 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 	mutex_unlock(&fs_info->scrub_lock);
 
 	scrub_free_ctx(sctx);
-	scrub_workers_put(root);
+	scrub_workers_put(fs_info);
 
 	return ret;
 }
@@ -2453,9 +2451,8 @@ void btrfs_scrub_continue_super(struct btrfs_root *root)
 	up_write(&root->fs_info->scrub_super_lock);
 }
 
-int __btrfs_scrub_cancel(struct btrfs_fs_info *fs_info)
+int btrfs_scrub_cancel(struct btrfs_fs_info *fs_info)
 {
-
 	mutex_lock(&fs_info->scrub_lock);
 	if (!atomic_read(&fs_info->scrubs_running)) {
 		mutex_unlock(&fs_info->scrub_lock);
@@ -2475,14 +2472,9 @@ int __btrfs_scrub_cancel(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
-int btrfs_scrub_cancel(struct btrfs_root *root)
+int btrfs_scrub_cancel_dev(struct btrfs_fs_info *fs_info,
+			   struct btrfs_device *dev)
 {
-	return __btrfs_scrub_cancel(root->fs_info);
-}
-
-int btrfs_scrub_cancel_dev(struct btrfs_root *root, struct btrfs_device *dev)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct scrub_ctx *sctx;
 
 	mutex_lock(&fs_info->scrub_lock);
@@ -2514,12 +2506,12 @@ int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid)
 	 * does not go away in cancel_dev. FIXME: find a better solution
 	 */
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(root, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!dev) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		return -ENODEV;
 	}
-	ret = btrfs_scrub_cancel_dev(root, dev);
+	ret = btrfs_scrub_cancel_dev(fs_info, dev);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	return ret;
@@ -2532,7 +2524,7 @@ int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 	struct scrub_ctx *sctx = NULL;
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(root, devid, NULL, NULL);
+	dev = btrfs_find_device(root->fs_info, devid, NULL, NULL);
 	if (dev)
 		sctx = dev->scrub_device;
 	if (sctx)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8bba9d1..8b7cf54 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -116,7 +116,7 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 		sb->s_flags |= MS_RDONLY;
 		printk(KERN_INFO "btrfs is forced readonly\n");
-		__btrfs_scrub_cancel(fs_info);
+		btrfs_scrub_cancel(fs_info);
 //		WARN_ON(1);
 	}
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bf5e68b..473ae89 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1388,7 +1388,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		disk_super = (struct btrfs_super_block *)bh->b_data;
 		devid = btrfs_stack_device_id(&disk_super->dev_item);
 		dev_uuid = disk_super->dev_item.uuid;
-		device = btrfs_find_device(root, devid, dev_uuid,
+		device = btrfs_find_device(root->fs_info, devid, dev_uuid,
 					   disk_super->fsid);
 		if (!device) {
 			ret = -ENOENT;
@@ -1425,7 +1425,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	spin_unlock(&root->fs_info->free_chunk_lock);
 
 	device->in_fs_metadata = 0;
-	btrfs_scrub_cancel_dev(root, device);
+	btrfs_scrub_cancel_dev(root->fs_info, device);
 
 	/*
 	 * the device list mutex makes sure that we don't change
@@ -1482,7 +1482,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 * at this point, the device is zero sized.  We want to
 	 * remove it from the devices list and zero out the old super
 	 */
-	if (clear_super) {
+	if (clear_super && disk_super) {
 		/* make sure this device isn't detected as part of
 		 * the FS anymore
 		 */
@@ -1542,7 +1542,7 @@ int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	dev_uuid = disk_super->dev_item.uuid;
-	*device = btrfs_find_device(root, devid, dev_uuid,
+	*device = btrfs_find_device(root->fs_info, devid, dev_uuid,
 				    disk_super->fsid);
 	brelse(bh);
 	if (!*device)
@@ -1704,7 +1704,8 @@ next_slot:
 		read_extent_buffer(leaf, fs_uuid,
 				   (unsigned long)btrfs_device_fsid(dev_item),
 				   BTRFS_UUID_SIZE);
-		device = btrfs_find_device(root, devid, dev_uuid, fs_uuid);
+		device = btrfs_find_device(root->fs_info, devid, dev_uuid,
+					   fs_uuid);
 		BUG_ON(!device); /* Logic error */
 
 		if (device->fs_devices->seeding) {
@@ -4468,13 +4469,13 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	return 0;
 }
 
-struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
+struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *cur_devices;
 
-	cur_devices = root->fs_info->fs_devices;
+	cur_devices = fs_info->fs_devices;
 	while (cur_devices) {
 		if (!fsid ||
 		    !memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
@@ -4572,8 +4573,8 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		read_extent_buffer(leaf, uuid, (unsigned long)
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
-		map->stripes[i].dev = btrfs_find_device(root, devid, uuid,
-							NULL);
+		map->stripes[i].dev = btrfs_find_device(root->fs_info, devid,
+							uuid, NULL);
 		if (!map->stripes[i].dev && !btrfs_test_opt(root, DEGRADED)) {
 			kfree(map);
 			free_extent_map(em);
@@ -4691,7 +4692,7 @@ static int read_one_dev(struct btrfs_root *root,
 			return ret;
 	}
 
-	device = btrfs_find_device(root, devid, dev_uuid, fs_uuid);
+	device = btrfs_find_device(root->fs_info, devid, dev_uuid, fs_uuid);
 	if (!device || !device->bdev) {
 		if (!btrfs_test_opt(root, DEGRADED))
 			return -EIO;
@@ -5083,7 +5084,7 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 	int i;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(root, stats->devid, NULL, NULL);
+	dev = btrfs_find_device(root->fs_info, stats->devid, NULL, NULL);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7eaaf4e..802e2ba 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -281,7 +281,7 @@ void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
-struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
+struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
-- 
1.8.0

