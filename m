From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not loop through raid types when looking for free extent
Date: Tue, 16 Nov 2010 16:22:04 -0500
Message-ID: <1289942524-29637-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is a bug in find_free_extent where if we don't find a free extent in the
raid type we are looking for, we loop through to the next raid type.  This is
not ok since we need to make sure we honor the raid types we are given.  So
instead kill this check and get the proper index for the raid type we want from
the allocator.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0c097f3..a917e3c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4785,16 +4785,16 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 	return 0;
 }
 
-static int get_block_group_index(struct btrfs_block_group_cache *cache)
+static int get_block_group_index(u64 flags)
 {
 	int index;
-	if (cache->flags & BTRFS_BLOCK_GROUP_RAID10)
+	if (flags & BTRFS_BLOCK_GROUP_RAID10)
 		index = 0;
-	else if (cache->flags & BTRFS_BLOCK_GROUP_RAID1)
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
 		index = 1;
-	else if (cache->flags & BTRFS_BLOCK_GROUP_DUP)
+	else if (flags & BTRFS_BLOCK_GROUP_DUP)
 		index = 2;
-	else if (cache->flags & BTRFS_BLOCK_GROUP_RAID0)
+	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
 		index = 3;
 	else
 		index = 4;
@@ -4834,7 +4834,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_space_info *space_info;
 	int last_ptr_loop = 0;
 	int loop = 0;
-	int index = 0;
+	int index = get_block_group_index(data);
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
@@ -4913,7 +4913,6 @@ ideal_cache:
 				btrfs_put_block_group(block_group);
 				up_read(&space_info->groups_sem);
 			} else {
-				index = get_block_group_index(block_group);
 				goto have_block_group;
 			}
 		} else if (block_group) {
@@ -5145,14 +5144,11 @@ checks:
 loop:
 		failed_cluster_refill = false;
 		failed_alloc = false;
-		BUG_ON(index != get_block_group_index(block_group));
+		BUG_ON(index != get_block_group_index(block_group->flags));
 		btrfs_put_block_group(block_group);
 	}
 	up_read(&space_info->groups_sem);
 
-	if (!ins->objectid && ++index < BTRFS_NR_RAID_TYPES)
-		goto search;
-
 	/* LOOP_FIND_IDEAL, only search caching/cached bg's, and don't wait for
 	 *			for them to make caching progress.  Also
 	 *			determine the best possible bg to cache
@@ -8204,7 +8200,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 static void __link_block_group(struct btrfs_space_info *space_info,
 			       struct btrfs_block_group_cache *cache)
 {
-	int index = get_block_group_index(cache);
+	int index = get_block_group_index(cache->flags);
 
 	down_write(&space_info->groups_sem);
 	list_add_tail(&cache->list, &space_info->block_groups[index]);
-- 
1.6.6.1

