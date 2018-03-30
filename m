Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeC3AMq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 20:12:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2U04LkI007742
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:12:45 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2h1abwr0n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:12:45 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07iZW001900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:45 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07iET007452
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:44 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] btrfs: drop the redundant invalidate_bdev()
Date: Fri, 30 Mar 2018 08:09:23 +0800
Message-Id: <20180330000924.11148-8-anand.jain@oracle.com>
In-Reply-To: <20180330000924.11148-1-anand.jain@oracle.com>
References: <20180330000924.11148-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the mount context btrfs_open_devices() calls invalidate_bdev()
for all the devices. So drop the invalidate_bdev() in open_ctree()
which is only for the btrfs_fs_devices::latest_bdev.

The call trace is as shown below.

btrfs_mount_root()
 |
 |_btrfs_parse_early_options (-o device only)
 | |_btrfs_scan_one_device
 |   |_btrfs_read_disk_super()
 |     |_read_cache_page_gfp()
 |
 |_btrfs_scan_one_device(mount-arg-dev only)
 | |_btrfs_read_disk_super()
 |   |_read_cache_page_gfp()
 |
 |
 |_btrfs_open_devices(fsid:all)
 |  |_btrfs_open_one_device()
 |    |_btrfs_get_bdev_and_sb()  <--- invalidate_bdev(fsid:all)
 |      |_btrfs_read_dev_super()
 |        |_btrfs_read_dev_one_super()
 |          |___bread()
 |
 |_btrfs_fill_super()
   |_btrfs_open_ctree()   <-- invalidate_bdev(latest_bdev) <-- redundant
     |_btrfs_read_dev_super(latest_bdev only)
       |_btrfs_read_dev_one_super(latest_bdev only)
         |___bread(latest_bdev)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1eabcc4bf8d2..55b8a57435a9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2553,8 +2553,6 @@ int open_ctree(struct super_block *sb,
 
 	__setup_root(tree_root, fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
-	invalidate_bdev(fs_devices->latest_bdev);
-
 	/*
 	 * Read super block and check the signature bytes only
 	 */
-- 
2.7.0

