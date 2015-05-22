Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41269 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbbEVPeD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 11:34:03 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v5.1 24/27] Btrfs: free the stale device
Date: Fri, 22 May 2015 23:33:48 +0800
Message-Id: <1432308828-31185-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1426845702-6298-25-git-send-email-anand.jain@oracle.com>
References: <1426845702-6298-25-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the btrfs on a device is overwritten with a new btrfs (mkfs),
the old btrfs instance in the kernel becomes stale. So with this
patch if kernel finds device is overwritten, then delete the stale
fsid/uuid.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
V5->V5.1: since this deals with only devices in unmounted state, don't
try to remove device link

 fs/btrfs/volumes.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 747241f..eb57331 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -445,6 +445,55 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+void btrfs_free_stale_device(struct btrfs_device *cur_dev)
+{
+	int del = 0;
+	struct btrfs_fs_devices *fs_devs;
+	struct btrfs_device *dev;
+
+	if (!rcu_str_deref(cur_dev->name))
+		return;
+	list_for_each_entry(fs_devs, &fs_uuids, list) {
+		if (fs_devs->opened)
+			continue;
+		if (fs_devs->seeding)
+			continue;
+		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+			if (dev == cur_dev)
+				continue;
+
+			/*
+			 * Todo: This won't be enough. What if same device
+			 * comes back with new uuid and with its mapper path?
+			 * But for now, this does helps as mostly an admin will
+			 * use either mapper or non mapper path throughout.
+			 */
+			if (!rcu_str_deref(dev->name))
+				continue;
+			if (!strcmp(rcu_str_deref(dev->name),
+						rcu_str_deref(cur_dev->name))) {
+				del = 1;
+				break;
+			}
+		}
+		if (del) {
+			/* delete the stale */
+			if (fs_devs->num_devices == 1) {
+				btrfs_sysfs_remove_fsid(fs_devs);
+				list_del(&fs_devs->list);
+				free_fs_devices(fs_devs);
+			} else {
+				fs_devs->num_devices--;
+				list_del(&dev->dev_list);
+				rcu_string_free(dev->name);
+				kfree(dev);
+			}
+			break;
+		}
+	}
+	return;
+}
+
 /*
  * Add new device to list of registered devices
  *
@@ -560,6 +609,8 @@ static noinline int device_list_add(const char *path,
 	if (!fs_devices->opened)
 		device->generation = found_transid;
 
+	btrfs_free_stale_device(device);
+
 	*fs_devices_ret = fs_devices;
 
 	return ret;
-- 
2.0.0.257.g75cc6c6

