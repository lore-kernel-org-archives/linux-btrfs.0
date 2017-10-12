Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33851 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdJLInP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 04:43:15 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C8hEGA013094
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 08:43:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9C8hDgt008495
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 08:43:14 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9C8hDFt023580
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 08:43:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use need_full_stripe() in __btrfs_map_block()
Date: Thu, 12 Oct 2017 16:43:00 +0800
Message-Id: <20171012084300.4740-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A cleanup patch, use need_full_stripe() to replace the open code.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3b3ba1ecd88b..f5dee43f8f3f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5673,10 +5673,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
 		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
 				&stripe_index);
-		if (op != BTRFS_MAP_WRITE && op != BTRFS_MAP_GET_READ_MIRRORS)
+		if (!need_full_stripe(op))
 			mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
+		if (need_full_stripe(op))
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -5689,7 +5689,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS) {
+		if (need_full_stripe(op)) {
 			num_stripes = map->num_stripes;
 		} else if (mirror_num) {
 			stripe_index = mirror_num - 1;
@@ -5703,7 +5703,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 		stripe_index *= map->sub_stripes;
 
-		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
+		if (need_full_stripe(op))
 			num_stripes = map->sub_stripes;
 		else if (mirror_num)
 			stripe_index += mirror_num - 1;
@@ -5718,9 +5718,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
-		if (need_raid_map &&
-		    (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS ||
-		     mirror_num > 1)) {
+		if (need_raid_map && (need_full_stripe(op) || mirror_num > 1)) {
 			/* push stripe_nr back to the start of the full stripe */
 			stripe_nr = div64_u64(raid56_full_stripe_start,
 					stripe_len * nr_data_stripes(map));
@@ -5747,9 +5745,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			/* We distribute the parity blocks across stripes */
 			div_u64_rem(stripe_nr + stripe_index, map->num_stripes,
 					&stripe_index);
-			if ((op != BTRFS_MAP_WRITE &&
-			     op != BTRFS_MAP_GET_READ_MIRRORS) &&
-			    mirror_num <= 1)
+			if (!need_full_stripe(op) && mirror_num <= 1)
 				mirror_num = 1;
 		}
 	} else {
-- 
2.13.1

