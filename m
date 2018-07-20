Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387909AbeGTR1C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:27:02 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CDD08AD87
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 16:37:56 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/7] btrfs: Remove fs_info from btrfs_destroy_dev_replace_tgtdev
Date: Fri, 20 Jul 2018 19:37:51 +0300
Message-Id: <1532104673-28311-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always passed a well-formed tgtdevice so the fs_info
can be referenced from there.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/dev-replace.c | 6 +++---
 fs/btrfs/volumes.c     | 5 ++---
 fs/btrfs/volumes.h     | 3 +--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dd17a4d7bea2..5a72f9933e58 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -506,7 +506,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->srcdev = NULL;
 	dev_replace->tgtdev = NULL;
 	btrfs_dev_replace_write_unlock(dev_replace);
-	btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
+	btrfs_destroy_dev_replace_tgtdev(tgt_device);
 	return ret;
 }
 
@@ -632,7 +632,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		btrfs_rm_dev_replace_blocked(fs_info);
 		if (tgt_device)
-			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
+			btrfs_destroy_dev_replace_tgtdev(tgt_device);
 		btrfs_rm_dev_replace_unblocked(fs_info);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
@@ -821,7 +821,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		btrfs_dev_name(tgt_device));
 
 	if (tgt_device)
-		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
+		btrfs_destroy_dev_replace_tgtdev(tgt_device);
 
 leave:
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 99e126a0edcb..241875277a7e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2055,10 +2055,9 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 	}
 }
 
-void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
-				      struct btrfs_device *tgtdev)
+void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 {
-	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_fs_devices *fs_devices = tgtdev->fs_info->fs_devices;
 
 	WARN_ON(!tgtdev);
 	mutex_lock(&fs_devices->device_list_mutex);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1bcf0f34e8dc..69a028058c43 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -455,8 +455,7 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);
 void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *srcdev);
-void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
-				      struct btrfs_device *tgtdev);
+void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev);
 void btrfs_scratch_superblocks(struct block_device *bdev, const char *device_path);
 int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
 			   u64 logical, u64 len);
-- 
2.7.4

