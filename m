Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59833 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935410AbeEJQWR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 12:22:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A3C55AE49
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 16:22:15 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs-progs: Use symbolic names for read ahead behavior
Date: Thu, 10 May 2018 19:22:11 +0300
Message-Id: <1525969331-18066-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Presently btrfs-progs haven't pulled the enum defining the symbolic
names of read ahead constants. This commit adds the enum and
simultaneously converts all usages to respective symbolic name.
No functional change, just making the code human readable.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.h         |  2 +-
 extent-tree.c   | 12 ++++++------
 qgroup-verify.c |  4 ++--
 volumes.c       |  4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/ctree.h b/ctree.h
index 1fef37c93485..4466137b897f 100644
--- a/ctree.h
+++ b/ctree.h
@@ -556,7 +556,7 @@ struct btrfs_node {
  * The slots array records the index of the item or block pointer
  * used while walking the tree.
  */
-
+enum { READA_NONE = 0, READA_BACK, READA_FORWARD };
 struct btrfs_path {
 	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
 	int slots[BTRFS_MAX_LEVEL];
diff --git a/extent-tree.c b/extent-tree.c
index 1b8a4f8cb1c3..787ffb0e569c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -112,7 +112,7 @@ static int cache_block_group(struct btrfs_root *root,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = 2;
+	path->reada = READA_FORWARD;
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 	key.objectid = last;
 	key.offset = 0;
@@ -1391,7 +1391,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	ret = insert_inline_extent_backref(trans, root->fs_info->extent_root,
 					   path, bytenr, num_bytes, parent,
@@ -1412,7 +1412,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
@@ -1458,7 +1458,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	key.objectid = bytenr;
 	key.offset = offset;
@@ -1550,7 +1550,7 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	key.objectid = bytenr;
 	if (skinny_metadata) {
@@ -2192,7 +2192,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
 	if (is_data)
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 571b4d4f7171..42ff4a06db2d 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -622,7 +622,7 @@ static void free_tree_blocks(void)
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tree_blocks, &uiter)))
 		free(unode_tree_block(unode));
-	ulist_free(tree_blocks);	
+	ulist_free(tree_blocks);
 	tree_blocks = NULL;
 }
 
@@ -1160,7 +1160,7 @@ static int scan_extents(struct btrfs_fs_info *info,
 		fprintf(stderr, "ERROR: Couldn't search slot: %d\n", ret);
 		goto out;
 	}
-	path.reada = 1;
+	path.reada = READA_BACK;
 
 	while (1) {
 		leaf = path.nodes[0];
diff --git a/volumes.c b/volumes.c
index ad3016dcdb20..9379d2f61eff 100644
--- a/volumes.c
+++ b/volumes.c
@@ -420,7 +420,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 		goto out;
 	}
 
-	path->reada = 2;
+	path->reada = READA_FORWARD;
 
 	key.objectid = device->devid;
 	key.offset = search_start;
@@ -846,7 +846,7 @@ static int btrfs_device_avail_bytes(struct btrfs_trans_handle *trans,
 	key.offset = root->fs_info->alloc_start;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 
-	path->reada = 2;
+	path->reada = READA_FORWARD;
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto error;
-- 
2.7.4

