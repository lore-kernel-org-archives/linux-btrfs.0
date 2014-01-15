Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51858 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaAOL7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 06:59:37 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0FBxSSO003393
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 19:59:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] Btrfs: cleanup the redundant code for the block group allocation and init
Date: Wed, 15 Jan 2014 20:00:55 +0800
Message-Id: <1389787258-10865-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 94 +++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 50 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 45d98d0..69a79ed 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8362,6 +8362,41 @@ static void __link_block_group(struct btrfs_space_info *space_info,
 	up_write(&space_info->groups_sem);
 }
 
+static struct btrfs_block_group_cache *
+btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
+{
+	struct btrfs_block_group_cache *cache;
+
+	cache = kzalloc(sizeof(*cache), GFP_NOFS);
+	if (!cache)
+		return NULL;
+
+	cache->free_space_ctl = kzalloc(sizeof(*cache->free_space_ctl),
+					GFP_NOFS);
+	if (!cache->free_space_ctl) {
+		kfree(cache);
+		return NULL;
+	}
+
+	cache->key.objectid = start;
+	cache->key.offset = size;
+	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+
+	cache->sectorsize = root->sectorsize;
+	cache->fs_info = root->fs_info;
+	cache->full_stripe_len = btrfs_full_stripe_len(root,
+					       &root->fs_info->mapping_tree,
+					       start);
+	atomic_set(&cache->count, 1);
+	spin_lock_init(&cache->lock);
+	INIT_LIST_HEAD(&cache->list);
+	INIT_LIST_HEAD(&cache->cluster_list);
+	INIT_LIST_HEAD(&cache->new_bg_list);
+	btrfs_init_free_space_ctl(cache);
+
+	return cache;
+}
+
 int btrfs_read_block_groups(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
@@ -8397,26 +8432,16 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			break;
 		if (ret != 0)
 			goto error;
+
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-		cache = kzalloc(sizeof(*cache), GFP_NOFS);
+
+		cache = btrfs_create_block_group_cache(root, found_key.objectid,
+						       found_key.offset);
 		if (!cache) {
 			ret = -ENOMEM;
 			goto error;
 		}
-		cache->free_space_ctl = kzalloc(sizeof(*cache->free_space_ctl),
-						GFP_NOFS);
-		if (!cache->free_space_ctl) {
-			kfree(cache);
-			ret = -ENOMEM;
-			goto error;
-		}
-
-		atomic_set(&cache->count, 1);
-		spin_lock_init(&cache->lock);
-		cache->fs_info = info;
-		INIT_LIST_HEAD(&cache->list);
-		INIT_LIST_HEAD(&cache->cluster_list);
 
 		if (need_clear) {
 			/*
@@ -8437,16 +8462,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
 				   sizeof(cache->item));
-		memcpy(&cache->key, &found_key, sizeof(found_key));
+		cache->flags = btrfs_block_group_flags(&cache->item);
 
 		key.objectid = found_key.objectid + found_key.offset;
 		btrfs_release_path(path);
-		cache->flags = btrfs_block_group_flags(&cache->item);
-		cache->sectorsize = root->sectorsize;
-		cache->full_stripe_len = btrfs_full_stripe_len(root,
-					       &root->fs_info->mapping_tree,
-					       found_key.objectid);
-		btrfs_init_free_space_ctl(cache);
 
 		/*
 		 * We need to exclude the super stripes now so that the space
@@ -8460,8 +8479,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			 * case.
 			 */
 			free_excluded_extents(root, cache);
-			kfree(cache->free_space_ctl);
-			kfree(cache);
+			btrfs_put_block_group(cache);
 			goto error;
 		}
 
@@ -8592,38 +8610,15 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	root->fs_info->last_trans_log_full_commit = trans->transid;
 
-	cache = kzalloc(sizeof(*cache), GFP_NOFS);
+	cache = btrfs_create_block_group_cache(root, chunk_offset, size);
 	if (!cache)
 		return -ENOMEM;
-	cache->free_space_ctl = kzalloc(sizeof(*cache->free_space_ctl),
-					GFP_NOFS);
-	if (!cache->free_space_ctl) {
-		kfree(cache);
-		return -ENOMEM;
-	}
-
-	cache->key.objectid = chunk_offset;
-	cache->key.offset = size;
-	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	cache->sectorsize = root->sectorsize;
-	cache->fs_info = root->fs_info;
-	cache->full_stripe_len = btrfs_full_stripe_len(root,
-					       &root->fs_info->mapping_tree,
-					       chunk_offset);
-
-	atomic_set(&cache->count, 1);
-	spin_lock_init(&cache->lock);
-	INIT_LIST_HEAD(&cache->list);
-	INIT_LIST_HEAD(&cache->cluster_list);
-	INIT_LIST_HEAD(&cache->new_bg_list);
-
-	btrfs_init_free_space_ctl(cache);
 
 	btrfs_set_block_group_used(&cache->item, bytes_used);
 	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
-	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
+	cache->flags = type;
 	cache->last_byte_to_unpin = (u64)-1;
 	cache->cached = BTRFS_CACHE_FINISHED;
 	ret = exclude_super_stripes(root, cache);
@@ -8633,8 +8628,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 		 * case.
 		 */
 		free_excluded_extents(root, cache);
-		kfree(cache->free_space_ctl);
-		kfree(cache);
+		btrfs_put_block_group(cache);
 		return ret;
 	}
 
-- 
1.8.3.1

