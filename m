Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36626 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbCTKEi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:38 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 25/27] Btrfs: sysfs: add support to show replacing target in the sysfs
Date: Fri, 20 Mar 2015 18:01:40 +0800
Message-Id: <1426845702-6298-26-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

This patch will add support to show the replacing target in sysfs
during the process of replacement.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 5 ++++-
 fs/btrfs/volumes.c     | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 124b60f..f06390b 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -376,6 +376,10 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	WARN_ON(!tgt_device);
 	dev_replace->tgtdev = tgt_device;
 
+	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
+	if (ret)
+		btrfs_error(root->fs_info, ret, "kobj add dev failed");
+
 	printk_in_rcu(KERN_INFO
 		      "BTRFS: dev_replace from %s (devid %llu) to %s started\n",
 		      src_device->missing ? "<missing disk>" :
@@ -593,7 +597,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	/* replace the sysfs entry */
 	btrfs_kobj_rm_device(fs_info->fs_devices, src_device);
-	btrfs_kobj_add_device(fs_info->fs_devices, tgt_device);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
 	/* write back the superblocks */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 452abb3..f51f5ba 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1921,6 +1921,9 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	mutex_lock(&uuid_mutex);
 	WARN_ON(!tgtdev);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+
+	btrfs_kobj_rm_device(fs_info->fs_devices, tgtdev);
+
 	if (tgtdev->bdev) {
 		btrfs_scratch_superblock(tgtdev);
 		fs_info->fs_devices->open_devices--;
-- 
2.0.0.153.g79dcccc

