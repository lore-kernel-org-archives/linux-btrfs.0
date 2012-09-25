Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:16981 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2IYGs5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 02:48:57 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8P6mt0e018898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2012 06:48:56 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8P6mtia028827
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2012 06:48:55 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8P6mtVR007029
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2012 01:48:55 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: limit thread pool size when remounting
Date: Tue, 25 Sep 2012 14:48:33 +0800
Message-Id: <1348555713-7518-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For some asynchronous threads, such as submit worker and cache worker, we
limit their thread pool size when mounting.

So we also need to do such things when remounting.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/super.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 83d6f9f..a58e834 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1158,17 +1158,20 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n",
 	       old_pool_size, new_pool_size);
 
-	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
+	btrfs_set_max_workers(&fs_info->generic_worker, min(1, new_pool_size));
 	btrfs_set_max_workers(&fs_info->workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
+	btrfs_set_max_workers(&fs_info->submit_workers,
+			      min_t(u64, fs_info->fs_devices->num_devices,
+			      new_pool_size));
+	btrfs_set_max_workers(&fs_info->caching_workers, min(2, new_pool_size));
+	btrfs_set_max_workers(&fs_info->fixup_workers, min(1, new_pool_size));
 	btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->endio_meta_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->endio_meta_write_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->endio_write_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_freespace_worker, new_pool_size);
+	btrfs_set_max_workers(&fs_info->endio_freespace_worker,
+			      min(1, new_pool_size));
 	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->scrub_workers, new_pool_size);
-- 
1.7.7.6

