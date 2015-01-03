Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16632 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbAEHyr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 02:54:47 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH] btrfs: mount should fail for devices with fsid that don't match
Date: Sun,  4 Jan 2015 00:01:05 +0800
Message-Id: <1420300865-5847-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(For commenting, not for integration yet).

We don't check if all devices that passed through the
mount -o device option are indeed belongs to the same fsid.
For which following mount which should fail is successful as of now.

mkfs.btrfs -f /dev/sda
mkfs.btrfs -f /dev/sdb

mount -o device=/dev/sda /dev/sdb /btrfs

The fix is bit more complicated than to -
check if not seeding and if fsid don't match then fail the mount.
Since we should also fail the mount when the seed device of some
other sprout is provided.

creating seed sprout dependency before the mount event and check
against it during mount is what required, which I have been
trying to avoid for a long time.
(This will also solve the long broken ioctl BTRFS_IOC_DEVICES_READY
for seed-sprout devices).

Any objections / comments ?

Thanks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c   | 20 ++++++++++++++++++++
 fs/btrfs/volumes.c |  5 ++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 17786d7..90d2414 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -773,6 +773,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	char *device_name, *opts, *orig, *p;
 	char *num = NULL;
 	int error = 0;
+	struct btrfs_fs_devices *tmp_fs_devices;
 
 	if (!options)
 		return 0;
@@ -826,8 +827,17 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 				error = -ENOMEM;
 				goto out;
 			}
+			tmp_fs_devices = *fs_devices;
 			error = btrfs_scan_one_device(device_name,
 					flags, holder, fs_devices);
+
+			if (!error && tmp_fs_devices && !tmp_fs_devices->seeding &&
+				!(*fs_devices)->seeding && tmp_fs_devices != (*fs_devices)) {
+				printk(KERN_ERR \
+					"BTRFS: fsid in the provided devices does not match\n");
+				error = -EINVAL;
+			}
+
 			kfree(device_name);
 			if (error)
 				goto out;
@@ -1293,6 +1303,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	char *subvol_name = NULL;
 	u64 subvol_objectid = 0;
 	int error = 0;
+	struct btrfs_fs_devices *tmp_fs_devices = NULL;
 
 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;
@@ -1318,7 +1329,16 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 			return ERR_PTR(error);
 	}
 
+	tmp_fs_devices = fs_devices;
 	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
+	if (!error && tmp_fs_devices && !tmp_fs_devices->seeding &&
+		!fs_devices->seeding && tmp_fs_devices != fs_devices)
+	{
+		printk(KERN_ERR \
+			"BTRFS: mount: fsid in the provided devices does not match\n");
+		error = -EINVAL;
+	}
+
 	if (error)
 		goto error_sec_opts;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fd05382..3bac663 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -564,8 +564,11 @@ static noinline int device_list_add(const char *path,
 	 * it back. We need it to pick the disk with largest generation
 	 * (as above).
 	 */
-	if (!fs_devices->opened)
+	if (!fs_devices->opened) {
 		device->generation = found_transid;
+		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING)
+			fs_devices->seeding = 1;
+	}
 
 	*fs_devices_ret = fs_devices;
 
-- 
2.0.0.153.g79dcccc

