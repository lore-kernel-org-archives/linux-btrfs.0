Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbbANSgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 13:36:35 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, <stable@vger.kernel.org>
Subject: [PATCH 1/5] btrfs: fix leak of path in btrfs_find_item
Date: Wed, 14 Jan 2015 19:36:33 +0100
Message-Id: <8ede0eb386a0421a522d6c6d2f6c500df13dd239.1421259762.git.dsterba@suse.cz>
In-Reply-To: <cover.1421259762.git.dsterba@suse.cz>
References: <cover.1421259762.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_find_item is called with NULL path it allocates one locally but
does not free it. Affected paths are inserting an orphan item for a file
and for a subvol root.

Move the path allocation to the callers.

CC: <stable@vger.kernel.org> # 3.14+
Fixes: 3f870c289900 ("btrfs: expand btrfs_find_item() to include find_orphan_item functionality")
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c    | 17 ++++-------------
 fs/btrfs/disk-io.c  |  9 ++++++++-
 fs/btrfs/tree-log.c | 11 ++++++++++-
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 14a72ed14ef7..f54511dd287e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2609,32 +2609,23 @@ static int key_search(struct extent_buffer *b, struct btrfs_key *key,
 	return 0;
 }
 
-int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *found_path,
+int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
 		u64 iobjectid, u64 ioff, u8 key_type,
 		struct btrfs_key *found_key)
 {
 	int ret;
 	struct btrfs_key key;
 	struct extent_buffer *eb;
-	struct btrfs_path *path;
+
+	ASSERT(path);
 
 	key.type = key_type;
 	key.objectid = iobjectid;
 	key.offset = ioff;
 
-	if (found_path == NULL) {
-		path = btrfs_alloc_path();
-		if (!path)
-			return -ENOMEM;
-	} else
-		path = found_path;
-
 	ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
-	if ((ret < 0) || (found_key == NULL)) {
-		if (path != found_path)
-			btrfs_free_path(path);
+	if ((ret < 0) || (found_key == NULL))
 		return ret;
-	}
 
 	eb = path->nodes[0];
 	if (ret && path->slots[0] >= btrfs_header_nritems(eb)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8c63419a7f70..6182e5493d0f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1630,6 +1630,7 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 				     bool check_ref)
 {
 	struct btrfs_root *root;
+	struct btrfs_path *path;
 	int ret;
 
 	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID)
@@ -1669,8 +1670,14 @@ again:
 	if (ret)
 		goto fail;
 
-	ret = btrfs_find_item(fs_info->tree_root, NULL, BTRFS_ORPHAN_OBJECTID,
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	ret = btrfs_find_item(fs_info->tree_root, path, BTRFS_ORPHAN_OBJECTID,
 			location->objectid, BTRFS_ORPHAN_ITEM_KEY, NULL);
+	btrfs_free_path(path);
 	if (ret < 0)
 		goto fail;
 	if (ret == 0)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9a02da16f2be..5be45c12dd71 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1257,10 +1257,19 @@ static int insert_orphan_item(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 offset)
 {
 	int ret;
-	ret = btrfs_find_item(root, NULL, BTRFS_ORPHAN_OBJECTID,
+	struct btrfs_path *path;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_find_item(root, path, BTRFS_ORPHAN_OBJECTID,
 			offset, BTRFS_ORPHAN_ITEM_KEY, NULL);
 	if (ret > 0)
 		ret = btrfs_insert_orphan_item(trans, root, offset);
+
+	btrfs_free_path(path);
+
 	return ret;
 }
 
-- 
1.8.4.5

