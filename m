Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726030AbeIYMnx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 08:43:53 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42090ACF3
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 06:37:50 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: relocation: Add basic extent backref related comment for build_backref_tree()
Date: Tue, 25 Sep 2018 14:37:46 +0800
Message-Id: <20180925063746.14805-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/relocation.c:build_backref_tree() is some code from 2009 era,
although it works pretty fine, it's not that easy to understand.
Especially combined with the complex btrfs backref format.

This patch adds some basic comment for the backref build part of the
code, making it less hard to read, at least for backref searching part.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
The edge/node weaving part is still pretty hard to understand, and needs extra
comment (will be part 2).

And since Jeff is working on global backref cache, which could
replace/delete build_backref_tree(), I would delay the refactor until we
have a solid plan for this.
(It would be pretty nasty to refactor the function anyway)
---
 fs/btrfs/relocation.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a554e7861b6e..1d0f9f6febc5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -648,8 +648,8 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 					int level, u64 bytenr)
 {
 	struct backref_cache *cache = &rc->backref_cache;
-	struct btrfs_path *path1;
-	struct btrfs_path *path2;
+	struct btrfs_path *path1; /* For searching extent root */
+	struct btrfs_path *path2; /* For searching parent of TREE_BLOCK_REF */
 	struct extent_buffer *eb;
 	struct btrfs_root *root;
 	struct backref_node *cur;
@@ -662,7 +662,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 	struct btrfs_key key;
 	unsigned long end;
 	unsigned long ptr;
-	LIST_HEAD(list);
+	LIST_HEAD(list); /* Pending edge list, upper node needs to be checked */
 	LIST_HEAD(useless);
 	int cowonly;
 	int ret;
@@ -778,6 +778,10 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 				key.type != BTRFS_SHARED_BLOCK_REF_KEY);
 		}
 
+		/*
+		 * Parent node found and matches with current inline ref, no
+		 * need to rebuild this node for this inline ref.
+		 */
 		if (exist &&
 		    ((key.type == BTRFS_TREE_BLOCK_REF_KEY &&
 		      exist->owner == key.offset) ||
@@ -787,11 +791,12 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 			goto next;
 		}
 
+		/* SHARED_BLOCK_REF means key.offset is the parent bytenr */
 		if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
 			if (key.objectid == key.offset) {
 				/*
-				 * only root blocks of reloc trees use
-				 * backref of this type.
+				 * only root blocks of reloc trees use backref
+				 * pointing to itself.
 				 */
 				root = find_reloc_root(rc, cur->bytenr);
 				ASSERT(root);
@@ -840,7 +845,11 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 			goto next;
 		}
 
-		/* key.type == BTRFS_TREE_BLOCK_REF_KEY */
+		/*
+		 * key.type == BTRFS_TREE_BLOCK_REF_KEY, inline ref offset means
+		 * the root objectid. We need to search the tree to get its
+		 * parent bytenr.
+		 */
 		root = read_fs_root(rc->extent_root->fs_info, key.offset);
 		if (IS_ERR(root)) {
 			err = PTR_ERR(root);
@@ -863,10 +872,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 
 		level = cur->level + 1;
 
-		/*
-		 * searching the tree to find upper level blocks
-		 * reference the block.
-		 */
+		/* search the tree to find parent blocks referring the block. */
 		path2->search_commit_root = 1;
 		path2->skip_locking = 1;
 		path2->lowest_level = level;
@@ -892,6 +898,8 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 		}
 		lower = cur;
 		need_check = true;
+
+		/* Adding all nodes and edges in the path */
 		for (; level < BTRFS_MAX_LEVEL; level++) {
 			if (!path2->nodes[level]) {
 				ASSERT(btrfs_root_bytenr(&root->root_item) ==
-- 
2.19.0
