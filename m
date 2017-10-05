Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18716 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751310AbdJENzD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Oct 2017 09:55:03 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v95Dt29m021752
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 5 Oct 2017 13:55:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v95Dt156005267
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 5 Oct 2017 13:55:01 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v95Dt1qs030126
        for <linux-btrfs@vger.kernel.org>; Thu, 5 Oct 2017 13:55:01 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8.1 2/2] btrfs: mark device failed for write and flush errors
Date: Thu,  5 Oct 2017 21:54:39 +0800
Message-Id: <20171005135439.5426-1-anand.jain@oracle.com>
In-Reply-To: <20171003155920.24925-1-anand.jain@oracle.com>
References: <20171003155920.24925-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch marks device as failed for the write/flush errors
so that it can be brought out of the RW device list. However
if the chunk render is incomplete due to missing of a device
then the volume/raid fails, so this situation is handled by
calling btrfs_handle_fs_error() which puts the whole FS to
RDONLY.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
This patch is to replace
  [PATCH v8 2/2] btrfs: check device for critical errors and mark failed

 fs/btrfs/volumes.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 05b150c03995..53397d077e91 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -501,6 +501,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 				u64 chunk_offset, u64 chunk_size);
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 chunk_offset);
+void btrfs_mark_device_failed(struct btrfs_device *dev);
 
 static inline int btrfs_dev_stats_dirty(struct btrfs_device *dev)
 {
@@ -513,6 +514,10 @@ static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 	atomic_inc(dev->dev_stat_values + index);
 	smp_mb__before_atomic();
 	atomic_inc(&dev->dev_stats_ccnt);
+
+	if (index == BTRFS_DEV_STAT_WRITE_ERRS ||
+		index == BTRFS_DEV_STAT_FLUSH_ERRS)
+		btrfs_mark_device_failed(dev);
 }
 
 static inline int btrfs_dev_stat_read(struct btrfs_device *dev,
-- 
2.13.1

