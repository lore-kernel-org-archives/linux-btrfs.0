Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26439 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2KUOTw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Nov 2012 09:19:52 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jansen@webgods.de
Subject: [PATCH] Btrfs: put raid properties into global table
Date: Wed, 21 Nov 2012 22:18:10 +0800
Message-Id: <1353507490-7604-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Raid properties can be shared among raid calculation code, we can put
them into a global table to keep it simple.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/extent-tree.c |    6 +++---
 fs/btrfs/volumes.c     |   46 ++++++++++++++++------------------------------
 fs/btrfs/volumes.h     |    9 +++++++++
 4 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c72ead8..52af255 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2955,6 +2955,7 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range);
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
 int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
+int __get_raid_index(u64 flags);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3e2c1..bb0f0b1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5466,7 +5466,7 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 	return 0;
 }
 
-static int __get_block_group_index(u64 flags)
+int __get_raid_index(u64 flags)
 {
 	int index;
 
@@ -5486,7 +5486,7 @@ static int __get_block_group_index(u64 flags)
 
 static int get_block_group_index(struct btrfs_block_group_cache *cache)
 {
-	return __get_block_group_index(cache->flags);
+	return __get_raid_index(cache->flags);
 }
 
 enum btrfs_loop_type {
@@ -7427,7 +7427,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	 */
 	target = get_restripe_target(root->fs_info, block_group->flags);
 	if (target) {
-		index = __get_block_group_index(extended_to_chunk(target));
+		index = __get_raid_index(extended_to_chunk(target));
 	} else {
 		/*
 		 * this is just a balance, so if we were marked as full
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0f5ebb7..b701fa4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3235,6 +3235,14 @@ static int btrfs_cmp_device_info(const void *a, const void *b)
 	return 0;
 }
 
+struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
+	{ 2, 1, 0, 4, 2, 2 /* raid10 */ },
+	{ 1, 1, 2, 2, 2, 2 /* raid1 */ },
+	{ 1, 2, 1, 1, 1, 2 /* dup */ },
+	{ 1, 1, 0, 2, 1, 1 /* raid0 */ },
+	{ 1, 1, 0, 1, 1, 1 /* single */ },
+};
+
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *extent_root,
 			       struct map_lookup **map_ret,
@@ -3264,43 +3272,21 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int ndevs;
 	int i;
 	int j;
+	int index;
 
 	BUG_ON(!alloc_profile_is_valid(type, 0));
 
 	if (list_empty(&fs_devices->alloc_list))
 		return -ENOSPC;
 
-	sub_stripes = 1;
-	dev_stripes = 1;
-	devs_increment = 1;
-	ncopies = 1;
-	devs_max = 0;	/* 0 == as many as possible */
-	devs_min = 1;
+	index = __get_raid_index(type);
 
-	/*
-	 * define the properties of each RAID type.
-	 * FIXME: move this to a global table and use it in all RAID
-	 * calculation code
-	 */
-	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
-		dev_stripes = 2;
-		ncopies = 2;
-		devs_max = 1;
-	} else if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
-		devs_min = 2;
-	} else if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
-		devs_increment = 2;
-		ncopies = 2;
-		devs_max = 2;
-		devs_min = 2;
-	} else if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-		sub_stripes = 2;
-		devs_increment = 2;
-		ncopies = 2;
-		devs_min = 4;
-	} else {
-		devs_max = 1;
-	}
+	sub_stripes = btrfs_raid_array[index].sub_stripes;
+	dev_stripes = btrfs_raid_array[index].dev_stripes;
+	devs_max = btrfs_raid_array[index].devs_max;
+	devs_min = btrfs_raid_array[index].devs_min;
+	devs_increment = btrfs_raid_array[index].devs_increment;
+	ncopies = btrfs_raid_array[index].ncopies;
 
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_stripe_size = 1024 * 1024 * 1024;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 53c06af..4a06901 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -179,6 +179,15 @@ struct btrfs_device_info {
 	u64 total_avail;
 };
 
+struct btrfs_raid_attr {
+	int sub_stripes;	/* sub_stripes info for map */
+	int dev_stripes;	/* stripes per dev */
+	int devs_max;		/* max devs to use */
+	int devs_min;		/* min devs needed */
+	int devs_increment;	/* ndevs has to be a multiple of this */
+	int ncopies;		/* how many copies to data has */
+};
+
 struct map_lookup {
 	u64 type;
 	int io_align;
-- 
1.7.7.6

