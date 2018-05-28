Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425255AbeE1PyP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:15 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 114EFAE65
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 15:54:13 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/11] btrfs-progs: Change btrfs_root to btrfs_fs_info argument in btrfs_lookup_extent_info
Date: Mon, 28 May 2018 09:36:47 +0300
Message-Id: <1527489410-3564-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That function really wants an fs_info and not a root. Accidentally,
this also makes the kernel/user space signatures to be coherent.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c        | 10 +++++-----
 check/mode-lowmem.c |  4 ++--
 ctree.c             |  3 ++-
 ctree.h             |  2 +-
 extent-tree.c       | 14 ++++++--------
 5 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/check/main.c b/check/main.c
index 9a7e6b6dbde3..9e8a83f86ab0 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1622,9 +1622,9 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		refs = nrefs->refs[*level];
 		ret = 0;
 	} else {
-		ret = btrfs_lookup_extent_info(NULL, root,
-				       path->nodes[*level]->start,
-				       *level, 1, &refs, NULL);
+		ret = btrfs_lookup_extent_info(NULL, fs_info,
+					       path->nodes[*level]->start,
+					       *level, 1, &refs, NULL);
 		if (ret < 0) {
 			err = ret;
 			goto out;
@@ -1664,7 +1664,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		if (bytenr == nrefs->bytenr[*level - 1]) {
 			refs = nrefs->refs[*level - 1];
 		} else {
-			ret = btrfs_lookup_extent_info(NULL, root, bytenr,
+			ret = btrfs_lookup_extent_info(NULL, fs_info, bytenr,
 					*level - 1, 1, &refs, NULL);
 			if (ret < 0) {
 				refs = 0;
@@ -5928,7 +5928,7 @@ static int run_next_block(struct btrfs_root *root,
 
 	flags = 0;
 	if (!init_extent_tree) {
-		ret = btrfs_lookup_extent_info(NULL, root, bytenr,
+		ret = btrfs_lookup_extent_info(NULL, fs_info, bytenr,
 				       btrfs_header_level(buf), 1, NULL,
 				       &flags);
 		if (ret < 0) {
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 410c5f635d4e..989306f03c2a 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -186,8 +186,8 @@ static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
 
 	if (bytenr != (u64)-1) {
 		/* the return value of this function seems a mistake */
-		ret = btrfs_lookup_extent_info(NULL, root, bytenr,
-				       level, 1, &refs, &flags);
+		ret = btrfs_lookup_extent_info(NULL, root->fs_info, bytenr,
+					       level, 1, &refs, &flags);
 		/* temporary fix */
 		if (ret < 0 && !check_all)
 			return ret;
diff --git a/ctree.c b/ctree.c
index e79d7aa32319..c89fd11fc48b 100644
--- a/ctree.c
+++ b/ctree.c
@@ -192,7 +192,8 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 	 */
 
 	if (btrfs_block_can_be_shared(root, buf)) {
-		ret = btrfs_lookup_extent_info(trans, root, buf->start,
+		ret = btrfs_lookup_extent_info(trans, trans->fs_info,
+					       buf->start,
 					       btrfs_header_level(buf), 1,
 					       &refs, &flags);
 		BUG_ON(ret);
diff --git a/ctree.h b/ctree.h
index 138cd22c6c6e..037e020401d2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2517,7 +2517,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size);
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 bytenr,
+			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 offset, int metadata, u64 *refs, u64 *flags);
 int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index d90eb8139d8b..2fd4e7a0d9eb 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1434,7 +1434,7 @@ int btrfs_extent_post_op(struct btrfs_trans_handle *trans)
 }
 
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 bytenr,
+			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 offset, int metadata, u64 *refs, u64 *flags)
 {
 	struct btrfs_path *path;
@@ -1446,9 +1446,8 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	u64 num_refs;
 	u64 extent_flags;
 
-	if (metadata &&
-	    !btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
-		offset = root->fs_info->nodesize;
+	if (metadata && !btrfs_fs_incompat(fs_info, SKINNY_METADATA)) {
+		offset = fs_info->nodesize;
 		metadata = 0;
 	}
 
@@ -1465,8 +1464,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 		key.type = BTRFS_EXTENT_ITEM_KEY;
 
 again:
-	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
-				0, 0);
+	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
 
@@ -1483,14 +1481,14 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 					      path->slots[0]);
 			if (key.objectid == bytenr &&
 			    key.type == BTRFS_EXTENT_ITEM_KEY &&
-			    key.offset == root->fs_info->nodesize)
+			    key.offset == fs_info->nodesize)
 				ret = 0;
 		}
 
 		if (ret) {
 			btrfs_release_path(path);
 			key.type = BTRFS_EXTENT_ITEM_KEY;
-			key.offset = root->fs_info->nodesize;
+			key.offset = fs_info->nodesize;
 			metadata = 0;
 			goto again;
 		}
-- 
2.7.4

