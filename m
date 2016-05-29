Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18537 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbcE2TsL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 15:48:11 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4TJm9tY018352
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u4TJm9bt002776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:09 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u4TJm9tl028104
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: failed to create sprout should set back to rdonly
Date: Mon, 30 May 2016 03:48:17 +0800
Message-Id: <1464551298-11291-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
References: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_init_new_device() should put the FS back to RDONLY
if init fails in the seed_device context.

Further it adds the following clean up:
- fixes a bug_on to goto label error_trans:
- move btrfs_abort_transaction() label error_trans: and
- as there is no code to undo the btrfs_prepare_sprout()
  so temporarily calls a bug_on

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2b88127bba5b..a637e99e4c6b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2351,7 +2351,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
 		ret = btrfs_prepare_sprout(root);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret)
+			goto error_trans;
 	}
 
 	device->fs_devices = root->fs_info->fs_devices;
@@ -2398,26 +2399,20 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		lock_chunks(root);
 		ret = init_first_rw_device(trans, root, device);
 		unlock_chunks(root);
-		if (ret) {
-			btrfs_abort_transaction(trans, root, ret);
-			goto error_trans;
-		}
+		if (ret)
+			goto error_sysfs;
 	}
 
 	ret = btrfs_add_device(trans, root, device);
-	if (ret) {
-		btrfs_abort_transaction(trans, root, ret);
-		goto error_trans;
-	}
+	if (ret)
+		goto error_sysfs;
 
 	if (seeding_dev) {
 		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
 
 		ret = btrfs_finish_sprout(trans, root);
-		if (ret) {
-			btrfs_abort_transaction(trans, root, ret);
-			goto error_trans;
-		}
+		if (ret)
+			goto error_sysfs;
 
 		/* Sprouting would change fsid of the mounted root,
 		 * so rename the fsid on the sysfs
@@ -2460,10 +2455,18 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	update_dev_time(device_path);
 	return ret;
 
+error_sysfs:
+	if (seeding_dev) {
+		/* undo of btrfs_prepare_sprout is missing*/
+		BUG_ON(1);
+	}
+	btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device);
 error_trans:
+	if (seeding_dev)
+		sb->s_flags |= MS_RDONLY;
+	btrfs_abort_transaction(trans, root, ret);
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
-	btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.7.0

