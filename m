Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49920 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387881AbeGTR1A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:27:00 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F270BAD5A
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 16:37:55 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/7] btrfs: Remove fs_info from btrfs_rm_dev_replace_remove_srcdev
Date: Fri, 20 Jul 2018 19:37:48 +0300
Message-Id: <1532104673-28311-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed srcdev argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/volumes.c     | 5 ++---
 fs/btrfs/volumes.h     | 3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 059ca3d5ddd3..df375e1a0c9f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -667,7 +667,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	btrfs_rm_dev_replace_blocked(fs_info);
 
-	btrfs_rm_dev_replace_remove_srcdev(fs_info, src_device);
+	btrfs_rm_dev_replace_remove_srcdev(src_device);
 
 	btrfs_rm_dev_replace_unblocked(fs_info);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e73b9e9d6c10..844e5d4fd3e4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1988,12 +1988,11 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	goto out;
 }
 
-void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
-					struct btrfs_device *srcdev)
+void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev)
 {
 	struct btrfs_fs_devices *fs_devices;
 
-	lockdep_assert_held(&fs_info->fs_devices->device_list_mutex);
+	lockdep_assert_held(&srcdev->fs_info->fs_devices->device_list_mutex);
 
 	/*
 	 * in case of fs with no seed, srcdev->fs_devices will point
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6943aab9bdd7..0ae45ff1961b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -452,8 +452,7 @@ void btrfs_init_devices_late(struct btrfs_fs_info *fs_info);
 int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
-void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
-					struct btrfs_device *srcdev);
+void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);
 void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *srcdev);
 void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
-- 
2.7.4

