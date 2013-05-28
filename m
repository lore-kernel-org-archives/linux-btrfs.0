Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60013 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3E1Su3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 14:50:29 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9DF9E7C0428
	for <linux-btrfs@vger.kernel.org>; Tue, 28 May 2013 12:50:28 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 5s8JBMsWghmHJaXt (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 28 May 2013 12:50:27 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: set the free space control unit properly
Date: Tue, 28 May 2013 14:50:25 -0400
Message-ID: <1369767025-16263-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan pointed out that xfstests generic/013 was failing because the free space
cache checker was complaining with leafsize of 16k.  Turns out this is because
we were unconditionally using root->sectorsize as the free space ctl unit in the
kernel, which doesn't work out if leafsize != sectorsize.  This caused the in
memory free space cache to get screwed up which translated to a wrong space
cache on disk.  This patch fixes the problem by not carrying the sectorsize in
the block group since we have the ctl->unit, and we set the ctl->unit according
to the type of block group we are.  This made generic/013 pass with 16k
leafsize, whereas before it failed every single time.  Thanks,

Cc: stable@vger.kernel.org
Reported-by: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h            |    1 -
 fs/btrfs/extent-tree.c      |    7 ++-----
 fs/btrfs/free-space-cache.c |   32 +++++++++++++++++++++++++-------
 fs/btrfs/free-space-cache.h |    3 ++-
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fd62aa8..3442976 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1206,7 +1206,6 @@ struct btrfs_block_group_cache {
 	u64 reserved;
 	u64 bytes_super;
 	u64 flags;
-	u64 sectorsize;
 	u64 cache_generation;
 
 	/* for raid56, this is a full stripe, without parity */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4ec8305..f7af6a0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8128,11 +8128,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		key.objectid = found_key.objectid + found_key.offset;
 		btrfs_release_path(path);
 		cache->flags = btrfs_block_group_flags(&cache->item);
-		cache->sectorsize = root->sectorsize;
 		cache->full_stripe_len = btrfs_full_stripe_len(root,
 					       &root->fs_info->mapping_tree,
 					       found_key.objectid);
-		btrfs_init_free_space_ctl(cache);
+		btrfs_init_free_space_ctl(cache, root);
 
 		/*
 		 * We need to exclude the super stripes now so that the space
@@ -8283,7 +8282,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	cache->sectorsize = root->sectorsize;
 	cache->fs_info = root->fs_info;
 	cache->full_stripe_len = btrfs_full_stripe_len(root,
 					       &root->fs_info->mapping_tree,
@@ -8295,12 +8293,11 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&cache->cluster_list);
 	INIT_LIST_HEAD(&cache->new_bg_list);
 
-	btrfs_init_free_space_ctl(cache);
-
 	btrfs_set_block_group_used(&cache->item, bytes_used);
 	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
+	btrfs_init_free_space_ctl(cache, root);
 
 	cache->last_byte_to_unpin = (u64)-1;
 	cache->cached = BTRFS_CACHE_FINISHED;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7517285..ec43e422 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1654,7 +1654,7 @@ static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
 		 * of cache left then go ahead an dadd them, no sense in adding
 		 * the overhead of a bitmap if we don't have to.
 		 */
-		if (info->bytes <= block_group->sectorsize * 4) {
+		if (info->bytes <= ctl->unit * 4) {
 			if (ctl->free_extents * 2 <= ctl->extents_thresh)
 				return false;
 		} else {
@@ -2001,12 +2001,19 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 	       "\n", count);
 }
 
-void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group)
+void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group,
+			       struct btrfs_root *root)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 
 	spin_lock_init(&ctl->tree_lock);
-	ctl->unit = block_group->sectorsize;
+
+	/* This works for mixed block groups too since sectorsize == leafsize */
+	if (block_group->flags & (BTRFS_BLOCK_GROUP_METADATA |
+				  BTRFS_BLOCK_GROUP_SYSTEM))
+		ctl->unit = root->leafsize;
+	else
+		ctl->unit = root->sectorsize;
 	ctl->start = block_group->key.objectid;
 	ctl->private = block_group;
 	ctl->op = &free_space_op;
@@ -2548,10 +2555,10 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 		cont1_bytes = min_bytes = bytes + empty_size;
 	} else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
 		cont1_bytes = bytes;
-		min_bytes = block_group->sectorsize;
+		min_bytes = ctl->unit;
 	} else {
 		cont1_bytes = max(bytes, (bytes + empty_size) >> 2);
-		min_bytes = block_group->sectorsize;
+		min_bytes = ctl->unit;
 	}
 
 	spin_lock(&ctl->tree_lock);
@@ -2976,6 +2983,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 static struct btrfs_block_group_cache *init_test_block_group(void)
 {
 	struct btrfs_block_group_cache *cache;
+	struct btrfs_free_space_ctl *ctl;
 
 	cache = kzalloc(sizeof(*cache), GFP_NOFS);
 	if (!cache)
@@ -2987,17 +2995,27 @@ static struct btrfs_block_group_cache *init_test_block_group(void)
 		return NULL;
 	}
 
+	ctl = cache->free_space_ctl;
 	cache->key.objectid = 0;
 	cache->key.offset = 1024 * 1024 * 1024;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	cache->sectorsize = 4096;
 
 	spin_lock_init(&cache->lock);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
 	INIT_LIST_HEAD(&cache->new_bg_list);
 
-	btrfs_init_free_space_ctl(cache);
+	/*
+	 * Have to do btrfs_init_free_space_ctl open coded here since we don't
+	 * have a root to pass in for ctl->unit.
+	 */
+	spin_lock_init(&ctl->tree_lock);
+	ctl->unit = 4096;
+	ctl->start = block_group->key.objectid;
+	ctl->private = block_group;
+	ctl->op = &free_space_op;
+	ctl->extents_thresh = ((1024 * 32) / 2) /
+				sizeof(struct btrfs_free_space);
 
 	return cache;
 }
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 894116b..482fbd6 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -78,7 +78,8 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 			      struct btrfs_trans_handle *trans,
 			      struct btrfs_path *path);
 
-void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group);
+void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group,
+			       struct btrfs_root *root);
 int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
 			   u64 bytenr, u64 size);
 static inline int
-- 
1.7.7.6

