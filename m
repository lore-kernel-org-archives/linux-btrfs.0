Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbdLOHjq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 02:39:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF7bNE1069506
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:45 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2ev9yug20j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:45 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBF7djWa013576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:45 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBF7djFj024740
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:45 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: misc cleanup btrfs_scan_one_device()
Date: Fri, 15 Dec 2017 15:40:16 +0800
Message-Id: <20171215074016.26461-3-anand.jain@oracle.com>
In-Reply-To: <20171215074016.26461-1-anand.jain@oracle.com>
References: <20171215074016.26461-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Assign ret = -EINVAL where actually its required.
Remove { } around single line if else code.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a7eb9b42cd92..ba06a4ccd5a6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1173,7 +1173,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct btrfs_super_block *disk_super;
 	struct block_device *bdev;
 	struct page *page;
-	int ret = -EINVAL;
+	int ret;
 	u64 devid;
 	u64 transid;
 	u64 total_devices;
@@ -1192,8 +1192,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
+	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
+		ret = -EINVAL;
 		goto error_bdev_put;
+	}
 
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
@@ -1206,11 +1208,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	mutex_unlock(&uuid_mutex);
 
 	if (ret > 0) {
-		if (disk_super->label[0]) {
+		if (disk_super->label[0])
 			pr_info("BTRFS: device label %s ", disk_super->label);
-		} else {
+		else
 			pr_info("BTRFS: device fsid %pU ", disk_super->fsid);
-		}
 
 		pr_cont("devid %llu transid %llu %s\n", devid, transid, path);
 		ret = 0;
-- 
2.7.0

