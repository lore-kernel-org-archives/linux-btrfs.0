Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38525 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934450AbdIYMX2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 08:23:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3] btrfs: cleanup btrfs_init_new_device()
Date: Mon, 25 Sep 2017 20:31:03 +0800
Message-Id: <20170925123104.16526-3-anand.jain@oracle.com>
In-Reply-To: <20170925123104.16526-1-anand.jain@oracle.com>
References: <20170925123104.16526-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Moves btrfs_abort_transaction() to the error goto and renames
error_trans to error_sysfs. This is a preparatory patch to
remove the BUG_ON() in btrfs_init_new_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9d64700cc9b6..5c34eea9d12d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2443,26 +2443,20 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		mutex_lock(&fs_info->chunk_mutex);
 		ret = init_first_rw_device(trans, fs_info);
 		mutex_unlock(&fs_info->chunk_mutex);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			goto error_trans;
-		}
+		if (ret)
+			goto error_sysfs;
 	}
 
 	ret = btrfs_add_device(trans, fs_info, device);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
-		goto error_trans;
-	}
+	if (ret)
+		goto error_sysfs;
 
 	if (seeding_dev) {
 		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
 
 		ret = btrfs_finish_sprout(trans, fs_info);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			goto error_trans;
-		}
+		if (ret)
+			goto error_sysfs;
 
 		/* Sprouting would change fsid of the mounted root,
 		 * so rename the fsid on the sysfs
@@ -2500,12 +2494,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	update_dev_time(device_path);
 	return ret;
 
-error_trans:
+error_sysfs:
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 	if (seeding_dev)
 		sb->s_flags |= MS_RDONLY;
+	btrfs_abort_transaction(trans, ret);
 	btrfs_end_transaction(trans);
 	rcu_string_free(device->name);
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.13.1

