Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44004 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeA3KU6 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 30 Jan 2018 05:20:58 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 1/2] btrfs: Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()
Date: Tue, 30 Jan 2018 18:20:45 +0800
Message-Id: <20180130102046.10586-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function __get_raid_index() is used to convert block group flags into
raid index, which can be used to get various info directly from
btrfs_raid_array[].

Refactor this function a little:

1) Rename to btrfs_bg_flags_to_raid_index()
   Double underline prefix is normally for internal functions, while the
   function is used by both extent-tree and volumes.

   Although the name is a little longer, but it should explain its usage
   quite well.

2) Move it to volumes.h and make it static inline
   Just several if-else branches, really no need to define it as a normal
   function.

   This also makes later code re-use between kernel and btrfs-progs
   easier.

3) Remove function get_block_group_index()
   Really no need to do such a simple thing as an exported function.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v2:
  Remove get_block_group_index() in this patch.
  Add extra comment for the usage of btrfs_bg_flags_to_raid_index()
---
 fs/btrfs/ctree.h       |  1 -
 fs/btrfs/extent-tree.c | 41 ++++++++++-------------------------------
 fs/btrfs/volumes.c     |  2 +-
 fs/btrfs/volumes.h     | 22 ++++++++++++++++++++++
 4 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 13c260b525a1..27249240fa3e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2629,7 +2629,6 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 u64 bytenr);
 void btrfs_get_block_group(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
-int get_block_group_index(struct btrfs_block_group_cache *cache);
 struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     u64 parent, u64 root_objectid,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2f4328511ac8..2693c8617817 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7346,29 +7346,6 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 	return ret;
 }
 
-int __get_raid_index(u64 flags)
-{
-	if (flags & BTRFS_BLOCK_GROUP_RAID10)
-		return BTRFS_RAID_RAID10;
-	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
-		return BTRFS_RAID_RAID1;
-	else if (flags & BTRFS_BLOCK_GROUP_DUP)
-		return BTRFS_RAID_DUP;
-	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
-		return BTRFS_RAID_RAID0;
-	else if (flags & BTRFS_BLOCK_GROUP_RAID5)
-		return BTRFS_RAID_RAID5;
-	else if (flags & BTRFS_BLOCK_GROUP_RAID6)
-		return BTRFS_RAID_RAID6;
-
-	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
-}
-
-int get_block_group_index(struct btrfs_block_group_cache *cache)
-{
-	return __get_raid_index(cache->flags);
-}
-
 static const char *btrfs_raid_type_names[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10]	= "raid10",
 	[BTRFS_RAID_RAID1]	= "raid1",
@@ -7483,7 +7460,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	u64 empty_cluster = 0;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
-	int index = __get_raid_index(flags);
+	int index = btrfs_bg_flags_to_raid_index(flags);
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
 	bool use_cluster = true;
@@ -7569,7 +7546,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				btrfs_put_block_group(block_group);
 				up_read(&space_info->groups_sem);
 			} else {
-				index = get_block_group_index(block_group);
+				index = btrfs_bg_flags_to_raid_index(
+						block_group->flags);
 				btrfs_lock_block_group(block_group, delalloc);
 				goto have_block_group;
 			}
@@ -7579,7 +7557,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	}
 search:
 	have_caching_bg = false;
-	if (index == 0 || index == __get_raid_index(flags))
+	if (index == 0 || index == btrfs_bg_flags_to_raid_index(flags))
 		full_search = true;
 	down_read(&space_info->groups_sem);
 	list_for_each_entry(block_group, &space_info->block_groups[index],
@@ -7837,7 +7815,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 loop:
 		failed_cluster_refill = false;
 		failed_alloc = false;
-		BUG_ON(index != get_block_group_index(block_group));
+		BUG_ON(btrfs_bg_flags_to_raid_index(block_group->flags) !=
+		       index);
 		btrfs_release_block_group(block_group, delalloc);
 		cond_resched();
 	}
@@ -9643,7 +9622,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 	 */
 	target = get_restripe_target(fs_info, block_group->flags);
 	if (target) {
-		index = __get_raid_index(extended_to_chunk(target));
+		index = btrfs_bg_flags_to_raid_index(extended_to_chunk(target));
 	} else {
 		/*
 		 * this is just a balance, so if we were marked as full
@@ -9657,7 +9636,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 			goto out;
 		}
 
-		index = get_block_group_index(block_group);
+		index = btrfs_bg_flags_to_raid_index(block_group->flags);
 	}
 
 	if (index == BTRFS_RAID_RAID10) {
@@ -9909,7 +9888,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 static void link_block_group(struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_space_info *space_info = cache->space_info;
-	int index = get_block_group_index(cache);
+	int index = btrfs_bg_flags_to_raid_index(cache->flags);
 	bool first = false;
 
 	down_write(&space_info->groups_sem);
@@ -10329,7 +10308,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 				  block_group->key.offset);
 
 	memcpy(&key, &block_group->key, sizeof(key));
-	index = get_block_group_index(block_group);
+	index = btrfs_bg_flags_to_raid_index(block_group->flags);
 	if (block_group->flags & (BTRFS_BLOCK_GROUP_DUP |
 				  BTRFS_BLOCK_GROUP_RAID1 |
 				  BTRFS_BLOCK_GROUP_RAID10))
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a25684287501..d818b1f9c625 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4625,7 +4625,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	if (list_empty(&fs_devices->alloc_list))
 		return -ENOSPC;
 
-	index = __get_raid_index(type);
+	index = btrfs_bg_flags_to_raid_index(type);
 
 	sub_stripes = btrfs_raid_array[index].sub_stripes;
 	dev_stripes = btrfs_raid_array[index].dev_stripes;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ff15208344a7..4758fd95f73d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -533,6 +533,28 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
 	btrfs_dev_stat_set(dev, index, 0);
 }
 
+/*
+ * Convert block group flags (BTRFS_BLOCK_GROUP_*) to btrfs_raid_types, which
+ * can be used as index to access btrfs_raid_array[].
+ */
+static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
+{
+	if (flags & BTRFS_BLOCK_GROUP_RAID10)
+		return BTRFS_RAID_RAID10;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
+		return BTRFS_RAID_RAID1;
+	else if (flags & BTRFS_BLOCK_GROUP_DUP)
+		return BTRFS_RAID_DUP;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
+		return BTRFS_RAID_RAID0;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID5)
+		return BTRFS_RAID_RAID5;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID6)
+		return BTRFS_RAID_RAID6;
+
+	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
+}
+
 void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
 void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_info,
 					struct btrfs_transaction *transaction);
-- 
2.16.1

