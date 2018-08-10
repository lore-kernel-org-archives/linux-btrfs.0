Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57538 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725746AbeHJISG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 04:18:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7A5n3DN109389
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:47 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2kn4sq5skc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:46 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7A5njRj013728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:46 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7A5njpj020188
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:45 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: assert for num_devices below 0
Date: Fri, 10 Aug 2018 13:53:20 +0800
Message-Id: <20180810055321.19730-3-anand.jain@oracle.com>
In-Reply-To: <20180810055321.19730-1-anand.jain@oracle.com>
References: <20180810055321.19730-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation to add helper function to deduce the num_devices with
replace running, use assert instead of bug_on and warn_on.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b6d9b6a6fba7..0062615a79be 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1877,7 +1877,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	num_devices = fs_devices->num_devices;
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		WARN_ON(num_devices < 1);
+		ASSERT(num_devices > 0);
 		num_devices--;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
@@ -3752,7 +3752,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	num_devices = fs_info->fs_devices->num_devices;
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		BUG_ON(num_devices < 1);
+		ASSERT(num_devices > 0);
 		num_devices--;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
-- 
2.7.0
