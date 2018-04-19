Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55329 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753948AbeDSQgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:36:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B4697AC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:36:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 10/16] btrfs: remove wrong use of volume_mutex from btrfs_dev_replace_start
Date: Thu, 19 Apr 2018 18:33:32 +0200
Message-Id: <680085048b4eb0a14981ab0e2a4f3b76665e0d02.1524146556.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The volume mutex does not protect against anything in this case, the
comment about scrub is right but not related to locking and looks
confusing. The comment in btrfs_find_device_missing_or_by_path is wrong
and confusing too.

The device_list_mutex is not held here to protect device lookup, but in
this case device replace cannot run in parallel with device removal (due
to exclusive op protection), so we don't need further locking here.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 7 +------
 fs/btrfs/volumes.c     | 4 ----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 346bd460f8e7..ba011af9b0d2 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -426,18 +426,13 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	struct btrfs_device *tgt_device = NULL;
 	struct btrfs_device *src_device = NULL;
 
-	/* the disk copy procedure reuses the scrub code */
-	mutex_lock(&fs_info->volume_mutex);
 	ret = btrfs_find_device_by_devspec(fs_info, srcdevid,
 					    srcdev_name, &src_device);
-	if (ret) {
-		mutex_unlock(&fs_info->volume_mutex);
+	if (ret)
 		return ret;
-	}
 
 	ret = btrfs_init_dev_replace_tgtdev(fs_info, tgtdev_name,
 					    src_device, &tgt_device);
-	mutex_unlock(&fs_info->volume_mutex);
 	if (ret)
 		return ret;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3b8085b5655d..8a5b022e9cde 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2198,10 +2198,6 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
 		struct btrfs_device *tmp;
 
 		devices = &fs_info->fs_devices->devices;
-		/*
-		 * It is safe to read the devices since the volume_mutex
-		 * is held by the caller.
-		 */
 		list_for_each_entry(tmp, devices, dev_list) {
 			if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
 					&tmp->dev_state) && !tmp->bdev) {
-- 
2.16.2

