Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbeA3G2u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 01:28:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0U6Sn9S108247
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:28:50 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2ftk4nr2nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:28:49 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0U6RK5X011279
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:27:20 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0U6RKl6014592
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:27:20 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: drop optimal argument from find_live_mirror()
Date: Tue, 30 Jan 2018 14:28:31 +0800
Message-Id: <20180130062831.14644-3-anand.jain@oracle.com>
In-Reply-To: <20180130062831.14644-1-anand.jain@oracle.com>
References: <20180130062831.14644-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Drop optimal argument from the function find_live_mirror()
as we can deduce it in the function itself.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9c9d987838c2..a61715677b67 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5253,10 +5253,11 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 
 static int find_live_mirror(struct btrfs_fs_info *fs_info,
 			    struct map_lookup *map, int first,
-			    int optimal, int dev_replace_is_ongoing)
+			    int dev_replace_is_ongoing)
 {
 	int i;
 	int num;
+	int optimal;
 	int tolerance;
 	struct btrfs_device *srcdev;
 
@@ -5268,6 +5269,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	else
 		num = map->num_stripes;
 
+	optimal = first + current->pid % num;
+
 	if (dev_replace_is_ongoing &&
 	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
 	     BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID)
@@ -5821,7 +5824,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			stripe_index = mirror_num - 1;
 		else {
 			stripe_index = find_live_mirror(fs_info, map, 0,
-					    current->pid % map->num_stripes,
 					    dev_replace_is_ongoing);
 			mirror_num = stripe_index + 1;
 		}
@@ -5849,8 +5851,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			int old_stripe_index = stripe_index;
 			stripe_index = find_live_mirror(fs_info, map,
 					      stripe_index,
-					      stripe_index +
-					      current->pid % map->sub_stripes,
 					      dev_replace_is_ongoing);
 			mirror_num = stripe_index - old_stripe_index + 1;
 		}
-- 
2.7.0

