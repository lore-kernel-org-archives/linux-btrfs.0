Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751046AbdGMIhu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 04:37:50 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CFD4ABDE
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 08:37:49 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Remove find_raid56_stripe_len
Date: Thu, 13 Jul 2017 11:37:43 +0300
Message-Id: <1499935063-24401-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1499935063-24401-1-git-send-email-nborisov@suse.com>
References: <1499935063-24401-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_raid56_stripe_len statically returns SZ_64K which equals BTRFS_STRIPE_LEN.
It's sole caller is __btrfs_alloc_chunk and it assigns the return value to ai
variable which is already set to BTRFS_STRIPE_LEN. So remove the function
invocation altogether and remove the function itself. Also remove the variable
since it's only aliasing BTRFS_STRIPE_LEN and use the define directly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 171a8e79332f..8d7c28a95a90 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4594,12 +4594,6 @@ static int btrfs_cmp_device_info(const void *a, const void *b)
 	return 0;
 }
 
-static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
-{
-	/* TODO allow them to set a preferred stripe size */
-	return SZ_64K;
-}
-
 static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 {
 	if (!(type & BTRFS_BLOCK_GROUP_RAID56_MASK))
@@ -4642,7 +4636,6 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	u64 max_chunk_size;
 	u64 stripe_size;
 	u64 num_bytes;
-	u64 raid_stripe_len = BTRFS_STRIPE_LEN;
 	int ndevs;
 	int i;
 	int j;
@@ -4784,16 +4777,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	 */
 	data_stripes = num_stripes / ncopies;
 
-	if (type & BTRFS_BLOCK_GROUP_RAID5) {
-		raid_stripe_len = find_raid56_stripe_len(ndevs - 1,
-							 info->stripesize);
+	if (type & BTRFS_BLOCK_GROUP_RAID5)
 		data_stripes = num_stripes - 1;
-	}
-	if (type & BTRFS_BLOCK_GROUP_RAID6) {
-		raid_stripe_len = find_raid56_stripe_len(ndevs - 2,
-							 info->stripesize);
+
+	if (type & BTRFS_BLOCK_GROUP_RAID6)
 		data_stripes = num_stripes - 2;
-	}
 
 	/*
 	 * Use the number of data stripes to figure out how big this chunk
@@ -4818,8 +4806,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	stripe_size = div_u64(stripe_size, dev_stripes);
 
 	/* align to BTRFS_STRIPE_LEN */
-	stripe_size = div64_u64(stripe_size, raid_stripe_len);
-	stripe_size *= raid_stripe_len;
+	stripe_size = div64_u64(stripe_size, BTRFS_STRIPE_LEN);
+	stripe_size *= BTRFS_STRIPE_LEN;
 
 	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map) {
@@ -4837,9 +4825,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		}
 	}
 	map->sector_size = info->sectorsize;
-	map->stripe_len = raid_stripe_len;
-	map->io_align = raid_stripe_len;
-	map->io_width = raid_stripe_len;
+	map->stripe_len = BTRFS_STRIPE_LEN;
+	map->io_align = BTRFS_STRIPE_LEN;
+	map->io_width = BTRFS_STRIPE_LEN;
 	map->type = type;
 	map->sub_stripes = sub_stripes;
 
-- 
2.7.4

