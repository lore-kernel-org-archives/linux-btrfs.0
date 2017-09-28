Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44639 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdI1Gvo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 02:51:44 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8S6ph7Q014802
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 06:51:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8S6phG3005725
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 06:51:43 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8S6ph66002287
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 06:51:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 3/3] btrfs: error out if btrfs_attach_transaction() fails
Date: Thu, 28 Sep 2017 14:51:11 +0800
Message-Id: <20170928065111.10224-3-anand.jain@oracle.com>
In-Reply-To: <20170928065111.10224-1-anand.jain@oracle.com>
References: <20170928065111.10224-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_init_new_device() calls btrfs_attach_transaction() to
commit sys chunks, and it should error out if it fails.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
v4: make this patch as part of this set.
    avoid double mutext unlock.
v3: not part of this set
v2: patch did not exist
v1: patch did not exist
 fs/btrfs/volumes.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4cb575fbf643..bdb8f04663a4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2323,6 +2323,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	u64 tmp;
 	int seeding_dev = 0;
 	int ret = 0;
+	bool unlocked = false;
 
 	if (sb_rdonly(sb) && !fs_info->fs_devices->seeding)
 		return -EROFS;
@@ -2482,6 +2483,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (seeding_dev) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
+		unlocked = true;
 
 		if (ret) /* transaction commit */
 			return ret;
@@ -2494,7 +2496,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		if (IS_ERR(trans)) {
 			if (PTR_ERR(trans) == -ENOENT)
 				return 0;
-			return PTR_ERR(trans);
+			ret = PTR_ERR(trans);
+			goto error_sysfs;
 		}
 		ret = btrfs_commit_transaction(trans);
 	}
@@ -2513,7 +2516,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-	if (seeding_dev) {
+	if (seeding_dev && !unlocked) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
 	}
-- 
2.13.1

