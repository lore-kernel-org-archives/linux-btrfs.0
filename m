Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbeA3G1W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 01:27:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0U6R2b0119614
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:27:22 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2ftk1xr409-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:27:21 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0U6RK7H025280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:27:21 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0U6RJvZ010504
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:27:20 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: drop num argument from find_live_mirror()
Date: Tue, 30 Jan 2018 14:28:30 +0800
Message-Id: <20180130062831.14644-2-anand.jain@oracle.com>
In-Reply-To: <20180130062831.14644-1-anand.jain@oracle.com>
References: <20180130062831.14644-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Obtain the stripes info from the map directly and so no need
to pass it as an argument.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f7147740b68e..9c9d987838c2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5252,13 +5252,22 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 }
 
 static int find_live_mirror(struct btrfs_fs_info *fs_info,
-			    struct map_lookup *map, int first, int num,
+			    struct map_lookup *map, int first,
 			    int optimal, int dev_replace_is_ongoing)
 {
 	int i;
+	int num;
 	int tolerance;
 	struct btrfs_device *srcdev;
 
+	ASSERT((map->type &
+		 (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)));
+
+	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
+		num = map->sub_stripes;
+	else
+		num = map->num_stripes;
+
 	if (dev_replace_is_ongoing &&
 	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
 	     BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID)
@@ -5812,7 +5821,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			stripe_index = mirror_num - 1;
 		else {
 			stripe_index = find_live_mirror(fs_info, map, 0,
-					    map->num_stripes,
 					    current->pid % map->num_stripes,
 					    dev_replace_is_ongoing);
 			mirror_num = stripe_index + 1;
@@ -5841,7 +5849,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			int old_stripe_index = stripe_index;
 			stripe_index = find_live_mirror(fs_info, map,
 					      stripe_index,
-					      map->sub_stripes, stripe_index +
+					      stripe_index +
 					      current->pid % map->sub_stripes,
 					      dev_replace_is_ongoing);
 			mirror_num = stripe_index - old_stripe_index + 1;
-- 
2.7.0

