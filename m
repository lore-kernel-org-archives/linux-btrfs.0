Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34084 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbcCYR0H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:07 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2PHKiAX024622
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:06 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 21w9720517-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:06 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/14] Btrfs: add bytes_readonly to the spaceinfo at once
Date: Fri, 25 Mar 2016 13:25:47 -0400
Message-ID: <1458926760-17563-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For some reason we're adding bytes_readonly to the space info after we update
the space info with the block group info.  This creates a tiny race where we
could over-reserve space because we haven't yet taken out the bytes_readonly
bit.  Since we already know this information at the time we call
update_space_info, just pass it along so it can be updated all at once.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 53e1297..c357c96 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3843,6 +3843,7 @@ static const char *alloc_name(u64 flags)
 
 static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
+			     u64 bytes_readonly,
 			     struct btrfs_space_info **space_info)
 {
 	struct btrfs_space_info *found;
@@ -3863,6 +3864,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		found->disk_total += total_bytes * factor;
 		found->bytes_used += bytes_used;
 		found->disk_used += bytes_used * factor;
+		found->bytes_readonly += bytes_readonly;
 		if (total_bytes > 0)
 			found->full = 0;
 		spin_unlock(&found->lock);
@@ -3890,7 +3892,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	found->disk_used = bytes_used * factor;
 	found->bytes_pinned = 0;
 	found->bytes_reserved = 0;
-	found->bytes_readonly = 0;
+	found->bytes_readonly = bytes_readonly;
 	found->bytes_may_use = 0;
 	found->full = 0;
 	found->max_extent_size = 0;
@@ -4400,7 +4402,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	space_info = __find_space_info(extent_root->fs_info, flags);
 	if (!space_info) {
 		ret = update_space_info(extent_root->fs_info, flags,
-					0, 0, &space_info);
+					0, 0, 0, &space_info);
 		BUG_ON(ret); /* -ENOMEM */
 	}
 	BUG_ON(!space_info); /* Logic error */
@@ -9862,7 +9864,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
-					&space_info);
+					cache->bytes_super, &space_info);
 		if (ret) {
 			btrfs_remove_free_space_cache(cache);
 			spin_lock(&info->block_group_cache_lock);
@@ -9875,9 +9877,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		}
 
 		cache->space_info = space_info;
-		spin_lock(&cache->space_info->lock);
-		cache->space_info->bytes_readonly += cache->bytes_super;
-		spin_unlock(&cache->space_info->lock);
 
 		__link_block_group(space_info, cache);
 
@@ -9969,7 +9968,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	int ret;
 	struct btrfs_root *extent_root;
 	struct btrfs_block_group_cache *cache;
-
 	extent_root = root->fs_info->extent_root;
 
 	btrfs_set_log_full_commit(root->fs_info, trans);
@@ -10015,7 +10013,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	 * assigned to our block group, but don't update its counters just yet.
 	 * We want our bg to be added to the rbtree with its ->space_info set.
 	 */
-	ret = update_space_info(root->fs_info, cache->flags, 0, 0,
+	ret = update_space_info(root->fs_info, cache->flags, 0, 0, 0,
 				&cache->space_info);
 	if (ret) {
 		btrfs_remove_free_space_cache(cache);
@@ -10035,7 +10033,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	 * the rbtree, update the space info's counters.
 	 */
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
-				&cache->space_info);
+				cache->bytes_super, &cache->space_info);
 	if (ret) {
 		btrfs_remove_free_space_cache(cache);
 		spin_lock(&root->fs_info->block_group_cache_lock);
@@ -10048,16 +10046,11 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	}
 	update_global_block_rsv(root->fs_info);
 
-	spin_lock(&cache->space_info->lock);
-	cache->space_info->bytes_readonly += cache->bytes_super;
-	spin_unlock(&cache->space_info->lock);
-
 	__link_block_group(cache->space_info, cache);
 
 	list_add_tail(&cache->bg_list, &trans->new_bgs);
 
 	set_avail_alloc_bits(extent_root->fs_info, type);
-
 	return 0;
 }
 
@@ -10602,21 +10595,21 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
 		mixed = 1;
 
 	flags = BTRFS_BLOCK_GROUP_SYSTEM;
-	ret = update_space_info(fs_info, flags, 0, 0, &space_info);
+	ret = update_space_info(fs_info, flags, 0, 0, 0, &space_info);
 	if (ret)
 		goto out;
 
 	if (mixed) {
 		flags = BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA;
-		ret = update_space_info(fs_info, flags, 0, 0, &space_info);
+		ret = update_space_info(fs_info, flags, 0, 0, 0, &space_info);
 	} else {
 		flags = BTRFS_BLOCK_GROUP_METADATA;
-		ret = update_space_info(fs_info, flags, 0, 0, &space_info);
+		ret = update_space_info(fs_info, flags, 0, 0, 0, &space_info);
 		if (ret)
 			goto out;
 
 		flags = BTRFS_BLOCK_GROUP_DATA;
-		ret = update_space_info(fs_info, flags, 0, 0, &space_info);
+		ret = update_space_info(fs_info, flags, 0, 0, 0, &space_info);
 	}
 out:
 	return ret;
-- 
2.5.0

