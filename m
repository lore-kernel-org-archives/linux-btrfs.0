Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55506 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbeDRG5U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 02:57:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I6pbig131772
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 06:57:19 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hdrxn95f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 06:57:19 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I6vI3O021919
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 06:57:18 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I6vIdb005630
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 06:57:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: add comment about BTRFS_FS_EXCL_OP
Date: Wed, 18 Apr 2018 14:59:25 +0800
Message-Id: <20180418065925.28294-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds comments about BTRFS_FS_EXCL_OP to existing comments
about the device locks.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: add more clarity to the comments added.

 fs/btrfs/volumes.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3a3912a9dec9..6d7f10729713 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -202,6 +202,38 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  *   device_list_mutex
  *     chunk_mutex
  *   balance_mutex
+ *
+ * BTRFS_FS_EXCL_OP
+ * ----------------
+ * Maintains the exclusivity of the following device operations.
+ *
+ * - Balance (*)
+ * - Device add
+ * - Device remove
+ * - Device Replace (*)
+ * - Resize
+ *
+ * The device operations (as above) can be in one of the following states.
+ *
+ * - Running state
+ * - Paused state
+ * - Completed state
+ *
+ * Only device operations marked with (*) can go into the Paused state for the
+ * following reasons.
+ *
+ * - Ioctl (only Balance can be Paused through Ioctl)
+ * - FS re-mounted as read-only
+ * - FS un-mounted and mounted as read-only
+ * - System power-recycle and mounted as read-only
+ * - FS or device errors leading to read-only FS
+ *
+ * BTRFS_FS_EXCL_OP flag is set and cleared using atomic functions.
+ * During the course of Paused state, the BTRFS_FS_EXCL_OP remains set.
+ * A device operation in Paused or Running state can be canceled or resumed
+ * either by Ioctl (Balance only) or when re-mounted as read-write FS.
+ * BTRFS_FS_EXCL_OP flag is cleared when the device operation is canceled or
+ * completed.
  */
 
 DEFINE_MUTEX(uuid_mutex);
-- 
2.15.0

