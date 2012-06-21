Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:47694 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab2FUUGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 16:06:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <harald@redhat.com>
Subject: [PATCH] Btrfs: add DEVICE_READY ioctl
Date: Thu, 21 Jun 2012 16:10:30 -0400
Message-ID: <1340309431-9972-2-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1340309431-9972-1-git-send-email-jbacik@fusionio.com>
References: <1340309431-9972-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This will be used in conjunction with btrfs device ready <dev>.  This is
needed for initrd's to have a nice and lightweight way to tell if all of the
devices needed for a file system are in the cache currently.  This keeps
them from having to do mount+sleep loops waiting for devices to show up.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ioctl.h   |    3 ++-
 fs/btrfs/super.c   |    7 +++++++
 fs/btrfs/volumes.c |    9 ++++++++-
 fs/btrfs/volumes.h |    1 +
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 497c530..34317cf 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -363,5 +363,6 @@ struct btrfs_ioctl_get_dev_stats {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_GET_AND_RESET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 					struct btrfs_ioctl_get_dev_stats)
-
+#define BTRFS_IOC_DEVICES_READY _IOW(BTRFS_IOCTL_MAGIC, 54, \
+				     struct btrfs_ioctl_vol_args)
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 23fc7e8..347ccd8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1458,6 +1458,13 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
 		break;
+	case BTRFS_IOC_DEVICES_READY:
+		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
+					    &btrfs_fs_type, &fs_devices);
+		if (ret)
+			break;
+		ret = !(fs_devices->num_devices == fs_devices->total_devices);
+		break;
 	}
 
 	kfree(vol);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3f292cf..a505627 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -429,6 +429,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	mutex_init(&fs_devices->device_list_mutex);
 	fs_devices->latest_devid = orig->latest_devid;
 	fs_devices->latest_trans = orig->latest_trans;
+	fs_devices->total_devices = orig->total_devices;
 	memcpy(fs_devices->fsid, orig->fsid, sizeof(fs_devices->fsid));
 
 	/* We have held the volume lock, it is safe to get the devices. */
@@ -739,6 +740,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	int ret;
 	u64 devid;
 	u64 transid;
+	u64 total_devices;
 
 	flags |= FMODE_EXCL;
 	bdev = blkdev_get_by_path(path, flags, holder);
@@ -760,6 +762,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
+	total_devices = btrfs_super_num_devices(disk_super);
 	if (disk_super->label[0])
 		printk(KERN_INFO "device label %s ", disk_super->label);
 	else
@@ -767,7 +770,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	printk(KERN_CONT "devid %llu transid %llu %s\n",
 	       (unsigned long long)devid, (unsigned long long)transid, path);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
-
+	if (!ret && fs_devices_ret)
+		(*fs_devices_ret)->total_devices = total_devices;
 	brelse(bh);
 error_close:
 	mutex_unlock(&uuid_mutex);
@@ -1433,6 +1437,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	list_del_rcu(&device->dev_list);
 
 	device->fs_devices->num_devices--;
+	device->fs_devices->total_devices--;
 
 	if (device->missing)
 		root->fs_info->fs_devices->missing_devices--;
@@ -1550,6 +1555,7 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
+	fs_devices->total_devices = 0;
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);
@@ -1749,6 +1755,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	root->fs_info->fs_devices->num_devices++;
 	root->fs_info->fs_devices->open_devices++;
 	root->fs_info->fs_devices->rw_devices++;
+	root->fs_info->fs_devices->total_devices++;
 	if (device->can_discard)
 		root->fs_info->fs_devices->num_can_discard++;
 	root->fs_info->fs_devices->total_rw_bytes += device->total_bytes;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 74366f2..a3c5d5c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -126,6 +126,7 @@ struct btrfs_fs_devices {
 	u64 missing_devices;
 	u64 total_rw_bytes;
 	u64 num_can_discard;
+	u64 total_devices;
 	struct block_device *latest_bdev;
 
 	/* all of the devices in the FS, protected by a mutex
-- 
1.7.7.6

