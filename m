Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40398 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbeCZI0C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 04:26:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q8IGB3147838
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:01 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2gxw81r0ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:01 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8Q10o025356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:01 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2Q8Q1te011004
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:01 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/8] btrfs: drop the redundant invalidate_bdev()
Date: Mon, 26 Mar 2018 16:27:41 +0800
Message-Id: <20180326082742.9235-9-anand.jain@oracle.com>
In-Reply-To: <20180326082742.9235-1-anand.jain@oracle.com>
References: <20180326082742.9235-1-anand.jain@oracle.com>
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
index 3cc50041c0b9..4f667c99dd16 100644
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

