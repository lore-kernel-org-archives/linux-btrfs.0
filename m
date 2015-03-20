Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36401 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbbCTKEK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:10 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 04/27] Btrfs: sysfs: fix, undo sysfs device links
Date: Fri, 20 Mar 2015 18:01:19 +0800
Message-Id: <1426845702-6298-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

Theoritically need to remove the device links attributes, but since its entire device
kobject was removed, so there wasn't any issue of about it. Just do it nicely.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 68dcd17..adfac3e 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -522,6 +522,7 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 		kobject_del(fs_info->space_info_kobj);
 		kobject_put(fs_info->space_info_kobj);
 	}
+	btrfs_kobj_rm_device(fs_info, NULL);
 	kobject_del(fs_info->device_dir_kobj);
 	kobject_put(fs_info->device_dir_kobj);
 	addrm_unknown_feature_attrs(fs_info, false);
@@ -604,6 +605,8 @@ static void init_feature_attrs(void)
 	}
 }
 
+/* when one_device is NULL, it removes all device links */
+
 int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
 		struct btrfs_device *one_device)
 {
@@ -621,6 +624,20 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
 						disk_kobj->name);
 	}
 
+	if (one_device)
+		return 0;
+
+	list_for_each_entry(one_device,
+			&fs_info->fs_devices->devices, dev_list) {
+		if (!one_device->bdev)
+			continue;
+		disk = one_device->bdev->bd_part;
+		disk_kobj = &part_to_dev(disk)->kobj;
+
+		sysfs_remove_link(fs_info->device_dir_kobj,
+						disk_kobj->name);
+	}
+
 	return 0;
 }
 
-- 
2.0.0.153.g79dcccc

