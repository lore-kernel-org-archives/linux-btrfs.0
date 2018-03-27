Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33432 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbeC0XiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 19:38:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2RNTeR6022103
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:17 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2gyyp7g0yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:17 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2RNcG2t023921
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:16 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2RNcGuh019295
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/8] btrfs: cleanup btrfs_read_disk_super() to return std error
Date: Wed, 28 Mar 2018 07:39:54 +0800
Message-Id: <20180327234000.23656-4-anand.jain@oracle.com>
In-Reply-To: <20180327234000.23656-1-anand.jain@oracle.com>
References: <20180327234000.23656-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only caller btrfs_scan_one_device() sets -EINVAL for error from
btrfs_read_disk_super(), so this patch returns -EINVAL from the latter
function.

A preparatory patch to add csum check in btrfs_read_disk_super().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2:
 Check btrfs_read_disk_super() to be more explicit ret < 0

 fs/btrfs/volumes.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 87d183accdb2..e63723f23227 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1154,23 +1154,23 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 
 	/* make sure our super fits in the device */
 	if (bytenr + PAGE_SIZE >= i_size_read(bdev->bd_inode))
-		return 1;
+		return -EINVAL;
 
 	/* make sure our super fits in the page */
 	if (sizeof(**disk_super) > PAGE_SIZE)
-		return 1;
+		return -EINVAL;
 
 	/* make sure our super doesn't straddle pages on disk */
 	index = bytenr >> PAGE_SHIFT;
 	if ((bytenr + sizeof(**disk_super) - 1) >> PAGE_SHIFT != index)
-		return 1;
+		return -EINVAL;
 
 	/* pull in the page with our super */
 	*page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
 				   index, GFP_KERNEL);
 
 	if (IS_ERR_OR_NULL(*page))
-		return 1;
+		return -EINVAL;
 
 	p = kmap(*page);
 
@@ -1180,7 +1180,7 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	if (btrfs_super_bytenr(*disk_super) != bytenr ||
 	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
 		btrfs_release_disk_super(*page);
-		return 1;
+		return -EINVAL;
 	}
 
 	if ((*disk_super)->label[0] &&
@@ -1218,10 +1218,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
-		ret = -EINVAL;
+	ret = btrfs_read_disk_super(bdev, bytenr, &page, &disk_super);
+	if (ret < 0)
 		goto error_bdev_put;
-	}
 
 	mutex_lock(&uuid_mutex);
 	device = device_list_add(path, disk_super);
-- 
2.7.0

