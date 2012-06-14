Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:31898 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab2FNRQk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 13:16:40 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] Btrfs: use btrfs_read_lock_root_node in get_old_root
Date: Thu, 14 Jun 2012 19:16:35 +0200
Message-Id: <1339694198-13388-4-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_old_root could race with root node updates because we weren't locking
the node early enough. Use btrfs_read_lock_root_node to grab the root locked
in the very beginning and release the lock as soon as possible (just like
btrfs_search_slot does).

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 836e4e0..2cde7b0 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1143,6 +1143,13 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 	return eb_rewin;
 }
 
+/*
+ * get_old_root() rewinds the state of @root's root node to the given @time_seq
+ * value. If there are no changes, the current root->root_node is returned. If
+ * anything changed in between, there's a fresh buffer allocated on which the
+ * rewind operations are done. In any case, the returned buffer is read locked.
+ * Returns NULL on error (with no locks held).
+ */
 static inline struct extent_buffer *
 get_old_root(struct btrfs_root *root, u64 time_seq)
 {
@@ -1151,6 +1158,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	struct tree_mod_root *old_root;
 	u64 old_generation;
 
+	eb = btrfs_read_lock_root_node(root);
 	tm = __tree_mod_log_oldest_root(root->fs_info, root, time_seq);
 	if (!tm)
 		return root->node;
@@ -1173,15 +1181,21 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		/* there's a root replace operation for the current root */
 		eb = alloc_dummy_extent_buffer(tm->index << PAGE_CACHE_SHIFT,
 					       root->nodesize);
+	}
+	btrfs_tree_read_unlock(root->node);
+	free_extent_buffer(root->node);
+	if (!eb)
+		return NULL;
+	btrfs_tree_read_lock(eb);
+	if (old_root->logical != root->node->start) {
 		btrfs_set_header_bytenr(eb, eb->start);
 		btrfs_set_header_backref_rev(eb, BTRFS_MIXED_BACKREF_REV);
 		btrfs_set_header_owner(eb, root->root_key.objectid);
 	}
-	if (!eb)
-		return NULL;
 	btrfs_set_header_level(eb, old_root->level);
 	btrfs_set_header_generation(eb, old_generation);
 	__tree_mod_log_rewind(eb, time_seq, tm);
+	extent_buffer_get(eb);
 
 	return eb;
 }
@@ -2612,9 +2626,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 
 again:
 	b = get_old_root(root, time_seq);
-	extent_buffer_get(b);
 	level = btrfs_header_level(b);
-	btrfs_tree_read_lock(b);
 	p->locks[level] = BTRFS_READ_LOCK;
 
 	while (b) {
-- 
1.7.3.4

