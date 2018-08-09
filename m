Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f177.google.com ([209.85.210.177]:34879 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbeHIUhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:22 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 05/12] btrfs-progs: load and check zone information
Date: Fri, 10 Aug 2018 03:10:58 +0900
Message-Id: <20180809181105.12856-5-naota@elisp.net>
In-Reply-To: <20180809181105.12856-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809181105.12856-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch checks if a device added to btrfs is a zoned block device. If it
is, load zones information and the zone size for the device.

For a btrfs volume composed of multiple zoned block devices, all devices
must have the same zone size.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 utils.c   | 10 ++++++++++
 volumes.c | 18 ++++++++++++++++++
 volumes.h |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/utils.c b/utils.c
index 71fc044a..a2172a82 100644
--- a/utils.c
+++ b/utils.c
@@ -250,6 +250,16 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	ret = btrfs_get_zone_info(fd, path, fs_info->fs_devices->hmzoned,
+				  &device->zinfo);
+	if (ret)
+		goto out;
+	if (device->zinfo.zone_size != fs_info->fs_devices->zone_size) {
+		error("Device zone size differ\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	disk_super = (struct btrfs_super_block *)buf;
 	dev_item = &disk_super->dev_item;
 
diff --git a/volumes.c b/volumes.c
index d81b348e..2ec27cd7 100644
--- a/volumes.c
+++ b/volumes.c
@@ -160,6 +160,8 @@ static int device_list_add(const char *path,
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
 	u64 found_transid = btrfs_super_generation(disk_super);
+	int hmzoned = btrfs_super_incompat_flags(disk_super) &
+			BTRFS_FEATURE_INCOMPAT_HMZONED;
 
 	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
@@ -237,6 +239,8 @@ static int device_list_add(const char *path,
 	if (fs_devices->lowest_devid > devid) {
 		fs_devices->lowest_devid = devid;
 	}
+	if (hmzoned)
+		fs_devices->hmzoned = 1;
 	*fs_devices_ret = fs_devices;
 	return 0;
 }
@@ -307,6 +311,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 	struct btrfs_device *device;
 	int ret;
 
+	fs_devices->zone_size = 0;
+
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (!device->name) {
 			printk("no name for device %llu, skip it now\n", device->devid);
@@ -330,6 +336,18 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 		device->fd = fd;
 		if (flags & O_RDWR)
 			device->writeable = 1;
+
+		ret = btrfs_get_zone_info(fd, device->name, fs_devices->hmzoned,
+					  &device->zinfo);
+		if (ret != 0)
+			goto fail;
+		if (!fs_devices->zone_size) {
+			fs_devices->zone_size = device->zinfo.zone_size;
+		} else if (device->zinfo.zone_size != fs_devices->zone_size) {
+			fprintf(stderr, "Device zone size differ\n");
+			ret = -EINVAL;
+			goto fail;
+		}
 	}
 	return 0;
 fail:
diff --git a/volumes.h b/volumes.h
index bad688e5..36a6f44b 100644
--- a/volumes.h
+++ b/volumes.h
@@ -111,6 +111,9 @@ struct btrfs_fs_devices {
 
 	int seeding;
 	struct btrfs_fs_devices *seed;
+
+	u64 zone_size;
+	unsigned int hmzoned:1;
 };
 
 struct btrfs_bio_stripe {
-- 
2.18.0

