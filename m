Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17695 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdKFIgS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 03:36:18 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA68aHLs001926
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aHkK022648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:17 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA68aGv8010228
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:17 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] btrfs: rename btrfs_add_device to btrfs_add_dev_item
Date: Mon,  6 Nov 2017 16:36:15 +0800
Message-Id: <20171106083618.7617-5-anand.jain@oracle.com>
In-Reply-To: <20171106083618.7617-1-anand.jain@oracle.com>
References: <20171106083618.7617-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function btrfs_add_device() is about adding the device item
so rename to reflect that in the function. Similarly we have
btrfs_rm_dev_item().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5b03c2b1b851..2329f429ce40 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1716,7 +1716,7 @@ static noinline int find_next_devid(struct btrfs_fs_info *fs_info,
  * the device information is stored in the chunk root
  * the btrfs_device struct should be fully filled in
  */
-static int btrfs_add_device(struct btrfs_trans_handle *trans,
+static int btrfs_add_dev_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info,
 			    struct btrfs_device *device)
 {
@@ -2501,7 +2501,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		}
 	}
 
-	ret = btrfs_add_device(trans, fs_info, device);
+	ret = btrfs_add_dev_item(trans, fs_info, device);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto error_sysfs;
-- 
2.13.1

