Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbbD3JHg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 05:07:36 -0400
From: xuw2015@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: George Wang <xuw2015@gmail.com>
Subject: [PATCH 2/3] btrfs: support to find missing device by path
Date: Thu, 30 Apr 2015 17:07:24 +0800
Message-Id: <1430384845-9666-2-git-send-email-xuw2015@gmail.com>
In-Reply-To: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
References: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: George Wang <xuw2015@gmail.com>

First try to find the device matches specified device path, if nothing, then
find the device by (devid, dev_uuid). This can fix the regression for
replacing an offline device which path is held in btrfs_device.

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/btrfs/volumes.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8bcd2a0..c8ece13 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1888,8 +1888,37 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&uuid_mutex);
 }
 
-static int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
-				     struct btrfs_device **device)
+
+/*
+ * Find specified device in fs_devices, caller must hold volume_mutex.
+ * Use @device_path as the key, do not check the devid and dev_uuid. Depends
+ * on usage, the caller may do more checking for ret device.
+ */
+static int __fast_find_device_by_path(struct btrfs_root *root, char *device_path,
+                                       struct btrfs_device **device)
+{
+	struct list_head *devices;
+	struct btrfs_device *tmp;
+	char *name;
+
+	devices = &root->fs_info->fs_devices->devices;
+
+	list_for_each_entry(tmp, devices, dev_list) {
+		name = rcu_str_deref(tmp->name);
+		if (tmp && 0 == strcmp(name, device_path)) {
+			*device = tmp;
+			return 0;
+		}
+	}
+
+       return -ENOENT;
+}
+
+/*
+ * Real read (devid, dev_uuid) from device, then find it in fs_devices
+ */
+static int __slow_find_device_by_path(struct btrfs_root *root, char *device_path,
+				struct btrfs_device **device)
 {
 	int ret = 0;
 	struct btrfs_super_block *disk_super;
@@ -1915,6 +1944,19 @@ static int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
 	return ret;
 }
 
+ 
+static int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
+			struct btrfs_device **device)
+{
+	int ret;
+
+	ret = __fast_find_device_by_path(root, device_path, device);
+	if (ret)
+		ret = __slow_find_device_by_path(root, device_path, device);
+
+	return ret;
+}
+
 int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 					 char *device_path,
 					 struct btrfs_device **device)
-- 
1.9.3

