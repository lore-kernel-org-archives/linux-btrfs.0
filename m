Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753723AbeGCFJx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 01:09:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6354u9n022650
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:09:52 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2jx2gpxv4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2018 05:09:52 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6359p20001576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:09:51 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6359pHb026515
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 05:09:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 1/2] btrfs: fix parent in memory total_devices after seed delete
Date: Tue,  3 Jul 2018 13:12:58 +0800
Message-Id: <20180703051259.2745-1-anand.jain@oracle.com>
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
 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5bd6f3a40f9c..6b807b166ca3 100644
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
2.15.0

