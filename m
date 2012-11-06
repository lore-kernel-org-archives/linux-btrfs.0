Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:61807 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp2) (RZmta 31.1 OK) with ESMTP id g01bccoA6DKvk5
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 17/26] Btrfs: disallow some operations on the device replace target device
Date: Tue,  6 Nov 2012 17:38:35 +0100
Message-Id: <21bdb540d81f99cce89d076f81d52d59c82e859a.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

This patch adds some code to disallow operations on the device that
is used as the target for the device replace operation.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c |  3 ++-
 fs/btrfs/ioctl.c       |  8 +++++++-
 fs/btrfs/scrub.c       | 14 +++++++++-----
 fs/btrfs/super.c       |  3 ++-
 fs/btrfs/volumes.c     | 41 ++++++++++++++++++++++++++++++++---------
 fs/btrfs/volumes.h     |  1 +
 7 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f9ceea9..83904b5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3649,7 +3649,7 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 /* scrub.c */
 int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		    u64 end, struct btrfs_scrub_progress *progress,
-		    int readonly);
+		    int readonly, int is_dev_replace);
 void btrfs_scrub_pause(struct btrfs_root *root);
 void btrfs_scrub_pause_super(struct btrfs_root *root);
 void btrfs_scrub_continue(struct btrfs_root *root);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4c94183..f37c0cc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7462,7 +7462,8 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		 * check to make sure we can actually find a chunk with enough
 		 * space to fit our block group in.
 		 */
-		if (device->total_bytes > device->bytes_used + min_free) {
+		if (device->total_bytes > device->bytes_used + min_free &&
+		    !device->is_tgtdev_for_dev_replace) {
 			ret = find_free_dev_extent(device, min_free,
 						   &dev_offset, NULL);
 			if (!ret)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d912c64..1a93c14 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1372,6 +1372,11 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		}
 	}
 
+	if (device->is_tgtdev_for_dev_replace) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
 	old_size = device->total_bytes;
 
 	if (mod < 0) {
@@ -3099,7 +3104,8 @@ static long btrfs_ioctl_scrub(struct btrfs_root *root, void __user *arg)
 		return PTR_ERR(sa);
 
 	ret = btrfs_scrub_dev(root->fs_info, sa->devid, sa->start, sa->end,
-			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY);
+			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY,
+			      0);
 
 	if (copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6cf23f4..460e30b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -116,6 +116,9 @@ struct scrub_ctx {
 	u32			sectorsize;
 	u32			nodesize;
 	u32			leafsize;
+
+	int			is_dev_replace;
+
 	/*
 	 * statistics
 	 */
@@ -284,7 +287,7 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 }
 
 static noinline_for_stack
-struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev)
+struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 {
 	struct scrub_ctx *sctx;
 	int		i;
@@ -296,6 +299,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev)
 	sctx = kzalloc(sizeof(*sctx), GFP_NOFS);
 	if (!sctx)
 		goto nomem;
+	sctx->is_dev_replace = is_dev_replace;
 	sctx->pages_per_bio = pages_per_bio;
 	sctx->curr = -1;
 	sctx->dev_root = dev->dev_root;
@@ -2293,7 +2297,7 @@ static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
 
 int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		    u64 end, struct btrfs_scrub_progress *progress,
