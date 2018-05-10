Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935534AbeEJMpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 70589AF04
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/17] btrfs: Remove fs_info argument from add_new_free_space
Date: Thu, 10 May 2018 15:44:45 +0300
Message-Id: <1525956296-32118-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function also takes a btrfs_block_group_cache which contains a
referene to the fs_info. So use that and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h           |  2 +-
 fs/btrfs/extent-tree.c     | 13 ++++++-------
 fs/btrfs/free-space-tree.c |  8 +++-----
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5b7080d2fbff..55e56b368216 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2832,7 +2832,7 @@ void btrfs_wait_for_snapshot_creation(struct btrfs_root *root);
 void check_system_chunk(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, const u64 type);
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
-		       struct btrfs_fs_info *info, u64 start, u64 end);
+		       u64 start, u64 end);
 
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1d3140ce34f0..02948c81ebe0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -343,8 +343,9 @@ static void fragment_free_space(struct btrfs_block_group_cache *block_group)
  * since their free space will be released as soon as the transaction commits.
  */
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
-		       struct btrfs_fs_info *info, u64 start, u64 end)
+		       u64 start, u64 end)
 {
+	struct btrfs_fs_info *info = block_group->fs_info;
 	u64 extent_start, extent_end, size, total_added = 0;
 	int ret;
 
@@ -489,8 +490,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 
 		if (key.type == BTRFS_EXTENT_ITEM_KEY ||
 		    key.type == BTRFS_METADATA_ITEM_KEY) {
-			total_found += add_new_free_space(block_group,
-							  fs_info, last,
+			total_found += add_new_free_space(block_group, last,
 							  key.objectid);
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
 				last = key.objectid +
@@ -508,7 +508,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 	}
 	ret = 0;
 
-	total_found += add_new_free_space(block_group, fs_info, last,
+	total_found += add_new_free_space(block_group, last,
 					  block_group->key.objectid +
 					  block_group->key.offset);
 	caching_ctl->progress = (u64)-1;
@@ -10161,8 +10161,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		} else if (btrfs_block_group_used(&cache->item) == 0) {
 			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
-			add_new_free_space(cache, info,
-					   found_key.objectid,
+			add_new_free_space(cache, found_key.objectid,
 					   found_key.objectid +
 					   found_key.offset);
 			free_excluded_extents(info, cache);
@@ -10299,7 +10298,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	add_new_free_space(cache, fs_info, chunk_offset, chunk_offset + size);
+	add_new_free_space(cache, chunk_offset, chunk_offset + size);
 
 	free_excluded_extents(fs_info, cache);
 
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 4b687e2f97aa..ecf07fdcf2d8 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1438,7 +1438,6 @@ static int load_free_space_bitmaps(struct btrfs_caching_control *caching_ctl,
 				extent_start = offset;
 			} else if (prev_bit == 1 && bit == 0) {
 				total_found += add_new_free_space(block_group,
-								  fs_info,
 								  extent_start,
 								  offset);
 				if (total_found > CACHING_CTL_WAKE_UP) {
@@ -1452,8 +1451,8 @@ static int load_free_space_bitmaps(struct btrfs_caching_control *caching_ctl,
 		}
 	}
 	if (prev_bit == 1) {
-		total_found += add_new_free_space(block_group, fs_info,
-						  extent_start, end);
+		total_found += add_new_free_space(block_group, extent_start,
+						  end);
 		extent_count++;
 	}
 
@@ -1510,8 +1509,7 @@ static int load_free_space_extents(struct btrfs_caching_control *caching_ctl,
 
 		caching_ctl->progress = key.objectid;
 
-		total_found += add_new_free_space(block_group, fs_info,
-						  key.objectid,
+		total_found += add_new_free_space(block_group, key.objectid,
 						  key.objectid + key.offset);
 		if (total_found > CACHING_CTL_WAKE_UP) {
 			total_found = 0;
-- 
2.7.4

