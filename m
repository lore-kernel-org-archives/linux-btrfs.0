Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968515AbeE3Gzu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:55:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4U6omow098842
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:50 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2j9ev89046-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6tnwH004159
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:49 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6tmu8019403
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:48 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: update device_list_mutex protected items
Date: Wed, 30 May 2018 14:58:18 +0800
Message-Id: <20180530065821.28385-4-anand.jain@oracle.com>
In-Reply-To: <20180530065821.28385-1-anand.jain@oracle.com>
References: <20180530065821.28385-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Include items of fs_uuids::fs_devices to be protected by
device_list_mutex, like (but not limited to) fs_devices::opened,
fs_devices::total_devices and fs_devices::num_devices. This is
been done in the code already.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0fdb9b717398..e3dd25238eb9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -164,7 +164,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  *
  * fs_devices::device_list_mutex (per-fs, with RCU)
  * ------------------------------------------------
- * protects updates to fs_devices::devices, ie. adding and deleting
+ * Protects updates to fs_uuids::fs_devices items, and fs_devices::devices, ie.
+ * adding and deleting.
  *
  * simple list traversal with read-only actions can be done with RCU protection
  *
-- 
2.7.0

