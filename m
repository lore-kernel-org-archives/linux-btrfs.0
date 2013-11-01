Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62357 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3KAHAf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 03:00:35 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so3468832pdj.22
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Nov 2013 00:00:34 -0700 (PDT)
Date: Fri, 1 Nov 2013 00:00:32 -0700
From: Kelley Nielsen <kelleynnn@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: opw-kernel@googlegroups.com
Subject: [PATCH 3/3] btrfs_find_item expanded to include find_orphan_item
 functionality
Message-ID: <b004d650091cd74e2482057dd70d3dfa1eed1583.1383289182.git.kelleynnn@gmail.com>
References: <cover.1383289182.git.kelleynnn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1383289182.git.kelleynnn@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the third step in bootstrapping the btrfs_find_item interface.
The function find_orphan_item, in orphan.c, is similar to the two
functions already replaced by the new interface. It uses two parameters,
which are already present in the interface, and is nearly identical to
the function brought in in the previous patch.

The two calls to find_orphan_item have been replaced by calls to
btrfs_find_item, with the defined object id and type that was used
internally by find_orphan_item, a null path, and a null key. A test for
a null path has been added to btrfs_find_item, and if it passes, a path
is allocated and freed. Finally, find_orphan_item has been removed.

Signed-off-by: Kelley Nielsen <kelleynnn@gmail.com>
Suggested-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/ctree.c    | 18 +++++++++++++++---
 fs/btrfs/disk-io.c  |  3 ++-
 fs/btrfs/orphan.c   | 20 --------------------
 fs/btrfs/tree-log.c |  3 ++-
 4 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 498b19d..83a5418 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2465,7 +2465,8 @@ static int key_search(struct extent_buffer *b, struct btrfs_key *key,
 /* Proposed generic search function, meant to take the place of the
 * various small search helper functions throughout the code and standardize
 * the search interface. Right now, it only replaces the former __inode_info
-* in backref.c, and the former btrfs_find_root_ref in root-tree.c.
+* in backref.c, the former btrfs_find_root_ref in root-tree.c, and the
+* former btrfs_find_orphan_item in orphan.c.
 *
 * If a null key is passed, it returns immediately after running
 * btrfs_search_slot, leaving the path filled as it is and passing its
@@ -2473,21 +2474,32 @@ static int key_search(struct extent_buffer *b, struct btrfs_key *key,
 * path to point to the first item in the tree after its specified
 * objectid, type, and offset for which objectid and type match the input.
 */
-int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
+int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *found_path,
 		u64 inum, u64 ioff, u8 key_type,
 		struct btrfs_key *found_key)
 {
 	int ret;
 	struct btrfs_key key;
 	struct extent_buffer *eb;
+	struct btrfs_path *path;
 
 	key.type = key_type;
 	key.objectid = inum;
 	key.offset = ioff;
 
+	if (found_path == NULL) {
+		path = btrfs_alloc_path();
+		if (!path)
+			return -ENOMEM;
+	} else
+		path = found_path;
+
 	ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
-	if ((ret < 0) || (found_key == NULL))
+	if ((ret < 0) || (found_key == NULL)) {
+		if (path != found_path)
+			btrfs_free_path(path);
 		return ret;
+	}
 
 	eb = path->nodes[0];
 	if (ret && path->slots[0] >= btrfs_header_nritems(eb)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4c4ed0b..bce90c9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1616,7 +1616,8 @@ again:
 	if (ret)
 		goto fail;
 
-	ret = btrfs_find_orphan_item(fs_info->tree_root, location->objectid);
+	ret = btrfs_find_item(fs_info->tree_root, NULL, BTRFS_ORPHAN_OBJECTID,
+			location->objectid, BTRFS_ORPHAN_ITEM_KEY, NULL);
 	if (ret < 0)
 		goto fail;
 	if (ret == 0)
diff --git a/fs/btrfs/orphan.c b/fs/btrfs/orphan.c
index 24cad16..65793ed 100644
--- a/fs/btrfs/orphan.c
+++ b/fs/btrfs/orphan.c
@@ -69,23 +69,3 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
-
-int btrfs_find_orphan_item(struct btrfs_root *root, u64 offset)
-{
-	struct btrfs_path *path;
-	struct btrfs_key key;
-	int ret;
-
-	key.objectid = BTRFS_ORPHAN_OBJECTID;
-	key.type = BTRFS_ORPHAN_ITEM_KEY;
-	key.offset = offset;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-
-	btrfs_free_path(path);
-	return ret;
-}
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a2c7b04..9972e2a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1238,7 +1238,8 @@ static int insert_orphan_item(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 offset)
 {
 	int ret;
-	ret = btrfs_find_orphan_item(root, offset);
+	ret = btrfs_find_item(root, NULL, BTRFS_ORPHAN_OBJECTID,
+			offset, BTRFS_ORPHAN_ITEM_KEY, NULL);
 	if (ret > 0)
 		ret = btrfs_insert_orphan_item(trans, root, offset);
 	return ret;
-- 
1.8.1.2

