Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46202 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932488AbaICNeS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:18 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYEIW006691
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 15/18] Btrfs: make the logic of source device removing more clear
Date: Wed, 3 Sep 2014 21:35:44 +0800
Message-ID: <1409751347-5296-15-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c |  3 +--
 fs/btrfs/volumes.c     | 19 +++++++------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e9cbbdb..6f662b3 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -569,8 +569,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
 		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
-	if (src_device->fs_devices->seeding)
-		fs_info->fs_devices->rw_devices++;
+	fs_info->fs_devices->rw_devices++;
 
 	/* replace the sysfs entry */
 	btrfs_kobj_rm_device(fs_info, src_device);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 24d7001..fd8141e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1819,23 +1819,18 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 	list_del_rcu(&srcdev->dev_list);
 	list_del_rcu(&srcdev->dev_alloc_list);
 	fs_devices->num_devices--;
-	if (srcdev->missing) {
+	if (srcdev->missing)
 		fs_devices->missing_devices--;
-		if (!fs_devices->seeding)
-			fs_devices->rw_devices++;
+
+	if (srcdev->writeable) {
+		fs_devices->rw_devices--;
+		/* zero out the old super if it is writable */
+		btrfs_scratch_superblock(srcdev);
 	}
 
-	if (srcdev->bdev) {
+	if (srcdev->bdev)
 		fs_devices->open_devices--;
 
-		/*
-		 * zero out the old super if it is not writable
-		 * (e.g. seed device)
-		 */
-		if (srcdev->writeable)
-			btrfs_scratch_superblock(srcdev);
-	}
-
 	call_rcu(&srcdev->rcu, free_device);
 
 	/*
-- 
1.9.3

