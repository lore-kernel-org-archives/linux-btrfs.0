Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35255 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdKMFyK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 00:54:10 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAD5s9ur010648
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:54:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAD5s95S024143
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:54:09 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAD5s8DQ016787
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:54:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: reset SB MOVED_ON flag for dynamically reappearing missing device
Date: Mon, 13 Nov 2017 13:53:41 +0800
Message-Id: <20171113055341.25764-2-anand.jain@oracle.com>
In-Reply-To: <20171113055341.25764-1-anand.jain@oracle.com>
References: <20171113055341.25764-1-anand.jain@oracle.com>
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
index ba32e2d73fbe..8bac1cf17048 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -798,6 +798,10 @@ static noinline int device_list_add(const char *path,
 				btrfs_warn(fs_info,
 					"BTRFS: device %s devid %llu uuid %pU joined\n",
 					path, devid, device->uuid);
+				if (!fs_devices->missing_devices)
+					btrfs_set_super_flags(fs_info->super_copy,
+						fs_info->super_copy->flags &
+						~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
 			}
 
 			if (device->writeable &&
-- 
2.13.1

