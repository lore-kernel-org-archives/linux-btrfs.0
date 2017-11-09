Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36737 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdKIPpa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 10:45:30 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA9FjTST028589
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA9FjSUc024168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:28 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA9FjSBI030860
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:28 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: let variable required be declared inside the loop
Date: Thu,  9 Nov 2017 23:45:24 +0800
Message-Id: <20171109154526.23181-3-anand.jain@oracle.com>
In-Reply-To: <20171109154526.23181-1-anand.jain@oracle.com>
References: <20171109154526.23181-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A preparation patch to create the actual device open in a new function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ab2f349ee293..ea6e542cb09d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -970,19 +970,20 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 				fmode_t flags, void *holder)
 {
-	struct request_queue *q;
-	struct block_device *bdev;
 	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *device;
 	struct btrfs_device *latest_dev = NULL;
-	struct buffer_head *bh;
-	struct btrfs_super_block *disk_super;
-	u64 devid;
 	int ret = 0;
 
 	flags |= FMODE_EXCL;
 
 	list_for_each_entry(device, head, dev_list) {
+		struct request_queue *q;
+		struct block_device *bdev;
+		struct buffer_head *bh;
+		struct btrfs_super_block *disk_super;
+		u64 devid;
+
 		if (device->bdev)
 			continue;
 		if (!device->name)
-- 
2.13.1

