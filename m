Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbeCNI1b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 04:27:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2E8Qu93157695
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 08:27:30 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2gpym8853r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 08:27:30 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2E8RTET024257
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 08:27:29 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2E8RT4h017472
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 08:27:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: drop num argument from find_live_mirror()
Date: Wed, 14 Mar 2018 16:29:12 +0800
Message-Id: <20180314082913.31503-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Obtain the stripes info from the map directly and so no need
to pass it as an argument.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2:
  Accepts David's comment to rename %num to %num_stripes.

 fs/btrfs/volumes.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1e72357bdfa8..9beea7c891a7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5275,13 +5275,22 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 }
 
 static int find_live_mirror(struct btrfs_fs_info *fs_info,
-			    struct map_lookup *map, int first, int num,
+			    struct map_lookup *map, int first,
 			    int optimal, int dev_replace_is_ongoing)
 {
 	int i;
+	int num_stripes;
 	int tolerance;
 	struct btrfs_device *srcdev;
 
+	ASSERT((map->type &
+		 (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)));
+
+	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
+		num_stripes = map->sub_stripes;
+	else
+		num_stripes = map->num_stripes;
+
 	if (dev_replace_is_ongoing &&
 	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
 	     BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID)
@@ -5298,7 +5307,7 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 		if (map->stripes[optimal].dev->bdev &&
 		    (tolerance || map->stripes[optimal].dev != srcdev))
 			return optimal;
-		for (i = first; i < first + num; i++) {
+		for (i = first; i < first + num_stripes; i++) {
 			if (map->stripes[i].dev->bdev &&
 			    (tolerance || map->stripes[i].dev != srcdev))
 				return i;
@@ -5835,7 +5844,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			stripe_index = mirror_num - 1;
 		else {
 			stripe_index = find_live_mirror(fs_info, map, 0,
-					    map->num_stripes,
 					    current->pid % map->num_stripes,
 					    dev_replace_is_ongoing);
 			mirror_num = stripe_index + 1;
@@ -5864,7 +5872,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			int old_stripe_index = stripe_index;
 			stripe_index = find_live_mirror(fs_info, map,
 					      stripe_index,
-					      map->sub_stripes, stripe_index +
+					      stripe_index +
 					      current->pid % map->sub_stripes,
 					      dev_replace_is_ongoing);
 			mirror_num = stripe_index - old_stripe_index + 1;
-- 
2.15.0

