Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18767 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932986AbeAKKLR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 05:11:17 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/2] btrfs-progs: cleanup, use enum values for btrfs_path reada
Date: Thu, 11 Jan 2018 18:11:08 +0800
Message-ID: <1515665468-7450-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515665468-7450-1-git-send-email-gujx@cn.fujitsu.com>
References: <1512471667-8555-1-git-send-email-gujx@cn.fujitsu.com>
 <1515665468-7450-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update btrfs-progs to match kernel sources
Reference:
commit e4058b54d1e4 ("btrfs: cleanup, use enum values for btrfs_path reada")

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-restore.c    |  4 ++--
 ctree.c           | 13 ++++++-------
 ctree.h           |  2 +-
 extent-tree.c     | 12 ++++++------
 free-space-tree.c |  2 +-
 qgroup-verify.c   |  2 +-
 volumes.c         |  4 ++--
 7 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 6196a1ed..a322e98f 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -258,7 +258,7 @@ again:
 			continue;
 		}
 
-		if (path->reada)
+		if (path->reada != READA_NONE)
 			reada_for_search(root, path, level, slot, 0);
 
 		next = read_node_slot(fs_info, c, slot);
@@ -275,7 +275,7 @@ again:
 		path->slots[level] = 0;
 		if (!level)
 			break;
-		if (path->reada)
+		if (path->reada != READA_NONE)
 			reada_for_search(root, path, level, 0, 0);
 		next = read_node_slot(fs_info, next, 0);
 		if (!extent_buffer_uptodate(next))
diff --git a/ctree.c b/ctree.c
index 361e53a8..04545ec7 100644
--- a/ctree.c
+++ b/ctree.c
@@ -974,7 +974,6 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 	u64 search;
 	u64 target;
 	u64 nread = 0;
-	int direction = path->reada;
 	struct extent_buffer *eb;
 	u32 nr;
 	u32 nscan = 0;
@@ -998,16 +997,16 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 	nritems = btrfs_header_nritems(node);
 	nr = slot;
 	while(1) {
-		if (direction < 0) {
+		if (path->reada == READA_BACK) {
 			if (nr == 0)
 				break;
 			nr--;
-		} else if (direction > 0) {
+		} else if (path->reada == READA_FORWARD) {
 			nr++;
 			if (nr >= nritems)
 				break;
 		}
-		if (path->reada < 0 && objectid) {
+		if (path->reada == READA_BACK && objectid) {
 			btrfs_node_key(node, &disk_key, nr);
 			if (btrfs_disk_key_objectid(&disk_key) != objectid)
 				break;
@@ -1156,7 +1155,7 @@ again:
 			if (level == lowest_level)
 				break;
 
-			if (should_reada)
+			if (should_reada != READA_NONE)
 				reada_for_search(root, p, level, slot,
 						 key->objectid);
 
@@ -2837,7 +2836,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 			continue;
 		}
 
-		if (path->reada)
+		if (path->reada != READA_NONE)
 			reada_for_search(root, path, level, slot, 0);
 
 		next = read_node_slot(fs_info, c, slot);
@@ -2854,7 +2853,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		path->slots[level] = 0;
 		if (!level)
 			break;
-		if (path->reada)
+		if (path->reada != READA_NONE)
 			reada_for_search(root, path, level, 0, 0);
 		next = read_node_slot(fs_info, next, 0);
 		if (!extent_buffer_uptodate(next))
diff --git a/ctree.h b/ctree.h
index b92df1c1..e1af9725 100644
--- a/ctree.h
+++ b/ctree.h
@@ -564,7 +564,7 @@ struct btrfs_node {
  * The slots array records the index of the item or block pointer
  * used while walking the tree.
  */
-
+enum { READA_NONE = 0, READA_BACK, READA_FORWARD };
 struct btrfs_path {
 	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
 	int slots[BTRFS_MAX_LEVEL];
diff --git a/extent-tree.c b/extent-tree.c
index 055582c3..4a3c4dc0 100644
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
@@ -1392,7 +1392,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	ret = insert_inline_extent_backref(trans, root->fs_info->extent_root,
 					   path, bytenr, num_bytes, parent,
@@ -1413,7 +1413,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
@@ -1459,7 +1459,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	key.objectid = bytenr;
 	key.offset = offset;
@@ -1551,7 +1551,7 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	key.objectid = bytenr;
 	if (skinny_metadata) {
@@ -2194,7 +2194,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
 	if (is_data)
diff --git a/free-space-tree.c b/free-space-tree.c
index 69a4eca8..03dde399 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -332,7 +332,7 @@ int load_free_space_tree(struct btrfs_fs_info *fs_info,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
 	if (IS_ERR(info)) {
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 571b4d4f..e41b6b58 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1160,7 +1160,7 @@ static int scan_extents(struct btrfs_fs_info *info,
 		fprintf(stderr, "ERROR: Couldn't search slot: %d\n", ret);
 		goto out;
 	}
-	path.reada = 1;
+	path.reada = READA_FORWARD;
 
 	while (1) {
 		leaf = path.nodes[0];
diff --git a/volumes.c b/volumes.c
index ce3a5405..b8ceed3d 100644
--- a/volumes.c
+++ b/volumes.c
@@ -354,7 +354,7 @@ static int find_free_dev_extent_start(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	path->reada = 2;
+	path->reada = READA_FORWARD;
 
 	key.objectid = device->devid;
 	key.offset = search_start;
@@ -783,7 +783,7 @@ static int btrfs_device_avail_bytes(struct btrfs_trans_handle *trans,
 	key.offset = root->fs_info->alloc_start;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 
-	path->reada = 2;
+	path->reada = READA_FORWARD;
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto error;
-- 
2.14.3



