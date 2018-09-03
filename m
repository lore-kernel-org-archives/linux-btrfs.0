Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727250AbeICOFl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 10:05:41 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD299AF4C
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Sep 2018 09:46:18 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Make btrfs_find_device_missing_or_by_path return directly a device
Date: Mon,  3 Sep 2018 12:46:13 +0300
Message-Id: <20180903094614.2667-3-nborisov@suse.com>
In-Reply-To: <20180903094614.2667-1-nborisov@suse.com>
References: <20180903094614.2667-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function returns a numeric error value and additionally the
device found in one of its input parameters. Simplify this by making
the function directly return a pointer to btrfs_device. Additionally
adjust the caller to handle the case when we want to remove the
'missing' device and ENOENT is returned to return the expected
positive error value, parsed by progs. Finally, unexport the function
since it's not called outside of volume.c. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 33 ++++++++++++++++++---------------
 fs/btrfs/volumes.h |  3 ---
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 715ea45c6c28..6202aa15d0d7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2123,11 +2123,11 @@ btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
 	return device;
 }
 
-int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
-					 const char *device_path,
-					 struct btrfs_device **device)
+static struct btrfs_device *
+btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
+				     const char *device_path)
 {
-	*device = NULL;
+	struct btrfs_device *device = NULL;
 	if (strcmp(device_path, "missing") == 0) {
 		struct list_head *devices;
 		struct btrfs_device *tmp;
@@ -2136,20 +2136,18 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
 		list_for_each_entry(tmp, devices, dev_list) {
 			if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
 					&tmp->dev_state) && !tmp->bdev) {
-				*device = tmp;
+				device = tmp;
 				break;
 			}
 		}
 
-		if (!*device)
-			return BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
+		if (!device)
+			return ERR_PTR(-ENOENT);
 	} else {
-		*device = btrfs_find_device_by_path(fs_info, device_path);
-		if (IS_ERR(*device))
-			return PTR_ERR(*device);
+		device = btrfs_find_device_by_path(fs_info, device_path);
 	}
 
-	return 0;
+	return device;
 }
 
 /*
@@ -2159,10 +2157,9 @@ int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
 				 const char *devpath,
 				 struct btrfs_device **device)
 {
-	int ret;
+	int ret = 0;
 
 	if (devid) {
-		ret = 0;
 		*device = btrfs_find_device(fs_info, devid, NULL, NULL);
 		if (!*device)
 			ret = -ENOENT;
@@ -2170,8 +2167,14 @@ int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
 		if (!devpath || !devpath[0])
 			return -EINVAL;
 
-		ret = btrfs_find_device_missing_or_by_path(fs_info, devpath,
-							   device);
+		*device = btrfs_find_device_missing_or_by_path(fs_info, devpath);
+		if (IS_ERR(*device)) {
+			if (PTR_ERR(*device) == -ENOENT &&
+			    strcmp(devpath, "missing") == 0)
+				ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
+			else
+				ret = PTR_ERR(*device);
+		}
 	}
 	return ret;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 23e9285d88de..e7811473024d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -410,9 +410,6 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_device *device,
 				     struct btrfs_device *this_dev);
-int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
-					 const char *device_path,
-					 struct btrfs_device **device);
 int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
 					 const char *devpath,
 					 struct btrfs_device **device);
-- 
2.17.1
