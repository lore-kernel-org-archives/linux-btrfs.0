Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2359 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab3APLck (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 06:32:40 -0500
Message-ID: <50F68FFB.3050806@cn.fujitsu.com>
Date: Wed, 16 Jan 2013 19:33:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH 2/2] Btrfs: make raid attr array more readable
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As the title said, this patch just make raid attr array more readable.

Cc: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 10 +++++++++-
 fs/btrfs/extent-tree.c | 22 +++++++++-------------
 fs/btrfs/volumes.c     | 47 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9ee099f..541ce9a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -953,7 +953,15 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
-#define BTRFS_NR_RAID_TYPES		5
+
+enum btrfs_raid_types {
+	BTRFS_RAID_RAID10,
+	BTRFS_RAID_RAID1,
+	BTRFS_RAID_DUP,
+	BTRFS_RAID_RAID0,
+	BTRFS_RAID_SINGLE,
+	BTRFS_NR_RAID_TYPES
+};
 
 #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
 					 BTRFS_BLOCK_GROUP_SYSTEM |  \
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e68585d..6de0621 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5547,20 +5547,16 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 
 int __get_raid_index(u64 flags)
 {
-	int index;
-
 	if (flags & BTRFS_BLOCK_GROUP_RAID10)
-		index = 0;
+		return BTRFS_RAID_RAID10;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
-		index = 1;
+		return BTRFS_RAID_RAID1;
 	else if (flags & BTRFS_BLOCK_GROUP_DUP)
-		index = 2;
+		return BTRFS_RAID_DUP;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
-		index = 3;
+		return BTRFS_RAID_RAID0;
 	else
-		index = 4;
-
-	return index;
+		return BTRFS_RAID_SINGLE;
 }
 
 static int get_block_group_index(struct btrfs_block_group_cache *cache)
@@ -7520,16 +7516,16 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		index = get_block_group_index(block_group);
 	}
 
-	if (index == 0) {
+	if (index == BTRFS_RAID_RAID10) {
 		dev_min = 4;
 		/* Divide by 2 */
 		min_free >>= 1;
-	} else if (index == 1) {
+	} else if (index == BTRFS_RAID_RAID1) {
 		dev_min = 2;
-	} else if (index == 2) {
+	} else if (index == BTRFS_RAID_DUP) {
 		/* Multiply by 2 */
 		min_free <<= 1;
-	} else if (index == 3) {
+	} else if (index == BTRFS_RAID_RAID0) {
 		dev_min = fs_devices->rw_devices;
 		do_div(min_free, dev_min);
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7fa9773..edc5ee3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3492,13 +3492,48 @@ static int btrfs_cmp_device_info(const void *a, const void *b)
 }
 
 struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
-	{ 2, 1, 0, 4, 2, 2 /* raid10 */ },
-	{ 1, 1, 2, 2, 2, 2 /* raid1 */ },
-	{ 1, 2, 1, 1, 1, 2 /* dup */ },
-	{ 1, 1, 0, 2, 1, 1 /* raid0 */ },
-	{ 1, 1, 1, 1, 1, 1 /* single */ },
+	[BTRFS_RAID_RAID10] = {
+		.sub_stripes	= 2,
+		.dev_stripes	= 1,
+		.devs_max	= 0,	/* 0 == as many as possible */
+		.devs_min	= 4,
+		.devs_increment	= 2,
+		.ncopies	= 2,
+	},
+	[BTRFS_RAID_RAID1] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 2,
+		.devs_min	= 2,
+		.devs_increment	= 2,
+		.ncopies	= 2,
+	},
+	[BTRFS_RAID_DUP] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 2,
+		.devs_max	= 1,
+		.devs_min	= 1,
+		.devs_increment	= 1,
+		.ncopies	= 2,
+	},
+	[BTRFS_RAID_RAID0] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 2,
+		.devs_increment	= 1,
+		.ncopies	= 1,
+	},
+	[BTRFS_RAID_RAID0] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 1,
+		.devs_min	= 1,
+		.devs_increment	= 1,
+		.ncopies	= 1,
+	},
 };
-
+ 
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *extent_root,
 			       struct map_lookup **map_ret,
-- 
1.7.11.7
