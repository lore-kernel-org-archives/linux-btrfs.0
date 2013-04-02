Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59608 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640Ab3DBQmb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 12:42:31 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 600917C068C
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2013 10:42:31 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id UuWBzDLexpU1AZTB (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 10:42:29 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix error handling in make/read block group
Date: Tue, 2 Apr 2013 12:42:27 -0400
Message-ID: <1364920947-3190-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed that we will add a block group to the space info before we add it to
the block group cache rb tree, so we could potentially allocate from the block
group before it's able to be searched for.  I don't think this is too much of
a problem, the race window is microscopic, but just in case move the tree
insertion to above the space info linking.  This makes it easier to adjust the
error handling as well, so we can remove a couple of BUG_ON(ret)'s and have real
error handling setup for these scenarios.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   41 +++++++++++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5791da2..68f928f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8192,10 +8192,26 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			free_excluded_extents(root, cache);
 		}
 
+		ret = btrfs_add_block_group_cache(root->fs_info, cache);
+		if (ret) {
+			btrfs_remove_free_space_cache(cache);
+			btrfs_put_block_group(cache);
+			goto error;
+		}
+
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
 					&space_info);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_remove_free_space_cache(cache);
+			spin_lock(&info->block_group_cache_lock);
+			rb_erase(&cache->cache_node,
+				 &info->block_group_cache_tree);
+			spin_unlock(&info->block_group_cache_lock);
+			btrfs_put_block_group(cache);
+			goto error;
+		}
+
 		cache->space_info = space_info;
 		spin_lock(&cache->space_info->lock);
 		cache->space_info->bytes_readonly += cache->bytes_super;
@@ -8203,9 +8219,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		__link_block_group(space_info, cache);
 
-		ret = btrfs_add_block_group_cache(root->fs_info, cache);
-		BUG_ON(ret); /* Logic error */
-
 		set_avail_alloc_bits(root->fs_info, cache->flags);
 		if (btrfs_chunk_readonly(root, cache->key.objectid))
 			set_block_group_ro(cache, 1);
@@ -8328,9 +8341,24 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	free_excluded_extents(root, cache);
 
+	ret = btrfs_add_block_group_cache(root->fs_info, cache);
+	if (ret) {
+		btrfs_remove_free_space_cache(cache);
+		btrfs_put_block_group(cache);
+		return ret;
+	}
+
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
-	BUG_ON(ret); /* -ENOMEM */
+	if (ret) {
+		btrfs_remove_free_space_cache(cache);
+		spin_lock(&root->fs_info->block_group_cache_lock);
+		rb_erase(&cache->cache_node,
+			 &root->fs_info->block_group_cache_tree);
+		spin_unlock(&root->fs_info->block_group_cache_lock);
+		btrfs_put_block_group(cache);
+		return ret;
+	}
 	update_global_block_rsv(root->fs_info);
 
 	spin_lock(&cache->space_info->lock);
@@ -8339,9 +8367,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	__link_block_group(cache->space_info, cache);
 
-	ret = btrfs_add_block_group_cache(root->fs_info, cache);
-	BUG_ON(ret); /* Logic error */
-
 	list_add_tail(&cache->new_bg_list, &trans->new_bgs);
 
 	set_avail_alloc_bits(extent_root->fs_info, type);
-- 
1.7.7.6

