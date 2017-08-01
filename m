Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44526 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751928AbdHARPz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:55 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFs3k012783
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFrSI013971
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFron032265
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/14] Btrfs: raid56: add verbose debug
Date: Tue,  1 Aug 2017 10:14:27 -0600
Message-Id: <20170801161439.13426-5-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c  | 2 ++
 fs/btrfs/volumes.c | 7 ++++++-
 fs/btrfs/volumes.h | 4 ++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 2b91b95..c75766f 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2753,7 +2753,9 @@ int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device)
 	cmpxchg(&fs_info->r5log, NULL, log);
 	ASSERT(fs_info->r5log == log);
 
+#ifdef BTRFS_DEBUG_R5LOG
 	trace_printk("r5log: set a r5log in fs_info,  alloc_range 0x%llx 0x%llx",
 		     log->data_offset, log->data_offset + log->device_size);
+#endif
 	return 0;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a17a488..ac64d93 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4731,8 +4731,13 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 		if (!device->in_fs_metadata ||
 		    device->is_tgtdev_for_dev_replace ||
-		    (device->type & BTRFS_DEV_RAID56_LOG))
+		    (device->type & BTRFS_DEV_RAID56_LOG)) {
+#ifdef BTRFS_DEBUG_R5LOG
+			if (device->type & BTRFS_DEV_RAID56_LOG)
+				btrfs_info(info, "skip a r5log when alloc chunk\n");
+#endif
 			continue;
+		}
 
 		if (device->total_bytes > device->bytes_used)
 			total_avail = device->total_bytes - device->bytes_used;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 60e347a..44cc3fa 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -26,6 +26,10 @@
 
 extern struct mutex uuid_mutex;
 
+#ifdef CONFIG_BTRFS_DEBUG
+#define BTRFS_DEBUG_R5LOG
+#endif
+
 #define BTRFS_STRIPE_LEN	SZ_64K
 
 struct buffer_head;
-- 
2.9.4

