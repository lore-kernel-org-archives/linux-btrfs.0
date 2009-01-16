From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Subject: [PATCH] Btrfs: simplify iteration codes
Date: Fri, 16 Jan 2009 15:25:54 +0800
Message-ID: <49703687.044e6e0a.04fa.257b@mx.google.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

merge list_for_each and list_entry to list_for_each_entry.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b187b53..70f0248 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -104,10 +104,8 @@ static noinline struct btrfs_device *__find_device(struct list_head *head,
 						   u64 devid, u8 *uuid)
 {
 	struct btrfs_device *dev;
-	struct list_head *cur;
 
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (dev->devid == devid &&
 		    (!uuid || !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE))) {
 			return dev;
@@ -118,11 +116,9 @@ static noinline struct btrfs_device *__find_device(struct list_head *head,
 
 static noinline struct btrfs_fs_devices *find_fsid(u8 *fsid)
 {
-	struct list_head *cur;
 	struct btrfs_fs_devices *fs_devices;
 
-	list_for_each(cur, &fs_uuids) {
-		fs_devices = list_entry(cur, struct btrfs_fs_devices, list);
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
 		if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0)
 			return fs_devices;
 	}

