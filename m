Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbeCZIZ6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 04:25:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q8Hh4L018329
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:57 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2gxw7j813p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:57 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8Pudj031264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:56 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8PtQ3016341
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:55 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/8] btrfs: cleanup btrfs_read_disk_super() to return std error
Date: Mon, 26 Mar 2018 16:27:36 +0800
Message-Id: <20180326082742.9235-4-anand.jain@oracle.com>
In-Reply-To: <20180326082742.9235-1-anand.jain@oracle.com>
References: <20180326082742.9235-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only caller btrfs_scan_one_device() sets -EINVAL for error from
btrfs_read_disk_super(), so this patch returns -EINVAL from the latter
function.

A preparatory patch to add csum check in btrfs_read_disk_super().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 87d183accdb2..ed22f0a3d239 100644
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
+	if (ret)
 		goto error_bdev_put;
-	}
 
 	mutex_lock(&uuid_mutex);
 	device = device_list_add(path, disk_super);
-- 
2.7.0

