Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31423 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaHMGRU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 02:17:20 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7D6HJfA025247
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:20 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s7D6HJJS006319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:19 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D6HI7D016677
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/8] btrfs: rename total_bytes to avoid confusion
Date: Wed, 13 Aug 2014 14:24:26 +0800
Message-Id: <1407911066-5363-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>

we are assigning number_devices to the total_bytes,
that's very confusing for a moment

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bf99e82..c0c360a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2253,7 +2253,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	struct list_head *devices;
 	struct super_block *sb = root->fs_info->sb;
 	struct rcu_string *name;
-	u64 total_bytes;
+	u64 ret_sz;
 	int seeding_dev = 0;
 	int ret = 0;
 
@@ -2356,13 +2356,13 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
 		root->fs_info->fs_devices->rotating = 1;
 
-	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
+	ret_sz = btrfs_super_total_bytes(root->fs_info->super_copy);
 	btrfs_set_super_total_bytes(root->fs_info->super_copy,
-				    total_bytes + device->total_bytes);
+				    ret_sz + device->total_bytes);
 
-	total_bytes = btrfs_super_num_devices(root->fs_info->super_copy);
+	ret_sz = btrfs_super_num_devices(root->fs_info->super_copy);
 	btrfs_set_super_num_devices(root->fs_info->super_copy,
-				    total_bytes + 1);
+				    ret_sz + 1);
 
 	/* add sysfs device entry */
 	btrfs_kobj_add_device(root->fs_info, device);
-- 
2.0.0.153.g79dcccc

