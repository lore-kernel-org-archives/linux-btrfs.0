Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49906 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933407AbeGCJEU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 05:04:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6393xTL028792
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 09:04:19 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2jwyccqu36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2018 09:04:19 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6394JCU020612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 09:04:19 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6394IgX027640
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 09:04:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: fix parent in memory total_devices after seed delete
Date: Tue,  3 Jul 2018 17:07:23 +0800
Message-Id: <20180703090724.22023-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of deleting the seed device the %cur_devices (seed)
and the %fs_devices (parent) are different. Now, as the parent
fs_devices::total_devices also maintains the total number of devices
including the seed device, so decrement its in-memory value for the
successful seed delete. We are already updating its corresponding on-disk
btrfs_super_block::number_devices value.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: no change

 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b34af7c217c..b5a60ab37a1c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2027,6 +2027,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	cur_devices->num_devices--;
 	cur_devices->total_devices--;
+	/* Update total_devices for the parent fs_devices if its seed */
+	if (cur_devices != fs_devices)
+		fs_devices->total_devices--;
 
 	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		cur_devices->missing_devices--;
-- 
2.7.0

