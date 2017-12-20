Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754205AbdLTIDe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 03:03:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBK81gXq079022
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:03:34 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2eyj568cjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:03:34 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBK83XHT025364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:03:33 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBK83X13010789
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:03:33 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: handle volume split brain condition for dynamically reappearing device
Date: Wed, 20 Dec 2017 16:04:03 +0800
Message-Id: <20171220080403.12702-2-anand.jain@oracle.com>
In-Reply-To: <20171220080403.12702-1-anand.jain@oracle.com>
References: <20171220080403.12702-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the missing device reappears and joins the RAID group, and if there
are no more missing device at the volume level, then reset the
BTRFS_SUPER_FLAG_VOL_MOVED_ON flag.

This patch is on top of the patch [1] in the ML.
[1] btrfs: handle dynamically reappearing missing device

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
On top of misc-next kdave.
v2:
 Rename to BTRFS_SUPER_FLAG_DEGRADED.

 fs/btrfs/volumes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 65d10f38dd99..32571f4fa72b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -858,6 +858,10 @@ static noinline int device_list_add(const char *path,
 
 			fs_devices->missing_devices--;
 			clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
+			if (!fs_devices->missing_devices)
+				btrfs_set_super_flags(fs_info->super_copy,
+						      fs_info->super_copy->flags &
+						      ~BTRFS_SUPER_FLAG_DEGRADED);
 
 			if (test_bit(BTRFS_DEV_STATE_WRITEABLE,
 				     &device->dev_state) &&
-- 
2.7.0

