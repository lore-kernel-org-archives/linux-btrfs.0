Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2241 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964989AbaLKIeL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 03:34:11 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <kreijack@inwind.it>, <1i5t5.duncan@cox.net>, <rwhite@pobox.com>,
        <lists@colorremedies.com>
CC: <linux-btrfs@vger.kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/3] Btrfs: raid56: simplify the parameter of nr_parity_stripes().
Date: Thu, 11 Dec 2014 16:31:24 +0800
Message-ID: <e6e28a35915d9bb147edb3b8767d27d10ab78ac3.1418203063.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We just need the type of a chunk to calculate the number of parity stripes,
but we have to pass a structure of lookup_map to it. This will prevent some
callers to use it where there is no a convenient lookup_map to be passed.

This patch replace the parameter of struct map_lookup * with a profile type.
Then we can use it more easily.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/raid56.h  | 8 ++++----
 fs/btrfs/volumes.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index ea5d73b..68ac9d3 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -19,11 +19,11 @@
 
 #ifndef __BTRFS_RAID56__
 #define __BTRFS_RAID56__
-static inline int nr_parity_stripes(struct map_lookup *map)
+static inline int nr_parity_stripes(u64 type)
 {
-	if (map->type & BTRFS_BLOCK_GROUP_RAID5)
+	if (type & BTRFS_BLOCK_GROUP_RAID5)
 		return 1;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
+	else if (type & BTRFS_BLOCK_GROUP_RAID6)
 		return 2;
 	else
 		return 0;
@@ -31,7 +31,7 @@ static inline int nr_parity_stripes(struct map_lookup *map)
 
 static inline int nr_data_stripes(struct map_lookup *map)
 {
-	return map->num_stripes - nr_parity_stripes(map);
+	return map->num_stripes - nr_parity_stripes(map->type);
 }
 #define RAID5_P_STRIPE ((u64)-2)
 #define RAID6_Q_STRIPE ((u64)-1)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f61278f..aa3a907 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5174,7 +5174,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 			/* RAID[56] write or recovery. Return all stripes */
 			num_stripes = map->num_stripes;
-			max_errors = nr_parity_stripes(map);
+			max_errors = nr_parity_stripes(map->type);
 
 			raid_map = kmalloc_array(num_stripes, sizeof(u64),
 					   GFP_NOFS);
-- 
1.8.4.2

