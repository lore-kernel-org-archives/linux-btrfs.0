Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36112 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbcCKAEs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 19:04:48 -0500
Received: by mail-pf0-f181.google.com with SMTP id u190so51110263pfb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 16:04:48 -0800 (PST)
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Cc: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Subject: [PATCH] btrfs-progs: Dont' stop scanning of devices at first failed device
Date: Thu, 10 Mar 2016 16:04:35 -0800
Message-Id: <1457654675-14084-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When 'btrfs device scan' command is invoked, it scans all devices,
check them for btrfs superblock and add devices with btrfs to a list.

Next, each device from the list is passed to kernel where it is handled
in the btrfs_scan_one_device() function. This function can, for example,
return -EBUSY when device contains superblock matched to existing and
mounted filesystem (if this device was pulled out from RAID and
connected again after some time).

btrfs tool stops device scan if any device has been failed to add, so
other existing devices with (possibly) valid FS will never be reached.

Fix this by remove stopping at any failure in the btrfs_register_all_devices(),
just return error count. btrfs_scan_one_device() reports any kind of
error already.

Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
 cmds-device.c |  2 +-
 utils.c       | 15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 94ffdc5..ec871d2 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -278,7 +278,7 @@ static int cmd_device_scan(int argc, char **argv)
 		ret = btrfs_scan_lblkid();
 		error_on(ret, "error %d while scanning", ret);
 		ret = btrfs_register_all_devices();
-		error_on(ret, "error %d while registering devices", ret);
+		error_on(ret, "there are %d errors while registering devices", ret);
 		goto out;
 	}
 
diff --git a/utils.c b/utils.c
index eabc36d..a5dcfbe 100644
--- a/utils.c
+++ b/utils.c
@@ -1545,7 +1545,7 @@ int btrfs_register_one_device(const char *fname)
  */
 int btrfs_register_all_devices(void)
 {
-	int err;
+	int err, ret = 0;
 	struct btrfs_fs_devices *fs_devices;
 	struct btrfs_device *device;
 	struct list_head *all_uuids;
@@ -1554,16 +1554,15 @@ int btrfs_register_all_devices(void)
 
 	list_for_each_entry(fs_devices, all_uuids, list) {
 		list_for_each_entry(device, &fs_devices->devices, dev_list) {
-			if (*device->name) {
+			if (*device->name)
 				err = btrfs_register_one_device(device->name);
-				if (err < 0)
-					return err;
-				if (err > 0)
-					return -err;
-			}
+
+			if (err)
+				ret++;
 		}
 	}
-	return 0;
+
+	return ret;
 }
 
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
-- 
2.5.0

