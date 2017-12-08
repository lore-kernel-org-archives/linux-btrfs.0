Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48914 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbdLHH4m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 02:56:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB87ufYn018128
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Dec 2017 07:56:41 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2eqp6e04ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Dec 2017 07:56:41 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB87ueHU009006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Dec 2017 07:56:40 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB87ueQr022499
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Dec 2017 07:56:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: self heal from SB fail
Date: Fri,  8 Dec 2017 15:57:05 +0800
Message-Id: <20171208075705.23462-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-EXPERIMENTAL-
As of now when primary SB fails we won't self heal and would fail mount,
this is an experimental patch which thinks why not go and read backup
copy.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c |  8 +++++++-
 fs/btrfs/volumes.c | 10 +++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9b20c1f3563b..a791b8dfe8a8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	 * So, we need to add a special mount option to scan for
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
-	for (i = 0; i < 1; i++) {
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		ret = btrfs_read_dev_one_super(bdev, i, &bh);
 		if (ret)
 			continue;
@@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 		ret = -EINVAL;
 	}
 
+#if 0
+	/*
+	 * Need a way to check for any copy of SB, as its not a
+	 * strong check, just ignore this for now.
+	 */
 	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
 		btrfs_err(fs_info, "super offset mismatch %llu != %u",
 			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
 		ret = -EINVAL;
 	}
+#endif
 
 	/*
 	 * Obvious sys_chunk_array corruptions, it must hold at least one key
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9fa2539a8493..f368db94d62b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 {
 	struct btrfs_super_block *disk_super;
 	struct block_device *bdev;
-	struct page *page;
+	struct buffer_head *sb_bh;
 	int ret = -EINVAL;
 	u64 devid;
 	u64 transid;
@@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		goto error;
 	}
 
-	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
+	sb_bh = btrfs_read_dev_super(bdev);
+	if (IS_ERR(sb_bh)) {
+		ret = PTR_ERR(sb_bh);
 		goto error_bdev_put;
+	}
+	disk_super = (struct btrfs_super_block *) sb_bh->b_data;
 
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
@@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (!ret && fs_devices_ret)
 		(*fs_devices_ret)->total_devices = total_devices;
 
-	btrfs_release_disk_super(page);
+	brelse(sb_bh);
 
 error_bdev_put:
 	blkdev_put(bdev, flags);
-- 
2.7.0

