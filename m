Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33884 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3KEDhm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 22:37:42 -0500
Received: by mail-pd0-f181.google.com with SMTP id x10so7558481pdj.40
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 19:37:41 -0800 (PST)
Date: Mon, 4 Nov 2013 19:37:39 -0800
From: Kelley Nielsen <kelleynnn@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: opw-kernel@googlegroups.com
Subject: [PATCH v2 3/3] expand btrfs_find_item() to include find_orphan_item
 functionality
Message-ID: <ee7a70d4cd1bbff0b573ce149a4c9b4d92e6dfaa.1383621635.git.kelleynnn@gmail.com>
References: <cover.1383621635.git.kelleynnn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1383621635.git.kelleynnn@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the third step in bootstrapping the btrfs_find_item interface.
The function find_orphan_item(), in orphan.c, is similar to the two
functions already replaced by the new interface. It uses two parameters,
which are already present in the interface, and is nearly identical to
the function brought in in the previous patch.

Replace the two calls to find_orphan_item() with calls to
btrfs_find_item(), with the defined objectid and type that was used
internally by find_orphan_item(), a null path, and a null key. Add a
test for a null path to btrfs_find_item, and if it passes, allocate and
free the path. Finally, remove find_orphan_item().

Signed-off-by: Kelley Nielsen <kelleynnn@gmail.com>
---
Changes since v1:
* Removed comment at the head of btrfs_find_item()
* Reworded commit messasge to use imperative, not passive voice

 fs/btrfs/ctree.c    | 26 +++++++++++++-------------
 fs/btrfs/disk-io.c  |  3 ++-
 fs/btrfs/orphan.c   | 20 --------------------
 fs/btrfs/tree-log.c |  3 ++-
 4 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7d2f71c..a528a14 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2462,32 +2462,32 @@ static int key_search(struct extent_buffer *b, struct btrfs_key *key,
 	return 0;
 }
 
-/* Proposed generic search function, meant to take the place of the
-* various small search helper functions throughout the code and standardize
-* the search interface. Right now, it only replaces the former __inode_info
-* in backref.c, and the former btrfs_find_root_ref in root-tree.c.
-*
-* If a null key is passed, it returns immediately after running
-* btrfs_search_slot, leaving the path filled as it is and passing its
-* return value upward. If a real key is passed, it will set the caller's
-* path to point to the first item in the tree after its specified
-* objectid, type, and offset for which objectid and type match the input.
-*/
-int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
+int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *found_path,
 		u64 iobjectid, u64 ioff, u8 key_type,
 		struct btrfs_key *found_key)
 {
 	int ret;
 	struct btrfs_key key;
 	struct extent_buffer *eb;
+	struct btrfs_path *path;
 
 	key.type = key_type;
 	key.objectid = iobjectid;
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

