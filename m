Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37322 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab3DZVGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:14 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] Btrfs-progs: move btrfs_fsck_reinit_root to cmds-check.c
Date: Fri, 26 Apr 2013 16:06:05 -0500
Message-Id: <1367010370-21571-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmds-check.c contains the only caller of btrfs_fsck_reinit_root;
moving it to the caller's source file gets ctree.c a little
closer to kernelspace, although it does require exporting
add_root_to_dirty_list(), which is not done in kernelspace.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-check.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 ctree.c      |   44 +-------------------------------------------
 ctree.h      |    3 +--
 3 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 9fd53f4..f9723c6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3981,6 +3981,49 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+
+static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root)
+{
+	struct extent_buffer *c;
+	struct extent_buffer *old = root->node;
+	int level;
+	struct btrfs_disk_key disk_key = {0,0,0};
+
+	level = 0;
+
+	c = btrfs_alloc_free_block(trans, root,
+				   btrfs_level_size(root, 0),
+				   root->root_key.objectid,
+				   &disk_key, level, 0, 0);
+	if (IS_ERR(c)) {
+		c = old;
+		extent_buffer_get(c);
+	}
+
+	memset_extent_buffer(c, 0, 0, sizeof(struct btrfs_header));
+	btrfs_set_header_level(c, level);
+	btrfs_set_header_bytenr(c, c->start);
+	btrfs_set_header_generation(c, trans->transid);
+	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
+	btrfs_set_header_owner(c, root->root_key.objectid);
+
+	write_extent_buffer(c, root->fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(c),
+			    BTRFS_FSID_SIZE);
+
+	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
+			    (unsigned long)btrfs_header_chunk_tree_uuid(c),
+			    BTRFS_UUID_SIZE);
+
+	btrfs_mark_buffer_dirty(c);
+
+	free_extent_buffer(old);
+	root->node = c;
+	add_root_to_dirty_list(root);
+	return 0;
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
diff --git a/ctree.c b/ctree.c
index 5409552..0b73bdf 100644
--- a/ctree.c
+++ b/ctree.c
@@ -67,7 +67,7 @@ void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p)
 	memset(p, 0, sizeof(*p));
 }
 
-static void add_root_to_dirty_list(struct btrfs_root *root)
+void add_root_to_dirty_list(struct btrfs_root *root)
 {
 	if (root->track_dirty && list_empty(&root->dirty_list)) {
 		list_add(&root->dirty_list,
@@ -137,48 +137,6 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root)
-{
-	struct extent_buffer *c;
-	struct extent_buffer *old = root->node;
-	int level;
-	struct btrfs_disk_key disk_key = {0,0,0};
-
-	level = 0;
-
-	c = btrfs_alloc_free_block(trans, root,
-				   btrfs_level_size(root, 0),
-				   root->root_key.objectid,
-				   &disk_key, level, 0, 0);
-	if (IS_ERR(c)) {
-		c = old;
-		extent_buffer_get(c);
-	}
-
-	memset_extent_buffer(c, 0, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_level(c, level);
-	btrfs_set_header_bytenr(c, c->start);
-	btrfs_set_header_generation(c, trans->transid);
-	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(c, root->root_key.objectid);
-
-	write_extent_buffer(c, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(c),
-			    BTRFS_FSID_SIZE);
-
-	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(c),
-			    BTRFS_UUID_SIZE);
-
-	btrfs_mark_buffer_dirty(c);
-
-	free_extent_buffer(old);
-	root->node = c;
-	add_root_to_dirty_list(root);
-	return 0;
-}
-
 /*
  * check if the tree block can be shared by multiple trees
  */
diff --git a/ctree.h b/ctree.h
index 0506aa1..f96b2f0 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2175,8 +2175,6 @@ int btrfs_check_node(struct btrfs_root *root,
 int btrfs_check_leaf(struct btrfs_root *root,
 		      struct btrfs_disk_key *parent_key,
 		      struct extent_buffer *buf);
-int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
@@ -2214,6 +2212,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		       int start_slot, int cache_only, u64 *last_ret,
 		       struct btrfs_key *progress);
 void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p);
+void add_root_to_dirty_list(struct btrfs_root *root);
 struct btrfs_path *btrfs_alloc_path(void);
 void btrfs_free_path(struct btrfs_path *p);
 void btrfs_init_path(struct btrfs_path *p);
-- 
1.7.1

