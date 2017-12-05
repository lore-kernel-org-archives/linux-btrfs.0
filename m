Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:50634 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751325AbdLELO4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 06:14:56 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id E7C0C486A761
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 19:14:51 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: use enum instead of constant value
Date: Tue, 5 Dec 2017 19:01:07 +0800
Message-ID: <1512471667-8555-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a enum for reada of btrfs_path to be consistent with kernel.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 ctree.c           |  3 ++-
 ctree.h           |  2 +-
 extent-tree.c     | 12 ++++++------
 free-space-tree.c |  2 +-
 qgroup-verify.c   |  2 +-
 volumes.c         |  4 ++--
 6 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/ctree.c b/ctree.c
index 4fc33b1..e9ab725 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1023,7 +1023,8 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 			nread += fs_info->nodesize;
 		}
 		nscan++;
-		if (path->reada < 2 && (nread > SZ_256K || nscan > 32))
+		if (path->reada < READA_FORWARD &&
+			(nread > SZ_256K || nscan > 32))
 			break;
 		if(nread > SZ_1M || nscan > 128)
 			break;
diff --git a/ctree.h b/ctree.h
index ef422ea..a1b019e 100644
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
index 055582c..e6d1df9 100644
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
+	path->reada = READA_BACK;
 
 	ret = insert_inline_extent_backref(trans, root->fs_info->extent_root,
 					   path, bytenr, num_bytes, parent,
@@ -1413,7 +1413,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
@@ -1459,7 +1459,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	key.objectid = bytenr;
 	key.offset = offset;
@@ -1551,7 +1551,7 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	key.objectid = bytenr;
 	if (skinny_metadata) {
@@ -2194,7 +2194,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
 	if (is_data)
diff --git a/free-space-tree.c b/free-space-tree.c
index 69a4eca..c068ead 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -332,7 +332,7 @@ int load_free_space_tree(struct btrfs_fs_info *fs_info,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
 	if (IS_ERR(info)) {
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 571b4d4..4a6b853 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1160,7 +1160,7 @@ static int scan_extents(struct btrfs_fs_info *info,
 		fprintf(stderr, "ERROR: Couldn't search slot: %d\n", ret);
 		goto out;
 	}
-	path.reada = 1;
+	path.reada = READA_BACK;
 
 	while (1) {
 		leaf = path.nodes[0];
diff --git a/volumes.c b/volumes.c
index ce3a540..b8ceed3 100644
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
1.9.1



