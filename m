Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48046 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHTCJc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 22:09:32 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7K29Uuq014295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 02:09:31 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7K29TS5019467
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 02:09:30 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7K29TdS010595
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 02:09:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/8 v2] btrfs: rename total_bytes to avoid confusion
Date: Wed, 20 Aug 2014 10:54:17 +0800
Message-Id: <1408503257-29568-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407911066-5363-8-git-send-email-anand.jain@oracle.com>
References: <1407911066-5363-8-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

we are assigning number_devices to the total_bytes,
that's very confusing for a moment

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: accepts David comment renames ret_sz to tmp

 fs/btrfs/volumes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bf99e82..718f734 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2253,7 +2253,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	struct list_head *devices;
 	struct super_block *sb = root->fs_info->sb;
 	struct rcu_string *name;
-	u64 total_bytes;
+	u64 tmp;
 	int seeding_dev = 0;
 	int ret = 0;
 
@@ -2356,13 +2356,13 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
 		root->fs_info->fs_devices->rotating = 1;
 
-	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
+	tmp = btrfs_super_total_bytes(root->fs_info->super_copy);
 	btrfs_set_super_total_bytes(root->fs_info->super_copy,
-				    total_bytes + device->total_bytes);
+				    tmp + device->total_bytes);
 
-	total_bytes = btrfs_super_num_devices(root->fs_info->super_copy);
+	tmp = btrfs_super_num_devices(root->fs_info->super_copy);
 	btrfs_set_super_num_devices(root->fs_info->super_copy,
-				    total_bytes + 1);
+				    tmp + 1);
 
 	/* add sysfs device entry */
 	btrfs_kobj_add_device(root->fs_info, device);
-- 
2.0.0.153.g79dcccc

