Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733128AbeGTR1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:27:01 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8B218AD71
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 16:37:56 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/7] btrfs: Remove fs_info from btrfs_assign_next_active_device
Date: Fri, 20 Jul 2018 19:37:50 +0300
Message-Id: <1532104673-28311-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed 'device' argument which is always
a well-formed device.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/volumes.c     | 9 +++++----
 fs/btrfs/volumes.h     | 4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index df375e1a0c9f..dd17a4d7bea2 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -658,7 +658,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	tgt_device->commit_total_bytes = src_device->commit_total_bytes;
 	tgt_device->commit_bytes_used = src_device->bytes_used;
 
-	btrfs_assign_next_active_device(fs_info, src_device, tgt_device);
+	btrfs_assign_next_active_device(src_device, tgt_device);
 
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 	fs_info->fs_devices->rw_devices++;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 35cc5b6a06e0..99e126a0edcb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1818,9 +1818,10 @@ static struct btrfs_device * btrfs_find_next_active_device(
  * where this function called, there should be always be another device (or
  * this_dev) which is active.
  */
-void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
-		struct btrfs_device *device, struct btrfs_device *this_dev)
+void btrfs_assign_next_active_device(struct btrfs_device *device,
+				     struct btrfs_device *this_dev)
 {
+	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_device *next_device;
 
 	if (this_dev)
@@ -1936,7 +1937,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		cur_devices->missing_devices--;
 
-	btrfs_assign_next_active_device(fs_info, device, NULL);
+	btrfs_assign_next_active_device(device, NULL);
 
 	if (device->bdev) {
 		cur_devices->open_devices--;
@@ -2069,7 +2070,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 
 	fs_devices->num_devices--;
 
-	btrfs_assign_next_active_device(fs_info, tgtdev, NULL);
+	btrfs_assign_next_active_device(tgtdev, NULL);
 
 	list_del_rcu(&tgtdev->dev_list);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0ae45ff1961b..1bcf0f34e8dc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -407,8 +407,8 @@ struct btrfs_device *btrfs_scan_one_device(const char *path,
 					   fmode_t flags, void *holder);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
-void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
-		struct btrfs_device *device, struct btrfs_device *this_dev);
+void btrfs_assign_next_active_device(struct btrfs_device *device,
+				     struct btrfs_device *this_dev);
 int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
 					 const char *device_path,
 					 struct btrfs_device **device);
-- 
2.7.4

