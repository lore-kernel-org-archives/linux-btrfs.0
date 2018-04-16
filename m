Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34988 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754160AbeDPK0b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 06:26:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3GAQ0mB074715
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 10:26:30 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hbam5vd46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 10:26:29 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3GAQTQv030848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 10:26:29 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3GAQTiP020826
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 10:26:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add comment about BTRFS_FS_EXCL_OP
Date: Mon, 16 Apr 2018 18:28:31 +0800
Message-Id: <20180416102831.12388-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds comments about BTRFS_FS_EXCL_OP to existing comments
about the device locks.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3a3912a9dec9..18306165ffaa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -202,6 +202,22 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  *   device_list_mutex
  *     chunk_mutex
  *   balance_mutex
+ *
+ * BTRFS_FS_EXCL_OP
+ * ----------------
+ * Maintains the exclusivity of the following device operations.
+ *
+ * - Balance (*)
+ * - Add
+ * - Remove
+ * - Replace (*)
+ * - Resize
+ *
+ * The device operation with (*) indicate it can continue after a CLI pause
+ * (only balance can be paused using CLI) or remount or unmount-mount sequence
+ * or a power-recycle, as long as the FS is still writeable. And during the
+ * course of the pause, the BTRFS_FS_EXCL_OP remains set. BTRFS_FS_EXCL_OP flag
+ * is set and cleared using atomic functions.
  */
 
 DEFINE_MUTEX(uuid_mutex);
-- 
2.15.0

