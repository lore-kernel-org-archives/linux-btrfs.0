Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbbANSgs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 13:36:48 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E087EAB0E
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 18:36:46 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/5] btrfs: expand btrfs_find_item if found_key is NULL
Date: Wed, 14 Jan 2015 19:36:46 +0100
Message-Id: <dd8b64a3d7c0fa520da463c7c2d253b4987d13e5.1421259762.git.dsterba@suse.cz>
In-Reply-To: <cover.1421259762.git.dsterba@suse.cz>
References: <cover.1421259762.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the found_key is NULL, then btrfs_find_item becomes a verbose wrapper
for simple btrfs_search_slot.

After we've removed all such callers, passing a NULL key is not valid
anymore.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c   |  3 ++-
 fs/btrfs/disk-io.c |  8 ++++++--
 fs/btrfs/inode.c   | 10 +++++++---
 fs/btrfs/scrub.c   |  8 ++++++--
 4 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f54511dd287e..20d1f2b0403d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2618,13 +2618,14 @@ int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
 	struct extent_buffer *eb;
 
 	ASSERT(path);
+	ASSERT(found_key);
 
 	key.type = key_type;
 	key.objectid = iobjectid;
 	key.offset = ioff;
 
 	ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
-	if ((ret < 0) || (found_key == NULL))
+	if (ret < 0)
 		return ret;
 
 	eb = path->nodes[0];
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6182e5493d0f..8d486603e8a3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1631,6 +1631,7 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root;
 	struct btrfs_path *path;
+	struct btrfs_key key;
 	int ret;
 
 	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID)
@@ -1675,8 +1676,11 @@ again:
 		ret = -ENOMEM;
 		goto fail;
 	}
-	ret = btrfs_find_item(fs_info->tree_root, path, BTRFS_ORPHAN_OBJECTID,
-			location->objectid, BTRFS_ORPHAN_ITEM_KEY, NULL);
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = location->objectid;
+
+	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
 	btrfs_free_path(path);
 	if (ret < 0)
 		goto fail;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e687bb0dc73a..cb69db7c273c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5009,6 +5009,7 @@ static int fixup_tree_root_location(struct btrfs_root *root,
 	struct btrfs_root *new_root;
 	struct btrfs_root_ref *ref;
 	struct extent_buffer *leaf;
+	struct btrfs_key key;
 	int ret;
 	int err = 0;
 
@@ -5019,9 +5020,12 @@ static int fixup_tree_root_location(struct btrfs_root *root,
 	}
 
 	err = -ENOENT;
-	ret = btrfs_find_item(root->fs_info->tree_root, path,
-				BTRFS_I(dir)->root->root_key.objectid,
-				location->objectid, BTRFS_ROOT_REF_KEY, NULL);
+	key.objectid = BTRFS_I(dir)->root->root_key.objectid;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = location->objectid;
+
+	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, path,
+				0, 0);
 	if (ret) {
 		if (ret < 0)
 			err = ret;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 8bfe3b6fd471..0baf3b50c61f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -520,6 +520,7 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 	struct inode_fs_paths *ipath = NULL;
 	struct btrfs_root *local_root;
 	struct btrfs_key root_key;
+	struct btrfs_key key;
 
 	root_key.objectid = root;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -533,8 +534,11 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 	/*
 	 * this makes the path point to (inum INODE_ITEM ioff)
 	 */
-	ret = btrfs_find_item(local_root, swarn->path, inum, 0,
-			BTRFS_INODE_ITEM_KEY, NULL);
+	key.objectid = inum;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, local_root, &key, swarn->path, 0, 0);
 	if (ret) {
 		btrfs_release_path(swarn->path);
 		goto err;
-- 
1.8.4.5