-		    int readonly)
+		    int readonly, int is_dev_replace)
 {
 	struct scrub_ctx *sctx;
 	int ret;
@@ -2356,14 +2360,14 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
-	if (!dev || dev->missing) {
+	if (!dev || (dev->missing && !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		scrub_workers_put(fs_info);
 		return -ENODEV;
 	}
 	mutex_lock(&fs_info->scrub_lock);
 
-	if (!dev->in_fs_metadata) {
+	if (!dev->in_fs_metadata || dev->is_tgtdev_for_dev_replace) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		scrub_workers_put(fs_info);
@@ -2376,7 +2380,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		scrub_workers_put(fs_info);
 		return -EINPROGRESS;
 	}
-	sctx = scrub_setup_ctx(dev);
+	sctx = scrub_setup_ctx(dev, is_dev_replace);
 	if (IS_ERR(sctx)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bdf1f5e..789c9b2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1362,7 +1362,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 		min_stripe_size = BTRFS_STRIPE_LEN;
 
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-		if (!device->in_fs_metadata || !device->bdev)
+		if (!device->in_fs_metadata || !device->bdev ||
+		    device->is_tgtdev_for_dev_replace)
 			continue;
 
 		avail_space = device->total_bytes - device->bytes_used;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1827bcd..87051e8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -480,8 +480,9 @@ again:
 	/* This is the initialized path, it is safe to release the devices. */
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
 		if (device->in_fs_metadata) {
-			if (!latest_transid ||
-			    device->generation > latest_transid) {
+			if (!device->is_tgtdev_for_dev_replace &&
+			    (!latest_transid ||
+			     device->generation > latest_transid)) {
 				latest_devid = device->devid;
 				latest_transid = device->generation;
 				latest_bdev = device->bdev;
@@ -796,7 +797,7 @@ int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 
 	*length = 0;
 
-	if (start >= device->total_bytes)
+	if (start >= device->total_bytes || device->is_tgtdev_for_dev_replace)
 		return 0;
 
 	path = btrfs_alloc_path();
@@ -913,7 +914,7 @@ int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	max_hole_size = 0;
 	hole_size = 0;
 
-	if (search_start >= search_end) {
+	if (search_start >= search_end || device->is_tgtdev_for_dev_replace) {
 		ret = -ENOSPC;
 		goto error;
 	}
@@ -1096,6 +1097,7 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 
 	WARN_ON(!device->in_fs_metadata);
+	WARN_ON(device->is_tgtdev_for_dev_replace);
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -1357,7 +1359,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		 * is held.
 		 */
 		list_for_each_entry(tmp, devices, dev_list) {
-			if (tmp->in_fs_metadata && !tmp->bdev) {
+			if (tmp->in_fs_metadata &&
+			    !tmp->is_tgtdev_for_dev_replace &&
+			    !tmp->bdev) {
 				device = tmp;
 				break;
 			}
@@ -1396,6 +1400,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		}
 	}
 
+	if (device->is_tgtdev_for_dev_replace) {
+		pr_err("btrfs: unable to remove the dev_replace target dev\n");
+		ret = -EINVAL;
+		goto error_brelse;
+	}
+
 	if (device->writeable && root->fs_info->fs_devices->rw_devices == 1) {
 		printk(KERN_ERR "btrfs: unable to remove the only writeable "
 		       "device\n");
@@ -1415,6 +1425,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (ret)
 		goto error_undo;
 
+	/*
+	 * TODO: the superblock still includes this device in its num_devices
+	 * counter although write_all_supers() is not locked out. This
+	 * could give a filesystem state which requires a degraded mount.
+	 */
 	ret = btrfs_rm_dev_item(root->fs_info->chunk_root, device);
 	if (ret)
 		goto error_undo;
@@ -1812,6 +1827,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	device->dev_root = root->fs_info->dev_root;
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
+	device->is_tgtdev_for_dev_replace = 0;
 	device->mode = FMODE_EXCL;
 	set_blocksize(device->bdev, 4096);
 
@@ -1975,7 +1991,8 @@ static int __btrfs_grow_device(struct btrfs_trans_handle *trans,
 
 	if (!device->writeable)
 		return -EACCES;
-	if (new_size <= device->total_bytes)
+	if (new_size <= device->total_bytes ||
+	    device->is_tgtdev_for_dev_replace)
 		return -EINVAL;
 
 	btrfs_set_super_total_bytes(super_copy, old_total + diff);
@@ -2604,7 +2621,8 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		size_to_free = div_factor(old_size, 1);
 		size_to_free = min(size_to_free, (u64)1 * 1024 * 1024);
 		if (!device->writeable ||
-		    device->total_bytes - device->bytes_used > size_to_free)
+		    device->total_bytes - device->bytes_used > size_to_free ||
+		    device->is_tgtdev_for_dev_replace)
 			continue;
 
 		ret = btrfs_shrink_device(device, old_size - size_to_free);
@@ -3136,6 +3154,9 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	u64 old_size = device->total_bytes;
 	u64 diff = device->total_bytes - new_size;
 
+	if (device->is_tgtdev_for_dev_replace)
+		return -EINVAL;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -3406,7 +3427,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		if (!device->in_fs_metadata)
+		if (!device->in_fs_metadata ||
+		    device->is_tgtdev_for_dev_replace)
 			continue;
 
 		if (device->total_bytes > device->bytes_used)
@@ -4617,6 +4639,7 @@ static void fill_device_from_item(struct extent_buffer *leaf,
 	device->io_align = btrfs_device_io_align(leaf, dev_item);
 	device->io_width = btrfs_device_io_width(leaf, dev_item);
 	device->sector_size = btrfs_device_sector_size(leaf, dev_item);
+	device->is_tgtdev_for_dev_replace = 0;
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
@@ -4727,7 +4750,7 @@ static int read_one_dev(struct btrfs_root *root,
 	fill_device_from_item(leaf, dev_item, device);
 	device->dev_root = root->fs_info->dev_root;
 	device->in_fs_metadata = 1;
-	if (device->writeable) {
+	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
 		spin_lock(&root->fs_info->free_chunk_lock);
 		root->fs_info->free_chunk_space += device->total_bytes -
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 802e2ba..8fd5a4d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -50,6 +50,7 @@ struct btrfs_device {
 	int in_fs_metadata;
 	int missing;
 	int can_discard;
+	int is_tgtdev_for_dev_replace;
 
 	spinlock_t io_lock;
 
-- 
1.8.0

