Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41120 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbeBTOtL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 09:49:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1KElClE150991
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:49:10 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2g8kh18s92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:49:10 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1KEn9Vd020953
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:49:09 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1KEn9BB025307
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:49:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: remove assert in btrfs_init_dev_replace_tgtdev()
Date: Tue, 20 Feb 2018 22:50:36 +0800
Message-Id: <20180220145036.9431-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the same function we just ran btrfs_alloc_device() which means the
btrfs_device::resized_list is sure to be empty and we are protected
with the btrfs_fs_info::volume_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d4a5f9126e7b..ac29ec0de984 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2655,7 +2655,6 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	device->total_bytes = btrfs_device_get_total_bytes(srcdev);
 	device->disk_total_bytes = btrfs_device_get_disk_total_bytes(srcdev);
 	device->bytes_used = btrfs_device_get_bytes_used(srcdev);
-	ASSERT(list_empty(&srcdev->resized_list));
 	device->commit_total_bytes = srcdev->commit_total_bytes;
 	device->commit_bytes_used = device->bytes_used;
 	device->fs_info = fs_info;
-- 
2.15.0

