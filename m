From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: corret fmode_t annotations
Date: Thu, 20 Nov 2008 20:02:07 +0100
Message-ID: <20081120190206.GA21389@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Make sure to propagate fmode_t properly and use the right constants for
it.  Note that the actual constants don't seem to be quite correct as
we can write to various devices opened FMODE_READ.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/fs/btrfs/super.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/super.c	2008-11-20 19:53:40.000000000 +0100
+++ btrfs-unstable/fs/btrfs/super.c	2008-11-20 20:00:21.000000000 +0100
@@ -240,7 +240,7 @@ int btrfs_parse_options(struct btrfs_roo
  * All other options will be parsed on much later in the mount process and
  * only when we need to allocate a new super block.
  */
-static int btrfs_parse_early_options(const char *options, int flags,
+static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		void *holder, char **subvol_name,
 		struct btrfs_fs_devices **fs_devices)
 {
@@ -416,18 +416,22 @@ static int btrfs_get_sb(struct file_syst
 	struct super_block *s;
 	struct dentry *root;
 	struct btrfs_fs_devices *fs_devices = NULL;
+	fmode_t mode = FMODE_READ;
 	int error = 0;
 
-	error = btrfs_parse_early_options(data, flags, fs_type,
+	if (!(flags & MS_RDONLY))
+		mode |= FMODE_WRITE;
+
+	error = btrfs_parse_early_options(data, mode, fs_type,
 					  &subvol_name, &fs_devices);
 	if (error)
 		goto error;
 
-	error = btrfs_scan_one_device(dev_name, flags, fs_type, &fs_devices);
+	error = btrfs_scan_one_device(dev_name, mode, fs_type, &fs_devices);
 	if (error)
 		goto error_free_subvol_name;
 
-	error = btrfs_open_devices(fs_devices, flags, fs_type);
+	error = btrfs_open_devices(fs_devices, mode, fs_type);
 	if (error)
 		goto error_free_subvol_name;
 
@@ -589,7 +593,7 @@ static long btrfs_control_ioctl(struct f
 	len = strnlen(vol->name, BTRFS_PATH_NAME_MAX);
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
-		ret = btrfs_scan_one_device(vol->name, MS_RDONLY,
+		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
 		break;
 	}
Index: btrfs-unstable/fs/btrfs/volumes.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/volumes.c	2008-11-20 19:51:20.000000000 +0100
+++ btrfs-unstable/fs/btrfs/volumes.c	2008-11-20 19:57:22.000000000 +0100
@@ -392,7 +392,7 @@ int btrfs_close_devices(struct btrfs_fs_
 }
 
 int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
-			 int flags, void *holder)
+			 fmode_t flags, void *holder)
 {
 	struct block_device *bdev;
 	struct list_head *head = &fs_devices->devices;
@@ -467,7 +467,7 @@ int __btrfs_open_devices(struct btrfs_fs
 error_brelse:
 		brelse(bh);
 error_close:
-		close_bdev_exclusive(bdev, MS_RDONLY);
+		close_bdev_exclusive(bdev, FMODE_READ);
 error:
 		continue;
 	}
@@ -486,7 +486,7 @@ out:
 }
 
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
-		       int flags, void *holder)
+		       fmode_t flags, void *holder)
 {
 	int ret;
 
@@ -505,7 +505,7 @@ int btrfs_open_devices(struct btrfs_fs_d
 	return ret;
 }
 
-int btrfs_scan_one_device(const char *path, int flags, void *holder,
+int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret)
 {
 	struct btrfs_super_block *disk_super;
@@ -1006,7 +1006,7 @@ int btrfs_rm_device(struct btrfs_root *r
 			goto out;
 		}
 	} else {
-		bdev = open_bdev_exclusive(device_path, MS_RDONLY,
+		bdev = open_bdev_exclusive(device_path, FMODE_READ,
 				      root->fs_info->bdev_holder);
 		if (IS_ERR(bdev)) {
 			ret = PTR_ERR(bdev);
@@ -1076,7 +1076,7 @@ int btrfs_rm_device(struct btrfs_root *r
 		BUG_ON(device->writeable);
 		brelse(bh);
 		if (bdev)
-			close_bdev_exclusive(bdev, MS_RDONLY);
+			close_bdev_exclusive(bdev, FMODE_READ);
 
 		if (device->bdev) {
 			close_bdev_exclusive(device->bdev, device->mode);
@@ -1119,7 +1119,7 @@ int btrfs_rm_device(struct btrfs_root *r
 	}
 	if (bdev) {
 		/* one close for us */
-		close_bdev_exclusive(bdev, MS_RDONLY);
+		close_bdev_exclusive(bdev, FMODE_READ);
 	}
 	kfree(device->name);
 	kfree(device);
@@ -1130,7 +1130,7 @@ error_brelse:
 	brelse(bh);
 error_close:
 	if (bdev)
-		close_bdev_exclusive(bdev, MS_RDONLY);
+		close_bdev_exclusive(bdev, FMODE_READ);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
 	mutex_unlock(&uuid_mutex);
@@ -2911,7 +2911,7 @@ static int open_seed_devices(struct btrf
 		goto out;
 	}
 
-	ret = __btrfs_open_devices(fs_devices, MS_RDONLY,
+	ret = __btrfs_open_devices(fs_devices, FMODE_READ,
 				   root->fs_info->bdev_holder);
 	if (ret)
 		goto out;
Index: btrfs-unstable/fs/btrfs/volumes.h
===================================================================
--- btrfs-unstable.orig/fs/btrfs/volumes.h	2008-11-20 19:54:08.000000000 +0100
+++ btrfs-unstable/fs/btrfs/volumes.h	2008-11-20 19:57:29.000000000 +0100
@@ -135,8 +135,8 @@ int btrfs_map_bio(struct btrfs_root *roo
 		  int mirror_num, int async_submit);
 int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
-		       int flags, void *holder);
-int btrfs_scan_one_device(const char *path, int flags, void *holder,
+		       fmode_t flags, void *holder);
+int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
