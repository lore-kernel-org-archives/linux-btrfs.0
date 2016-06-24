Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbcFXWPc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6EC2CADE7
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:28 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 26/31] btrfs: root->fs_info cleanup, update_block_group{,flags}
Date: Fri, 24 Jun 2016 18:15:19 -0400
Message-Id: <1466806524-27508-27-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 14f4d05..bc56e04 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -76,7 +76,7 @@ enum {
 };
 
 static int update_block_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root, u64 bytenr,
+			      struct btrfs_fs_info *fs_info, u64 bytenr,
 			      u64 num_bytes, int alloc);
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -5971,11 +5971,10 @@ void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len)
 }
 
 static int update_block_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root, u64 bytenr,
+			      struct btrfs_fs_info *info, u64 bytenr,
 			      u64 num_bytes, int alloc)
 {
 	struct btrfs_block_group_cache *cache = NULL;
-	struct btrfs_fs_info *info = root->fs_info;
 	u64 total = num_bytes;
 	u64 old_val;
 	u64 byte_in_group;
@@ -6016,7 +6015,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		spin_lock(&cache->space_info->lock);
 		spin_lock(&cache->lock);
 
-		if (btrfs_test_opt(root->fs_info, SPACE_CACHE) &&
+		if (btrfs_test_opt(info, SPACE_CACHE) &&
 		    cache->disk_cache_state < BTRFS_DC_CLEAR)
 			cache->disk_cache_state = BTRFS_DC_CLEAR;
 
@@ -6848,7 +6847,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 
-		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
+		ret = update_block_group(trans, root->fs_info, bytenr,
+					 num_bytes, 0);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -7866,7 +7866,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
+	ret = update_block_group(trans, fs_info, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
 			ins->objectid, ins->offset);
@@ -7952,9 +7952,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	ret = update_block_group(trans, root, ins->objectid,
-				 root->fs_info->nodesize,
-				 1);
+	ret = update_block_group(trans, fs_info, ins->objectid,
+				 fs_info->nodesize, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
 			ins->objectid, ins->offset);
@@ -9262,7 +9261,7 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
+static u64 update_block_group_flags(struct btrfs_fs_info *fs_info, u64 flags)
 {
 	u64 num_devices;
 	u64 stripped;
@@ -9271,11 +9270,11 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 	 * if restripe for this chunk_type is on pick target profile and
 	 * return, otherwise do the usual balance
 	 */
-	stripped = get_restripe_target(root->fs_info, flags);
+	stripped = get_restripe_target(fs_info, flags);
 	if (stripped)
 		return extended_to_chunk(stripped);
 
-	num_devices = root->fs_info->fs_devices->rw_devices;
+	num_devices = fs_info->fs_devices->rw_devices;
 
 	stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
@@ -9391,7 +9390,7 @@ again:
 	 * if we are changing raid levels, try to allocate a corresponding
 	 * block group with the new raid level.
 	 */
-	alloc_flags = update_block_group_flags(root, cache->flags);
+	alloc_flags = update_block_group_flags(root->fs_info, cache->flags);
 	if (alloc_flags != cache->flags) {
 		ret = do_chunk_alloc(trans, root, alloc_flags,
 				     CHUNK_ALLOC_FORCE);
@@ -9417,7 +9416,8 @@ again:
 	ret = inc_block_group_ro(cache, 0);
 out:
 	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
-		alloc_flags = update_block_group_flags(root, cache->flags);
+		alloc_flags = update_block_group_flags(root->fs_info,
+						       cache->flags);
 		lock_chunks(root->fs_info);
 		check_system_chunk(trans, root, alloc_flags);
 		unlock_chunks(root->fs_info);
-- 
2.7.1

