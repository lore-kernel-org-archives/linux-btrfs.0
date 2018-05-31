Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbeEaHc6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 03:32:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4V7VY9d062264
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 07:32:57 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2j9ev85mty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 07:32:57 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4V7WuvL025916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 07:32:56 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4V7WsxB003201
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 07:32:56 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix parent in memory total_devices after seed delete
Date: Thu, 31 May 2018 15:35:28 +0800
Message-Id: <20180531073529.15309-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If in case of deleting the seed device the %cur_devices (seed)
and the %fs_devices (parent) are different. Now, as the parent
fs_devices::total_devices also maintains the total number of devices
including the seed device, so decrement its in memory value for the
successful seed delete as we do update its corresponding
btrfs_super_block::number_devices.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d3f9efbef9a9..5296f26be2f6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2047,6 +2047,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	cur_devices->num_devices--;
 	cur_devices->total_devices--;
+	/* Update total_devices for the parent fs_devices if its seed */
+	if (cur_devices != fs_devices)
+		fs_devices->total_devices--;
 
 	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		cur_devices->missing_devices--;
-- 
2.7.0

