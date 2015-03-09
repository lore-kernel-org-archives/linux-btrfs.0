Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20362 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbbCIRK5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:10:57 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 23/26] Btrfs: free the stale device
Date: Tue, 10 Mar 2015 06:38:41 +0800
Message-Id: <1425940724-7744-24-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 58232bc..452abb3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -446,6 +446,55 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+
+void btrfs_free_stale_device(struct btrfs_device *cur_dev)
+{
+	int del = 0;
+	struct btrfs_fs_devices *fs_devs;
+	struct btrfs_device *dev;
+
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
+
+			if (!strcmp(rcu_str_deref(dev->name),
+						rcu_str_deref(cur_dev->name))) {
+				del = 1;
+				break;
+			}
+		}
+		if (del) {
+			/* delete the stale */
+			if (fs_devs->num_devices == 1) {
+				btrfs_kobj_rm_device(fs_devs, dev);
+				btrfs_sysfs_remove_fsid(fs_devs);
+				list_del(&fs_devs->list);
+				free_fs_devices(fs_devs);
+			} else {
+				fs_devs->num_devices--;
+				btrfs_kobj_rm_device(fs_devs, dev);
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
@@ -561,6 +610,8 @@ static noinline int device_list_add(const char *path,
 	if (!fs_devices->opened)
 		device->generation = found_transid;
 
+	btrfs_free_stale_device(device);
+
 	*fs_devices_ret = fs_devices;
 
 	return ret;
-- 
2.0.0.153.g79dcccc

