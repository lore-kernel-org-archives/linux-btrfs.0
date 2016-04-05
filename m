Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:28946 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbcDEAKM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 20:10:12 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 911DAAC0272
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Apr 2016 09:10:06 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3050.s.css.fujitsu.com (Postfix) with SMTP id 7FCF2F3
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Apr 2016 09:10:06 +0900 (JST)
Message-Id: <201604050008.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 05 Apr 2016 09:08:47 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix missing s_id setting
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When fs_devices->latest_bdev is deleted or is replaced, sb->s_id has
not been updated.
As a result, the deleted device name is displayed by btrfs_printk.

[before fix]
 # btrfs dev del /dev/sdc4 /mnt2
 # btrfs dev add /dev/sdb6 /mnt2

 [  217.458249] BTRFS info (device sdc4): found 1 extents
 [  217.695798] BTRFS info (device sdc4): disk deleted /dev/sdc4
 [  217.941284] BTRFS info (device sdc4): disk added /dev/sdb6

[after fix]
 # btrfs dev del /dev/sdc4 /mnt2
 # btrfs dev add /dev/sdb6 /mnt2

 [   83.835072] BTRFS info (device sdc4): found 1 extents
 [   84.080617] BTRFS info (device sdc3): disk deleted /dev/sdc4
 [   84.401951] BTRFS info (device sdc3): disk added /dev/sdb6

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/dev-replace.c |  5 ++++-
 fs/btrfs/volumes.c     | 11 +++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index a1d6652..11c4198 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -560,8 +560,11 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	tgt_device->commit_bytes_used = src_device->bytes_used;
 	if (fs_info->sb->s_bdev == src_device->bdev)
 		fs_info->sb->s_bdev = tgt_device->bdev;
-	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
+	if (fs_info->fs_devices->latest_bdev == src_device->bdev) {
 		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
+		snprintf(fs_info->sb->s_id, sizeof(fs_info->sb->s_id), "%pg",
+			 tgt_device->bdev);
+	}
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 	fs_info->fs_devices->rw_devices++;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e2b54d5..a471385 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1846,8 +1846,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 				 struct btrfs_device, dev_list);
 	if (device->bdev == root->fs_info->sb->s_bdev)
 		root->fs_info->sb->s_bdev = next_device->bdev;
-	if (device->bdev == root->fs_info->fs_devices->latest_bdev)
+	if (device->bdev == root->fs_info->fs_devices->latest_bdev) {
 		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
+		snprintf(root->fs_info->sb->s_id,
+			 sizeof(root->fs_info->sb->s_id), "%pg",
+			 next_device->bdev);
+	}
 
 	if (device->bdev) {
 		device->fs_devices->open_devices--;
@@ -2034,8 +2038,11 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				 struct btrfs_device, dev_list);
 	if (tgtdev->bdev == fs_info->sb->s_bdev)
 		fs_info->sb->s_bdev = next_device->bdev;
-	if (tgtdev->bdev == fs_info->fs_devices->latest_bdev)
+	if (tgtdev->bdev == fs_info->fs_devices->latest_bdev) {
 		fs_info->fs_devices->latest_bdev = next_device->bdev;
+		snprintf(fs_info->sb->s_id, sizeof(fs_info->sb->s_id), "%pg",
+			 next_device->bdev);
+	}
 	list_del_rcu(&tgtdev->dev_list);
 
 	call_rcu(&tgtdev->rcu, free_device);
-- 
2.6.4


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
