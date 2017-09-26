Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46630 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966941AbdIZHlE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 03:41:04 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/3] btrfs: cleanup btrfs_init_new_device()
Date: Tue, 26 Sep 2017 15:48:42 +0800
Message-Id: <20170926074843.31910-3-anand.jain@oracle.com>
In-Reply-To: <20170926074843.31910-1-anand.jain@oracle.com>
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170926074843.31910-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Moves btrfs_abort_transaction() to the error goto and renames
error_trans to error_sysfs. This is a preparatory patch to
remove the BUG_ON() in btrfs_init_new_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9d64700cc9b6..22eb81794375 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2445,14 +2445,14 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		mutex_unlock(&fs_info->chunk_mutex);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
-			goto error_trans;
+			goto error_sysfs;
 		}
 	}
 
 	ret = btrfs_add_device(trans, fs_info, device);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto error_trans;
+		goto error_sysfs;
 	}
 
 	if (seeding_dev) {
@@ -2461,7 +2461,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		ret = btrfs_finish_sprout(trans, fs_info);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
-			goto error_trans;
+			goto error_sysfs;
 		}
 
 		/* Sprouting would change fsid of the mounted root,
@@ -2500,12 +2500,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	update_dev_time(device_path);
 	return ret;
 
-error_trans:
+error_sysfs:
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 	if (seeding_dev)
 		sb->s_flags |= MS_RDONLY;
 	btrfs_end_transaction(trans);
 	rcu_string_free(device->name);
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.13.1

