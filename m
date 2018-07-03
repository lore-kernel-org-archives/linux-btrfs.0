Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43754 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753822AbeGCFLp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 01:11:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6354Fqd050126
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:11:45 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2jwyccq2jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2018 05:11:45 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w635BiSi005761
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:11:45 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w635BiX8017511
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:11:44 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: drop devices declare in btrfs_init_new_device()
Date: Tue,  3 Jul 2018 13:14:51 +0800
Message-Id: <20180703051451.3673-2-anand.jain@oracle.com>
In-Reply-To: <20180703051451.3673-1-anand.jain@oracle.com>
References: <20180703051451.3673-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is only one usage of the declared devices variable, instead
use its value directly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f7fa0ea26e9c..124bd8728c37 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2406,7 +2406,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
 	struct block_device *bdev;
-	struct list_head *devices;
 	struct super_block *sb = fs_info->sb;
 	struct rcu_string *name;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
@@ -2431,10 +2430,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	filemap_write_and_wait(bdev->bd_inode->i_mapping);
 
-	devices = &fs_devices->devices;
-
 	mutex_lock(&fs_devices->device_list_mutex);
-	list_for_each_entry(device, devices, dev_list) {
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (device->bdev == bdev) {
 			ret = -EEXIST;
 			mutex_unlock(
-- 
2.15.0

