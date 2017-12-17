Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32883 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752118AbdLQNx6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 08:53:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBHDqkHH056602
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 13:53:58 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2ewstq806e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 13:53:57 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBHDqDOr026679
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 13:52:13 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBHDqDh9024315
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 13:52:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 2/2] btrfs: handle volume split brain condition for dynamically reappearing device
Date: Sun, 17 Dec 2017 21:52:47 +0800
Message-Id: <20171217135247.1838-2-anand.jain@oracle.com>
In-Reply-To: <20171217135247.1838-1-anand.jain@oracle.com>
References: <20171217135247.1838-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the missing device reappears and joins the RAID group, and if there
are no more missing device at the volume level, then reset the
BTRFS_SUPER_FLAG_VOL_MOVED_ON flag.

This patch is on top of the patch [1] in the ML.
[1] btrfs: handle dynamically reappearing missing device

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c08b9b89e285..b881fc2b2225 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -865,6 +865,10 @@ static noinline int device_list_add(const char *path,
 				btrfs_warn(fs_info,
 					"BTRFS: device %s devid %llu joined\n",
 					path, devid);
+				if (!fs_devices->missing_devices)
+					btrfs_set_super_flags(fs_info->super_copy,
+						fs_info->super_copy->flags &
+						~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
 			}
 
 			if (test_bit(BTRFS_DEV_STATE_WRITEABLE,
-- 
2.7.0

